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
        let str = Constants.termAndConditionPolicyString.rawValue
        let attributedString = NSMutableAttributedString(string: str)
        var foundRange = attributedString.mutableString.range(of:Constants.termsOfUserString.rawValue)
        attributedString.addAttribute(NSAttributedString.Key.link, value: Constants.urlTermOfUser.rawValue, range: foundRange)
        foundRange = attributedString.mutableString.range(of:Constants.privacyPolicyString.rawValue )
        attributedString.addAttribute(NSAttributedString.Key.link, value:Constants.UrlPrivacyPolicy.rawValue, range: foundRange)
        textViewField.attributedText = attributedString
        
    }
    
    static var masterDataDirectoryURL: URL {
        var tempFileLoc = "";
        if let library = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last {
            let url = URL(fileURLWithPath: library).appendingPathComponent("InitialContents");
            tempFileLoc = url.path;
            var isDir : ObjCBool = false;
            if FileManager.default.fileExists(atPath: tempFileLoc, isDirectory: &isDir) == false || !isDir.boolValue {
                do {
                    try FileManager.default.createDirectory(atPath: tempFileLoc, withIntermediateDirectories: true, attributes:nil);
                }
                catch {
                    debugPrint("Error Occured in Creating MasterData Directory")
                }
            }
        }
        return URL(fileURLWithPath: tempFileLoc);
    }
    
    static func getUUID() -> String {
        let uuid = UIDevice.current.identifierForVendor
        return uuid!.uuidString
    }
}
