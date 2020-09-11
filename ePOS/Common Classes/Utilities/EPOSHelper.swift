//
//  EPOSHelper.swift
//  ePOS
//
//  Created by Matra Sharma on 10/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

//MARK: - get Class name string
protocol NameObject {
    var className: String { get }
    static var className: String { get }
}

extension NameObject {
    var className: String {
        return String(describing: type(of: self))
    }

    static var className: String {
        return String(describing: self)
    }
}

extension NSObject : NameObject {}

//MARK: - get storyboard object
func storyboard(withName name: String) -> UIStoryboard {
    return UIStoryboard(name: name, bundle: nil)
}

//MARK: - Tabbar items
enum TabBarItem: String {
    case home = "Home"
    case transactions = "Transactions"
    case account = "Account"
    
    func image() -> UIImage? {
        switch self {
        case .home:
            return UIImage(named: "HomeUnselected")?.withRenderingMode(.alwaysOriginal)
        case .transactions:
            return UIImage(named: "transactionUnselected")?.withRenderingMode(.alwaysOriginal)
        case .account:
            return UIImage(named: "profileUnselected")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    func selectedImage() -> UIImage? {
        switch self {
        case .home:
            return UIImage(named: "homeSelected")?.withRenderingMode(.alwaysOriginal)
        case .transactions:
            return UIImage(named: "transactionsSelected")?.withRenderingMode(.alwaysOriginal)
        case .account:
            return UIImage(named: "profileSelected")?.withRenderingMode(.alwaysOriginal)
        }
    }
}
