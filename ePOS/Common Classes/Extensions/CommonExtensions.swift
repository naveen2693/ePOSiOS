//
//  CommonExtensions.swift
//  ePOS
//
//  Created by Abhishek on 17/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
extension UIView {
    func getText() -> String? {
        return self.responds(to: #selector(getter: UILabel.text)) ?
        self.perform(#selector(getter: UILabel.text))?.takeUnretainedValue() as? String : nil
    }
}
