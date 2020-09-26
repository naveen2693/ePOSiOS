//
//  PersonalInfoViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 16/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

enum WorkFlowState: Int {
    case one
    case two
    case three
    case four
}

class PersonalInfoViewController: CustomNavigationStyleViewController {

    @IBOutlet private weak var textFieldCompanyType: EPOSTextField!
    @IBOutlet private weak var textFieldPAN: EPOSTextField!
    @IBOutlet private weak var textFieldNameOnPAN: EPOSTextField!
    @IBOutlet private weak var textFieldGSTIN: EPOSTextField!
    @IBOutlet private weak var textFieldDocumentType: EPOSTextField!
    @IBOutlet private weak var textFieldDocumentInfo: EPOSTextField!
    @IBOutlet private weak var nextButton: EPOSRoundButton!
    @IBOutlet private weak var checkbox: CheckBox!
    @IBOutlet private weak var checkboxInfoLabel: EPOSLabel!
    @IBOutlet private weak var dropdownImageView: UIImageView!
    
    var currentWorkflowState :WorkFlowState = .one
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureUIInitially()
        // Do any additional setup after loading the view.
    }

    
    
    
}

//MARK: - Private Func
private
extension PersonalInfoViewController {
    //MARK: - ConfigureUI
    func configureUIInitially() {
        navigationItem.title = "Registration"
        textFieldPAN.delegate = self
        checkbox.style = .tick
        checkbox.borderStyle = .roundedSquare(radius: 2)
        
        hideAllTextFields()
    }
    
    //MARK: - RefreshPage
    func refreshPage() {
        
        switch currentWorkflowState {
        case .one:
            hideAllTextFields()
        case .two:
            textFieldPAN.isHidden = false
            textFieldNameOnPAN.isHidden = false
        case .three:
            textFieldGSTIN.isHidden = false
            checkbox.isHidden = false
            checkboxInfoLabel.isHidden = false
        case .four:
            textFieldDocumentType.isHidden = false
            textFieldDocumentInfo.isHidden = false
            dropdownImageView.isHidden = false
        }
        
    }
    
    func hideAllTextFields() {
        textFieldPAN.isHidden = true
        textFieldNameOnPAN.isHidden = true
        textFieldGSTIN.isHidden = true
        textFieldDocumentType.isHidden = true
        textFieldDocumentInfo.isHidden = true
        checkbox.isHidden = true
        checkboxInfoLabel.isHidden = true
        dropdownImageView.isHidden = true
    }
}


//MARK: - textfield delegate
extension PersonalInfoViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == textFieldPAN) {
            let textFieldCharacterCount = textField.text?.count ?? 0
            if (textFieldCharacterCount < 10 || textFieldCharacterCount > 10) {
                textFieldPAN.trailingAssistiveLabel.text = "Invalid PAN number"
            } else {
                textFieldPAN.trailingAssistiveLabel.text = ""
         }
        }
    }

}
//MARK: - Actions
extension PersonalInfoViewController {
    
    @IBAction func checkboxClicked(_ sender: Any) {
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        if currentWorkflowState != .four {
            var currentWorkFlowIndex = currentWorkflowState.rawValue
            currentWorkFlowIndex += 1
            currentWorkflowState = WorkFlowState(rawValue: currentWorkFlowIndex) ?? .one
            refreshPage()
        }
        else {
            //go to next page
            let controller = MerchantDetailsViewController.viewController(appID: "34h35h43h54h5")
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func needHelpClicked(_ sender: Any) {
    }
}
