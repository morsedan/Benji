//
//  ReadOverlayView.swift
//  Benji
//
//  Created by Benji Dodgson on 7/28/19.
//  Copyright © 2019 Benjamin Dodgson. All rights reserved.
//

import Foundation
import Koloda

class FeedOverlayView: OverlayView {

    override var overlayState: SwipeResultDirection?  {
        didSet {
            switch overlayState {
            case .left? :
                self.backgroundColor = Color.red.color.withAlphaComponent(0.5)
            case .right? :
                self.backgroundColor = Color.blue.color.withAlphaComponent(0.5)
            default:
                break
            }

        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    private func initialize() {
        self.roundCorners()
    }
}
