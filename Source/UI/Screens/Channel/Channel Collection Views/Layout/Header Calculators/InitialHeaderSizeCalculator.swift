//
//  InitialHeaderSizeCalculator.swift
//  Benji
//
//  Created by Benji Dodgson on 9/21/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class InitialHeaderSizeCalculator: HeaderSizeCalculator {

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
        guard let createdAt = channel.dateCreatedAsDate else { return .zero }

        let dateString = Date.standard.string(from: createdAt)
        let text = LocalizedString(id: "",
                                   arguments: [dateString],
                                   default: "Created On: @1")

        let descriptionHeight = self.getDescriptionLabelSize(for: channel.channelDescription).height
        let dateHeight = self.getDateLabelSize(for: text).height

        let height = 10 + descriptionHeight + 10 + dateHeight + 20
        
        return CGSize(width: self.channelLayout.channelCollectionView.width, height: height)
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
