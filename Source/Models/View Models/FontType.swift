//
//  Font.swift
//  Benji
//
//  Created by Benji Dodgson on 12/27/18.
//  Copyright © 2018 Benjamin Dodgson. All rights reserved.
//

import Foundation

enum FontType: String {
    
    case regular = "AvenirNext-Regular"
    case demiBold = "AvenirNext-DemiBold"
    case heavy = "AvenirNext-Heavy"
    case medium = "AvenirNext-Medium"
    case ultraLight = "AvenirNext-UltraLight"

    func getFont(with size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
