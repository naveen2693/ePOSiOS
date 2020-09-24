//
//  EPOSLabel.swift
//  ePOS
//
//  Created by Matra Sharma on 07/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

enum EPOSFontStyle: Int {
    case medium20 = 1
    case medium16 = 2
    case regular16 = 3
    case medium14 = 4
    case regular14 = 5
    case medium12 = 6
    case regular12 = 7
    case regular10 = 8
    case medium10 = 9
    case medium15 = 10
}


class EPOSLabel: UILabel {

    @IBInspectable var fontStyle: Int = 5 {
        didSet {
            self.font = self.getFontStyle()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = getFontStyle()
    }

    fileprivate func getFontStyle() -> UIFont {
        let fontType = EPOSFontStyle(rawValue: self.fontStyle)
        guard fontType != nil else {
            return UIFont.regularFontWith(size: 14)
        }
        
        switch fontType! {
        case .medium20:
            return UIFont.mediumFontWith(size: 20)
        case .medium16:
            return UIFont.mediumFontWith(size: 16)
        case .regular16:
            return UIFont.regularFontWith(size: 16)
        case .medium14:
            return UIFont.mediumFontWith(size: 14)
        case .regular14:
            return UIFont.regularFontWith(size: 14)
        case .medium12:
            return UIFont.mediumFontWith(size: 12)
        case .regular12:
            return UIFont.regularFontWith(size: 12)
        case .regular10:
            return UIFont.regularFontWith(size: 10)
        case .medium10:
            return UIFont.mediumFontWith(size: 10)
        case .medium15:
            return UIFont.mediumFontWith(size: 15)
        }
    }
}

