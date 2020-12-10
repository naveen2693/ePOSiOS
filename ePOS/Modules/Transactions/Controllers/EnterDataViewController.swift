//
//  EnterDataViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 02/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class EnterDataViewController: CustomNavigationStyleViewController {

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
                   var entereddetail = detailTextField.text!
                   
                   var iTag = CStateMachine.currentNode?.HostTlvtag
                   var bArrDetail = [Byte](entereddetail.utf8)
                   TransactionHUB.AddTLVDataWithTag(uiTag: iTag!, Data: [Byte](entereddetail.utf8), length: bArrDetail.count)
               
                   var tempNode = CStateMachine.currentNode?.GotoChild()
                   if(tempNode?.node_type == 2)
                   {
                       //Going Online
                       CStateMachine.currentNode = tempNode
                       TransactionHomeViewController.DoTransaction()
                   }
               }
        
    }
    
}
