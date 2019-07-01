//
//  ModalViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 6/30/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

// A container viewcontroller to display modal content, such as branded alerts.
// Automatically handles presentation and dismissal animations.

class ModalViewController: ViewController {

    // A container view to hold any views you want to slide up from the bottom of the screen
    let mainContent = UIView()

    private var modalTransitionDelegate = ModalControllerTransitioningDelegate()

    init() {
        super.init(nibName: nil, bundle: nil)

        self.modalPresentationStyle = .overFullScreen
        self.transitioningDelegate = self.modalTransitionDelegate

        self.initializeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initializeViews() {
        // This is needed to maintain the contentViews frame
        self.definesPresentationContext = true

        self.view.addSubview(self.mainContent)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.mainContent.frame = self.view.bounds
    }
}

private class ModalControllerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    let transitionController = ModalControllerAnimatedTransitioning()

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        self.transitionController.isPresenting = true
        return self.transitionController
    }

    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {

            self.transitionController.isPresenting = false
            return self.transitionController
    }
}
