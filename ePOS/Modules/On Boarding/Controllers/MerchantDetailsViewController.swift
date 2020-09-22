//
//  MerchantDetailsViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 20/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class MerchantDetailsViewController: UIViewController {

    @IBOutlet private weak var textFieldBusinessName: EPOSTextField!
    @IBOutlet private weak var textFieldAddress: EPOSTextField!
    @IBOutlet private weak var textFieldCity: EPOSTextField!
    @IBOutlet private weak var textFieldState: EPOSTextField!
    @IBOutlet private weak var textFieldPinecode: EPOSTextField!
    @IBOutlet private weak var textFieldTurnover: EPOSTextField!
    @IBOutlet private weak var textFieldMerchantCategory: EPOSTextField!
    @IBOutlet private weak var textFieldBusinessSince: EPOSTextField!
    @IBOutlet private weak var nextButton: EPOSRoundButton!
    @IBOutlet weak var labelApplicationID: EPOSLabel?
    
    private var eposApplicationID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    class func viewController(appID : String) -> MerchantDetailsViewController {
        let controller = MerchantDetailsViewController.init(nibName: MerchantDetailsViewController.className, bundle: nil)
        controller.eposApplicationID = appID
        return controller
    }
    
    @IBAction func needHelpClicked(_ sender: Any) {
    }
    @IBAction func nextButtonClicked(_ sender: Any) {
        let controller = BankDetailsViewController.viewController(appID: "34h35h43h54h5")
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
