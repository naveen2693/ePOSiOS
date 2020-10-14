//
//  OTPVerificationController.swift
//  ePOS
//
//  Created by Abhishek on 11/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit
class OTPVerficationController:UIViewController {
    
    private let oTPLength: Int = 6
    var mobileNumber:String!
    var userData : UserData?
    var activeTextField = UITextField()
    var lastTextField :OTPTextField?
    var otpValue:String="";
    var otpTimer = Timer()
    var timingCount = 5
    
    @IBOutlet weak var labelMobileNumber: UILabel!
    @IBOutlet weak var btnResendOtp: UIButton!
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet var textField1: OTPTextField?
    @IBOutlet var textField2: OTPTextField?
    @IBOutlet var textField3: OTPTextField?
    @IBOutlet var textField4: OTPTextField?
    @IBOutlet var textField5: OTPTextField?
    @IBOutlet var textField6: OTPTextField?
    @IBOutlet var textField7: OTPTextField?
    @IBOutlet var textField8: OTPTextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardNotifications()
        // MARK:- Set Fields
        setFields()
        otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        let allTextFields: [OTPTextField?] = [textField1, textField2, textField3, textField4, textField5, textField6, textField7, textField8]
        var tempOTPLength = oTPLength
        while tempOTPLength < allTextFields.count {
            var textField = allTextFields[tempOTPLength]
            textField?.isHidden = true
            textField = nil
            tempOTPLength += 1
        }
        textField1?.setDelegate = self
        textField2?.setDelegate = self
        textField3?.setDelegate = self
        textField4?.setDelegate = self
        textField5?.setDelegate = self
        textField6?.setDelegate = self
        textField7?.setDelegate = self
        textField8?.setDelegate = self
        
        textField1?.delegate = self
        textField2?.delegate = self
        textField3?.delegate = self
        textField4?.delegate = self
        textField5?.delegate = self
        textField6?.delegate = self
        textField7?.delegate = self
        textField8?.delegate = self
        
        setLastTextField()
        if let textField = textField1 {
            textField.isEnabled = true
//            textField.becomeFirstResponder()
        }
//        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
//    override func keyboardWillShow(notification: NSNotification) {
//        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//
//          // if keyboard size is not available for some reason, dont do anything
//          return
//        }
//
//        var shouldMoveViewUp = false
//
//        if let bottomOfTextField = view.getConvertedFrame(fromSubview: activeTextField)?.maxY {
//            let topOfKeyboard = self.view.frame.height - (keyboardSize.height + 50.0 )
//
//            // if the bottom of Textfield is below the top of keyboard, move up
//            if topOfKeyboard > 5 {
//              shouldMoveViewUp = true
//            }
//        }
//
//        if(shouldMoveViewUp) {
//          self.view.frame.origin.y = 0 - keyboardSize.height
//        }
//    }
//
//    override func keyboardWillHide(notification: NSNotification) {
//
//    }
    
    private  func setFields()
    {
        if let unwrappedMobileNumber = mobileNumber{
            labelMobileNumber.text! = unwrappedMobileNumber
        }
    }
    
    class func initWith(mobileNumber: String,userData:UserData?) -> OTPVerficationController {
        let controller = OTPVerficationController.instantiate(appStoryboard: .loginScreen)
        controller.mobileNumber = mobileNumber
        return controller
    }
    
    
    @IBAction func buttonSubmit(_ sender: Any) {
        activeTextField.resignFirstResponder()
        let response = Validation.shared.validate(values:(ValidationMode.otp,otpValue))
        switch response {
        case .success:
             showLoading()
            if let unwrappedMobileNumber = mobileNumber {
                IntialDataRequest.callApiVerifyOtpWith(mobileNumber:unwrappedMobileNumber,otp:otpValue,completion:{[weak self] result in
                    self?.hideLoading()
                    switch result {
                    case .success(let response):
                        print(response);
                        self?.gotoSignUpController()
                     case .failure(BaseError.errorMessage(let error)):
                    self?.showAlert(title:Constants.apiError.rawValue, message:error as? String)
                        
                    }
                })
            }
        case .failure(_, let message):
            self.showAlert(title:Constants.validationFailure.rawValue, message:message.rawValue)        }
    }
    
