//
//  OTPVerificationController.swift
//  ePOS
//
//  Created by Abhishek on 11/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit
class OTPVerficationController:UIViewController{
var oTPLength: Int?
var activeTextField = UITextField()
var lastTextField :OTPTextField?
var oTPString:String="";
var otpTimer = Timer()
var timingCount = 20
@IBOutlet var submit: UIImageView!
@IBOutlet weak var btnResendOtp: UIButton!
@IBOutlet weak var horizontalStackView: UIStackView!
@IBOutlet var text_Field_1: OTPTextField?
@IBOutlet var text_Field_2: OTPTextField?
@IBOutlet var text_Field_3: OTPTextField?
@IBOutlet var text_Field_4: OTPTextField?
override func viewDidLoad() {
    super.viewDidLoad()
    otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    let allTextFields: [OTPTextField?] = [text_Field_1, text_Field_2, text_Field_3, text_Field_4]
    var tempOTPLength = oTPLength
    while tempOTPLength! < allTextFields.count {
        var textField = allTextFields[tempOTPLength!]
        textField?.isHidden = true
        textField = nil
        tempOTPLength = tempOTPLength! + 1
    }
    text_Field_1?.pineDelegate = self
    text_Field_2?.pineDelegate = self
    text_Field_3?.pineDelegate = self
    text_Field_4?.pineDelegate = self
    setLastTextField()
    // Do any additional setup after loading the view.
}


@objc func update() {
   
    if(timingCount > 0) {
        timingCount -= 1
        btnResendOtp.isUserInteractionEnabled = false
        btnResendOtp.setTitle("\(timingCount) Resend Otp", for: .normal)
    }
    else {
        //otpTimer.invalidate()
        print("call your api")
        btnResendOtp.setTitle("Resend Otp", for:.normal)
        btnResendOtp.isUserInteractionEnabled = true
        btnResendOtp.addTarget(self, action: #selector(resendbutton), for: .touchUpInside)
        
        // if you want to reset the time make count = 60 and resendTime.fire()
    }
    
}

@objc func resendbutton(sender: UIButton!) {
    otpTimer = Timer()
    timingCount = 10
    otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
}



// MARK:- Set Last Test Field
private func setLastTextField() {
    switch oTPLength {
    case 4:
        lastTextField = text_Field_4
    default: break
    }
}

private func addBottomLineToTextField(textField : OTPTextField) {
    let border = CALayer()
    let borderWidth = CGFloat(1.0)
    //border.borderColor = PINEPG_COLOR_GREEN.cgColor
    border.frame = CGRect(x: 0, y: textField.frame.size.height - borderWidth, width: textField.frame.size.width, height: textField.frame.size.height)
    border.borderWidth = borderWidth
    textField.layer.addSublayer(border)
    textField.layer.masksToBounds = true
}
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if let text_Field_1 = text_Field_1 {
        self.addBottomLineToTextField(textField: text_Field_1)
    }
    if let text_Field_2 = text_Field_2 {
        self.addBottomLineToTextField(textField: text_Field_2)
    }
    if let text_Field_3 = text_Field_3 {
        self.addBottomLineToTextField(textField: text_Field_3)
    }
    if let text_Field_4 = text_Field_4 {
        self.addBottomLineToTextField(textField: text_Field_4)
    }
}
}
extension OTPVerficationController: OTPTextFieldDelegate {
func textFieldDidDelete() {
    
    if activeTextField == text_Field_1 {
        print("backButton was pressed in text_Field_1")
        // do nothing
    }
    
    if activeTextField == text_Field_2 {
        print("backButton was pressed in otpTextField2")
        text_Field_2?.isEnabled = false
        text_Field_1?.isEnabled = true
        text_Field_1?.becomeFirstResponder()
        text_Field_1?.text = ""
    }
    
    if activeTextField == text_Field_3 {
        print("backButton was pressed in otpTextField3")
        text_Field_3?.isEnabled = false
        text_Field_2?.isEnabled = true
        text_Field_2?.becomeFirstResponder()
        text_Field_2?.text = ""
    }
    
    if activeTextField == text_Field_4 {
        print("backButton was pressed in otpTextField4")
        text_Field_4?.isEnabled = false
        text_Field_3?.isEnabled = true
        text_Field_3?.becomeFirstResponder()
        text_Field_3?.text = ""
    }
}
}

extension OTPVerficationController: UITextFieldDelegate {
func textFieldDidBeginEditing(_ textField: UITextField) {
    
    activeTextField = textField
}

public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    oTPString += string
    if let text = textField.text {
        if (text.count < 1) && (!(string.isEmpty)) {
            
            if textField == text_Field_1 {
                text_Field_1?.isEnabled = false
                text_Field_2?.isEnabled = true
                text_Field_2?.becomeFirstResponder()
            }
            
            if textField == text_Field_2 {
                text_Field_2?.isEnabled = false
                text_Field_3?.isEnabled = true
                text_Field_3?.becomeFirstResponder()
            }
            
            if textField == text_Field_3 {
                text_Field_3?.isEnabled = false
                text_Field_4?.isEnabled = true
                text_Field_4?.becomeFirstResponder()
            }
            
            if textField == text_Field_4 {
            }
            
            textField.text = string
            return false
            
        }
        // 11. if the user gets to the last textField and presses the back button everything above will get reversed
        else if (text.count >= 1) && (string.isEmpty) {
            
            if textField == text_Field_2 {
                text_Field_2?.isEnabled = false
                text_Field_1?.isEnabled = true
                text_Field_1?.becomeFirstResponder()
                text_Field_1?.text = ""
            }
            
            if textField == text_Field_3 {
                text_Field_3?.isEnabled = false
                text_Field_2?.isEnabled = true
                text_Field_2?.becomeFirstResponder()
                text_Field_2?.text = ""
            }
            
            if textField == text_Field_4 {
                text_Field_4?.isEnabled = false
                text_Field_3?.isEnabled = true
                text_Field_3?.becomeFirstResponder()
                text_Field_3?.text = ""
            }
            if textField == text_Field_1 {
                // do nothing
            }
            
            textField.text = ""
            return false
            
        }
        // 12. after pressing the backButton and moving forward again we will have to do what's in step 10 all over again
        else if text.count >= 1 {
            
            if textField == text_Field_1 {
                text_Field_1?.isEnabled = false
                text_Field_2?.isEnabled = true
                text_Field_2?.becomeFirstResponder()
            }
            
            if textField == text_Field_2 {
                text_Field_2?.isEnabled = false
                text_Field_3?.isEnabled = true
                text_Field_3?.becomeFirstResponder()
            }
            
            if textField == text_Field_3 {
                text_Field_3?.isEnabled = false
                text_Field_4?.isEnabled = true
                text_Field_4?.becomeFirstResponder()
            }
            
            textField.text = string
            return false
        }
    }
    return true
}
}


