//
//  CenterViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
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
    }

    override func viewIsReadyForLayout() {
        super.viewIsReadyForLayout()

    }
}


