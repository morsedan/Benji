//
//  ChannelCollectionViewLayoutAttributes.swift
//  Benji
//
//  Created by Benji Dodgson on 7/11/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class ChannelCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

    //Header
    var headerTopOffset: CGFloat = .zero
    var headerDateOffset: CGFloat = .zero
    var headerDateLabelSize: CGSize = .zero
    var headerDescriptionLabelSize: CGSize = .zero

    //Cell
    var avatarSize: CGSize = .zero
    var avatarLeadingPadding: CGFloat = .zero
    var bubbleViewSize: CGSize = .zero
    var bubbleViewHorizontalPadding: CGFloat = .zero
    var messageTextViewSize: CGSize = .zero
    var messageTextViewVerticalPadding: CGFloat = .zero
    var messageTextViewMaxWidth: CGFloat = .zero
    var messageTextViewHorizontalPadding: CGFloat = .zero
    var messageFontType: FontType = .regular
    var isFromCurrentUser: Bool = false
    var maskedCorners: CACornerMask = []

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! ChannelCollectionViewLayoutAttributes
        copy.headerTopOffset = self.headerTopOffset
        copy.headerDateOffset = self.headerDateOffset
        copy.headerDateLabelSize = self.headerDateLabelSize
        copy.headerDescriptionLabelSize = self.headerDescriptionLabelSize
        copy.avatarSize = self.avatarSize
        copy.avatarLeadingPadding = self.avatarLeadingPadding
        copy.bubbleViewSize = self.bubbleViewSize
        copy.bubbleViewHorizontalPadding = self.bubbleViewHorizontalPadding
        copy.messageTextViewSize = self.messageTextViewSize
        copy.messageTextViewVerticalPadding = self.messageTextViewVerticalPadding
        copy.messageTextViewMaxWidth = self.messageTextViewMaxWidth
        copy.messageFontType = self.messageFontType
        copy.messageTextViewHorizontalPadding = self.messageTextViewHorizontalPadding
        copy.isFromCurrentUser = self.isFromCurrentUser
        copy.maskedCorners = self.maskedCorners
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? ChannelCollectionViewLayoutAttributes {
            return super.isEqual(object) && attributes.headerTopOffset == self.headerDateOffset
                && attributes.headerTopOffset == self.headerTopOffset
                && attributes.headerDateLabelSize == self.headerDateLabelSize
                && attributes.headerDescriptionLabelSize == self.headerDescriptionLabelSize
                && attributes.avatarSize == self.avatarSize
                && attributes.avatarLeadingPadding == self.avatarLeadingPadding
                && attributes.bubbleViewSize == self.bubbleViewSize
                && attributes.messageTextViewSize == self.messageTextViewSize
                && attributes.messageTextViewVerticalPadding == self.messageTextViewVerticalPadding
                && attributes.messageTextViewMaxWidth == self.messageTextViewMaxWidth
                && attributes.messageFontType == self.messageFontType
                && attributes.messageTextViewHorizontalPadding == self.messageTextViewHorizontalPadding
                && attributes.isFromCurrentUser == self.isFromCurrentUser
                && attributes.bubbleViewHorizontalPadding == self.bubbleViewHorizontalPadding
                && attributes.maskedCorners == self.maskedCorners
        }

        return false
    }
}
