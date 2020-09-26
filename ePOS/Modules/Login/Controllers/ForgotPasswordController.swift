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
    var mobileNumber:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(mobileNumber == nil)
        {
            self.showAlert(title: "Error", message:Constants.errorMessage.rawValue )
        }
    }
    
    class func initWith(mobileNumber: String) -> ForgotPasswordController {
        let controller = ForgotPasswordController.instantiate(appStoryboard: .loginScreen)
        controller.mobileNumber = mobileNumber
        return controller
    }
    
    @IBAction func buttonLogin(_ sender: Any) {
        let storyboard = UIStoryboard(name: "LoginScreen", bundle: nil)
        _ = storyboard.instantiateViewController(withIdentifier: "LoginController") as? LoginController
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func buttonSubmit(_ sender: Any) {
        showLoading()
        let mobileNumber = textFieldMobileNumber.text!;
        let response = Validation.shared.validate(values: (type: ValidationType.phoneNo, inputValue:mobileNumber))
        switch response {
        case .success:
            IntialDataRequest.forgotPasswordCallApiWith(mobileNumber:mobileNumber,completion:{[weak self] result in
                self?.hideLoading()
                switch result {
                case .success(let response):
                    print(response);
                    self?.gotoPasswordResetLinkMsgController(mobileNumber: mobileNumber);
                    
                 case .failure(BaseError.errorMessage(let error)):
                 self?.showAlert(title:Constants.apiError.rawValue, message:error as? String)
                }
            })
            
        case .failure(_, let message):
            print(message.localized())
        }
    }
    
    private func gotoPasswordResetLinkMsgController(mobileNumber:String)
    {
        let viewController = PasswordResetLinkMsgController.initWith(mobileNumber: mobileNumber)
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
}

