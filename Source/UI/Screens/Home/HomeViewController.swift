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

    lazy var channelsVC = ChannelsViewController()
    lazy var feedVC = FeedViewController()
    lazy var segmentControl = HomeSegmentControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.contentContainer.addSubview(self.segmentControl)


    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.segmentControl.top = self.contentContainer.top
        self.segmentControl.centerOnX()
    }
}


