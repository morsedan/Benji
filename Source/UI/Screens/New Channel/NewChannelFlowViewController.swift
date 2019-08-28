//
//  NewChannelScrolledModalViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 8/27/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class NewChannelFlowViewController: ScrolledModalFlowViewController {

    let titleBar = NewChannelTitleBar()
    let collectionView = NewChannelCollectionView()

    override func initializeViews() {
        super.initializeViews()

        self.view.addSubview(self.titleBar)
        self.view.addSubview(self.collectionView)
    }
    

}
