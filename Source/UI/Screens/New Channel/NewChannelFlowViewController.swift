//
//  NewChannelScrolledModalViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class NewChannelFlowViewController: ScrolledModalFlowViewController {

    lazy var purposeVC = ChannelPurposeViewController()

    override func initializeViews() {
        super.initializeViews()

        self.add(controller: self.purposeVC)
        self.moveForward()
    }
}