    private func callResendOtp()
    {
        if let unwrappedMobileNumber = mobileNumber {
            IntialDataRequest.resendOtpCallApiWith(mobileNumber:unwrappedMobileNumber,completion:{[weak self] result in
                switch result {
                case .success(let response):
                    self?.textField1?.text = ""
                    self?.textField2?.text = ""
                    self?.textField3?.text = ""
                    self?.textField4?.text = ""
                    self?.textField5?.text = ""
                    self?.textField6?.text = ""
                    self?.textField7?.text = ""
                    self?.textField8?.text = ""
                    print(response);
                 case .failure(BaseError.errorMessage(let error)):
                  self?.showAlert(title:Constants.apiError.rawValue, message:error as? String)
                }
            })
        }
    }
    
    @objc func update() {
        
        if(timingCount > 0) {
            timingCount -= 1
            btnResendOtp.isUserInteractionEnabled = false
            btnResendOtp.setTitle("\(timingCount) Resend Otp", for: .normal)
        }
        else {
            print("call your api")
            self.otpTimer.invalidate()
            btnResendOtp.setTitle("Resend Otp", for:.normal)
            btnResendOtp.isUserInteractionEnabled = true
            btnResendOtp.addTarget(self, action: #selector(resendbutton), for: .touchUpInside)
            
        }
    }
    
    @objc func resendbutton(sender: UIButton!) {
        // MARK:- call resend otp api
        callResendOtp();
        otpTimer = Timer()
        timingCount = 10
        otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    private func  gotoSignUpController()
    {
    let viewController = SignUpController.initWith(mobileNumber: mobileNumber,userData: userData)
    self.navigationController?.pushViewController(viewController, animated: true)
   
    }
    
    
    // MARK:- Set Last Test Field
    private func setLastTextField() {
        switch oTPLength {
        case 4:
            lastTextField = textField4
        case 5:
            lastTextField = textField5
        case 6:
            lastTextField = textField6
        default:
            lastTextField = textField8
        }
        
//        lastTextField?.doneAccessory = true
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
        if let textField5 = textField5 {
            self.addBottomLineToTextField(textField: textField5)
        }
        if let textField6 = textField6 {
            self.addBottomLineToTextField(textField: textField6)
        }
        if let textField7 = textField7 {
            self.addBottomLineToTextField(textField: textField7)
        }
        if let textField8 = textField8 {
            self.addBottomLineToTextField(textField: textField8)
        }
    }
    
}

extension OTPVerficationController: OTPTextFieldDelegate {
    func textFieldDidDelete() {
        
        if activeTextField == textField1 {
            print("backButton was pressed in textField1")
            // do nothing
        }
        
        if let text = activeTextField.text, !text.isEmpty {
            activeTextField.text = ""
            return
        }
        if activeTextField == textField2 {
            print("backButton was pressed in otpTextField2")
//            textField2?.isEnabled = false
            textField1?.isEnabled = true
            textField1?.becomeFirstResponder()
            textField1?.text = ""
        }
        
        if activeTextField == textField3 {
            print("backButton was pressed in otpTextField3")
//            textField3?.isEnabled = false
            textField2?.isEnabled = true
            textField2?.becomeFirstResponder()
            textField2?.text = ""
        }
        
        if activeTextField == textField4 {
            print("backButton was pressed in otpTextField4")
//            textField4?.isEnabled = false
            textField3?.isEnabled = true
            textField3?.becomeFirstResponder()
            textField3?.text = ""
        }
        
        if activeTextField == textField5 {
            print("backButton was pressed in otpTextField4")
//            textField5?.isEnabled = false
            textField4?.isEnabled = true
            textField4?.becomeFirstResponder()
            textField4?.text = ""
        }
        
        if activeTextField == textField6 {
            print("backButton was pressed in otpTextField4")
//            textField6?.isEnabled = false
            textField5?.isEnabled = true
            textField5?.becomeFirstResponder()
            textField5?.text = ""
        }
        
        if activeTextField == textField7 {
            print("backButton was pressed in otpTextField4")
//            textField7?.isEnabled = false
            textField6?.isEnabled = true
            textField6?.becomeFirstResponder()
            textField6?.text = ""
        }
        
        if activeTextField == textField8 {
            print("backButton was pressed in otpTextField4")
//            textField8?.isEnabled = false
            textField7?.isEnabled = true
            textField7?.becomeFirstResponder()
            textField7?.text = ""
        }
    }
}

extension OTPVerficationController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField != lastTextField {
//            self.passwordField.becomeFirstResponder()
            return false
        }

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeTextField = textField
    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        otpValue = otpValue+string
        if let text = textField.text {
            
            if (text.count < 1) && (!string.isEmpty) {
                
                if textField == textField1 {
//                    textField1?.isEnabled = false
                    textField2?.isEnabled = true
                    textField2?.becomeFirstResponder()
                }
                
                if textField == textField2 {
//                    textField2?.isEnabled = false
                    textField3?.isEnabled = true
                    textField3?.becomeFirstResponder()
                }
                
                if textField == textField3 {
//                    textField3?.isEnabled = false
                    textField4?.isEnabled = true
                    textField4?.becomeFirstResponder()
                }
                
                if textField == textField4 {
//                    textField4?.isEnabled = false
                    textField5?.isEnabled = true
                    textField5?.becomeFirstResponder()
                }
                
                if textField == textField5 {
//                    textField5?.isEnabled = false
                    textField6?.isEnabled = true
                    textField6?.becomeFirstResponder()
                }
                
                if textField == textField6 {
//                    textField6?.isEnabled = false
                    textField7?.isEnabled = true
                    textField7?.becomeFirstResponder()
                }
                
                if textField == textField7 {
//                    textField7?.isEnabled = false
                    textField8?.isEnabled = true
                    textField8?.becomeFirstResponder()
                }
                
                if textField == textField8 {
                    // do nothing or better yet do something now that you have all 6 digits for the sms code. Once the user lands on this textField then the sms code is complete
                }
                
                textField.text = string
                return false
                
            } // 11. if the user gets to the last textField and presses the back button everything above will get reversed
            else if (text.count >= 1) && (string.isEmpty) {
                if let text = activeTextField.text, !text.isEmpty {
                    activeTextField.text = ""
                } else {
                    if textField == textField2 {
    //                    textField2?.isEnabled = false
                        textField1?.isEnabled = true
                        textField1?.becomeFirstResponder()
                        textField1?.text = ""
                    }
                    
                    if textField == textField3 {
    //                    textField3?.isEnabled = false
                        textField2?.isEnabled = true
                        textField2?.becomeFirstResponder()
                        textField2?.text = ""
                    }
                    
                    if textField == textField4 {
    //                    textField4?.isEnabled = false
                        textField3?.isEnabled = true
                        textField3?.becomeFirstResponder()
                        textField3?.text = ""
                    }
                    
                    if textField == textField5 {
    //                    textField5?.isEnabled = false
                        textField4?.isEnabled = true
                        textField4?.becomeFirstResponder()
                        textField4?.text = ""
                    }
                    
                    if textField == textField6 {
    //                    textField6?.isEnabled = false
                        textField5?.isEnabled = true
                        textField5?.becomeFirstResponder()
                        textField5?.text = ""
                    }
                    
                    if textField == textField7 {
    //                    textField7?.isEnabled = false
                        textField6?.isEnabled = true
                        textField6?.becomeFirstResponder()
                        textField6?.text = ""
                    }
                    
                    if textField == textField8 {
                        textField8?.isEnabled = false
                        textField7?.isEnabled = true
                        textField7?.becomeFirstResponder()
                        textField7?.text = ""
                    }
                    
                    if textField == textField1 {
                        // do nothing
                    }
                }
                
                textField.text = ""
                return false
                
            } // 12. after pressing the backButton and moving forward again we will have to do what's in step 10 all over again
            else if text.count >= 1 {
                
                if textField == textField1 {
//                    textField1?.isEnabled = false
                    textField2?.isEnabled = true
                    textField2?.becomeFirstResponder()
                }
                
                if textField == textField2 {
//                    textField2?.isEnabled = false
                    textField3?.isEnabled = true
                    textField3?.becomeFirstResponder()
                }
                
                if textField == textField3 {
//                    textField3?.isEnabled = false
                    textField4?.isEnabled = true
                    textField4?.becomeFirstResponder()
                }
                
                if textField == textField4 {
//                    textField4?.isEnabled = false
                    textField5?.isEnabled = true
                    textField5?.becomeFirstResponder()
                }
                
                if textField == textField5 {
//                    textField5?.isEnabled = false
                    textField6?.isEnabled = true
                    textField6?.becomeFirstResponder()
                }
                
                if textField == textField6 {
//                    textField6?.isEnabled = false
                    textField7?.isEnabled = true
                    textField7?.becomeFirstResponder()
                }
                
                if textField == textField7 {
//                    textField7?.isEnabled = false
                    textField8?.isEnabled = true
                    textField8?.becomeFirstResponder()
                }
                
                if textField == textField8 {
                    // do nothing or better yet do something now that you have all 6 digits for the sms code. Once the user lands on this textField then the sms code is complete
                }
                
                textField.text = string
                return false
            }
        }
        return true
    }
}


