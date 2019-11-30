//
//  ChannelCollectionViewManager.swift
//  Benji
//
//  Created by Benji Dodgson on 11/10/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import ReactiveSwift
import TwilioChatClient

class ChannelCollectionViewManager: NSObject, UITextViewDelegate, ChannelDataSource,
UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var sections: [ChannelSectionable] = [] {
        didSet {
            self.updateLayoutDataSource()
        }
    }

    var collectionView: ChannelCollectionView
    var didSelectURL: ((URL) -> Void)?
    var willDisplayCell: ((Messageable, IndexPath) -> Void)?

    init(with collectionView: ChannelCollectionView) {
        self.collectionView = collectionView
        super.init()
        self.updateLayoutDataSource()
    }

    private func updateLayoutDataSource() {
        self.collectionView.channelLayout.dataSource = self
    }

    // MARK: DATA SOURCE

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let channelCollectionView = collectionView as? ChannelCollectionView else { return 0 }
        var numberOfSections = self.numberOfSections()

        if !channelCollectionView.isTypingIndicatorHidden {
            numberOfSections += 1
        }

        return numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if self.isSectionReservedForTypingIndicator(section) {
            return 1
        }

        return self.numberOfItems(inSection: section)
    }

    // MARK: DELEGATE

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let channelCollectionView = collectionView as? ChannelCollectionView else { fatalError() }

        if self.isSectionReservedForTypingIndicator(indexPath.section) {
            return channelCollectionView.dequeueReusableCell(TypingIndicatorCell.self, for: indexPath)
        }

        guard let message = self.item(at: indexPath) else { fatalError("No message found for cell") }

        let cell = channelCollectionView.dequeueReusableCell(MessageCell.self, for: indexPath)

        cell.configure(with: message)
        cell.textView.delegate = self
        cell.didTapMessage = { [weak self] in
            guard let `self` = self, let current = User.current() else { return }
            self.updateConsumers(with: current, for: message)
        }

        return cell
    }

    private func updateConsumers(with consumer: Avatar, for message: Messageable) {

        //create system message copy of current message

        message.udpateConsumers(with: consumer)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return self.header(for: collectionView, at: indexPath)
        case UICollectionView.elementKindSectionFooter:
            fatalError("UNRECOGNIZED SECTION KIND")
        default:
            fatalError("UNRECOGNIZED SECTION KIND")
        }
    }

    private func header(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let channelCollectionView = collectionView as? ChannelCollectionView else { fatalError() }

        if self.isSectionReservedForTypingIndicator(indexPath.section) {
            return UICollectionReusableView()
        }

        guard let section = self.sections[safe: indexPath.section] else { fatalError() }

        if indexPath.section == 0,
            let topHeader = self.getTopHeader(for: section, at: indexPath, in: channelCollectionView) {
            return topHeader
        }

        let header = channelCollectionView.dequeueReusableHeaderView(ChannelSectionHeader.self, for: indexPath)
        header.configure(with: section.date)
        
        return header
    }

    private func getTopHeader(for section: ChannelSectionable,
                              at indexPath: IndexPath,
                              in collectionView: ChannelCollectionView) -> UICollectionReusableView? {

        guard let index = section.firstMessageIndex, index > 0 else { return nil }

        let moreHeader = collectionView.dequeueReusableHeaderView(LoadMoreSectionHeader.self, for: indexPath)
        //Reset all gestures
        moreHeader.gestureRecognizers?.forEach({ (recognizer) in
            moreHeader.removeGestureRecognizer(recognizer)
        })

        moreHeader.button.onTap { [weak self] (tap) in
            guard let `self` = self else { return }
            moreHeader.button.isLoading = true
            self.didSelectLoadMore(for: index)
        }

        return moreHeader
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let cell = cell as? TypingIndicatorCell {
            cell.typingBubble.startAnimating()
        } else if let message = self.item(at: indexPath){
            self.willDisplayCell?(message, indexPath)
        }
    }

    // MARK: FLOW LAYOUT

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let channelLayout = collectionViewLayout as? ChannelCollectionViewFlowLayout else { return .zero }

        /// May not have a message because of the typing indicator
        let message = self.item(at: indexPath)
        return channelLayout.sizeForItem(at: indexPath, with: message)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {

        guard let channelLayout = collectionViewLayout as? ChannelCollectionViewFlowLayout else {
            return .zero
        }

        return channelLayout.sizeForHeader(at: section, with: collectionView)
    }

    // MARK: TEXT VIEW DELEGATE

    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        self.didSelectURL?(URL)
        return false
    }

    func didSelectLoadMore(for messageIndex: Int) {
        guard let channel = ChannelManager.shared.activeChannel.value else { return }

        MessageSupplier.shared.getMessages(before: UInt(messageIndex), for: channel)
            .observe { (result) in
                switch result {
                case .success(let sections):
                    self.set(newSections: sections,
                             keepOffset: true,
                             completion: nil)
                case .failure(_):
                    break
                }
        }
    }
}
