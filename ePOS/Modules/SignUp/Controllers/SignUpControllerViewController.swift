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
    var userDataFromLoginController:UserData?
    var mobileNumber:String="";
    var checkBox:Bool=false;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView?.delegate = self
        checkBoxConfiguration()
        populateData()
        if let unwrappedTextView = textView {
            Util.passTextViewReference(textViewField : unwrappedTextView)
        } else {
            fatalError("Error: Load url failed.")
        }
    }
    
    private func populateData()
    {
        textFieldMobileNumber.text = mobileNumber
        
    }
    @IBAction func buttonSubmit(_ sender: Any) {
        // MARK:- Validation
        let response = Validation.shared.validate(values: (ValidationType.alphabeticString, textFieldBusinessName.text as Any)
            ,(ValidationType.alphabeticString,textFIeldContactName.text  as Any)
            ,(ValidationType.email,textFieldEmailId.text  as Any)
            ,(ValidationType.password,textFieldPassword.text  as Any)
            ,(ValidationType.checkBoxChecked,checkBox)
            ,(ValidationType.confirmPassword,textFieldConfirmPassword.text  as Any))
        
        switch response {
        case .success:
            IntialDataRequest.callApiSignupRequest(signUpData: SignUpData(contactName:textFIeldContactName.text, email:textFieldEmailId.text, establishmentName: textFieldBusinessName.text, password:textFieldPassword.text, referralCode:textFieldReferralCode.text,contactNumber:mobileNumber), completion:{result in
                switch result {
                    
                case .success(let response):
                    OnBoardingRequest.getUserProfileAndProceedToLaunch(showProgress: true, completion:{result in
                        switch result {
                        case .success(let response):
                            print(response)
                            
                        case .failure(let error):
                            print(error)
                            ;
                        }
                    });
                    print(response)
                case .failure(let error):
                    print(error)
                }
                
            })
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
        checkBox = true;
    }
private func checkBoxConfiguration()
    {
        buttonCheckBox?.style = .tick
        buttonCheckBox?.borderStyle = .roundedSquare(radius: 12)
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
