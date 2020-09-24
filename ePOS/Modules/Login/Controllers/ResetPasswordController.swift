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
            //generate the alert for mobile number nil
        }
        //fillup the mobile Number
        setTextfields();
        
    }
    
    private func setTextfields()
    {
        
        textFieldMobileNumber.text = mobileNumber
    }
    
    private func callResendOtpApi() {
        if let unwrappedMobileNumber = mobileNumber {
            IntialDataRequest.resendOtpCallApiWith(mobileNumber:unwrappedMobileNumber,completion:{result in
                switch result {
                case .success (let response):
                    print(response);
                case .failure(let error):
                    print(error)
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
    
    
    
    @IBAction func buttonCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonSubmit(_ sender: Any) {
        let mobileNumber:String =  textFieldMobileNumber.text!
        let otp:String =  textFieldOtp.text!
        let password:String =  textFieldPassword.text!
        let confirmPassword:String =  textFieldConfirmPassword.text!
        let response = Validation.shared.validate(values: (ValidationType.phoneNo, mobileNumber)
            ,(ValidationType.password,password)
            ,(ValidationType.confirmPassword,confirmPassword)
            ,(ValidationType.otp,otp))
        switch response {
        case .success:
            IntialDataRequest.resetPasswordCallApiwith(mobileNumber:mobileNumber,otp: otp,newPassword:password,completion:{result in
                switch result {
                case .success(let response):
                    print(response);
                    // MARK:-generate the toast for successfull reset password
                case .failure(let error):
                    print(error);
                    
                }
            })
            
        case .failure(_, let message):
            print(message.localized())
        }
    }
    
}
