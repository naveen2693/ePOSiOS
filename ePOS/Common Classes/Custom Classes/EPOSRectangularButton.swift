//
//  EPOSRectangularButton.swift
//  ePOS
//
//  Created by Matra Sharma on 07/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class EPOSRectangularButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.setGradientBackgroundColors([UIColor.darkThemeColor(), UIColor.lightThemeColor()], direction: .toLeft, for: .normal)
            }
            else {
                self.setGradientBackgroundColors([UIColor.subTextColor()], direction: .toLeft, for: .disabled)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.font = UIFont.mediumFontWith(size: 14)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setGradientBackgroundColors([UIColor.darkThemeColor(), UIColor.lightThemeColor()], direction: .toLeft, for: .normal)
        self.setGradientBackgroundColors([UIColor.subTextColor()], direction: .toLeft, for: .disabled)
        self.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
    }
}
