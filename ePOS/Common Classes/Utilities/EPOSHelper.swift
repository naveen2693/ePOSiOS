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

//MARK: - UIViewController extension
extension UIViewController {
    func showAlert(title: String?, message: String?) {
    
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}

//MARK: Images related
extension UIImageView{
    func circle() {
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.clipsToBounds = true
    }
}

import Kingfisher
extension UIImageView {
    func load(withImageUrl urlString: String?) {
        if let urlString = urlString, let url = URL(string: urlString) {
            let imageResource = ImageResource(downloadURL: url)
            self.kf.setImage(with: imageResource, placeholder: nil, options:  [.transition(.fade(0.3))])
        } else {
            self.image = nil
        }
    }
}
