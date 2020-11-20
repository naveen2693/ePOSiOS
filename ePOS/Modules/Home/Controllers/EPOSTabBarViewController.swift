//
//  EPOSTabBarViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 09/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit
class EPOSTabBarViewController: UITabBarController {
    
    private lazy var homeViewController :TransactionHomeViewController = {
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? TransactionHomeViewController else {
            fatalError("HomeViewController is not initial controller in Home.storyboard")
        }
        let tabbarItem = UITabBarItem(title: TabBarItem.home.rawValue, image: TabBarItem.home.image(), selectedImage: TabBarItem.home.selectedImage())
        tabbarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        controller.tabBarItem = tabbarItem
        return controller
    }()
    
    private lazy var transactionViewController :TransactionHistoryViewController = {
        let storyboard = UIStoryboard.init(name: "Transactions", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? TransactionHistoryViewController else {
            fatalError("TransactionsViewController is not initial controller in Transactions.storyboard")
        }
        let tabbarItem = UITabBarItem(title: TabBarItem.transactions.rawValue, image: TabBarItem.transactions.image(), selectedImage: TabBarItem.transactions.selectedImage())
        tabbarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        controller.tabBarItem = tabbarItem
        return controller
    }()
    
    private lazy var accountViewController :AccountViewControllerTableViewController = {
        let storyboard = UIStoryboard.init(name: "Account", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? AccountViewControllerTableViewController else {
            fatalError("AccountViewController is not initial controller in Account.storyboard")
        }
        let tabbarItem = UITabBarItem(title: TabBarItem.account.rawValue, image: TabBarItem.account.image(), selectedImage: TabBarItem.account.selectedImage())
        tabbarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        controller.tabBarItem = tabbarItem
        return controller
    }()
    
    lazy var homeNavigationController = UINavigationController(rootViewController: self.homeViewController)
    lazy var accountNavigationController = UINavigationController(rootViewController: self.transactionViewController)
    lazy var transactionsNavigationController = UINavigationController(rootViewController: self.accountViewController)

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabbar()
        // Do any additional setup after loading the view.
    }
    

}

//MARK: - setup tabbar
private
extension EPOSTabBarViewController {
    func setTabbar() {
        setViewControllers([homeNavigationController, accountNavigationController, transactionsNavigationController], animated: true)
        
        removeTopBlackLine()
        
        tabBar.isTranslucent = false
        UITabBar.appearance().shadowImage = nil
        UITabBar.appearance().layer.borderWidth = 0.0
        tabBar.unselectedItemTintColor = UIColor.titleColor()
        tabBar.tintColor = UIColor.lightThemeColor()
        tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        tabBar.layer.shadowOpacity = 0.3
    }
    
    func removeTopBlackLine() {
        if #available(iOS 13.0, *) {
            // ios 13.0 and above
            let appearance = tabBar.standardAppearance
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            appearance.backgroundEffect = nil
            // need to set background because it is black in standardAppearance
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
        } else {
            // below ios 13.0
            let image = UIImage()
            tabBar.shadowImage = image
            tabBar.backgroundImage = image
            // background
            tabBar.backgroundColor = .white
        }
    }
}
