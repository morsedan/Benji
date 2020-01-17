//
//  Sizeable.swift
//  Benji
//
//  Created by Benji Dodgson on 1/16/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

typealias SizeableViewController = ViewController & Sizeable

protocol Sizeable {
    func getHeight(for width: CGFloat) -> CGFloat
    func getWidth(for height: CGFloat) -> CGFloat
}
