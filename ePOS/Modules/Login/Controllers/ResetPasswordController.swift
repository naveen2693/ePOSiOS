//
//  ResetPasswordController.swift
//  ePOS
//
//  Created by Abhishek on 22/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//
import UIKit
class ResetPasswordController: UIViewController {
    
    @IBOutlet weak var textFieldMobileNumber: EPOSTextField!
    @IBOutlet weak var textFieldOtp: EPOSTextField!
    @IBOutlet weak var textFieldPassword: EPOSTextField!
    @IBOutlet weak var textFieldConfirmPassword: EPOSTextField!
    @IBOutlet weak var buttonResendOtp: UIButton!
    var mobileNumber:String?
    var otpTimer = Timer()
    var timingCount = 20
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        if(mobileNumber == nil)
        {
            self.showAlert(title: "Error", message:Constants.errorMessage.rawValue )
        }
        hideKeyboardWhenTappedAround()
        //fillup the mobile Number
        setTextfields();
        
    }
    
    class func initWith(mobileNumber: String) -> PasswordController {
        let controller = PasswordController.instantiate(appStoryboard: .loginScreen)
        controller.mobileNumber = mobileNumber
        return controller
    }
    
    private func setTextfields()
    {
        
        textFieldMobileNumber.text = mobileNumber
        textFieldMobileNumber.isEnabled = false
    }
    
    private func callResendOtpApi() {
        showLoading()
        if let unwrappedMobileNumber = mobileNumber {
            IntialDataRequest.resendOtpCallApiWith(mobileNumber:unwrappedMobileNumber,completion:{[weak self] result in
                self?.hideLoading()
                switch result {
                case .success (let response):
                    print(response);
                case .failure(BaseError.errorMessage(let error)):
                    self?.showAlert(title:Constants.apiError.rawValue, message:error as? String)
                }
            })
        } else {
            fatalError("Api failed.")
        }
        
        
    }
    
    @objc func update() {
        
        if(timingCount > 0) {
            timingCount -= 1
            buttonResendOtp.isUserInteractionEnabled = false
            buttonResendOtp.setTitle("\(timingCount) Resend Otp", for: .normal)
        }
            
        else {
            //otpTimer.invalidate()
            print("call your api")
            self.otpTimer.invalidate()
            buttonResendOtp.setTitle("Resend Otp", for:.normal)
            buttonResendOtp.isUserInteractionEnabled = true
            buttonResendOtp.addTarget(self, action: #selector(resendbutton), for: .touchUpInside)
            
            // if you want to reset the time make count = 60 and resendTime.fire()
        }
        
    }
    @objc func resendbutton(sender: UIButton!) {
        callResendOtpApi();
        otpTimer = Timer()
        timingCount = 10
        otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    
    
    
    @IBAction func buttonSubmit(_ sender: Any) {
        let response = Validation.shared.validate(values: (ValidationMode.phoneNo,  textFieldMobileNumber.text as Any)
            ,(ValidationMode.password,textFieldPassword.text as Any)
            ,(ValidationMode.confirmPassword,textFieldConfirmPassword.text as Any)
            ,(ValidationMode.otp,textFieldOtp.text as Any))
        switch response {
        case .success:
             showLoading()
            IntialDataRequest.resetPasswordCallApiwith(mobileNumber:mobileNumber!,otp: textFieldOtp.text!,newPassword:textFieldPassword.text!,completion:{[weak self] result in
                self?.hideLoading()
                switch result {
                case .success(let response):
                    print(response)
                    
                    DispatchQueue.main.async {
                        
                        self?.navigationController?.dismiss(animated: true, completion:nil)
                    }
                // MARK:-generate the toast for successfull reset password
                case .failure(BaseError.errorMessage(let error)):
                    self?.showAlert(title:Constants.apiError.rawValue, message:error as? String)
                    
                }
            })
            
        case .failure(_, let message):
            self.showAlert(title:Constants.validationFailure.rawValue, message:message.rawValue)
        }
    }
    
}

extension ResetPasswordController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == textFieldMobileNumber) {
            let response = Validation.shared.validate(values: (type: ValidationMode.phoneNo, inputValue:textFieldMobileNumber.text as Any))
            switch response {
            case .success:
                textFieldMobileNumber.trailingAssistiveLabel.text = ""
            case .failure(_, let message):
                textFieldMobileNumber.trailingAssistiveLabel.text = message.rawValue
            }
        }
        else if (textField == textFieldOtp) {
            let response = Validation.shared.validate(values: (type: ValidationMode.otp, inputValue:textFieldOtp.text as Any))
            switch response {
            case .success:
                textFieldOtp.trailingAssistiveLabel.text = ""
            case .failure(_, let message):
                textFieldOtp.trailingAssistiveLabel.text = message.rawValue
            }
        }
        else if (textField == textFieldPassword) {
            let response = Validation.shared.validate(values: (type: ValidationMode.password, inputValue:textFieldPassword.text as Any))
            switch response {
            case .success:
                textFieldPassword.trailingAssistiveLabel.text = ""
            case .failure(_, let message):
                textFieldPassword.trailingAssistiveLabel.text = message.rawValue
            }
        }
        else if (textField == textFieldConfirmPassword) {
            let response = Validation.shared.validate(values: (type: ValidationMode.confirmPassword, inputValue:textFieldConfirmPassword.text as Any))
            switch response {
            case .success:
                textFieldConfirmPassword.trailingAssistiveLabel.text = ""
            case .failure(_, let message):
                textFieldConfirmPassword.trailingAssistiveLabel.text = message.rawValue
            }
        }
    }
}
