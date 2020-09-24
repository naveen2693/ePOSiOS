//
//  GenericSwitchingController.swift
//  ePOS
//
//  Created by Abhishek on 23/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public enum AppStoryboard: String {
    case loginScreen = "LoginScreen"
    case signupStoryboard = "SignUpStoryboard"
    public var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController not found")
        }
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID: String {
        return "\(self)"
    }
    
static func instantiate(appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
