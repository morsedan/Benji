//
//  PhoneTextField.swift
//  Benji
//
//  Created by Benji Dodgson on 1/18/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation
import PhoneNumberKit

class PhoneTextField: PhoneNumberTextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.padding)
    }
}
