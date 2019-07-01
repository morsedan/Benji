//
//  ChannelsContentView.swift
//  Benji
//
//  Created by Benji Dodgson on 2/3/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelsContentView: View {

    lazy var collectionView: ChannelsCollectionView = {
        return ChannelsCollectionView()
    }()

    @IBOutlet weak var collectionViewContainer: UIView!
    @IBOutlet weak var button: Button!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.set(backgroundColor: .clear)
        self.collectionViewContainer.set(backgroundColor: .clear)

        self.collectionViewContainer.addSubview(self.collectionView)
        self.collectionView.autoPinEdgesToSuperviewEdges()

        self.button.set(style: .normal(color: .blue, text: "ADD"))
    }
}
