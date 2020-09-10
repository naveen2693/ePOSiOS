//
//  EPOSTextField+FloatText.swift
//  ePOS
//
//  Created by Matra Sharma on 09/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

extension EPOSTextField {
    @IBInspectable var floatingText : String {
        get {
            return label.text ?? ""
        }
        set {
            label.text = newValue
        }
    }
}
