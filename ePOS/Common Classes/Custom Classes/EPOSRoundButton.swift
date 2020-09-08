//
//  EPOSRoundButton.swift
//  ePOS
//
//  Created by Matra Sharma on 07/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class EPOSRoundButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.setBackgroundImage(UIImage(named: "submitEnabled"), for: .normal)
            }
            else {
                self.setBackgroundImage(UIImage(named: "submitDisabled"), for: .disabled)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setBackgroundImage(UIImage(named: "submitEnabled"), for: .normal)
        self.setBackgroundImage(UIImage(named: "submitDisabled"), for: .disabled)
    }
    
}
