//
//  LoginController.swift
//  ePOS
//
//  Created by Abhishek on 11/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit
class LoginController: UIViewController {
@IBOutlet weak var textView: UITextView?
@IBOutlet weak var textFieldMobileNumber: BottomBorderTF?
@IBOutlet weak var imageProccedNextView: UIImageView?
@IBOutlet weak var viewCheckBox: CheckBox?
    
override func viewDidLoad() {
    super.viewDidLoad()
    self.textView?.delegate = self
    if let unwrappedTextView = textView {
          Util.passTextViewReference(textViewField : unwrappedTextView)
       } else {
            fatalError("Error: Load url failed.")
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
    print(sender.isChecked)
}
    
}

extension LoginController:UITextViewDelegate
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
