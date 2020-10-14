//
//  AppDelegate.swift
//  ePOS
//
//  Created by Matra Sharma on 03/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
let appDelegate: AppDelegate = {
    return (UIApplication.shared.delegate as? AppDelegate ?? AppDelegate())
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        configureFirebase()
        setAppearance()
//        loadApp()
        return true
    }

    
    // MARK: Firebase
    func configureFirebase() {
//        #if DEBUG || UAT
//        let firebaseConfig = Bundle.main.path(forResource: "GoogleService-Info-dev", ofType: "plist")
//        #else
//        let firebaseConfig = Bundle.main.path(forResource: "GoogleService-Info-prod", ofType: "plist")
//        #endif
//
//        guard let options = FirebaseOptions(contentsOfFile: firebaseConfig ?? "") else {
//            fatalError("Invalid Firebase configuration file.")
//        }
//
//        FirebaseApp.configure(options: options)
        FirebaseApp.configure()
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
//        Analytics.logEvent("Project_Name", parameters: [
//        "name":"ePOS Dev"
//        ])
    }
    

}

//MARK: - Custom Methods
extension AppDelegate {
    
    func loadApp() {
        if EPOSUserDefaults.getProfile() != nil {
            getOnBoardingData()
        } else {
            showLoginScreen()
        }
    }
    
    func showLoginScreen() {
        if let loginController = AppStoryboard.loginScreen.initialViewController() {
            setRootControllerOnWindowWith(loginController)
        }
    }
    
    func setRootControllerOnWindowWith(_ controller: UIViewController)  {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let navController = controller as? UINavigationController {
            self.window?.rootViewController = navController
        } else {
            let navigationController = UINavigationController(rootViewController: controller)
            self.window?.rootViewController = navigationController
        }
        self.window?.makeKeyAndVisible()
    }
    
    func showHomeScreen() {
        setRootControllerOnWindowWith(EPOSTabBarViewController())
    }
    
    func setOnBoardingNavigationWith(_ state: WorkFlowState) {
        switch state {
        case .leadNotCreated, .leadInitialized:
            let controller = PersonalInfoViewController.viewController(state)
//            let navigationController = AppStoryboard.main.initialViewController()
            setRootControllerOnWindowWith(controller)
        default:
            break
        }
    }
    
    func getOnBoardingData() {
        OnBoardingRequest.getUserProfileAndProceedToLaunch(showProgress: true, completion:{ result in
            weak var weakSelf = self
            switch result {
            case .success(let response):
                if let workflowState = response as? WorkFlowState {
                    weakSelf?.setOnBoardingNavigationWith(workflowState)
                }
            case .failure(let error):
                print("")
//               self.showAlert(title:Constants.validationFailure.rawValue, message:error)
            }
        });
    }
    
    func setAppearance() {

        UINavigationBar.appearance().tintColor = UIColor.white

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.mediumFontWith(size: 18), NSAttributedString.Key.foregroundColor: UIColor.white]


        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.font: UIFont.mediumFontWith(size: 12), NSAttributedString.Key.foregroundColor: UIColor.subTextColor()]

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).borderStyle = .none

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .clear
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.subTextColor()], for: .normal)

    }
    
}

