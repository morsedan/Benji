//
//  FeedContentView.swift
//  Benji
//
//  Created by Benji Dodgson on 7/25/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

/**
 The VerticalCardSwiper is a subclass of `UIView` that has a `VerticalCardSwiperView` embedded.

 To use this, you need to implement the `VerticalCardSwiperDatasource`.

 If you want to handle actions like cards being swiped away, implement the `VerticalCardSwiperDelegate`.
 */
class CardSwiperView: View {

    /// The collectionView where all the magic happens.
    var collectionView: FeedCollectionView!

    /// Indicates if side swiping on cards is enabled. Default is `true`.
    var isSideSwipingEnabled: Bool = true {
        willSet {
            if newValue {
                self.horizontalPangestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            } else {
                self.collectionView.removeGestureRecognizer(horizontalPangestureRecognizer)
            }
        }
    }
    /// The inset (spacing) at the top for the cards. Default is 40.
    var topInset: CGFloat = 40 {
        didSet {
            self.setCardSwiperInsets()
        }
    }
    /// The inset (spacing) at each side of the cards. Default is 20.
    var sideInset: CGFloat = 20 {
        didSet {
            self.setCardSwiperInsets()
        }
    }
    /// Sets how much of the next card should be visible. Default is 50.
    var visibleNextCardHeight: CGFloat = 50 {
        didSet {
            self.setCardSwiperInsets()
        }
    }
    /// Vertical spacing between the focussed card and the bottom (next) card. Default is 40.
    var cardSpacing: CGFloat = 40 {
        willSet {
            self.flowLayout.minimumLineSpacing = newValue
        }
        didSet {
            self.setCardSwiperInsets()
        }
    }
    /// The transform animation that is shown on the top card when scrolling through the cards. Default is 0.05.
    var firstItemTransform: CGFloat = 0.05 {
        willSet {
            self.flowLayout.firstItemTransform = newValue
        }
    }
    /// Allows you to enable/disable the stacking effect. Default is `true`.
    var isStackingEnabled: Bool = true {
        willSet {
            self.flowLayout.isStackingEnabled = newValue
        }
    }
    /// Allows you to set the view to Stack at the Top or at the Bottom. Default is `true`.
    var isStackOnBottom: Bool = true {
        willSet {
            self.flowLayout.isStackOnBottom = newValue
        }
    }
    /// Sets how many cards of the stack are visible in the background. Default is 1.
    var stackedCardsCount: Int = 1 {
        willSet {
            self.flowLayout.stackedCardsCount = newValue
        }
    }
    /**
     Returns an array of indexes (as Int) that are currently visible in the `VerticalCardSwiperView`.
     This includes cards that are stacked (behind the focussed card).
     */
    var indexesForVisibleCards: [Int] {
        var indexes: [Int] = []
        // Add each visible cell except the lowest one and return
        for cellIndexPath in self.collectionView.indexPathsForVisibleItems {
            indexes.append(cellIndexPath.row)
        }
        return indexes.sorted()
    }
    /// The currently focussed card index.
    var focussedCardIndex: Int? {
        let center = self.convert(self.collectionView.center, to: self.collectionView)
        if let indexPath = self.collectionView.indexPathForItem(at: center) {
            return indexPath.row
        }
        return nil
    }

    weak var delegate: CardSwiperDelegate?
    weak var datasource: CardSwiperDataSource?

    /// We use this tapGestureRecognizer for the tap recognizer.
    fileprivate var tapGestureRecognizer: UITapGestureRecognizer!
    /// We use this tapGestureRecognizer for the tap recognizer.
    fileprivate var longPressGestureRecognizer: UILongPressGestureRecognizer!
    /// We use this horizontalPangestureRecognizer for the vertical panning.
    fileprivate var horizontalPangestureRecognizer: UIPanGestureRecognizer!
    /// Stores a `CGRect` with the area that is swipeable to the user.
    fileprivate var swipeAbleArea: CGRect?
    /// The `CardCell` that the user can (and is) moving.
    fileprivate var swipedCard: CardCell! {
        didSet {
            self.setupCardSwipeDelegate()
        }
    }

    /// The flowlayout used in the collectionView.
    private lazy var flowLayout: FeedCollectionViewFlowLayout = {
        let flowLayout = FeedCollectionViewFlowLayout()
        flowLayout.firstItemTransform = firstItemTransform
        flowLayout.minimumLineSpacing = cardSpacing
        flowLayout.isPagingEnabled = true
        return flowLayout
    }()

    /**
     Inserts new cards at the specified indexes.

     Call this method to insert one or more new cards into the cardSwiper.
     You might do this when your data source object receives data for new items or in response to user interactions with the cardSwiper.
     - parameter indexes: An array of integers at which to insert the new card. This parameter must not be nil.
     */
    func insertCards(at indexes: [Int]) {
        performUpdates {
            self.collectionView.insertItems(at: indexes.map { (index) -> IndexPath in
                return self.convertIndexToIndexPath(for: index)
            })
        }
    }

