//
//  CenterViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import SideMenu

class CenterViewController: FullScreenViewController {

    lazy var leftVC: LeftViewController = {
        return LeftViewController()
    }()

    lazy var rightVC: RightViewController = {
        return RightViewController()
    }()

    @IBOutlet weak var view1: View!
    @IBOutlet weak var view2: View!
    @IBOutlet weak var view3: View!
    @IBOutlet weak var view4: View!

    @IBOutlet weak var lable1: Label!
    @IBOutlet weak var lable2: Label!
    @IBOutlet weak var lable3: Label!
    @IBOutlet weak var lable4: Label!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Define the menus
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: self.leftVC)
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController

        let menuRightNavigationController = UISideMenuNavigationController(rootViewController: self.rightVC)
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuRightNavigationController = menuRightNavigationController

        // (Optional) Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the view controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)

        // (Optional) Prevent status bar area from turning black when menu appears:
        SideMenuManager.default.menuFadeStatusBar = false
    }

    override func viewIsReadyForLayout() {
        super.viewIsReadyForLayout()

        self.view1.set(backgroundColor: .blue)
        self.view2.set(backgroundColor: .darkGray)
        self.view3.set(backgroundColor: .red)
        self.view4.set(backgroundColor: .green)

        let style = StringStyle(font: .demiBold, size: 20, color: .white, kern: 2)
        let string = AttributedString("Some default text that will show in the view 😀", style: style)

        self.lable1.set(attributed: string)
        self.lable2.set(attributed: string)
        self.lable3.set(attributed: string)
        self.lable4.set(attributed: string)
    }
}


