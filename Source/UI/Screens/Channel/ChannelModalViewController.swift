//
//  ChannelModalViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/17/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelModalViewController: ScrolledModalViewController {

    let detailBar = ChannelDetailBar()

    init(with channelType: ChannelType) {
        let vc = ChannelViewController(channelType: channelType)
        super.init(presentable: vc)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViews() {
        super.initializeViews()

        self.view.addSubview(self.detailBar)

        self.detailBar.closeButton.onTap { [unowned self] (tap) in
            self.dismiss(animated: true, completion: nil)
        }

        //Have modal go to bottom of detail bar 
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.detailBar.size = CGSize(width: self.view.width, height: 60)
        self.detailBar.top = self.view.safeAreaInsets.top
        self.detailBar.centerOnX()
    }
}
