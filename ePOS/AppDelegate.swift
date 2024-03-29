//
//  AppDelegate.swift
//  ePOS
//
//  Created by Matra Sharma on 03/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit
import Firebase

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureFirebase()
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
//        FirebaseApp.configure()
//        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
//        Analytics.logEvent("Project_Name", parameters: [
//        "name":"ePOS Dev"
//        ])
    }
    

}

//MARK: - Custom Methods
extension AppDelegate {
    
    func showHomeScreen()  {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: EPOSTabBarViewController())
        navigationController.isNavigationBarHidden = true
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
}
