//
//  LoginController.swift
//  ePOS
//
//  Created by Abhishek on 11/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit
class LoginController: UIViewController{
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textFieldMobileNumber: EPOSTextField!
    @IBOutlet weak var viewCheckBox: CheckBox!
    var CheckBox = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isSelectable = true
        checkBoxConfiguration()
        
        if let unwrappedTextView = textView {
            Util.passTextViewReference(textViewField : unwrappedTextView)
        } else {
            fatalError("Error: Load url failed.")
        }
        textView.isUserInteractionEnabled = true
        textView.isSelectable = true
    }
    
    
@IBAction func ButtonSubmit(_ sender: Any) {
        let mobileNumber:String = textFieldMobileNumber.text!
        let response = Validation.shared.validate(values: (type: ValidationType.phoneNo, inputValue:mobileNumber),(ValidationType.checkBoxChecked,CheckBox))
        switch response {
        case .success:
            IntialDataRequest.CheckUserWith(mobileNumber:mobileNumber,completion:{result in
            switch result {
                
            case .success(let response):
                print(response)
                break;
            case .failure(let failure):
                break;
                }
            
            })
            break
        case .failure(_, let message):
            print(message.localized())
        }
    }
    
    
    // MARK:- CheckBox Configuration
    private func checkBoxConfiguration()
    {
        viewCheckBox?.style = .tick
        viewCheckBox?.borderStyle = .roundedSquare(radius: 12)
        viewCheckBox?.addTarget(self, action: #selector(onCheckBoxValueChange(_:)), for: .valueChanged)
    }
    
    // MARK:- CheckBox Control
    @objc func onCheckBoxValueChange(_ sender: CheckBox) {
        CheckBox = sender.isChecked
        print(sender.isChecked)
    }
   
    
}

extension LoginController:UITextViewDelegate
{
    
    private func textview(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
            if (URL.absoluteString == Constants.urlTermOfUser.rawValue) {
                Util.OpenCommonViewController(ctx: self, url: URL)
                
            }
            else if (URL.absoluteString == Constants.UrlPrivacyPolicy.rawValue) {
                Util.OpenCommonViewController(ctx: self, url: URL)
              
            }
            return false
        }
 
}
