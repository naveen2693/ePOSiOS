//
//  CustomNavigationStyleViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 25/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

struct System {
    static func clearNavigationBar(forBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
}

class CustomNavigationStyleViewController: UIViewController {
    
    @IBOutlet private weak var viewBG: RoundedCornerView!
    @IBOutlet var topConstraint: NSLayoutConstraint?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navController = navigationController {
            System.clearNavigationBar(forBar: navController.navigationBar)
            navController.view.backgroundColor = .clear
        }
        showBackButton()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topConstraint?.constant = 16
    }
    
    func showBackButton() {
        let button: UIButton = UIButton (type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "backIcon"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0 , y: 0, width: 50, height: 40)

        let barButton = UIBarButtonItem(customView: button)
        if self != self.navigationController?.viewControllers[0] {
            self.navigationItem.leftBarButtonItem = barButton
        }
    }
    
    func hideBackButton() {
        self.navigationItem.leftBarButtonItem = nil
    }
    
    @objc
    func backButtonPressed() {
        if self == self.navigationController?.viewControllers[0] {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
