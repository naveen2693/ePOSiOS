//
//  EPOSGradientView.swift
//  ePOS
//
//  Created by Matra Sharma on 07/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

@IBDesignable
class EPOSGradientView: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear {
        didSet {
            applyGradient()
        }
    }
    @IBInspectable var endColor: UIColor = UIColor.clear {
        didSet {
            applyGradient()
        }
    }
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            applyGradient()
        }
    }
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    func applyGradient() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [startColor, endColor].map {$0.cgColor}
        if (isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }
    }
}
