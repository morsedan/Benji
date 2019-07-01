//
//  AlertModalController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

typealias PagingModalPresentableVC = PagingModalPresentable & UIViewController
protocol PagingModalPresentable: class {
    var onTappedToDismiss: (() ->())? { get set }
}

// A container view controller to display a series of modal pages arranged horizontally.
// Provides methods to scroll amongst the pages.
// Presentation and dismissal animations are handled by a custom transitioning controller.

class PagingModalController: TomorrowModalController {

    enum ScrollType {
        // No user initiated scrolling
        case disabled
        // User can scroll to items previously viewed
        case previouslyViewed
        // User can scroll freely
        case enabled

        var isScrollEnabled: Bool {
            switch self {
            case .disabled:
                return false
            case .previouslyViewed, .enabled:
                return true
            }
        }
    }
    private var isAnimatingScroll: Bool = false {
        didSet {
            // Prevent the user from interrupting the scrolling animation
            self.scrollView.isUserInteractionEnabled = !self.isAnimatingScroll
        }
    }
    var canDismissWithTap: Bool = true
    var scrollType: ScrollType {
        didSet {
            self.scrollView.isScrollEnabled = self.scrollType.isScrollEnabled
            self.updateContentSize(targetIndex: self.scrollView.currentXIndex)
        }
    }

    let scrollView = UIScrollView()

    init(contentViewControllers: [PagingModalPresentableVC]) {
        self.scrollType = .disabled
        super.init()
        self.configure(contentViewControllers: contentViewControllers)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.isScrollEnabled = false
        self.scrollView.bounces = false
        self.scrollView.clipsToBounds = false
        self.scrollView.delegate = self
        self.mainContent.addSubview(self.scrollView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let ratio: CGFloat = UIScreen.main.isSmallerThan(screenSize: .tablet) ? 0.98 : 1
        self.scrollView.size = CGSize(width: ratio * self.view.width, height: self.view.height)

        for (index, viewController) in self.children.enumerated() {
            viewController.view.frame = CGRect(x: CGFloat(index) * self.scrollView.width,
                                               y: 0,
                                               width: self.scrollView.width,
                                               height: self.scrollView.height)
        }

        self.updateContentSize(targetIndex: nil)
    }

    func configure(contentViewControllers: [PagingModalPresentableVC]) {

        self.children.forEach { (viewController) in
            viewController.removeFromParentSuperview()
        }
        self.scrollView.setContentOffset(.zero, animated: false)

        contentViewControllers.forEach { (viewController) in
            self.append(viewController: viewController)
        }
    }

    func append(viewController: PagingModalPresentableVC) {
        self.addChild(viewController: viewController, toView: self.scrollView)
        viewController.onTappedToDismiss = { [weak self] in
            guard let `self` = self else { return }
            if self.canDismissWithTap {
                self.dismiss(animated: true, completion: nil)
            }
        }

        self.view.layoutNow()
        self.updateContent()
    }

    func goToNextPage() {
        let currentIndex = self.scrollView.currentXIndex
        self.goToViewController(atIndex: currentIndex + 1)
    }

    func goToPreviousPage() {
        let currentIndex = self.scrollView.currentXIndex
        self.goToViewController(atIndex: currentIndex - 1)
    }

    func willGoTo(controller: UIViewController) { }

    func goToCard(_ card: PagingModalPresentableVC, animated: Bool) {
        guard let index = self.children.firstIndex(of: card) else { return }

        self.goToViewController(atIndex: index, animated: animated)
    }

    func goToViewController(atIndex index: Int, animated: Bool = true) {
        guard let targetViewController = self.children[safe: index] else { return }
        self.willGoTo(controller: targetViewController)

        self.updateContentSize(targetIndex: index)

        self.scrollView.scrollHorizontallyTo(view: targetViewController.view, animated: animated)
        self.isAnimatingScroll = animated
    }

    func updateContentSize(targetIndex index: Int?) {
        switch self.scrollType {
        case .disabled, .enabled:
            guard let lastViewController = self.children.last else { return }
            // Prevent the scrollview from scrolling vertically by setting the content height to one
            self.scrollView.contentSize = CGSize(width: lastViewController.view.right, height: 1)
        case .previouslyViewed:
            guard let index = index else { return }
            guard let targetViewController = self.children[safe: index] else { return }

            self.scrollView.contentSize = CGSize(width: targetViewController.view.right, height: 1)
        }
    }

    func didCenterOn(controller: PagingModalPresentableVC) { }

    func updateContent() {
        let currentIndex = self.scrollView.currentXIndex

        guard let targetViewController = self.children[safe: currentIndex],
            let presentableVC = targetViewController as? PagingModalPresentableVC else { return }

        self.updateContentSize(targetIndex: nil)
        self.didCenterOn(controller: presentableVC)
    }
}

extension PagingModalController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.isAnimatingScroll {
            self.updateContent()
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.isAnimatingScroll = false
        self.updateContent()
    }
}
