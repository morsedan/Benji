//
//  CenterViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import SideMenu
import PureLayout

class CenterViewController: FullScreenViewController {

    lazy var leftVC: LeftViewController = {
        return LeftViewController()
    }()

    lazy var rightVC: RightViewController = {
        return RightViewController()
    }()

    lazy var channelsVC: ChannelsViewController = {
        return ChannelsViewController()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addChild(viewController: self.channelsVC, toView: self.view)
        self.channelsVC.view.autoPinEdgesToSuperviewEdges()
        self.setupSideMenu()
    }

    override func viewIsReadyForLayout() {
        super.viewIsReadyForLayout()

    }

    private func setupSideMenu() {
        // Define the menus
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: self.leftVC)
        menuLeftNavigationController.navigationBar.isHidden = true
        menuLeftNavigationController.sideMenuDelegate = self
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController

        let menuRightNavigationController = UISideMenuNavigationController(rootViewController: self.rightVC)
        menuRightNavigationController.navigationBar.isHidden = true
        menuRightNavigationController.sideMenuDelegate = self
        SideMenuManager.default.menuRightNavigationController = menuRightNavigationController

        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuAnimationTransformScaleFactor = 0.8
        SideMenuManager.default.menuPresentMode = .viewSlideInOut

        SideMenuManager.default.menuFadeStatusBar = false
    }
}

extension CenterViewController: UISideMenuNavigationControllerDelegate {

    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }

    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }

    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }

    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
}


