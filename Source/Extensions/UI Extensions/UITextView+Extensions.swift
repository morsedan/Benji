//
//  UITextView+Extensions.swift
//  Benji
//
//  Created by Benji Dodgson on 12/29/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

extension UITextView {
    func getSize(withWidth width: CGFloat) -> CGSize {
        guard let t = self.text, let attText = self.attributedText else { return CGSize.zero }

        let attributes = attText.attributes(at: 0,
                                            longestEffectiveRange: nil,
                                            in: NSRange(location: 0, length: attText.length))

        let maxSize = CGSize(width: width, height: CGFloat.infinity)

        let size: CGSize = t.boundingRect(with: maxSize,
                                          options: .usesLineFragmentOrigin,
                                          attributes: attributes,
                                          context: nil).size

        return size
    }
}
