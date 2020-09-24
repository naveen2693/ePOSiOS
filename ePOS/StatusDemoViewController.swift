//
//  StatusDemoViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 10/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class StatusDemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let controller = EmptyDataViewController.viewController(NoUserItem(), delegate: self)
        let controller = PersonalInfoViewController.init(nibName: PersonalInfoViewController.className, bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true)
        // Do any additional setup after loading the view.
//        showLoading()
//        perform(#selector(hideLoader), with: nil, afterDelay: 5.0)
    }
    
    @objc func hideLoader() {
//        stopLoading()
    }

    @IBAction func firstClicked(_ sender: Any) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StatusDemoViewController: EmptyDataControllerDelegate {
    func actionButtonClicked(_ controller: EmptyDataViewController, for itemType: EmptyViewItemProtocol) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
