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

    /// A method that by default checks if the section is the last in the
    /// `messagesCollectionView` and that `isTypingIndicatorViewHidden`
    /// is FALSE
    ///
    /// - Parameter section
    /// - Returns: A Boolean indicating if the TypingIndicator should be presented at the given section
    func isSectionReservedForTypingIndicator(_ section: Int) -> Bool {
        return !self.collectionView.isTypingIndicatorHidden
            && section == self.numberOfSections(in: self.collectionView) - 1
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let channelCollectionView = collectionView as? ChannelCollectionView else { return 0 }
        collectionView.backgroundView?.isHidden = self.channelDataSource.sections.value.count > 0
        var numberOfSections = self.channelDataSource.sections.value.count
        if channelCollectionView.isTypingIndicatorHidden {
            numberOfSections += 1
        }
        return numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = self.channelDataSource.sections.value[safe: section] else { return 0 }

        if self.isSectionReservedForTypingIndicator(section) {
            return 1
        }

        return sectionType.items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let channelCollectionView = collectionView as? ChannelCollectionView else {
            fatalError("Collection view not found")
        }

        guard let channelDataSource = channelCollectionView.channelDataSource else {
            fatalError("Data Source not found")
        }

        if self.isSectionReservedForTypingIndicator(indexPath.section) {
            return channelCollectionView.dequeueReusableCell(TypingIndicatorCell.self, for: indexPath)
        }

        guard let message = channelDataSource.item(at: indexPath) else {
            fatalError("Message not found")
        }

        let cell = channelCollectionView.dequeueReusableCell(MessageCell.self, for: indexPath)

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

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return self.header(for: collectionView, at: indexPath)
        case UICollectionView.elementKindSectionFooter:
            fatalError("NO FOOTER")
        default:
            fatalError("UNRECOGNIZED SECTION KIND")
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard !self.isSectionReservedForTypingIndicator(section) else { return .zero }
        return CGSize(width: collectionView.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? TypingIndicatorCell else { return }
        cell.typingBubble.startAnimating()
    }

    private func header(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: ChannelSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                            withReuseIdentifier: "ChannelSectionHeader",
                                                                                            for: indexPath) as! ChannelSectionHeader

        guard let section = self.channelDataSource.sections.value[safe: indexPath.section] else { return header }
        header.configure(with: section.date)
        return header
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
