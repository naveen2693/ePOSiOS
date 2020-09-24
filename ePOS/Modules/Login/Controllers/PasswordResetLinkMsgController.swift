//
//  PasswordResetLinkMsgController.swift
//  ePOS
//
//  Created by Abhishek on 23/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//
import UIKit

class PasswordResetLinkMsgController : UIViewController {
    
    @IBOutlet weak var textFieldMobileNumber: EPOSTextField!
    var mobileNumber:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(mobileNumber == nil)
        {
            // MARK:- alert show here
        }
    }
    
    @IBAction func buttonSubmit(_ sender: Any) {
        gotoResetPasswordController()
    }
    
    private func gotoResetPasswordController()
    {
        let storyboard = UIStoryboard(name: "LoginScreen", bundle:Bundle(for: PasswordResetLinkMsgController.self))
        let viewController = storyboard.instantiateViewController(withIdentifier:"ResetPasswordController") as? ResetPasswordController
        viewController?.mobileNumber = mobileNumber
        if let unwrappedViewController = viewController {
            let navController = UINavigationController(rootViewController: unwrappedViewController)
            navController.modalPresentationStyle = .overCurrentContext
            navController.modalTransitionStyle = .crossDissolve
            self.present(navController, animated: false, completion: nil)
        } else {
            fatalError("Error: Load url failed.")
        }
        
    }
}
