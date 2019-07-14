//
//  ChannelDataSource.swift
//  Benji
//
//  Created by Benji Dodgson on 7/14/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift

class ChannelDataSource: CollectionDataSource {
    typealias SectionType = Date
    typealias ItemType = MessageType
    typealias CollectionViewType = ChannelCollectionView
    var sections: MutableProperty<[Date: [MessageType]]> = MutableProperty([Date: [MessageType]]())
}
