//
//  CommonExtensions.swift
//  ePOS
//
//  Created by Abhishek on 17/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto
extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar

        self.spellCheckingType = .no
        self.autocorrectionType = .no
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}


extension UIView {

    // there can be other views between `subview` and `self`
    func getConvertedFrame(fromSubview subview: UIView) -> CGRect? {
        guard subview.isDescendant(of: self) else {
            return nil
        }

        var frame = subview.frame
        if subview.superview == nil {
            return frame
        }

        var superview = subview.superview
        while superview != self {
            frame = superview!.convert(frame, to: superview!.superview)
            if superview!.superview == nil {
                break
            } else {
                superview = superview!.superview
            }
        }

        return superview!.convert(frame, to: self)
    }

}

class SelfSizingTableView: UITableView {
    var maxHeight = CGFloat.infinity

    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    override var intrinsicContentSize: CGSize {
        let height = min(maxHeight, contentSize.height)
        return CGSize(width: contentSize.width, height: height)
    }
}

extension UIViewController{
func hideKeyboardWhenTappedAround() {
       let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
   }
   
   @objc func dismissKeyboard() {
       view.endEditing(true)
   }
}

extension String {
    
    func hmac(key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key, key.count, self, self.count, &digest)
        let data = digest.withUnsafeBytes { DispatchData(bytes: $0) }
        return data.map { String(format: "%02hhx", $0) }.joined()
    }
    
    func substring(from: Int?, to: Int?) -> String {
           if let start = from {
               guard start < self.count else {
                   return ""
               }
           }

           if let end = to {
               guard end >= 0 else {
                   return ""
               }
           }

           if let start = from, let end = to {
               guard end - start >= 0 else {
                   return ""
               }
           }

           let startIndex: String.Index
           if let start = from, start >= 0 {
               startIndex = self.index(self.startIndex, offsetBy: start)
           } else {
               startIndex = self.startIndex
           }

           let endIndex: String.Index
           if let end = to, end >= 0, end < self.count {
               endIndex = self.index(self.startIndex, offsetBy: end + 1)
           } else {
               endIndex = self.endIndex
           }

           return String(self[startIndex ..< endIndex])
       }
  
}
