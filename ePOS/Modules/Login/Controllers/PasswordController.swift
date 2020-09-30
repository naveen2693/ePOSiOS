//
//  PasswordController.swift
//  ePOS
//
//  Created by Abhishek on 11/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class PasswordController: UIViewController {
    
    @IBOutlet weak var textFieldPassword: EPOSTextField!
    var mobileNumber:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func buttonForgotPassword(_ sender: Any) {
        // MARK:-goto Forgot PasswordController
        self.gotoForgotPasswordController()
        
    }
    
    class func initWith(mobileNumber: String) -> PasswordController {
        let controller = PasswordController.instantiate(appStoryboard: .loginScreen)
        controller.mobileNumber = mobileNumber
        return controller
    }
    
    @IBAction func buttonSubmit(_ sender: Any) {
        
        let response = Validation.shared.validate(values: (type: ValidationMode.password, inputValue:textFieldPassword.text as Any  ))
        switch response {
        case .success:
            showLoading()
            if let unwrappedMobileNumber = mobileNumber {
                IntialDataRequest.callLoginApiAfterNumberVerfication(mobileNumber:unwrappedMobileNumber, password:textFieldPassword.text! ,completion:{[weak self] result in
                    self?.hideLoading()
                    switch result {
                    case .success(let _):
                        appDelegate.getOnBoardingData()
                    case .failure(BaseError.errorMessage(let error)):
                     self?.showAlert(title:Constants.apiError.rawValue, message:error as? String)
                    }
                })
            }
        case .failure(_, let message):
            self.showAlert(title:Constants.validationFailure.rawValue, message:message.rawValue)        }
    }
    private func gotoForgotPasswordController()
    {
        let viewController = ForgotPasswordController.initWith(mobileNumber: mobileNumber)
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .overCurrentContext
        navController.modalTransitionStyle = .crossDissolve
        self.present(navController, animated: false, completion: nil)
    }
}
extension PasswordController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == textFieldPassword) {
            let response = Validation.shared.validate(values: (type: ValidationMode.password, inputValue:textFieldPassword.text as Any))
            switch response {
            case .success:
                textFieldPassword.trailingAssistiveLabel.text = ""
            case .failure(_, let message):
                textFieldPassword.trailingAssistiveLabel.text = message.rawValue
            }
        }
    }
}
