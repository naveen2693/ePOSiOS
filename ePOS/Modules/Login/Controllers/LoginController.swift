//
//  LoginController.swift
//  ePOS
//
//  Created by Abhishek on 11/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class LoginController: UIViewController{
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textFieldMobileNumber: EPOSTextField!
    @IBOutlet weak var viewCheckBox: CheckBox!
    var CheckBox = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isSelectable = true
        checkBoxConfiguration()
        if let unwrappedTextView = textView {
            Util.passTextViewReference(textViewField : unwrappedTextView)
        } else {
            fatalError("Error: Load url failed.")
        }
        // MARK:-Get Configuration data
        getConfigurationData();
        
    }
    
    @IBAction func ButtonSubmit(_ sender: Any) {
        showLoading()
        let response = Validation.shared.validate(values: (type: ValidationType.phoneNo, inputValue:textFieldMobileNumber.text as Any),(ValidationType.checkBoxChecked,CheckBox))
        switch response {
        case .success:
            IntialDataRequest.checkUserWith(mobileNumber:textFieldMobileNumber.text!,completion:{ [weak self] result in
                self?.hideLoading()
                switch result {
                case .success(let response):
                    self?.decideUserNavigation(response)
                    print(response)
                 case .failure(BaseError.errorMessage(let error)):
                  self?.showAlert(title:Constants.apiError.rawValue, message:error as? String)
                }
                
            })
        case .failure(_, let message):
            hideLoading()
            print(message.localized())
        }
    }
    // MARK:- decideUserNavigation
    private func decideUserNavigation(_ response : AnyObject) {
        guard let checkUserModel = response as? CheckUserModel else {
            return
        }
        
        if checkUserModel.userExists?.bool == true  {
            if let userData = checkUserModel.UserData, let udid = userData.appUuid {
                EPOSUserDefaults.setUdid(udid:udid)
            }
            if checkUserModel.udfFields != nil,
                let dict = checkUserModel.udfFields,
                let value = dict[UdfFields.keyISFirstTimeLoginUser.rawValue],
                value == UdfFields.valUdfPositiveValue.rawValue {
                callApiOtpToCreateNewPassword()
            } else {
                gotoPasswordVerificationController()
            }
        } else if let userData = checkUserModel.UserData {
            if userData.mobileVerified?.bool == true {
                if let udid = userData.appUuid {
                    EPOSUserDefaults.setUdid(udid:udid)
                }
                gotoSignUpController(userData: userData)
            }
        } else if let userData = checkUserModel.UserData {
            gotoOtpVerificationController(userData: userData)
        }
    }
    
    // MARK:-CallApi for SendOtp
    internal func callApiOtpToCreateNewPassword()
    {
        guard let mobileNumber = textFieldMobileNumber.text else {
            self.showAlert(title: "", message: "Mobile number not found")
            return
        }
        IntialDataRequest.forgotPasswordCallApiWith(mobileNumber:mobileNumber,completion:{[weak self]  result in
            switch result {
            case .success(let response):
                self?.gotoPasswordResetController()
                print(response)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    internal func gotoSignUpController(userData:UserData)
    {
        
        if let mobileNumber = textFieldMobileNumber.text {
            let viewController = SignUpController.initWith(mobileNumber: mobileNumber, userData: userData)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    internal func gotoOtpVerificationController(userData:UserData)
    {
        if let mobileNumber = textFieldMobileNumber.text {
            let viewController = OTPVerficationController.initWith(mobileNumber: mobileNumber,userData: userData)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    internal func gotoPasswordVerificationController()
    {
        
        if let mobileNumber = textFieldMobileNumber.text {
            let viewController = PasswordController.initWith(mobileNumber: mobileNumber)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    internal func gotoPasswordResetController()
    {
        if let mobileNumber = textFieldMobileNumber.text {
            let viewController = ResetPasswordController.initWith(mobileNumber: mobileNumber)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK:- CheckBox Configuration
    private func checkBoxConfiguration()
    {
        viewCheckBox?.style = .tick
        viewCheckBox?.borderStyle = .roundedSquare(radius: 12)
        viewCheckBox?.addTarget(self, action: #selector(onCheckBoxValueChange(_:)), for: .valueChanged)
    }
    
    // MARK:- CheckBox Control
    @objc func onCheckBoxValueChange(_ sender: CheckBox) {
        CheckBox = sender.isChecked
        print(sender.isChecked)
    }
    
    // MARK:-Get Configuration Function Defination
    private func getConfigurationData()
    {
        IntialDataRequest.getConfigurationDataWith(globalChangeNumber:0,completion:{ [weak self] result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(BaseError.errorMessage(let error)):
                self?.showAlert(title:Constants.apiError.rawValue, message:error as? String)
            }
            
        })
    }
}

extension LoginController:UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.absoluteString == Constants.urlTermOfUser.rawValue) {
            Util.OpenCommonViewController(ctx: self, url: URL as NSURL)
            
        }
        else if (URL.absoluteString == Constants.UrlPrivacyPolicy.rawValue) {
            Util.OpenCommonViewController(ctx: self, url: URL as NSURL)
            
        }
        return false
    }
}
