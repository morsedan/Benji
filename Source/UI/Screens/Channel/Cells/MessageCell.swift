//
//  ChannelCell.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import PureLayout

class MessageCell: UICollectionViewCell {

    let avatarView = AvatarView()
    let bubbleView = View()
    let textView = MessageTextView()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.initializeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.initializeViews()
    }

    private func initializeViews() {
        self.contentView.addSubview(self.avatarView)
        self.contentView.addSubview(self.bubbleView)
        self.contentView.addSubview(self.textView)
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let attributes = layoutAttributes as? ChannelCollectionViewLayoutAttributes else { return }

    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.textView.text = nil
    }

    func configure(with message: MessageType,
                   at indexPath: IndexPath,
                   and collectionView: ChannelCollectionView) {

        guard let dataSource = collectionView.channelDataSource else { return }

        
    }
}
