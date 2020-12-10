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

        var tempNode = CStateMachine.currentNode
        var fieldName = tempNode?.DisplayMessage
        //Need to add field name with detailTextField
        
        //topLabel.text = fieldName
        
        // Do any additional setup after loading the view.
    }


    
//    @IBAction func nextClicked(_ sender: Any)
//    {
//
//        if (amountTextField?.text) != nil
//        {
//            var enteredAmount = amountTextField.text!
//
//            if(enteredAmount.contains("."))
//            {
//               enteredAmount =  enteredAmount.replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
//            }
//            else{
//                enteredAmount.append("00")
//            }
//
//            self.transactionDelegate?.amountEntered(enteredAmount)
//        }
//        // let controller = EnterDataViewController.init(nibName: EnterDataViewController.className, bundle: nil)
//       // self.navigationController?.pushViewController(controller, animated: true)
//    }
    
    
    @IBAction func nextClicked(_ sender: Any)
    {
       
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
            
            var iTag = CStateMachine.currentNode?.HostTlvtag
            var bArrAmount = [Byte](enteredAmount.utf8)
            TransactionHUB.AddTLVDataWithTag(uiTag: iTag!, Data: [Byte](enteredAmount.utf8), length: bArrAmount.count)
        
            var tempNode = CStateMachine.currentNode?.GotoChild()
//            if(tempNode?.node_type == 4)
//            {
//                CStateMachine.currentNode = tempNode
//                let controller = EnterDataViewController.init(nibName: EnterDataViewController.className, bundle: nil)
//                self.navigationController?.pushViewController(controller, animated: true)
//            }
            
            TransactionHUB.goToNode(tempNode,self.navigationController)
            
            
            //self.transactionDelegate?.amountEntered(enteredAmount)
            
        }
    }
    
}
