//
//  PagingSectionHeader.swift
//  Benji
//
//  Created by Benji Dodgson on 9/21/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import TwilioChatClient

class InitialSectionHeader: UICollectionReusableView {

    private let dateLabel = XSmallLabel()
    private let descriptionLabel = SmallSemiBoldLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeViews()
    }

    private func initializeViews() {

        self.addSubview(self.dateLabel)
        self.addSubview(self.descriptionLabel)

        self.set(backgroundColor: .clear)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.descriptionLabel.setSize(withWidth: self.width * 0.8)
        self.descriptionLabel.top = 10
        self.descriptionLabel.centerOnX()

        self.dateLabel.setSize(withWidth: self.width * 0.8)
        self.dateLabel.top = self.descriptionLabel.bottom + 10
        self.dateLabel.centerOnX()
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
        guard let createdAt = channel.dateCreatedAsDate else { return }
        let dateString = Date.standard.string(from: createdAt)
        let text = LocalizedString(id: "",
                                   arguments: [dateString],
                                   default: "Created On: @1")
        self.dateLabel.set(text: text,
                       color: .lightPurple,
                       alignment: .center,
                       stringCasing: .unchanged)

        self.descriptionLabel.set(text: channel.channelDescription,
                                  color: .white,
                                  alignment: .center)
    }
}
