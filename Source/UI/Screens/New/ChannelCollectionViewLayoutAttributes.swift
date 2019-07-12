//
//  ChannelCollectionViewLayoutAttributes.swift
//  Benji
//
//  Created by Benji Dodgson on 7/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

    var avatarSize: CGSize = .zero
    var avatarLeadingPadding: CGFloat = .zero
    var bubbleViewSize: CGSize = .zero
    var messageTextViewSize: CGSize = .zero
    var messageTextViewVerticalPadding: CGFloat = .zero
    var messageTextViewHorizontalPadding: CGFloat = .zero

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! ChannelCollectionViewLayoutAttributes

        copy.avatarSize = self.avatarSize
        copy.avatarLeadingPadding = self.avatarLeadingPadding
        copy.bubbleViewSize = self.bubbleViewSize
        copy.messageTextViewSize = self.messageTextViewSize
        copy.messageTextViewVerticalPadding = self.messageTextViewVerticalPadding
        copy.messageTextViewHorizontalPadding = self.messageTextViewHorizontalPadding

        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        
        if let attributes = object as? ChannelCollectionViewLayoutAttributes {
            return super.isEqual(object) && attributes.avatarSize == self.avatarSize
            && attributes.avatarLeadingPadding == self.avatarLeadingPadding
            && attributes.bubbleViewSize == self.bubbleViewSize
            && attributes.messageTextViewSize == self.messageTextViewSize
            && attributes.messageTextViewVerticalPadding == self.messageTextViewVerticalPadding
            && attributes.messageTextViewHorizontalPadding == self.messageTextViewHorizontalPadding
        }

        return false
    }
}
