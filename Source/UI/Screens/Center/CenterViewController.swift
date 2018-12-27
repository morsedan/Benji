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
    @IBOutlet weak var view4: View!


    @IBOutlet weak var lable1: Label!
    @IBOutlet weak var lable2: Label!
    @IBOutlet weak var lable3: Label!
    @IBOutlet weak var lable4: Label!



    override func viewIsReadyForLayout() {
        super.viewIsReadyForLayout()

        self.view1.set(backgroundColor: .blue)
        self.view2.set(backgroundColor: .darkGray)
        self.view3.set(backgroundColor: .red)
        self.view4.set(backgroundColor: .green)

        let style = StringStyle(font: .medium, size: 20, color: .white, kern: 2)
        let string = AttributedString("Some default text that will show in the view 😀", style: style)

        self.lable1.set(attributed: string)
        self.lable2.set(attributed: string)
        self.lable3.set(attributed: string)
        self.lable4.set(attributed: string)

    }
}


