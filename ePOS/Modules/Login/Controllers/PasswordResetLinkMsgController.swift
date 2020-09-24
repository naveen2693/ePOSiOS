//
//  PasswordResetLinkMsgController.swift
//  ePOS
//
//  Created by Abhishek on 23/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//
import UIKit

class PasswordResetLinkMsgController : UIViewController {
    var mobileNumber:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(mobileNumber == nil)
        {
            self.showAlert(title: "Error", message:Constants.errorMessage.rawValue )
        }
    }
    
    @IBAction func buttonSubmit(_ sender: Any) {
        gotoResetPasswordController()
    }
    
    private func gotoResetPasswordController()
    {
            let viewController = ResetPasswordController.instantiate(appStoryboard: .loginScreen)
            viewController.mobileNumber = mobileNumber
           self.navigationController?.pushViewController(viewController, animated: true)
    }
}
