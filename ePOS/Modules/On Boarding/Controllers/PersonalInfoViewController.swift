//
//  PersonalInfoViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 16/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit


class PersonalInfoViewController: CustomNavigationStyleViewController {

    @IBOutlet weak var applicationLabel: EPOSLabel!
    @IBOutlet weak var topCreamView: RoundedCornerView!
    @IBOutlet internal weak var textFieldCompanyType: EPOSTextField!
    @IBOutlet private weak var textFieldPAN: EPOSTextField!
    @IBOutlet private weak var textFieldNameOnPAN: EPOSTextField!
    @IBOutlet private weak var textFieldGSTIN: EPOSTextField!
    @IBOutlet internal weak var textFieldDocumentType: EPOSTextField!
    @IBOutlet private weak var textFieldDocumentInfo: EPOSTextField!
    @IBOutlet private weak var nextButton: EPOSRoundButton!
    @IBOutlet private weak var checkbox: CheckBox!
    @IBOutlet private weak var checkboxInfoLabel: EPOSLabel!
    @IBOutlet private weak var dropdownImageView: UIImageView!

    let applicationText = "Your epos application ID: "
    private var currentWorkflowState :WorkFlowState = .leadNotCreated
    private var currentLead: Lead? {
        return EPOSUserDefaults.CurrentLead()
    }
//    private let documentTypes = MasterDataProvider().getDropdownDataFor(.eposPOI)
    internal let dropDown = MakeDropDown()
    internal var dropDownRowHeight: CGFloat = 44
    internal var dropdownData: [CodeData] = [CodeData]()
    
    class func viewController(_ state: WorkFlowState) -> PersonalInfoViewController {
        
        let controller = PersonalInfoViewController.init(nibName: PersonalInfoViewController.className, bundle: nil)
        controller.currentWorkflowState = state
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUIInitially()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpDropDownFor(.businessType)
    }
    
    func showPan() {
        textFieldPAN.isHidden = false
        textFieldNameOnPAN.isHidden = false
        nextButton.isEnabled = true
    }

}

//MARK: - Private Func
private
extension PersonalInfoViewController {
    //MARK: - ConfigureUI
    func configureUIInitially() {
        navigationItem.title = "Registration"
        setApplicationID()
        nextButton.isEnabled = false
        textFieldCompanyType.inputView = UIView()
        textFieldCompanyType.inputAccessoryView = UIView()
        textFieldDocumentType.inputView = UIView()
        textFieldDocumentType.inputAccessoryView = UIView()
        MasterDataProvider().getDropdownDataFor(.businessType) { (data) in
            weak var weakSelf = self
            weakSelf?.dropdownData = data
        }

        checkbox.style = .tick
        checkbox.borderStyle = .roundedSquare(radius: 2)

        hideAllTextFields()
    }

