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
        let mobileNumber:String = textFieldMobileNumber.text!
        let response = Validation.shared.validate(values: (type: ValidationType.phoneNo, inputValue:mobileNumber),(ValidationType.checkBoxChecked,CheckBox))
        switch response {
        case .success:
            IntialDataRequest.checkUserWith(mobileNumber:mobileNumber,completion:{result in
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error)
                }
                
            })
        case .failure(_, let message):
            print(message.localized())
        }
    }
    // MARK:-CallApi for SendOtp
    internal func callApiOtpToCreateNewPasswordWith(mobileNumber:String)
    {
        IntialDataRequest.forgotPasswordCallApiWith(mobileNumber:mobileNumber,completion:{result in
            switch result {
            case .success(let response):
                self.gotoPasswordResetController(mobileNumber: mobileNumber)
                print(response)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    internal func gotoSignUpController(mobileNumber:String,userData:UserData)
    {
        let viewController = SignUpController.instantiate(appStoryboard: .loginScreen)
        viewController.mobileNumber = mobileNumber
        viewController.userDataFromLoginController = userData
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    internal func gotoOtpVerificationController(mobileNumber:String,userData:UserData)
    {
        let viewController = OTPVerficationController.instantiate(appStoryboard: .loginScreen)
        viewController.mobileNumber = mobileNumber
        viewController.userDataFromLoginController = userData
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    internal func gotoPasswordVerificationController(mobileNumber:String)
    {
        let viewController = PasswordController.instantiate(appStoryboard: .loginScreen)
        viewController.mobileNumber = mobileNumber
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    internal func gotoPasswordResetController(mobileNumber:String)
    {
        let viewController = ResetPasswordController.instantiate(appStoryboard: .loginScreen)
        viewController.mobileNumber = mobileNumber
        self.navigationController?.pushViewController(viewController, animated: true)
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
        IntialDataRequest.getConfigurationDataWith(globalChangeNumber:0,completion:{result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
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
