//
//  SuggestionCell.swift
//  Benji
//
//  Created by Benji Dodgson on 10/22/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation

class SuggestionCell: UICollectionViewCell, DisplayableCell {
    typealias ItemType = SuggestionType

    var backgroundStyle: UIKeyboardAppearance = .light

    func configure(with item: SuggestionType?) {

    }

    override func layoutSubviews() {
        super.layoutSubviews()


    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         super.touchesBegan(touches, with: event)
        self.contentView.scaleDown()
     }

     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
         super.touchesEnded(touches, with: event)
        self.contentView.scaleUp()
     }

     override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
         super.touchesCancelled(touches, with: event)
        self.contentView.scaleUp()
     }
}
