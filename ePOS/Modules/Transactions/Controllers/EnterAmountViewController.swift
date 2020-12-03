//
//  EnterAmountViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 02/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

protocol prTransactionTestDelegate: class {
    func amountEntered(_ enteredAmount: String)
}

class EnterAmountViewController: CustomNavigationStyleViewController {

    weak var transactionDelegate: prTransactionTestDelegate?
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var amountTextField: EPOSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    
    @IBAction func nextClicked(_ sender: Any) {
       
        if (amountTextField?.text) != nil
        {
            var enteredAmount = amountTextField.text!
            
            if(enteredAmount.contains("."))
            {
               enteredAmount =  enteredAmount.replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
            }
            else{
                enteredAmount.append("00")
            }
            
            self.transactionDelegate?.amountEntered(enteredAmount)
        }
        // let controller = EnterDataViewController.init(nibName: EnterDataViewController.className, bundle: nil)
       // self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
