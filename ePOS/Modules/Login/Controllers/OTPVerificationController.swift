//
//  OTPVerificationController.swift
//  ePOS
//
//  Created by Abhishek on 11/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit
class OTPVerficationController:UIViewController {
    var oTPLength: Int?
    var mobileNumber:String?
    var activeTextField = UITextField()
    var lastTextField :OTPTextField?
    var oTPString:String="";
    var otpTimer = Timer()
    var timingCount = 20
    @IBOutlet var submit: UIImageView!
    @IBOutlet weak var btnResendOtp: UIButton!
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet var textField1: OTPTextField?
    @IBOutlet var textField2: OTPTextField?
    @IBOutlet var textField3: OTPTextField?
    @IBOutlet var textField4: OTPTextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        let allTextFields: [OTPTextField?] = [textField1, textField2, textField3, textField4]
        var tempOTPLength = oTPLength
        while tempOTPLength! < allTextFields.count {
            var textField = allTextFields[tempOTPLength!]
            textField?.isHidden = true
            textField = nil
            tempOTPLength = tempOTPLength! + 1
        }
        textField1?.pineDelegate = self
        textField2?.pineDelegate = self
        textField3?.pineDelegate = self
        textField4?.pineDelegate = self
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
            lastTextField = textField4
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
        if let textField1 = textField1 {
            self.addBottomLineToTextField(textField: textField1)
        }
        if let textField2 = textField2 {
            self.addBottomLineToTextField(textField: textField2)
        }
        if let textField3 = textField3 {
            self.addBottomLineToTextField(textField: textField3)
        }
        if let textField4 = textField4 {
            self.addBottomLineToTextField(textField: textField4)
        }
    }
}

extension OTPVerficationController: OTPTextFieldDelegate {
    func textFieldDidDelete() {
        
        if activeTextField == textField1 {
            print("backButton was pressed in text_Field_1")
            // do nothing
        }
        
        if activeTextField == textField2 {
            print("backButton was pressed in otpTextField2")
            textField2?.isEnabled = false
            textField1?.isEnabled = true
            textField1?.becomeFirstResponder()
            textField1?.text = ""
        }
        
        if activeTextField == textField3 {
            print("backButton was pressed in otpTextField3")
            textField3?.isEnabled = false
            textField2?.isEnabled = true
            textField2?.becomeFirstResponder()
            textField2?.text = ""
        }
        
        if activeTextField == textField4 {
            print("backButton was pressed in otpTextField4")
            textField4?.isEnabled = false
            textField3?.isEnabled = true
            textField3?.becomeFirstResponder()
            textField3?.text = ""
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
                
                if textField == textField1 {
                    textField1?.isEnabled = false
                    textField2?.isEnabled = true
                    textField2?.becomeFirstResponder()
                }
                
                if textField == textField2 {
                    textField2?.isEnabled = false
                    textField3?.isEnabled = true
                    textField3?.becomeFirstResponder()
                }
                
                if textField == textField3 {
                    textField3?.isEnabled = false
                    textField4?.isEnabled = true
                    textField4?.becomeFirstResponder()
                }
                
                if textField == textField4 {
                }
                
                textField.text = string
                return false
                
            }
                // 11. if the user gets to the last textField and presses the back button everything above will get reversed
            else if (text.count >= 1) && (string.isEmpty) {
                
                if textField == textField2 {
                    textField2?.isEnabled = false
                    textField1?.isEnabled = true
                    textField1?.becomeFirstResponder()
                    textField1?.text = ""
                }
                
                if textField == textField3 {
                    textField3?.isEnabled = false
                    textField2?.isEnabled = true
                    textField2?.becomeFirstResponder()
                    textField2?.text = ""
                }
                
                if textField == textField4 {
                    textField4?.isEnabled = false
                    textField3?.isEnabled = true
                    textField3?.becomeFirstResponder()
                    textField3?.text = ""
                }
                if textField == textField1 {
                    // do nothing
                }
                
                textField.text = ""
                return false
                
            }
                // 12. after pressing the backButton and moving forward again we will have to do what's in step 10 all over again
            else if text.count >= 1 {
                
                if textField == textField1 {
                    textField1?.isEnabled = false
                    textField2?.isEnabled = true
                    textField2?.becomeFirstResponder()
                }
                
                if textField == textField2 {
                    textField2?.isEnabled = false
                    textField3?.isEnabled = true
                    textField3?.becomeFirstResponder()
                }
                
                if textField == textField3 {
                    textField3?.isEnabled = false
                    textField4?.isEnabled = true
                    textField4?.becomeFirstResponder()
                }
                
                textField.text = string
                return false
            }
        }
        return true
    }
}


