//
//  String+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 12/25/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

extension String {

    init(optional value: String?) {
        if let strongValue = value {
            self.init(stringLiteral: strongValue)
        } else {
            self.init()
        }
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)

        return ceil(boundingBox.width)
    }

    // Gets an NSAttributedString compatible ranges for all the emojis in a string
    // NSAttributedStrings are encoded using UTF16, and emojis may consist of multiple code units
    // https://developer.apple.com/swift/blog/?id=30
    func getEmojiRanges() -> [NSRange] {

        var ranges: [NSRange] = []

        for (index, character) in self.enumerated() {
            guard character.isEmoji else { continue }
            let characterIndex = self.index(self.startIndex, offsetBy: index)
            let nsRange = NSRange(characterIndex...characterIndex, in: self)
            ranges.append(nsRange)
        }

        return ranges
    }

    func substring(with nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
}

extension Range where Bound == String.Index {
    var nsRange: NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset - self.lowerBound.encodedOffset)
    }
}

extension String: Localized {

    var identifier: String {
        return String()
    }

    var arguments: [Localized] {
        return []
    }

    var defaultString: String? {
        return self
    }

    func localized(withArguments arguments: [Localized]) -> Localized {
        return self
    }
}
