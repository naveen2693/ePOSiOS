//
//  EnterAmountViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 02/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class EnterAmountViewController: CustomNavigationStyleViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var amountTextField: EPOSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    
    @IBAction func nextClicked(_ sender: Any) {
        let controller = EnterDataViewController.init(nibName: EnterDataViewController.className, bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
