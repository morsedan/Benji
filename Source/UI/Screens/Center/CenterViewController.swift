//
//  CenterViewController.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

class CenterViewController: FullScreenViewController {

    @IBOutlet weak var view1: View!
    @IBOutlet weak var view2: View!
    @IBOutlet weak var view3: View!

    override func viewIsReadyForLayout() {
        super.viewIsReadyForLayout()

        self.view1.set(backgroundColor: .blue)
        self.view2.set(backgroundColor: .green)
        self.view3.set(backgroundColor: .red)
    }
}


