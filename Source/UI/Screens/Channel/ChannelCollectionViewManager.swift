//
//  ChannelCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 7/20/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift

class ChannelCollectionViewManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, ChannelDataSource {
    
    var sections: MutableProperty<[ChannelSectionType]> = MutableProperty([])
    var previousSections: [ChannelSectionType]?
    var collectionView: CollectionView

    var didSelect: (_ item: MessageType, _ indexPath: IndexPath) -> Void = { _, _ in }
    var didLongPress: (_ item: MessageType, _ indexPath: IndexPath) -> Void = { _, _ in }

    init(with collectionView: CollectionView) {
        self.collectionView = collectionView
        super.init()
        self.initialize()
    }

    private func initialize() {
        // Do Stuff
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionView.backgroundView?.isHidden = self.sections.value.count > 0
        return self.sections.value.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = self.sections.value[safe: section] else { return 0 }
        return section.items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let channelCollectionView = collectionView as? ChannelCollectionView else {
            fatalError("Collection view not found")
        }

        guard let channelDataSource = channelCollectionView.channelDataSource else {
            fatalError("Data Source not found")
        }

        guard let message = channelDataSource.item(at: indexPath) else {
            fatalError("Message not found")
        }

        let cell: MessageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell",
                                                                   for: indexPath) as! MessageCell

        cell.configure(with: message, at: indexPath, and: channelCollectionView)
        //Reset all gestures
        cell.contentView.gestureRecognizers?.forEach({ (recognizer) in
            cell.contentView.removeGestureRecognizer(recognizer)
        })

        cell.contentView.onTap { [weak self] (tap) in
            guard let `self` = self else { return }
            self.didSelect(message, indexPath)
        }

        cell.contentView.onLongPress { [weak self] (longPress) in
            guard let `self` = self else { return }
            self.didLongPress(message, indexPath)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let channelLayout = collectionViewLayout as? ChannelCollectionViewFlowLayout else { return .zero }
        return  channelLayout.sizeForItem(at: indexPath)
    }
}
