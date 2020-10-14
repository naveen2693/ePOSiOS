//
//  UIViewController+Protocol.swift
//  ePOS
//
//  Created by Matra Sharma on 24/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

//MARK: - Loader UIViewController
protocol LoaderPresentable {
    func showLoading()
    func hideLoading()
}

extension LoaderPresentable where Self: UIViewController {
    
    func showLoading() {
        hideLoading()
        
        if let frame = UIApplication.shared.keyWindow?.bounds {
            let loader = EPOSLoader.init(frame: frame)
            loader.showLoading()
        }
    }
    
    func hideLoading() {
        if let loader = findLoader() {
            loader.hideLoading()
        }
    }
    
    func findLoader() -> EPOSLoader? {
        if let loaderViews = UIApplication.shared.keyWindow?.subviews.filter({ $0 is EPOSLoader }),
            let loader = loaderViews.first as? EPOSLoader {
            return loader
        }
        return nil
    }
}

extension UIViewController: LoaderPresentable  {}
//MARK: - RightLabelOnNavBar
protocol RightLabelOnNavigationBar {
    func setRightTitle(withTitle: String)
}

extension RightLabelOnNavigationBar where Self: CustomNavigationStyleViewController {
    
    func setRightTitle(withTitle: String) {
        let label = EPOSLabel()
        label.fontStyle = 4
        label.textColor = UIColor.white
        label.text = withTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: label)
    }
}

extension CustomNavigationStyleViewController: RightLabelOnNavigationBar {}

extension UIViewController {

    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

}

extension UIViewController  {
    //Hide the keyboard for any text field when the UI is touched outside of the keyboard.
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true) //Hide the keyboard
    }
}

