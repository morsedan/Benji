//
//  ChannelViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelViewController: FullScreenViewController {

    lazy var collectionView: ChannelCollectionView = {
        return ChannelCollectionView()
    }()

    lazy var manager: ChannelCollectionViewManager = {
        return ChannelCollectionViewManager(with: self.collectionView, items: self.items)
    }()

    var items: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let item1 = Message(id: "1",
                            text: "",
                            backgroundColor: .darkGray)

        let item2 = Message(id: "2",
                            text: "",
                            backgroundColor: .blue)

        let item3 = Message(id: "3",
                            text: "",
                            backgroundColor: .blue)

        let item4 = Message(id: "4",
                            text: "",
                            backgroundColor: .darkGray)

        let item5 = Message(id: "5",
                            text: "",
                            backgroundColor: .darkGray)

        let item6 = Message(id: "6",
                            text: "",
                            backgroundColor: .blue)

        self.items.append(contentsOf: [item1, item2, item3, item4, item5, item6])

        self.collectionView.dataSource = self.manager
        self.collectionView.delegate = self.manager
    }
}
