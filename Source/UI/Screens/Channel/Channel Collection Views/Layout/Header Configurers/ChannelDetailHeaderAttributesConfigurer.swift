//
//  InitialHeaderSizeCalculator.swift
//  Benji
//
//  Created by Benji Dodgson on 9/21/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient
import TMROLocalization

class ChannelDetailHeaderAttributesConfigurer: ChannelHeaderAttributesConfigurer {

    var dateLabelHeight: CGFloat = .zero
    var descriptionLabelHeight: CGFloat = .zero
    var topOffset: CGFloat = 10
    var dateOffset: CGFloat = 10

    override func configure(attributes: ChannelCollectionViewLayoutAttributes,
                            for layout: ChannelCollectionViewFlowLayout) {

        guard let channelType = layout.dataSource?.sections.first?.channelType else { return }

        switch channelType {
        case .channel(let channel):
            attributes.attributes.headerTopOffset = self.topOffset
            attributes.attributes.headerDateOffset = self.dateOffset
            let dateText = self.getLocalizedDateText(for: channel)
            attributes.attributes.headerDateLabelSize = self.getDateLabelSize(for: dateText, with: layout)
            attributes.attributes.headerDescriptionLabelSize = self.getDescriptionLabelSize(for: channel.channelDescription, with: layout)
        default:
            break
        }
    }

    override func sizeForHeader(at section: Int, for layout: ChannelCollectionViewFlowLayout) -> CGSize {
        guard let channelType = layout.dataSource?.sections.first?.channelType else { return .zero }

        switch channelType {
        case .channel(let channel):
            return self.getSize(for: channel, with: layout)
        default:
            break
        }

        return .zero
    }

    private func getSize(for channel: TCHChannel, with layout: ChannelCollectionViewFlowLayout) -> CGSize {

        let dateText = self.getLocalizedDateText(for: channel)
        let descriptionHeight = self.getDescriptionLabelSize(for: channel.channelDescription, with: layout).height
        let dateHeight = self.getDateLabelSize(for: dateText, with: layout).height

        let height = self.topOffset + descriptionHeight + self.dateOffset + dateHeight + 20

        return CGSize(width: layout.itemWidth, height: height)
    }

    private func getLocalizedDateText(for channel: TCHChannel) -> Localized {
        guard let createdAt = channel.dateCreatedAsDate else { return LocalizedString.empty }

        let dateString = Date.standard.string(from: createdAt)
        let text = LocalizedString(id: "",
                                   arguments: [dateString],
                                   default: "Created On: @1")
        return text
    }

    private func getDescriptionLabelSize(for description: Localized,
                                         with layout: ChannelCollectionViewFlowLayout) -> CGSize {

        let attributed = AttributedString(description,
                                          fontType: .smallSemiBold,
                                          color: .white)

        let attributedString = attributed.string
        let maxWidth = layout.itemWidth * 0.9
        let size = attributedString.getSize(withWidth: maxWidth)
        return size
    }

    private func getDateLabelSize(for dateString: Localized,
                                  with layout: ChannelCollectionViewFlowLayout) -> CGSize {

        let attributed = AttributedString(dateString,
                                          fontType: .xSmall,
                                          color: .white)

        let attributedString = attributed.string
        let maxWidth = layout.itemWidth * 0.9
        let size = attributedString.getSize(withWidth: maxWidth)
        return size
    }
}