    /**
     Deletes cards at the specified indexes.

     Call this method to delete one or more new cards from the cardSwiper.
     You might do this when you remove the items from your data source object or in response to user interactions with the cardSwiper.
     - parameter indexes: An array of integers at which to delete the card. This parameter must not be nil.
     */
    func deleteCards(at indexes: [Int]) {
        performUpdates {
            self.collectionView.deleteItems(at: indexes.map { (index) -> IndexPath in
                return self.convertIndexToIndexPath(for: index)
            })
        }
    }

    /**
     Moves an item from one location to another in the collection view.

     Use this method to reorganize existing cards. You might do this when you rearrange the items within your data source object or in response to user interactions with the cardSwiper. The cardSwiper updates the layout as needed to account for the move, animating cards into position as needed.

     - parameter atIndex: The index of the card you want to move. This parameter must not be nil.
     - parameter toIndex: The index of the card’s new location. This parameter must not be nil.
     */
    func moveCard(at atIndex: Int, to toIndex: Int) {
        self.collectionView.moveItem(at: convertIndexToIndexPath(for: atIndex),
                                     to: convertIndexToIndexPath(for: toIndex))
    }

    override func initialize() {
        self.setupVerticalCardSwiperView()
        self.setupConstraints()
        self.setCardSwiperInsets()
        self.setupGestureRecognizer()
    }

    private func performUpdates(updateClosure: () -> Void) {
        UIView.performWithoutAnimation {
            self.collectionView.performBatchUpdates({
                updateClosure()
            }, completion: { [weak self] _ in
                self?.collectionView.collectionViewLayout.invalidateLayout()
            })
        }
    }
}

extension CardSwiperView: CardDelegate {

    internal func willSwipeAway(cell: CardCell, swipeDirection: SwipeDirection) {
        self.collectionView.isUserInteractionEnabled = false

        if let index = self.collectionView.indexPath(for: cell)?.row {
            self.delegate?.willSwipeCardAway?(cell: cell, index: index, swipeDirection: swipeDirection)
        }
    }

    internal func didSwipeAway(cell: CardCell, swipeDirection direction: SwipeDirection) {
        if let indexPathToRemove = self.collectionView.indexPath(for: cell) {
            swipedCard = nil
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: [indexPathToRemove])
            }, completion: { [weak self] _ in
                guard let `self` = self else { return }
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.isUserInteractionEnabled = true
                self.delegate?.didSwipeCardAway?(cell: cell, index: indexPathToRemove.row, swipeDirection: direction)
            })
        }
    }

    internal func didDragCard(cell: CardCell, swipeDirection: SwipeDirection) {
        if let index = self.collectionView.indexPath(for: cell)?.row {
            self.delegate?.didDragCard?(card: cell, index: index, swipeDirection: swipeDirection)
        }
    }

    private func setupCardSwipeDelegate() {
        self.swipedCard?.delegate = self
    }
}

