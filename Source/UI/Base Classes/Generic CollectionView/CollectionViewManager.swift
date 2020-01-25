//  Copyright © 2019 Tomorrow Ideas Inc. All rights reserved.

import Foundation
import ReactiveSwift

class CollectionViewManager<CellType: ManageableCell & UICollectionViewCell>: NSObject,
UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    unowned let collectionView: UICollectionView

    let items = MutableProperty<[CellType.ItemType]>([])

    var allowMultipleSelection: Bool = false
    private(set) var selectedIndexPaths: Set<IndexPath> = [] {
        didSet {
            self.updateSelected(indexPaths: self.selectedIndexPaths, and: oldValue)
        }
    }
    var selectedItems: [CellType.ItemType] {
        var items: [CellType.ItemType] = []
        for indexPath in self.selectedIndexPaths {
            if let item = self.items.value[safe: indexPath.row] {
                items.append(item)
            }
        }
        return items
    }

    // MARK: Events

    lazy var onSelectedItem = Property(self._onSelectedItem)
    private let _onSelectedItem = MutableProperty<(item: CellType.ItemType, indexPath: IndexPath)?>(nil)
    var didLongPress: ((CellType.ItemType, IndexPath) -> Void)?
    var willDisplayCell: ((CellType.ItemType, IndexPath) -> Void)?
    var didFinishCenteringOnCell: ((CellType.ItemType, IndexPath) -> Void)?

    required init(with collectionView: UICollectionView) {
        self.collectionView = collectionView

        super.init()

        self.initializeCollectionView()
    }

    func initializeCollectionView() {
        self.collectionView.register(CellType.self, forCellWithReuseIdentifier: CellType.reuseID)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    // MARK: Data Source Updating

    func set(newItems: [CellType.ItemType], completion: ((Bool) -> Swift.Void)? = nil) {
        self.updateCollectionView(items: newItems, modify: { [weak self] in
            guard let `self` = self else { return }
            self.items.value = newItems
        }, completion: completion)
    }

    private func updateCollectionView(items: [CellType.ItemType],
                                      modify: @escaping () -> Void,
                                      completion: ((Bool) -> Swift.Void)? = nil) {
        self.collectionView.reloadWithModify(previousItems: self.items.value,
                                             newItems: items,
                                             equalityOption: .equality,
                                             modify: modify,
                                             completion: completion)
    }

    func append(item: CellType.ItemType, in section: Int = 0) {
        guard !self.items.value.contains(item) else { return }

        let indexPath = IndexPath(item: self.items.value.count, section: section)
        self.items.value.append(item)
        self.collectionView.insertItems(at: [indexPath])
    }

    func insert(item: CellType.ItemType, at index: Int) {
        self.items.value.insert(item, at: index)
        self.collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
    }

    func update(item: CellType.ItemType, in section: Int = 0) {

        guard let itemIndex = self.items.value.firstIndex(where: { (oldItem) in
            return oldItem.diffIdentifier().isEqual(item.diffIdentifier())
        }) else { return }

        self.items.value[itemIndex] = item
        self.collectionView.reloadItems(at: [IndexPath(row: itemIndex, section: section)])
    }

    func set(item: CellType.ItemType, at index: Int) {
        self.items.value[index] = item
        self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }

    func delete(item: CellType.ItemType, in section: Int = 0) {

        guard let itemIndex = self.items.value.firstIndex(where: { (oldItem) in
            return oldItem.diffIdentifier().isEqual(item.diffIdentifier())
        }) else { return }

        self.items.value.remove(at: itemIndex)
        self.collectionView.deleteItems(at: [IndexPath(row: itemIndex, section: section)])
    }

    func select(indexPath: IndexPath, animated: Bool = false) {
        guard let item = self.items.value[safe: indexPath.row] else { return }

        if self.allowMultipleSelection {
            self.selectedIndexPaths.insert(indexPath)
        } else {
            self.selectedIndexPaths = [indexPath]
        }

        // Even though we're managing the selected index paths, we still need to animate to item
        self.collectionView.selectItem(at: indexPath,
                                       animated: animated,
                                       scrollPosition: .centeredHorizontally)

        self._onSelectedItem.value = (item, indexPath)
    }

    private func updateSelected(indexPaths: Set<IndexPath>, and oldIndexPaths: Set<IndexPath>) {
        // Reset all the old indexPaths if they are not also in the new array
        oldIndexPaths.forEach { (indexPath) in
            if !indexPaths.contains(indexPath),
                let cell = self.collectionView.cellForItem(at: indexPath) as? CellType {
                cell.update(isSelected: self.allowMultipleSelection)
            }
        }

        indexPaths.forEach { (indexPath) in
            if let cell = self.collectionView.cellForItem(at: indexPath) as? CellType {
                cell.update(isSelected: true)
            }
        }
    }

    func reset() {
        self.items.value = []
        self.collectionView.reloadData()
    }

    // MARK: CollectionView Data Source

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.value.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: CellType = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.reuseID,
                                                                for: indexPath) as! CellType

        let item = self.items.value[safe: indexPath.row]
        cell.configure(with: item)

        cell.onLongPress = { [unowned self] in
            guard let item = self.items.value[safe: indexPath.row] else { return }
            self.didLongPress?(item, indexPath)
        }

        // Allows subclasses to do additional cell configuration
        self.managerDidConfigure(cell: cell, for: indexPath)

        return cell
    }

    // Subclasses can override this to do more cell configuration
    func managerDidConfigure(cell: CellType, for indexPath: IndexPath) {
        cell.update(isSelected: self.selectedIndexPaths.contains(indexPath))
    }

    // MARK: CollectionView Delegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.select(indexPath: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

        let configurableCell: CellType = cell as! CellType
        configurableCell.collectionViewManagerWillDisplay()

        guard let item = self.items.value[safe: indexPath.row] else { return }
        self.willDisplayCell?(item, indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let configurableCell: CellType = cell as! CellType
        configurableCell.collectionViewManagerDidEndDisplaying()
    }

    // MARK: CollectionView Flow Layout Delegate

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        return layout.itemSize
    }

    // MARK: CollectionView Menu

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return nil 
    }

    // MARK: ScrollView Delegate (These are part of the collectionview delegate)

    func scrollViewDidScroll(_ scrollView: UIScrollView) { }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let indexPath = self.collectionView.centerMostIndexPath(),
            let item = self.items.value[safe: indexPath.row] else { return }
        self.didFinishCenteringOnCell?(item, indexPath)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let indexPath = self.collectionView.centerMostIndexPath(),
            let item = self.items.value[safe: indexPath.row] else { return }
        self.didFinishCenteringOnCell?(item, indexPath)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) { }
}

