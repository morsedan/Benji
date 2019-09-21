//
//  ChannelCollectionViewFlowLayout.swift
//  Benji
//
//  Created by Benji Dodgson on 7/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCollectionViewFlowLayout: UICollectionViewFlowLayout {

    private(set) var isTypingIndicatorViewHidden: Bool = true
    private var insertingIndexPaths: [IndexPath] = []

    override class var layoutAttributesClass: AnyClass {
        return ChannelCollectionViewLayoutAttributes.self
    }

    lazy var messageSizeCalculator = MessageSizeCalculator(layout: self)
    lazy var typingIndicatorSizeCalculator = TypingCellSizeCalculator(layout: self)
    lazy var initialHeaderSizeCalculator = InitialHeaderSizeCalculator(layout: self)

    var channelCollectionView: ChannelCollectionView {
        guard let channelCollectionView = self.collectionView as? ChannelCollectionView else {
            fatalError("ChannelCollectionView NOT FOUND")
        }
        return channelCollectionView
    }

    var dataSource: ChannelDataSource {
        guard let dataSource = self.channelCollectionView.channelDataSource else {
            fatalError("ChannelDataSource is nil")
        }
        return dataSource
    }

    var itemWidth: CGFloat {
        guard let collectionView = self.collectionView else { return 0 }
        return collectionView.frame.width - self.sectionInset.left - self.sectionInset.right
    }

    override init() {
        super.init()
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    private func setupView() {
        self.scrollDirection = .vertical
        self.minimumLineSpacing = 4
    }

    override func prepare() {
        super.prepare()

        self.collectionView?.contentInset.bottom = 80
        self.collectionView?.contentInset.top = 10
    }

    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)

        self.insertingIndexPaths.removeAll()

        for update in updateItems {
            if let indexPath = update.indexPathAfterUpdate,
                update.updateAction == .insert {
                self.insertingIndexPaths.append(indexPath)
            }
        }
    }

    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()

        self.insertingIndexPaths.removeAll()
    }

    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)

        if self.insertingIndexPaths.contains(itemIndexPath) {
            attributes?.alpha = 0.0
            attributes?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }

        return attributes
    }

    // MARK: - Attributes

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesArray = super.layoutAttributesForElements(in: rect) as? [ChannelCollectionViewLayoutAttributes] else {
            return nil
        }
        for attributes in attributesArray where attributes.representedElementCategory == .cell {
            let cellSizeCalculator = self.cellSizeCalculatorForItem(at: attributes.indexPath)
            cellSizeCalculator.configure(attributes: attributes)
        }
        return attributesArray
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) as? ChannelCollectionViewLayoutAttributes else {
            return nil
        }
        if attributes.representedElementCategory == .cell {
            let cellSizeCalculator = self.cellSizeCalculatorForItem(at: attributes.indexPath)
            cellSizeCalculator.configure(attributes: attributes)
        }
        return attributes
    }

    // MARK: - Layout Invalidation

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return self.collectionView?.bounds.width != newBounds.width
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        guard let flowLayoutContext = context as? UICollectionViewFlowLayoutInvalidationContext else { return context }
        flowLayoutContext.invalidateFlowLayoutDelegateMetrics = self.shouldInvalidateLayout(forBoundsChange: newBounds)
        return flowLayoutContext
    }

    private func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
        if self.isSectionReservedForTypingIndicator(indexPath.section) {
            return self.typingIndicatorSizeCalculator
        }
        //Can eventually extended this to switch over different message types and size calculators
        return self.messageSizeCalculator
    }

    private func headerSizeCalculator(for section:  Int) -> HeaderSizeCalculator {
        return self.initialHeaderSizeCalculator
    }

    // MARK: - PUBLIC

    func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let calculator = self.cellSizeCalculatorForItem(at: indexPath)
        return calculator.sizeForItem(at: indexPath)
    }

    func sizeForHeader(at section: Int) -> CGSize {
        if self.isSectionReservedForTypingIndicator(section) {
            return .zero
        }

        if section == 0 {
            let calculator = self.headerSizeCalculator(for: section)
            return calculator.sizeForHeader(at: section)
        }

        return CGSize(width: self.channelCollectionView.width, height: 50)
    }

    // MARK: - Typing Indicator API

    /// Notifies the layout that the typing indicator will change state
    ///
    /// - Parameters:
    ///   - isHidden: A Boolean value that is to be the new state of the typing indicator
    func setTypingIndicatorViewHidden(_ isHidden: Bool) {
        self.isTypingIndicatorViewHidden = isHidden
    }

    /// A method that by default checks if the section is the last in the
    /// `messagesCollectionView` and that `isTypingIndicatorViewHidden`
    /// is FALSE
    ///
    /// - Parameter section
    /// - Returns: A Boolean indicating if the TypingIndicator should be presented at the given section
    func isSectionReservedForTypingIndicator(_ section: Int) -> Bool {
        return !isTypingIndicatorViewHidden && section == self.channelCollectionView.numberOfSections - 1
    }
}
