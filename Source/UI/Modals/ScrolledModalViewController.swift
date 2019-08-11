//
//  ScrolledModalViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol ScrolledModalControllerPresentable where Self : UIViewController {
    var topMargin: CGFloat { get }
    var scrollView: UIScrollView? { get }
    var scrollingEnabled: Bool { get }
    var didDismiss: (() -> Void)? { get set }
}

class ScrolledModalViewController: ViewController, ScrolledModalContainerViewDelegate, KeyboardManageable {

    var contentExpandedHeight: CGFloat {
        return self.view.height - self.presentable.topMargin
    }

    private let tapDismissView = UIView()

    private let modalContainerView: ScrolledModalContainerView
    private var presentable: ScrolledModalControllerPresentable

    private let titleLabel = Label()
    private let titleContainer = View()

    var titleText: Localized? {
        didSet {
            guard let text = self.titleText else { return }
            let attributed = AttributedString(text,
                                              fontType: .display2,
                                              color: .white)
            self.titleLabel.set(attributed: attributed,
                                alignment: .left)
        }
    }

    init(presentable: ScrolledModalControllerPresentable) {
        self.presentable = presentable
        self.modalContainerView = ScrolledModalContainerView(presentable: presentable)

        super.init()

        // You should be able to see the rest of the view hierarchy underneath this controller
        self.modalPresentationStyle = .overFullScreen

        self.modalContainerView.initialize(scrollingEnabled: self.presentable.scrollingEnabled)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerKeyboardEvents()

        self.view.set(backgroundColor: .clear)
        self.modalContainerView.delegate = self

        // The tap dismiss view should be added as the bottom most view so it doesn't prevent interactions
        // with the content.
        self.tapDismissView.set(backgroundColor: .backgroundWithAlpha)
        self.tapDismissView.alpha = 0

        self.view.addSubview(self.tapDismissView)
        self.tapDismissView.onTap { [unowned self] (tap) in
            self.modalContainerView.animateToHeight(height: 0)
        }

        self.view.addSubview(self.modalContainerView)
        self.view.addSubview(self.titleContainer)
        self.titleContainer.addSubview(self.titleLabel)
        self.titleContainer.set(backgroundColor: .background3)

        self.addChild(viewController: self.presentable, toView: self.modalContainerView)
        self.presentable.didDismiss = { [unowned self] in
            self.dismiss(animated: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.animate(height: self.getExpandedHeight(), with: Theme.animationDuration)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.tapDismissView.frame = self.view.bounds

        self.modalContainerView.size = CGSize(width: self.view.width * 0.95,
                                              height: self.modalContainerView.currentHeight)
        self.modalContainerView.centerOnX()
        self.modalContainerView.bottom = self.view.height

        self.titleContainer.width = self.modalContainerView.width

        if let attributedText = self.titleLabel.attributedText {
            let titleWidth = self.titleContainer.width - 24 * 2
            self.titleLabel.size = attributedText.getSize(withWidth: titleWidth)
            self.titleContainer.height = self.titleLabel.height + 32 + Theme.contentOffset
        } else {
            self.titleContainer.height = 0
        }

        self.titleLabel.top = 32
        self.titleLabel.left = 24

        self.titleContainer.bottom = self.modalContainerView.top
        self.titleContainer.centerOnX()
        self.titleContainer.round(corners: UIRectCorner(arrayLiteral: [.topLeft, .topRight]), size: CGSize(width: Theme.cornerRadius, height: Theme.cornerRadius))

        self.presentable.view.frame = self.modalContainerView.bounds
    }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let expandedHeight = size.height - self.presentable.topMargin
        self.modalContainerView.setExpandedHeight(expandedHeight: expandedHeight)
    }

    func scrolledmodalContainerViewIsPanning(_ container: ScrolledModalContainerView,
                                             withProgress progress: Float) {
        self.updateAlpha(with: progress)
    }

    func scrolledModalContainerView(_ container: ScrolledModalContainerView,
                                    updated currentHeight: CGFloat) {
        self.view.layoutNow()
        self.updateAlpha(with: self.modalContainerView.progress)
    }

    func scrolledModalContainerViewFinishedAnimating(_ container: ScrolledModalContainerView,
                                                     withProgress progress: Float) {
        self.updateAlpha(with: progress)
        guard progress == 0 else { return }
        self.dismiss(animated: true, completion: nil)
    }

    private func animate(height: CGFloat, with duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.modalContainerView.setExpandedHeight(expandedHeight: height)
        }
    }

    private func updateAlpha(with progress: Float) {
        self.tapDismissView.alpha = CGFloat(progress)
    }

    private func getExpandedHeight() -> CGFloat {
        return self.view.height - self.presentable.topMargin
    }

    func handleKeyboard(height: CGFloat) {
        let expandedHeight = self.getExpandedHeight() + height
        self.animate(height: expandedHeight, with: 0.15)
    }
}
