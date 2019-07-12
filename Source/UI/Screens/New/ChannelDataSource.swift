//
//  ChannelDataSource.swift
//  Benji
//
//  Created by Benji Dodgson on 7/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

protocol ChannelDataSource: AnyObject {
    func messageForItem(at indexPath: IndexPath, in collectionView: ChannelCollectionView) -> MessageType
    func numberOfSections(in collectionView: ChannelCollectionView) -> Int
    func numberOfItems(inSection section: Int, in collectionView: ChannelCollectionView) -> Int
}
