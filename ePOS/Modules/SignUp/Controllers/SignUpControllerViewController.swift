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

@IBOutlet weak var textFieldBusinessName: EPOSTextField?
@IBOutlet weak var textFIeldContactName: EPOSTextField?
@IBOutlet weak var textFieldMobileNumber: EPOSTextField?
@IBOutlet weak var textFieldEmailId: EPOSTextField?
@IBOutlet weak var textFieldPassword: EPOSTextField?
@IBOutlet weak var textFieldConfirmPassword: EPOSTextField?
@IBOutlet weak var textFieldReferralCode: EPOSTextField?
@IBOutlet weak var textView: UITextView?
@IBOutlet weak var buttonCheckBox: CheckBox?
var mobileNumber:String="";
let objSignUpApi = MoyaProvider<ApiService>()
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
    guard let establishmentName:String = textFieldBusinessName?.getText(),
        let contactName:String =  textFIeldContactName?.getText(),
        let email:String =  textFieldEmailId?.getText(),
        let password:String =  textFieldPassword?.getText(),
        let confirmPwd:String =  textFieldConfirmPassword?.getText(),
        let referralCode:String =  textFieldReferralCode?.getText() else {
            return
    }
    let response = Validation.shared.validate(values: (ValidationType.alphabeticString, establishmentName),(ValidationType.alphabeticString,contactName),(ValidationType.email,email),(ValidationType.password,password),(ValidationType.alphabeticString,referralCode))
    switch response {
    case .success:
        objSignUpApi.request(.getSignUpSubscription(registrationData:Util.convertSignUpDataToModel(establishmentName: establishmentName,email: email,contactName: contactName,password: password,referralCode: referralCode, mobileNumber: mobileNumber))){ [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success( _):
                break
            case .failure( _):
                break;
            }
        }
    case .failure(_, let message):
        print(message.localized())
    }
}
}

extension SignUpController:UITextViewDelegate
{
// MARK:- Term&Condition link Interaction
private func textview(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
    if (URL.absoluteString == Constants.TERM_CONDITIONS) {
        Util.OpenCommonViewController(ctx: self, url: URL)
    } else if (URL.absoluteString == Constants.URL_PRIVACY_POLICY) {
        Util.OpenCommonViewController(ctx: self, url: URL)
    }
    return false
}



}
