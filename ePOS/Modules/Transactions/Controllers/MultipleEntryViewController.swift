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
    override func viewDidLoad() {
        super.viewDidLoad()
        addOptions()
        // Do any additional setup after loading the view.
    }


    private func addOptions()  {
        var yPosition: CGFloat = 20
        let height: CGFloat = 50
        for index in 1 ... options.count {
            let textField = UITextField(frame: CGRect(x: 20, y: yPosition, width: 200, height: height))
            yPosition += 30 + height
            textField.tag = index
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = ""
            textField.keyboardType = UIKeyboardType.default
            textField.returnKeyType = UIReturnKeyType.done
            textField.autocorrectionType = UITextAutocorrectionType.no
            textField.borderStyle = UITextField.BorderStyle.roundedRect
            textField.clearButtonMode = UITextField.ViewMode.whileEditing;
            containerView.addSubview(textField)
        }
    }
    
    @IBAction func continueClicked(_ sender: Any) {
    }
}
