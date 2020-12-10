//
//  EnterDataViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 02/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

protocol prTransactionTestDelegate: class {
    func PerformTransaction()
}

class EnterDataViewController: CustomNavigationStyleViewController {

    weak var transactionDelegate: prTransactionTestDelegate?
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var detailTextField: EPOSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tempNode = CStateMachine.currentNode
        if let fieldName = tempNode?.DisplayMessage{
            detailTextField.floatingText = fieldName
        }

    }

    @IBAction func nextClicked(_ sender: Any) {
        
        if (detailTextField?.text) != nil
        {
            let entereddetail = detailTextField.text!
                   
            let iTag = CStateMachine.currentNode?.HostTlvtag
            let bArrDetail = [Byte](entereddetail.utf8)
            TransactionHUB.AddTLVDataWithTag(uiTag: iTag!, Data: [Byte](entereddetail.utf8), length: bArrDetail.count)
               
            let tempNode = CStateMachine.currentNode?.GotoChild()

            TransactionHUB.goToNode(tempNode,self.navigationController,transactionDelegate)
      }
    
  }
}
