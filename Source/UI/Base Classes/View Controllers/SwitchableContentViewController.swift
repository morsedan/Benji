//
//  SwitchableContentViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 1/14/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

class SwitchableContentViewController: NavigationBarViewController, KeyboardObservable {

    override func initializeViews() {
        super.initializeViews()

        self.registerKeyboardEvents()
        
    }


    func handleKeyboard(frame: CGRect, with animationDuration: TimeInterval, timingCurve: UIView.AnimationCurve) {

    }
}
