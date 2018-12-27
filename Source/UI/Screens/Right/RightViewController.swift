//
//  RightViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class RightViewController: FullScreenViewController {

    override func viewIsReadyForLayout() {
        super.viewIsReadyForLayout()

        self.view.set(backgroundColor: .green)
    }
}
