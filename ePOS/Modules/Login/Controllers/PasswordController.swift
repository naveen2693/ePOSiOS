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
    var mobileNumber:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func buttonForgotPassword(_ sender: Any) {
        // MARK:-goto Forgot PasswordController
        self.gotoForgotPasswordController()
    }
    
    @IBAction func buttonSubmit(_ sender: Any) {

        let response = Validation.shared.validate(values: (type: ValidationType.password, inputValue:textFieldPassword.text as Any  ))
        switch response {
        case .success:
            if let unwrappedMobileNumber = mobileNumber {
                IntialDataRequest.callLoginApiAfterNumberVerfication(mobileNumber:unwrappedMobileNumber, password:textFieldPassword.text! ,completion:{[weak self] result in
                    switch result {
                    case .success(let response):
                        OnBoardingRequest.getUserProfileAndProceedToLaunch(showProgress: true, completion:{ result in
                        switch result {
                        case .success(let response):
                            print(response)
                        case .failure(let error):
                            print(error)
                            ;
                            }
                        });
                        print(response);
                    case .failure(let error):
                        print(error)
                    }
                })
            }
        case .failure(_, let message):
            print(message.localized())
        }
    }
    
    private func gotoForgotPasswordController()
    {
        let viewController = ForgotPasswordController.instantiate(appStoryboard: .loginScreen)
        viewController.mobileNumber = mobileNumber
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .overCurrentContext
        navController.modalTransitionStyle = .crossDissolve
        self.present(navController, animated: false, completion: nil)
    }
}
