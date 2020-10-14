//
//  EPOSGradientView.swift
//  ePOS
//
//  Created by Matra Sharma on 07/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornerView: UIView {
    @IBInspectable var cornerRound: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRound
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
  
}
