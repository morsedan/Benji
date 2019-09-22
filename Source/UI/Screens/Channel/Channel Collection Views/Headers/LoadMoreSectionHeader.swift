//
//  LoadMoreSectionHeader.swift
//  Benji
//
//  Created by Benji Dodgson on 9/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class LoadMoreSectionHeader: UICollectionReusableView {

    private let descriptionLabel = XSmallLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeViews()
    }

    private func initializeViews() {

        self.addSubview(self.descriptionLabel)

        self.set(backgroundColor: .clear)
    }

    func configure(with sectionType: ChannelSectionType) {
        guard let channelType = sectionType.channelType else { return }

        switch channelType {
        case .system(_):
            return
        case .channel(let channel):
            self.layout(channel: channel)
        }
    }

    private func layout(channel: TCHChannel) {

    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
         super.apply(layoutAttributes)

         guard let attributes = layoutAttributes as? ChannelCollectionViewLayoutAttributes else { return }

         self.layoutContent(with: attributes)
     }

    private func layoutContent(with attributes: ChannelCollectionViewLayoutAttributes) {

        self.descriptionLabel.size = attributes.headerDescriptionLabelSize
        self.descriptionLabel.top = attributes.headerTopOffset
        self.descriptionLabel.centerOnX()
    }
}
