//
//  NSAttributedString+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 12/25/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

extension Array where Element: NSAttributedString {
    var concatenated: NSAttributedString {
        let joined = self.reduce(NSMutableAttributedString(), +)
        return NSAttributedString(joined)
    }
}

extension Array where Element: NSMutableAttributedString {
    var concatenated: NSMutableAttributedString {
        return reduce(NSMutableAttributedString(), +)
    }
}

extension NSAttributedString {

    @objc convenience init(_ mutableAttributedString: NSMutableAttributedString) {
        self.init(attributedString: mutableAttributedString)
    }

    static func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSMutableAttributedString {
        let mutableLHS = NSMutableAttributedString(lhs)
        mutableLHS.append(rhs)
        return mutableLHS
    }

    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect,
                                       options: [.usesLineFragmentOrigin, .usesFontLeading],
                                       context: nil)

        return boundingBox.height.rounded(FloatingPointRoundingRule.up)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect,
                                       options: [.usesLineFragmentOrigin,
                                                 .usesFontLeading], context: nil)

        return boundingBox.width.rounded(FloatingPointRoundingRule.up)
    }
}