    func setApplicationID() {
        if currentWorkflowState == .leadNotCreated {
            topCreamView.isHidden = true
        } else if currentLead != nil, let appID = currentLead!.applicationId {
            topCreamView.isHidden = false
            applicationLabel.text = applicationText + appID
        }
    }
    //MARK: - RefreshPage
    func refreshPage() {
        if currentLead?.workFlowState == WorkFlowState.leadInitialized.rawValue {
            currentWorkflowState = .leadInitialized
            textFieldGSTIN.isHidden = false
            checkbox.isHidden = false
            checkboxInfoLabel.isHidden = false
        }
        setApplicationID()
        
//        switch currentWorkflowState {
//        case .one:
//            hideAllTextFields()
//        case .two:
//            textFieldPAN.isHidden = false
//            textFieldNameOnPAN.isHidden = false
//        case .three:
//            textFieldGSTIN.isHidden = false
//            checkbox.isHidden = false
//            checkboxInfoLabel.isHidden = false
//        case .four:
//            textFieldDocumentType.isHidden = false
//            textFieldDocumentInfo.isHidden = false
//            dropdownImageView.isHidden = false
//        }

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
    
    func createLead() {
        let response = Validation.shared.validate(values: (ValidationType.pan, textFieldPAN.text as Any)
        ,(ValidationType.alphabeticString,textFieldNameOnPAN.text  as Any))
        switch response {
        case .success:
            showLoading()
            let leadParams = CreateLeadParams(name: textFieldNameOnPAN.text!.lowercased(), pan: textFieldPAN.text!.lowercased(), firmType:textFieldCompanyType.text!.uppercased() , kyc: [], typeOfLead: "EPOS")
            OnBoardingRequest.createLeadWith(params: leadParams) { [weak self] response in
                switch response {
                case .success(_):
                    self?.refreshPage()
                    MasterDataProvider().getDropdownDataFor(.eposPOI) { (data) in
                        weak var weakSelf = self
                        weakSelf?.dropdownData = data
                        weakSelf?.hideLoading()
                    }
                case .failure(BaseError.errorMessage(let error)):
                    self?.hideLoading()
                    self?.showAlert(title:Constants.apiError.rawValue, message:error as? String)
                }
            }
        case .failure(_, let message):
            showAlert(title: "ERROR", message: message.rawValue)
        }
    }
    
}


//MARK: - textfield delegate
extension PersonalInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == textFieldCompanyType || textField == textFieldCompanyType {
//            return false
//        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textFieldCompanyType || textField == textFieldCompanyType {
            return false
        }
        if textField == textFieldPAN, textField.text!.count > 10 {
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textFieldNameOnPAN {
            let result = Validation.shared.validate(values: (ValidationType.alphabeticString, textFieldNameOnPAN.text as Any))
            if case Valid.failure(_, let message) = result {
                textFieldNameOnPAN.trailingAssistiveLabel.text = message.rawValue
            } else {
                textFieldNameOnPAN.trailingAssistiveLabel.text = ""
            }
        }
        
        if textField == textFieldPAN {
            let resultDoc = Validation.shared.validate(values: (ValidationType.pan, textFieldPAN.text as Any))
            if case Valid.failure(_, let message) = resultDoc {
                textFieldPAN.trailingAssistiveLabel.text = message.rawValue
            } else {
                textFieldPAN.trailingAssistiveLabel.text = ""
            }
        }
    }

}
//MARK: - Actions
extension PersonalInfoViewController {
    
    @IBAction func openDropDown(_ sender: UIButton) {
        if sender.tag == 1 {
            if textFieldCompanyType.isFirstResponder == false {
                textFieldCompanyType.becomeFirstResponder()
            }
            showDropdown(!dropDown.isDropDownPresent, rows: 3)
        } else if sender.tag == 2 {
            if textFieldDocumentType.isHidden == true {
                return
            }
            if textFieldDocumentType.isFirstResponder == false {
                textFieldDocumentType.becomeFirstResponder()
            }
            showDropdown(!dropDown.isDropDownPresent, rows: 6)
        }
    }

    private func showDropdown(_ show: Bool, rows: Int) {
        if show == true {
            dropDown.reloadDropDown(height: self.dropDownRowHeight * CGFloat(rows))
            dropDown.showDropDown(height: self.dropDownRowHeight * CGFloat(rows))
        } else {
            dropDown.hideDropDown()
        }
    }
    @IBAction func checkboxClicked(_ sender: Any) {
    }

    @IBAction func nextClicked(_ sender: Any) {
        if currentLead != nil {
            if let workFlowString = currentLead!.workFlowState, let workflowState = WorkFlowState(rawValue: workFlowString) {
                currentWorkflowState = workflowState
            }
        } else if currentWorkflowState == .leadNotCreated {
            createLead()
        }
//        if currentWorkflowState != .four {
//            var currentWorkFlowIndex = currentWorkflowState.rawValue
//            currentWorkFlowIndex += 1
//            currentWorkflowState = WorkFlowState(rawValue: currentWorkFlowIndex) ?? .one
//            refreshPage()
//        }
//        else {
//            //go to next page
//            let controller = MerchantDetailsViewController.viewController(appID: "34h35h43h54h5")
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
    }

    @IBAction func needHelpClicked(_ sender: Any) {
    }
}
