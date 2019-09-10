//
//  NewChannelScrolledModalViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class NewChannelFlowViewController: ScrolledModalFlowViewController {

    lazy var purposeVC = ChannelPurposeViewController(delegate: self.delegate)
    unowned let delegate: ChannelPurposeViewControllerDelegate

    init(delegate: ChannelPurposeViewControllerDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.topMargin = 100
        self.add(controller: self.purposeVC)
        self.moveForward()
    }

    override func handleKeyboard(frame: CGRect, with animationDuration: TimeInterval, timingCurve: UIView.AnimationCurve) {

        
    }
}
