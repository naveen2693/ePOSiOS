//
//  BankDetailsViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 20/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class BankDetailsViewController: CustomNavigationStyleViewController {

    @IBOutlet private weak var textFieldAccountNumber: EPOSTextField!
    @IBOutlet private weak var textFieldConfirmAccount: EPOSTextField!
    @IBOutlet private weak var textFieldIFSCCode: EPOSTextField!
    @IBOutlet private weak var nextButton: EPOSRoundButton!
    @IBOutlet weak var labelApplicationID: EPOSLabel?
    @IBOutlet weak var enterAmountView: UIView!
    @IBOutlet weak var labelAccount: UILabel!
    @IBOutlet weak var textFieldAmount: EPOSTextField!
    
    private var eposApplicationID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        enterAmountView.isHidden = true
        // Do any additional setup after loading the view.
    }

    class func viewController() -> BankDetailsViewController {
        let controller = BankDetailsViewController.init(nibName: BankDetailsViewController.className, bundle: nil)
        return controller
    }
    
    @IBAction func needHelpClicked(_ sender: Any) {
    }
    @IBAction func nextButtonClicked(_ sender: Any) {
        let controller = SelectPackageViewController.init(nibName: SelectPackageViewController.className, bundle: nil)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }

    @IBAction func findIFSCClicked(_ sender: Any) {
        let controller = SearchIFSCViewController.viewController(delegate: self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension BankDetailsViewController: IFSCSelectedDelegate {
    func didSelectedIFSC(_ controller: IFSCCodeDetailViewController, code: IFSCDetail) {
        textFieldIFSCCode.text = code.ifscCode
    }
}
