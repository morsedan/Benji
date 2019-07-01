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
    var didExit: (() -> Void)? { get set }
}

class ScrolledModalController: ViewController {

    var contentExpandedHeight: CGFloat {
        return self.view.height - self.presentable.topMargin
    }

    private let tapDismissView = UIView()

    private let modalContainerView: ScrolledModalContainerView
    private var presentable: ScrolledModalControllerPresentable

    init(presentable: ScrolledModalControllerPresentable) {
        self.presentable = presentable
        self.modalContainerView = ScrolledModalContainerView(presentable: presentable)

        super.init(nibName: nil, bundle: nil)

        // You should be able to see the rest of the view hierarchy underneath this controller
        self.modalPresentationStyle = .overFullScreen

        self.modalContainerView.initialize(scrollingEnabled: self.presentable.scrollingEnabled)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.set(backgroundColor: .clear)
        self.modalContainerView.delegate = self

        // The tap dismiss view should be added as the bottom most view so it doesn't prevent interactions
        // with the content.
        self.view.addSubview(self.tapDismissView)
        self.tapDismissView.onTap { [unowned self] (tap) in
            self.dismiss(animated: true)
        }

        self.view.addSubview(self.modalContainerView)

        self.addChild(viewController: self.presentable, toView: self.modalContainerView)
        self.presentable.didExit = { [unowned self] in
            self.dismiss(animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let expandedHeight = self.view.height - self.presentable.topMargin
        self.modalContainerView.setExpandedHeight(expandedHeight: expandedHeight)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.tapDismissView.frame = self.view.bounds

        self.modalContainerView.size = CGSize(width: self.view.width,
                                              height: self.modalContainerView.currentHeight)
        self.modalContainerView.left = 0
        self.modalContainerView.bottom = self.view.height

        self.presentable.view.frame = self.modalContainerView.bounds
    }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let expandedHeight = size.height - self.presentable.topMargin
        self.modalContainerView.setExpandedHeight(expandedHeight: expandedHeight)
    }
}

extension ScrolledModalController: ScrolledModalContainerViewDelegate {

    func scrolledModalContainerView(_ container: ScrolledModalContainerView,
                                    updated currentHeight: CGFloat) {
        self.view.layoutNow()
    }

    func scrolledModalContainerViewFinishedAnimating(_ container: ScrolledModalContainerView,
                                                     withProgress progress: Float) {
        guard progress == 0 else { return }
        self.dismiss(animated: true, completion: nil)
    }
}
