//
//  ChannelViewController+Updates.swift
//  Benji
//
//  Created by Benji Dodgson on 11/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

extension ChannelViewController {

    func loadMessages() {
        self.collectionViewManager.reset()

        guard let channel = ChannelManager.shared.selectedChannel.value else { return }

        MessageSupplier.shared.getLastMessages(for: channel)
            .observe { (result) in
                switch result {
                case .success(let sections):
                    self.collectionView.activityIndicator.stopAnimating()
                    self.collectionViewManager.set(newSections: sections) { [unowned self] in
                        self.collectionView.scrollToBottom()
                    }
                case .failure(_):
                    break
                }
        }
    }
}
