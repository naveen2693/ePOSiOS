//
//  OtpTextField.swift
//  ePOS
//
//  Created by Abhishek on 11/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

protocol OTPTextFieldDelegate: class {
    func textFieldDidDelete()
}
class OTPTextField: UITextField {

    weak var pineDelegate: OTPTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        pineDelegate?.textFieldDidDelete()
    }
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        let beginning = self.beginningOfDocument
        let end = self.position(from: beginning, offset: self.text?.count ?? 0)
        return end
    }

}
