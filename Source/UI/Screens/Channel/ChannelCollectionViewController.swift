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

class ChannelCollectionViewController: ViewController, UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {

    let loadingView = LoadingView()

    var didSelect: (_ item: MessageType, _ indexPath: IndexPath) -> Void = { _, _ in }
    var didLongPress: (_ item: MessageType, _ indexPath: IndexPath) -> Void = { _, _ in }

    lazy var channelDataSource: ChannelDataSourceManager = {
        let dataSource = ChannelDataSourceManager()
        return dataSource
    }()

    lazy var collectionView: ChannelCollectionView = {
        let flowLayout = ChannelCollectionViewFlowLayout()
        let collectionView = ChannelCollectionView(with: flowLayout)
        return collectionView
    }()

    override func loadView() {
        self.view = self.collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.channelDataSource.collectionView = self.collectionView
        self.collectionView.channelDataSource = self.channelDataSource

        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        self.subscribeToClient()
        self.subscribeToUpdates()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionView.backgroundView?.isHidden = self.channelDataSource.sections.value.count > 0
        return self.channelDataSource.sections.value.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = self.channelDataSource.sections.value[safe: section] else { return 0 }
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
        guard let channelLayout = collectionViewLayout as? ChannelCollectionViewFlowLayout else {
            return .zero
        }
        return channelLayout.sizeForItem(at: indexPath)
    }
}
