//
//  MultipleEntryViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 31/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class MultipleEntryViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    var options = [String]()
    private var multipleDataEntry:String?
    var list = [PvmListParserVO]()
    weak var transactionDelegate: prTransactionTestDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //guard let multipleDataEntry = CStateMachine.currentNode as? MultipleDataEntryActivity else {return}
        //multipleDataEntry =  multipleDataEntry.iName
        
        guard let multipleDataEntry = CStateMachine.currentNode as? MultipleDataEntryActivity else {return}
        list = multipleDataEntry.pvmListParser
        addOptions()
        // Do any additional setup after loading the view.
    }


    private func addOptions()  {
        var yPosition: CGFloat = 20
        let height: CGFloat = 50
        for index in 1 ... list.count {
            let pvmListParser = list[index-1]
            let textField = UITextField(frame: CGRect(x: 20, y: yPosition, width: 300, height: height))
            yPosition += 30 + height
            textField.tag = index
            //textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = pvmListParser.DM
            if pvmListParser.InputMethod == .NUMERIC_ENTRY{
                textField.keyboardType = UIKeyboardType.numberPad
            }else{
                textField.keyboardType = UIKeyboardType.default
            }
            textField.returnKeyType = UIReturnKeyType.done
            textField.autocorrectionType = UITextAutocorrectionType.no
            textField.borderStyle = UITextField.BorderStyle.roundedRect
            textField.clearButtonMode = UITextField.ViewMode.whileEditing;
            containerView.addSubview(textField)
        }
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        
        let textFieldList = containerView.subviews
        
        for element in textFieldList
        {
            if let element = element as? UITextField
            {
                guard let value = element.text as? String else
                {
                    //TODO Show Error please enter all values
                    return
                }
                
                let placeHolderName = element.placeholder
                let pvmobject = (list.filter{$0.DM == placeHolderName}).first
                let htlTag = pvmobject?.HTL
                //Add TLV Data
                TransactionHUB.AddTLVDataWithTag(uiTag: htlTag!, Data: [Byte](value.utf8), length: value.count)
            }
        }
        
        let tempNode = CStateMachine.currentNode?.GotoChild()
        TransactionHUB.goToNode(tempNode,self.navigationController,transactionDelegate)
        
    }
}
