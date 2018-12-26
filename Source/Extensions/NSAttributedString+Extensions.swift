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

extension NSMutableAttributedString {

    convenience init(_ attributedString: NSAttributedString) {
        self.init(attributedString: attributedString)
    }

    convenience init(_ string: String, with attributes: [NSAttributedString.Key: Any]) {
        self.init(string: string)
        self.addAttributes(attributes, range: NSMakeRange(0, string.count))
    }

    static func +(lhs: NSMutableAttributedString,
                  rhs: NSMutableAttributedString) -> NSMutableAttributedString {
        // Make a copy so we don't modify the original string
        let lhsCopy = NSMutableAttributedString(lhs)
        lhsCopy.append(rhs)
        return lhsCopy
    }

    func addAttribute(_ name: NSAttributedString.Key, value: Any) {
        self.addAttribute(name, value: value, range: NSMakeRange(0, self.length))
    }

    func addAttributes(_ attrs: [NSAttributedString.Key : Any]) {
        self.addAttributes(attrs, range: NSMakeRange(0, self.length))
    }

    func addAttribute(_ attributeKey: NSAttributedString.Key, toSubstring substring: String) {
        if let range = self.string.range(of: substring) {
            self.addAttribute(attributeKey, value: substring, range: range.nsRange)
        }
    }

    func removeAttributes(atRange range: NSRange) {
        var mutableRange = range
        if range.location + range.length <= self.length {
            let attributes = self.attributes(at: range.location, effectiveRange: &mutableRange)
            for attribute in attributes {
                self.removeAttribute(attribute.key, range: range)
            }
        } else {
            print("INVALID RANGE FOR: \(self.string)")
        }
    }

    func height(forConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            context: nil)
        return ceil(boundingBox.height)
    }

    func width(forConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            context: nil)
        return ceil(boundingBox.width)
    }
}

