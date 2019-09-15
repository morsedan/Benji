//
//  ChannelDataSourceManager.swift
//  Benji
//
//  Created by Benji Dodgson on 7/20/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift

class ChannelDataSourceManager: ChannelDataSource {
    var sections: [ChannelSectionType] = []
    var collectionView: CollectionView?
}
