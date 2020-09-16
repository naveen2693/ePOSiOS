//
//  Util.swift
//  ePOS
//
//  Created by Abhishek on 11/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public class Util
{
// MARK:-Open Webview
    public static func OpenCommonViewController(ctx:UIViewController,url:NSURL)
{
    let storyboard = UIStoryboard(name: "Main", bundle:Bundle(for: CommonWebViewController.self))
    let viewController = storyboard.instantiateViewController(withIdentifier:"CommonWebViewController") as? CommonWebViewController
    viewController?.loadUrl=url;
    if let unwrappedViewController = viewController {
           let navController = UINavigationController(rootViewController: unwrappedViewController)
           navController.modalPresentationStyle = .overCurrentContext
           navController.modalTransitionStyle = .crossDissolve
           ctx.present(navController, animated: false, completion: nil)
       } else {
            fatalError("Error: Load url failed.")
       }
}
    
    // MARK:- Term&Condition Text View
 public static func passTextViewReference(textViewField:UITextView)
 {
     let str = Constants.TERMCONDITIONS_PRIVACYPOLICY
     let attributedString = NSMutableAttributedString(string: str)
     var foundRange = attributedString.mutableString.range(of:Constants.TERM_CONDITIONS)
     attributedString.addAttribute(NSAttributedString.Key.link, value: Constants.URL_TERM_AND_CONDITION, range: foundRange)
     foundRange = attributedString.mutableString.range(of:Constants.PRIVACY_POLICY )
     attributedString.addAttribute(NSAttributedString.Key.link, value:Constants.URL_PRIVACY_POLICY, range: foundRange)
     textViewField.attributedText = attributedString
 }
    

}
