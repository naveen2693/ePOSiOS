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

@IBDesignable
class RoundedShadowCornerView: UIView {
    @IBInspectable var cornerRound: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRound
            self.layer.masksToBounds = true;
            self.backgroundColor = UIColor.white
            self.layer.shadowColor = UIColor.lightGray.cgColor
            self.layer.shadowOpacity = 0.8
            self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.layer.shadowRadius = 6.0
            self.layer.masksToBounds = false
        }
    }
  
}
