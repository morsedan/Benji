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

    weak var dataSource: ChannelDataSource? {
        didSet {
            self.invalidateLayout()
            self.collectionView?.reloadData()
        }
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
        self.collectionView?.contentInset.top = 70
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
            let message = self.dataSource?.item(at: attributes.indexPath)
            let configurer = self.configurer(for: message, at: attributes.indexPath)

            if let msg = message {
                configurer.configure(with: msg, for: self, attributes: attributes)
            }
        }

        for attributes in attributesArray where attributes.representedElementCategory == .supplementaryView {
            let headerSizeCalculator = self.headerSizeCalculator(for: attributes.indexPath.section)
            headerSizeCalculator.configure(attributes: attributes)
        }

        return attributesArray
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) as? ChannelCollectionViewLayoutAttributes else {
            return nil
        }

        if attributes.representedElementCategory == .cell, let message = self.dataSource?.item(at: indexPath) {
            let configurer = self.configurer(for: message, at: indexPath)
            configurer.configure(with: message, for: self, attributes: attributes)
        } else if attributes.representedElementCategory == .supplementaryView {
            let headerSizeCalculator = self.headerSizeCalculator(for: attributes.indexPath.section)
            headerSizeCalculator.configure(attributes: attributes)
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

    private func configurer(for message: Messageable?, at indexPath: IndexPath) -> ChannelCellAttributesConfigurer {
        // Can eventually extended this to switch over different message types

        if self.isSectionReservedForTypingIndicator(indexPath.section) {
            return TypingCellAttributesConfigurer()
        }

        return MessageCellAttributesConfigurer()
    }

    private func headerSizeCalculator(for section:  Int) -> HeaderSizeCalculator {
        return self.initialHeaderSizeCalculator
    }

    // MARK: - PUBLIC

    func sizeForItem(at indexPath: IndexPath, with message: Messageable?) -> CGSize {
        return self.configurer(for: message, at: indexPath).size(with: message, for: self)
    }

    func sizeForHeader(at section: Int, with collectionView: UICollectionView) -> CGSize {

        if self.isSectionReservedForTypingIndicator(section) {
            return .zero
        }

        if section == 0 {
             if let sectionType = self.dataSource?.sections[safe: section],
                let index = sectionType.firstMessageIndex, index > 0 {
                 return CGSize(width: collectionView.width, height: 50)
             } else {
                 let calculator = self.headerSizeCalculator(for: section)
                 return calculator.sizeForHeader(at: section)
             }
         }

        return CGSize(width: collectionView.width, height: 50)
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
        guard let collectionView = self.collectionView else { return false }
        return !self.isTypingIndicatorViewHidden && section == collectionView.numberOfSections - 1
    }
}
