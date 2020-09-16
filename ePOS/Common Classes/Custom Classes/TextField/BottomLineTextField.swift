//
//  BottomLineTextField.swift
//  ePOS
//
//  Created by Abhishek on 10/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit
class BottomBorderTF: UITextField {

var bottomBorder = UIView()
override func awakeFromNib() {

    //MARK: Setup Bottom-Border
    self.translatesAutoresizingMaskIntoConstraints = false
    bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    bottomBorder.backgroundColor = UIColor.darkThemeColor()
    bottomBorder.translatesAutoresizingMaskIntoConstraints = false
    addSubview(bottomBorder)
    //Mark: Setup Anchors
    bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength

   }
}
