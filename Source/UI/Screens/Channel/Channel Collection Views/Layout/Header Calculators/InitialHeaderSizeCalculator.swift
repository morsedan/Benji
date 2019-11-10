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

class InitialHeaderSizeCalculator: HeaderSizeCalculator {

    var dateLabelHeight: CGFloat = .zero
    var descriptionLabelHeight: CGFloat = .zero
    var topOffset: CGFloat = 10
    var dateOffset: CGFloat = 10

    override func configure(attributes: ChannelCollectionViewLayoutAttributes) {

        let dataSource = self.channelLayout.dataSource
        guard let channelType = dataSource.sections.first?.channelType else { return }

        switch channelType {
        case .channel(let channel):
            attributes.headerTopOffset = self.topOffset
            attributes.headerDateOffset = self.dateOffset
            attributes.headerDateLabelSize = self.getDateLabelSize(for: self.getLocalizedDateText(for: channel))
            attributes.headerDescriptionLabelSize = self.getDescriptionLabelSize(for: channel.channelDescription)
        default:
            break
        }
    }

    override func sizeForHeader(at section: Int) -> CGSize {
        let dataSource = self.channelLayout.dataSource
        guard let channelType = dataSource.sections.first?.channelType else { return .zero }

        switch channelType {
        case .channel(let channel):
            return self.getHeight(for: channel)
        default:
            break
        }

        return .zero
    }

    private func getHeight(for channel: TCHChannel) -> CGSize {

        let dateText = self.getLocalizedDateText(for: channel)
        let descriptionHeight = self.getDescriptionLabelSize(for: channel.channelDescription).height
        let dateHeight = self.getDateLabelSize(for: dateText).height

        let height = self.topOffset + descriptionHeight + self.dateOffset + dateHeight + 20
        
        return CGSize(width: self.channelLayout.channelCollectionView.width, height: height)
    }

    private func getLocalizedDateText(for channel: TCHChannel) -> Localized {
        guard let createdAt = channel.dateCreatedAsDate else { return LocalizedString.empty }

        let dateString = Date.standard.string(from: createdAt)
        let text = LocalizedString(id: "",
                                   arguments: [dateString],
                                   default: "Created On: @1")
        return text
    }

    private func getDescriptionLabelSize(for description: Localized) -> CGSize {

        let attributed = AttributedString(description,
                                          fontType: .smallSemiBold,
                                          color: .white)

        let attributedString = attributed.string
        let maxWidth = self.channelLayout.itemWidth * 0.9
        let size = attributedString.getSize(withWidth: maxWidth)
        return size
    }

    private func getDateLabelSize(for dateString: Localized) -> CGSize {

        let attributed = AttributedString(dateString,
                                          fontType: .xSmall,
                                          color: .white)

        let attributedString = attributed.string
        let maxWidth = self.channelLayout.itemWidth * 0.9
        let size = attributedString.getSize(withWidth: maxWidth)
        return size
    }
}
