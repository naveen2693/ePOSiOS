//
//  SignUpControllerViewController.swift
//  ePOS
//
//  Created by Abhishek on 15/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit
import Moya
class SignUpController: UIViewController {
    
    @IBOutlet weak var textFieldBusinessName: EPOSTextField!
    @IBOutlet weak var textFIeldContactName: EPOSTextField!
    @IBOutlet weak var textFieldMobileNumber: EPOSTextField!
    @IBOutlet weak var textFieldEmailId: EPOSTextField!
    @IBOutlet weak var textFieldPassword: EPOSTextField!
    @IBOutlet weak var textFieldConfirmPassword: EPOSTextField!
    @IBOutlet weak var textFieldReferralCode: EPOSTextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonCheckBox: CheckBox!
    var userData:UserData?
    var mobileNumber:String!;
    var checkBox:Bool=false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView?.delegate = self
        checkBoxConfiguration()
        populateData()
//        addKeyboardNotifications()
//        hideKeyboardWhenTappedAround()
        if let unwrappedTextView = textView {
            Util.passTextViewReference(textViewField : unwrappedTextView)
        } else {
            fatalError("Error: Load url failed.")
        }
    }
    
    
    class func initWith(mobileNumber: String,userData:UserData?) -> SignUpController {
        let controller = SignUpController.instantiate(appStoryboard: .signupStoryboard)
        controller.mobileNumber = mobileNumber
        controller.userData = userData
        return controller
    }
    
    
    private func populateData()
    {
        if userData != nil
        {
            textFieldEmailId.text = userData?.email
            textFieldEmailId.isEnabled = false;
            textFieldBusinessName.text = userData?.establishmentName
            textFieldBusinessName.isEnabled = false
        }
        textFieldMobileNumber.text = mobileNumber
        textFieldMobileNumber.isEnabled = false
        
    }
    @IBAction func buttonSubmit(_ sender: Any) {
        // MARK:- Validation
        let response = Validation.shared.validate(values: (ValidationMode.businessNameValidation, textFieldBusinessName.text as Any)
            ,(ValidationMode.contactNameValidation,textFIeldContactName.text  as Any)
            ,(ValidationMode.email,textFieldEmailId.text  as Any)
            ,(ValidationMode.password,textFieldPassword.text  as Any)
            ,(ValidationMode.checkBoxChecked,checkBox)
            ,(ValidationMode.confirmPassword,textFieldConfirmPassword.text  as Any))
        
        switch response {
        case .success:
            IntialDataRequest.callApiSignupRequest(signUpData: SignUpData(contactName:textFIeldContactName.text, email:textFieldEmailId.text, establishmentName: textFieldBusinessName.text, password:textFieldPassword.text, referralCode:textFieldReferralCode.text,contactNumber:mobileNumber), completion:{ result in
                switch result {
                    
                case .success(_):
                    appDelegate.getOnBoardingData()
                case .failure(let error):
                    print(error)
                }
                
            })
        case .failure(_, let message):
            self.showAlert(title:Constants.validationFailure.rawValue, message:message.rawValue)
        }
    }
   
    @objc func onCheckBoxValueChange(_ sender: CheckBox) {
        checkBox = sender.isChecked;
        checkBox = true;
    }
    private func checkBoxConfiguration()
    {
        buttonCheckBox?.style = .tick
        buttonCheckBox?.borderStyle = .square
        buttonCheckBox?.addTarget(self, action: #selector(onCheckBoxValueChange(_:)), for: .valueChanged)
    }
}
// MARK:- CheckBox Configuration

extension SignUpController:UITextViewDelegate
{
    // MARK:- Term&Condition link Interaction
    private func textview(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        if (URL.absoluteString == Constants.urlTermOfUser.rawValue) {
            Util.OpenCommonViewController(ctx: self, url: URL)
        } else if (URL.absoluteString == Constants.UrlPrivacyPolicy.rawValue) {
            Util.OpenCommonViewController(ctx: self, url: URL)
        }
        return false
    }
}


extension SignUpController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == textFieldEmailId) {
            let response = Validation.shared.validate(values: (type: ValidationMode.email, inputValue:textFieldEmailId.text as Any))
            switch response {
            case .success:
                textFieldEmailId.trailingAssistiveLabel.text = ""
            case .failure(_, let message):
                textFieldEmailId.trailingAssistiveLabel.text = message.rawValue
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
        else if (textField == textFieldBusinessName) {
            let response = Validation.shared.validate(values: (type: ValidationMode.businessNameValidation, inputValue:textFieldBusinessName.text as Any))
            switch response {
            case .success:
                textFieldBusinessName.trailingAssistiveLabel.text = ""
            case .failure(_, let message):
                textFieldBusinessName.trailingAssistiveLabel.text = message.rawValue
            }
        }
        else if (textField == textFIeldContactName) {
            let response = Validation.shared.validate(values: (type: ValidationMode.contactNameValidation, inputValue:textFIeldContactName.text as Any))
            switch response {
            case .success:
                textFIeldContactName.trailingAssistiveLabel.text = ""
            case .failure(_, let message):
                textFIeldContactName.trailingAssistiveLabel.text = message.rawValue
            }
        }
    }
    
}

