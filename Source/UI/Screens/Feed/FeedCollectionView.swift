//
//  FeedCollectionView.swift
//  Benji
//
//  Created by Benji Dodgson on 11/17/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Koloda

class FeedCollectionView: KolodaView {

    let defaultTopOffset: CGFloat = 20
    let defaultHorizontalOffset: CGFloat = 100
    let defaultHeightRatio: CGFloat = 1.25
    let backgroundCardHorizontalMarginMultiplier: CGFloat = 0.25
    let backgroundCardScalePercent: CGFloat = 1.5

    override func frameForCard(at index: Int) -> CGRect {

        switch index {
        case 0:
            let topOffset: CGFloat = self.defaultTopOffset
            let xOffset: CGFloat = self.defaultHorizontalOffset
            let width = (self.frame).width - 2 * self.defaultHorizontalOffset
            let height = width * self.defaultHeightRatio
            let yOffset: CGFloat = topOffset
            let frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
            return frame
        case 1:
            let horizontalMargin = -self.bounds.width * self.backgroundCardHorizontalMarginMultiplier
            let width = self.bounds.width * self.backgroundCardScalePercent
            let height = width * self.defaultHeightRatio
            return CGRect(x: horizontalMargin, y: 0, width: width, height: height)
        default:
            return .zero
        }
    }
}
