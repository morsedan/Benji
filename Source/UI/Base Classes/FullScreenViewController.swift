//
//  FullScreenViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/25/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class FullScreenViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.set(backgroundColor: .darkGray)
    }
}

// Base class for all full screen view controllers pushed onto a UINavigationController stack.
// Contains a custom navigation bar that replaces the standard navigation bar. View content is
// placed in the space below the nav bar.
class NavigationPageViewController: ViewController {

    // A custom nav bar that replaces the standard UINavController bar
    let tomorrowNavigationBar = NavigationBar()

    // A view to insert content. Takes up the space below the custom nav bar
    let contentContainer = View()

    var isTomorrowNavBarHidden: Bool = false {
        didSet {
            self.view.setNeedsLayout()
        }
    }
    private var wasPreviousNavBarHidden = false

    // Observe the standard title property so we can set the title on the custom nav bar
    override var title: String? {
        willSet {
            if let text = newValue {
                self.tomorrowNavigationBar.setTitle(text)
            }
        }
    }

    var localizedTitle: Localized? {
        willSet {
            if let localized = newValue {
                self.tomorrowNavigationBar.setTitle(localized)
            }
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init?(withObject object: DeepLinkable) {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.set(backgroundColor: .blue)
        self.view.addSubview(self.tomorrowNavigationBar)
        self.view.addSubview(self.contentContainer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.tomorrowNavigationBar.top = self.view.safeAreaInsets.top
        self.tomorrowNavigationBar.width = self.view.width
        self.tomorrowNavigationBar.height = self.isTomorrowNavBarHidden ? 0 : 44
        self.tomorrowNavigationBar.isHidden = self.isTomorrowNavBarHidden
        self.tomorrowNavigationBar.centerOnX()

        self.contentContainer.top = self.tomorrowNavigationBar.bottom
        self.contentContainer.width = self.view.width
        self.contentContainer.height = self.view.height - self.tomorrowNavigationBar.bottom
        self.contentContainer.centerOnX()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        once(caller: self, token: "savePreviousNavBarState") {
            guard let navController = self.navigationController else { return }
            self.wasPreviousNavBarHidden = navController.isNavigationBarHidden
            // Full screen view controllers have their own nav bar so hide the system one
            navController.setNavigationBarHidden(true, animated: true)
        }

        self.updateNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Force hide keyboard so it dimisses at the same time as view controller
        self.view.endEditing(true)
    }

    override func viewWasDismissed() {
        super.viewWasDismissed()

        self.navigationController?.setNavigationBarHidden(self.wasPreviousNavBarHidden,
                                                          animated: true)
    }

    private func updateNavigationBar() {}

    func setLeftNavBar(_ item: UIView) {
        self.tomorrowNavigationBar.setLeft(item) { [unowned self] in
            self.didTapLeftItem()
        }
    }

    func setRightNavBar(_ item: UIView) {
        self.tomorrowNavigationBar.setRight(item) { [unowned self] in
            self.didTapRightItem()
        }
    }

    func didTapLeftItem() {
        if let navigationController = self.navigationController,
            navigationController.viewControllers.first !== self {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }

    func didTapRightItem() {}
}

