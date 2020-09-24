//
//  ForgotPasswordController.swift
//  ePOS
//
//  Created by Abhishek on 23/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class ForgotPasswordController : UIViewController {
    
    @IBOutlet weak var textFieldMobileNumber: EPOSTextField!
    var mobileNumber:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(mobileNumber == nil)
        {
            self.showAlert(title: "Error", message:Constants.errorMessage.rawValue )
        }
    }
    
    @IBAction func buttonLogin(_ sender: Any) {
        let storyboard = UIStoryboard(name: "LoginScreen", bundle: nil)
        _ = storyboard.instantiateViewController(withIdentifier: "LoginController") as? LoginController
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func buttonSubmit(_ sender: Any) {
        let mobileNumber = textFieldMobileNumber.text!;
        let response = Validation.shared.validate(values: (type: ValidationType.phoneNo, inputValue:mobileNumber))
        switch response {
        case .success:
            IntialDataRequest.forgotPasswordCallApiWith(mobileNumber:mobileNumber,completion:{[weak self] result in
                switch result {
                case .success(let response):
                    print(response);
                    self?.gotoPasswordResetLinkMsgController(mobileNumber: mobileNumber);
                    
                case .failure(let error):
                    print(error)
                }
            })
            
        case .failure(_, let message):
            print(message.localized())
        }
    }
    
    private func gotoPasswordResetLinkMsgController(mobileNumber:String)
    {
        let viewController = PasswordResetLinkMsgController.instantiate(appStoryboard: .loginScreen)
        viewController.mobileNumber = mobileNumber
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}

