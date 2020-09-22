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
var mobileNumber:String="";
var checkBox:Bool=false;
override func viewDidLoad() {
    super.viewDidLoad()
    self.textView?.delegate = self
    if let unwrappedTextView = textView {
        Util.passTextViewReference(textViewField : unwrappedTextView)
    } else {
        fatalError("Error: Load url failed.")
    }
}

@IBAction func buttonSubmit(_ sender: Any) {
   
    let establishmentName:String = textFieldBusinessName.text!
    let contactName:String =  textFIeldContactName.text!
    let email:String =  textFieldEmailId.text!
    let password:String =  textFieldPassword.text!
    let confirmPassword:String =  textFieldConfirmPassword.text!
    let referralCode:String =  textFieldReferralCode.text!
// MARK:- Validation
    let response = Validation.shared.validate(values: (ValidationType.alphabeticString, establishmentName)
        ,(ValidationType.alphabeticString,contactName)
        ,(ValidationType.email,email)
        ,(ValidationType.password,password)
        ,(ValidationType.alphabeticString,referralCode)
        ,(ValidationType.checkBoxChecked,checkBox)
        ,(ValidationType.confirmPassword,confirmPassword))
    
    switch response {
    case .success:
        IntialDataRequest.SignupRequest(signUpData: SignUpData(contactName:contactName, email:email, establishmentName: password, password:establishmentName, referralCode:referralCode,contactNumber:mobileNumber), completion:{result in
        switch result {
            
        case .success(_):
            break;
        case .failure(_):
            break;
            }
        
        })
        break
        
    case .failure(_, let message):
        print(message.localized())
    }
}
//
//    public func gotoOTPVerification(mobileNumber:String, User ) {
//
//   }
//
//   @Override
//   public void gotoSignUp(String mobileNumber, User user) {
//       Intent intent = new Intent(this, SignUpActivity.class);
//       intent.putExtra(KEY_MOBILE_NUM, mobileNumber);
//       intent.putExtra(KEY_USER_PROFILE, user);
//       startActivity(intent);
//   }
//
//   @Override
//   public void gotoPasswordVerification(String mobileNumber) {
//       Intent intent = new Intent(this, PasswordActivity.class);
//       intent.putExtra(KEY_MOBILE_NUM, mobileNumber);
//       startActivity(intent);
//   }
//
//   @Override
//   public void gotoPasswordReset(String mobileNumber) {
//       Intent intent = new Intent(this, ResetPasswordActivity.class);
//       intent.putExtra(KEY_MOBILE_NUM, mobileNumber);
//       startActivity(intent);
//   }
//
@objc func onCheckBoxValueChange(_ sender: CheckBox) {
    checkBox = sender.isChecked;
}
}
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
