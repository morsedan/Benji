//
//  ChannelCollectionViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 7/2/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import ReactiveSwift
import GestureRecognizerClosures

class ChannelCollectionViewController: ViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let loadingView = LoadingView()
    lazy var flowLayout = ChannelCollectionViewFlowLayout()
    lazy var channelDataSource = ChannelDataSource()
    lazy var collectionView: ChannelCollectionView = {
        let collectionView = ChannelCollectionView(with: self.flowLayout)
        collectionView.channelDataSource = self.channelDataSource
        return collectionView
    }()

    var items = MutableProperty<[MessageType]>([])
    // A deep copied array representing the last state of the items.
    // Used to animate changes to the collection view
    private var previousItems: [MessageType]?

    var didSelect: (_ item: MessageType, _ indexPath: IndexPath) -> Void = { _, _ in }
    var didLongPress: (_ item: MessageType, _ indexPath: IndexPath) -> Void = { _, _ in }

    init() {
        super.init(nibName: nil, bundle: nil)
        //self.view.set(backgroundColor: .clear)
        self.subscribeToClient()
        self.subscribeToUpdates()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reset() {
        self.items.value = []
        self.previousItems = nil
        self.collectionView.reloadData()
    }

    func set(newItems: [MessageType]) {
        self.updateCollectionView(items: newItems, modify: { [weak self] in
            guard let `self` = self else { return }
            self.items.value = newItems
        })
    }

    func append(item: MessageType, in section: Int = 0) {

        guard self.items.value.count > 0 else {
            self.set(newItems: [item])
            return
        }

        guard !self.items.value.contains(item) else { return }

        let indexPath = IndexPath(item: self.items.value.count, section: section)
        self.items.value.append(item)
        self.collectionView.insertItems(at: [indexPath])
    }

    func update(item: MessageType, in section: Int = 0) {
        var indexPath: IndexPath?
        for (index, existingItem) in self.items.value.enumerated() {
            if existingItem == item {
                indexPath = IndexPath(item: index, section: section)
                break
            }
        }

        guard let ip = indexPath else { return }

        self.items.value[ip.item] = item
        self.collectionView.reloadItems(at: [ip])
    }

    func delete(item: MessageType, in section: Int = 0) {

        var indexPath: IndexPath?
        for (index, existingItem) in self.items.value.enumerated() {
            if existingItem == item {
                indexPath = IndexPath(item: index, section: section)
                break
            }
        }

        guard let ip = indexPath else { return }

        self.items.value.remove(at: ip.item)
        self.collectionView.deleteItems(at: [ip])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView?.isHidden = self.items.value.count > 0
        return self.items.value.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let channelCollectionView = collectionView as? ChannelCollectionView else {
            fatalError("Collection view not found")
        }

        guard let channelDataSource = channelCollectionView.channelDataSource else {
            fatalError("Data Source not found")
        }

        guard let message = channelDataSource.item(at: indexPath, in: channelCollectionView) else {
            fatalError("Message not found")
        }

        let cell: MessageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell",
                                                                for: indexPath) as! MessageCell

        cell.configure(with: message, at: indexPath, and: self.collectionView)
        //Reset all gestures
        cell.contentView.gestureRecognizers?.forEach({ (recognizer) in
            cell.contentView.removeGestureRecognizer(recognizer)
        })

        cell.contentView.onTap { [weak self] (tap) in
            guard let `self` = self, let item = self.items.value[safe: indexPath.row] else { return }
            self.didSelect(item, indexPath)
        }

        cell.contentView.onLongPress { [weak self] (longPress) in
            guard let `self` = self, let item = self.items.value[safe: indexPath.row] else { return }
            self.didLongPress(item, indexPath)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let channelLayout = collectionViewLayout as? ChannelCollectionViewFlowLayout else { return .zero }
        return  channelLayout.sizeForItem(at: indexPath)
    }

    private func updateCollectionView(items: [MessageType], modify: @escaping () -> Void) {

        self.reloadCollectionView(previousItems: self.previousItems ?? [],
                                  newItems: items,
                                  modify: modify)

        self.previousItems = items
    }

    private func reloadCollectionView(previousItems: [MessageType],
                                      newItems: [MessageType],
                                      modify: @escaping () -> Void) {

        self.collectionView.reload(previousItems: previousItems,
                                   newItems: newItems,
                                   equalityOption: .equality,
                                   modify: modify,
                                   completion: nil)
    }
}
