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

    let label = RegularBoldLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeViews()
    }

    private func initializeViews() {

        self.label.set(text: "LOAD MORE", color: .white, alignment: .center, stringCasing: .uppercase)
        self.set(backgroundColor: .red)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.label.setSize(withWidth: self.width)
        self.label.centerOnXAndY()
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
}
