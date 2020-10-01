//
//  CommonExtensions.swift
//  ePOS
//
//  Created by Abhishek on 17/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
import UIKit

//extension UITextField{
//    @IBInspectable var doneAccessory: Bool{
//        get{
//            return self.doneAccessory
//        }
//        set (hasDone) {
//            if hasDone{
//                addDoneButtonOnKeyboard()
//            }
//        }
//    }
//
//    func addDoneButtonOnKeyboard()
//    {
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//        doneToolbar.barStyle = .default
//
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
//
//        let items = [flexSpace, done]
//        doneToolbar.items = items
//        doneToolbar.sizeToFit()
//
//        self.inputAccessoryView = doneToolbar
//
//        self.spellCheckingType = .no
//        self.autocorrectionType = .no
//    }
//
//    @objc func doneButtonAction()
//    {
//        self.resignFirstResponder()
//    }
//}
//

//extension UIView {
//
//    // there can be other views between `subview` and `self`
//    func getConvertedFrame(fromSubview subview: UIView) -> CGRect? {
//        guard subview.isDescendant(of: self) else {
//            return nil
//        }
//
//        var frame = subview.frame
//        if subview.superview == nil {
//            return frame
//        }
//
//        var superview = subview.superview
//        while superview != self {
//            frame = superview!.convert(frame, to: superview!.superview)
//            if superview!.superview == nil {
//                break
//            } else {
//                superview = superview!.superview
//            }
//        }
//
//        return superview!.convert(frame, to: self)
//    }
//
//}
