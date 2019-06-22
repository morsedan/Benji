//
//  CenterViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import PureLayout

class HomeViewController: FullScreenViewController {

    lazy var channelsVC: ChannelsViewController = {
        return ChannelsViewController()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addChild(viewController: self.channelsVC, toView: self.view)
        self.channelsVC.view.autoPinEdgesToSuperviewEdges()
    }
}


