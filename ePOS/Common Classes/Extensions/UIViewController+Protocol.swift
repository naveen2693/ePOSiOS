//
//  UIViewController+Protocol.swift
//  ePOS
//
//  Created by Matra Sharma on 24/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

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

extension UIViewController: LoaderPresentable {}