extension CardSwiperView: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if let panGestureRec = horizontalPangestureRecognizer {
            // When a horizontal pan is detected, we make sure to disable the collectionView.panGestureRecognizer so that it doesn't interfere with the sideswipe.
            if let direction = panGestureRec.direction, direction.isX {
                return false
            }
        }
        return true
    }

    /// We set up the `horizontalPangestureRecognizer` and attach it to the `collectionView`.
    fileprivate func setupGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleTap))
        tapGestureRecognizer.delegate = self
        self.collectionView.addGestureRecognizer(tapGestureRecognizer)

        longPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(handleHold))
        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.minimumPressDuration = 0.125
        longPressGestureRecognizer.cancelsTouchesInView = false
        self.collectionView.addGestureRecognizer(longPressGestureRecognizer)

        horizontalPangestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        horizontalPangestureRecognizer.maximumNumberOfTouches = 1
        horizontalPangestureRecognizer.delegate = self
        self.collectionView.addGestureRecognizer(horizontalPangestureRecognizer)
        self.collectionView.panGestureRecognizer.maximumNumberOfTouches = 1
    }

    @objc fileprivate func handleTap(sender: UITapGestureRecognizer) {
        if let delegate = delegate {
            if let wasTapped = delegate.didTapCard {
                /// The taplocation relative to the collectionView.
                let locationInCollectionView = sender.location(in: self.collectionView)

                if let tappedCardIndex = self.collectionView.indexPathForItem(at: locationInCollectionView) {
                    wasTapped(self.collectionView, tappedCardIndex.row)
                }
            }
        }
    }

    @objc fileprivate func handleHold(sender: UILongPressGestureRecognizer) {
        if let delegate = delegate {
            if let wasHeld = delegate.didHoldCard {
                /// The taplocation relative to the collectionView.
                let locationInCollectionView = sender.location(in: self.collectionView)

                if let swipedCardIndex = self.collectionView.indexPathForItem(at: locationInCollectionView) {
                    wasHeld(self.collectionView, swipedCardIndex.row, sender.state)
                }
            }
        }
    }

    /**
     This function is called when a pan is detected inside the `collectionView`.
     We also take care of detecting if the pan gesture is inside the `swipeAbleArea` and we animate the cell if necessary.
     - parameter sender: The `UIPanGestureRecognizer` that detects the pan gesture. In this case `horizontalPangestureRecognizer`.
     */
    @objc private func handlePan(sender: UIPanGestureRecognizer) {

        guard isSideSwipingEnabled else { return }

        /// The taplocation relative to the superview.
        let location = sender.location(in: self)
        /// The taplocation relative to the collectionView.
        let locationInCollectionView = sender.location(in: self.collectionView)
        /// The translation of the finger performing the PanGesture.
        let translation = sender.translation(in: self)

        if let swipeArea = self.swipeAbleArea, swipeArea.contains(location) && !self.collectionView.isScrolling {
            if let swipedCardIndex = self.collectionView.indexPathForItem(at: locationInCollectionView) {
                /// The card that is swipeable inside the SwipeAbleArea.
                self.swipedCard = self.collectionView.cellForItem(at: swipedCardIndex) as? CardCell
            }
        }

        if swipedCard != nil && !self.collectionView.isScrolling {
            /// The angle we pass for the swipe animation.
            let maximumRotation: CGFloat = 1.0
            let rotationStrength = min(translation.x / self.swipedCard.frame.width, maximumRotation)
            let angle = (CGFloat(Double.pi) / 10.0) * rotationStrength

            switch sender.state {
            case .began, .changed:
                swipedCard.animateCard(angle: angle, horizontalTranslation: translation.x)
            case .ended:
                swipedCard.endedPanAnimation(angle: angle)
                swipedCard = nil
            default:
                self.swipedCard.resetToCenterPosition()
                self.swipedCard = nil
            }
        }
    }
}

extension CardSwiperView: UICollectionViewDelegate, UICollectionViewDataSource {

    /**
     Reloads all of the data for the VerticalCardSwiperView.

     Call this method sparingly when you need to reload all of the items in the VerticalCardSwiper. This causes the VerticalCardSwiperView to discard any currently visible items (including placeholders) and recreate items based on the current state of the data source object. For efficiency, the VerticalCardSwiperView only displays those cells and supplementary views that are visible. If the data shrinks as a result of the reload, the VerticalCardSwiperView adjusts its scrolling offsets accordingly.
     */
    func reloadData() {
        self.collectionView.reloadData()
    }

    /**
     Scrolls the collection view contents until the specified item is visible.
     If you want to scroll to a specific card from the start, make sure to call this function in `viewDidLayoutSubviews`
     instead of functions like `viewDidLoad` as the underlying collectionView needs to be loaded first for this to work.
     - parameter index: The index of the item to scroll into view.
     - parameter animated: Specify true to animate the scrolling behavior or false to adjust the scroll view’s visible content immediately.
     - Returns: True if scrolling succeeds. False if scrolling failed.
     Scrolling could fail due to the flowlayout not being set up yet or an incorrect index.
     */
    func scrollToCard(at index: Int, animated: Bool) -> Bool {

        /**
         scrollToItem & scrollRectToVisible were giving issues with reliable scrolling,
         so we're using setContentOffset for the time being.
         See: https://github.com/JoniVR/VerticalCardSwiper/issues/23
         */
        guard
            let cellHeight = flowLayout.cellHeight,
            index >= 0,
            index < self.collectionView.numberOfItems(inSection: 0)
            else { return false }

        let y = CGFloat(index) * (cellHeight + flowLayout.minimumLineSpacing) - topInset
        let point = CGPoint(x: self.collectionView.contentOffset.x, y: y)
        self.collectionView.setContentOffset(point, animated: animated)
        return true
    }

    /**
     Register a class for use in creating new CardCells.
     Prior to calling the dequeueReusableCell(withReuseIdentifier:for:) method of the collection view,
     you must use this method or the register(_:forCellWithReuseIdentifier:) method
     to tell the collection view how to create a new cell of the given type.
     If a cell of the specified type is not currently in a reuse queue,
     the VerticalCardSwiper uses the provided information to create a new cell object automatically.
     If you previously registered a class or nib file with the same reuse identifier,
     the class you specify in the cellClass parameter replaces the old entry.
     You may specify nil for cellClass if you want to unregister the class from the specified reuse identifier.
     - parameter cellClass: The class of a cell that you want to use in the VerticalCardSwiper
     identifier
     - parameter identifier: The reuse identifier to associate with the specified class. This parameter must not be nil and must not be an empty string.
     */
    func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        self.collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    /**
     Register a nib file for use in creating new collection view cells.
     Prior to calling the dequeueReusableCell(withReuseIdentifier:for:) method of the collection view,
     you must use this method or the register(_:forCellWithReuseIdentifier:) method
     to tell the collection view how to create a new cell of the given type.
     If a cell of the specified type is not currently in a reuse queue,
     the collection view uses the provided information to create a new cell object automatically.
     If you previously registered a class or nib file with the same reuse identifier,
     the object you specify in the nib parameter replaces the old entry.
     You may specify nil for nib if you want to unregister the nib file from the specified reuse identifier.
     - parameter nib: The nib object containing the cell object. The nib file must contain only one top-level object and that object must be of the type UICollectionViewCell.
     identifier
     - parameter identifier: The reuse identifier to associate with the specified nib file. This parameter must not be nil and must not be an empty string.
     */
    func register(nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        self.collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasource?.numberOfCards(cardSwiperView: self) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.datasource?.cardForItemAt(cardSwiperView: self, cardForItemAt: indexPath.row) ?? CardCell()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.didScroll?(in: self.collectionView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.delegate?.didEndScroll?(in: self.collectionView)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.didEndScroll?(in: self.collectionView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.delegate?.didEndScroll?(in: self.collectionView)
    }

    fileprivate func setupVerticalCardSwiperView() {
        self.collectionView = FeedCollectionView(flowLayout: self.flowLayout)//VerticalCardSwiperView(frame: self.frame, collectionViewLayout: flowLayout)
        self.collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.addSubview(self.collectionView)
    }

    fileprivate func setupConstraints() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }

    private func setCardSwiperInsets() {
        let bottomInset = self.visibleNextCardHeight + self.flowLayout.minimumLineSpacing
        self.collectionView.contentInset = UIEdgeInsets(top: topInset,
                                                        left: sideInset,
                                                        bottom: bottomInset,
                                                        right: sideInset)
    }
}

extension CardSwiperView: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemSize = calculateItemSize(for: indexPath.row)

        // set cellHeight in the custom flowlayout, we use this for paging calculations.
        flowLayout.cellHeight = itemSize.height

        if swipeAbleArea == nil {
            // Calculate and set the swipeAbleArea. We use this to determine wheter the cell can be swiped to the sides or not.
            let swipeAbleAreaOriginY = collectionView.frame.origin.y + collectionView.contentInset.top
            self.swipeAbleArea = CGRect(x: 0, y: swipeAbleAreaOriginY, width: self.frame.width, height: itemSize.height)
        }
        return itemSize
    }

    fileprivate func calculateItemSize(for index: Int) -> CGSize {

        let cellWidth: CGFloat!
        let cellHeight: CGFloat!
        let xInsets = sideInset * 2
        let yInsets = cardSpacing + visibleNextCardHeight + topInset

        // get size from delegate if the sizeForItem function is called.
        if let customSize = delegate?.sizeForItem?(in: self.collectionView, index: index) {
            // set custom sizes and make sure sizes are not negative, if they are, don't subtract the insets.
            cellWidth = customSize.width - (customSize.width - xInsets > 0 ? xInsets : 0)
            cellHeight = customSize.height - (customSize.height - yInsets > 0 ? yInsets : 0)
        } else {
            cellWidth = self.collectionView.frame.size.width - xInsets
            cellHeight = self.collectionView.frame.size.height - yInsets
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension CardSwiperView {
    /// Takes an index as Int and converts it to an IndexPath with row: index and section: 0.
    func convertIndexToIndexPath(for index: Int) -> IndexPath {
        return IndexPath(row: index, section: 0)
    }
}

extension UIPanGestureRecognizer {

    /**
     This calculated var stores the direction of the gesture received by the `UIPanGestureRecognizer`.
     */
    var direction: PanDirection? {
        let velocity = self.velocity(in: view)
        let vertical = abs(velocity.y) > abs(velocity.x)
        switch (vertical, velocity.x, velocity.y) {
        case (true, _, let y) where y < 0: return .Up
        case (true, _, let y) where y > 0: return .Down
        case (false, let x, _) where x > 0: return .Right
        case (false, let x, _) where x < 0: return .Left
        default: return .None
        }
    }
}

/// The direction of the `UIPanGesture`.
public enum PanDirection: Int {
    case Up
    case Down
    case Left
    case Right
    case None

    /// Returns true is the PanDirection is horizontal.
    var isX: Bool { return self == .Left || self == .Right }
    /// Returns true if the PanDirection is vertical.
    var isY: Bool { return self == .Up || self == .Down }
}


