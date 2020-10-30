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
    @IBOutlet private weak var textFieldDocumentState: EPOSTextField!
    @IBOutlet private weak var nextButton: EPOSRoundButton!
    @IBOutlet private weak var checkbox: CheckBox!
    @IBOutlet private weak var checkboxInfoLabel: EPOSLabel!
    @IBOutlet private weak var dropdownImageView: UIImageView!
    @IBOutlet weak var scrollContentView: RoundedCornerView!
    @IBOutlet weak var creamViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var companyTypeButton: UIButton!
    @IBOutlet weak var documentTypeButton: UIButton!
    
    let applicationText = "Your epos application ID: "
    private var currentWorkflowState :WorkFlowState = .leadNotCreated
    private var currentLead: Lead? {
        return EPOSUserDefaults.CurrentLead()
    }
//    private let documentTypes = MasterDataProvider().getDropdownDataFor(.eposPOI)
    internal let dropDown = MakeDropDown()
    internal var dropDownRowHeight: CGFloat = 44
    internal var dropdownData: [CodeData] = [CodeData]()
    private var activeTextField = UITextField()
    private var varifiedGST : GSTDetails?
    
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

    func showPan() {
        textFieldPAN.isHidden = false
        textFieldNameOnPAN.isHidden = false
        nextButton.isEnabled = true
    }

    func showState() {
        textFieldDocumentState.isHidden = textFieldDocumentType.text! != DocumentType.voterId.rawValue
        textFieldDocumentInfo.floatingText = "Enter \(textFieldDocumentType.text!) Number"
        textFieldDocumentInfo.placeholder = "Enter \(textFieldDocumentType.text!) Number"
    }

}

//MARK: - Private Func
private
extension PersonalInfoViewController {
    //MARK: - ConfigureUI
    func configureUIInitially() {
        navigationItem.title = "Registration"
        setRightTitle(withTitle: "1/3")
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
        checkbox.borderStyle = .square

        hideAllTextFields()
        refreshPage()
    }

    func setApplicationID() {
        if currentWorkflowState == .leadNotCreated {
            creamViewHeightConstraint.constant = 0
            //topCreamView.isHidden = true
        } else if currentLead != nil, let appID = currentLead!.applicationId {
            //topCreamView.isHidden = false
            creamViewHeightConstraint.constant = 29
            applicationLabel.text = applicationText + appID
            scrollContentView.cornerRound = 0
        }
    }
    //MARK: - RefreshPage
    func refreshPage() {
        if let lead = currentLead, lead.workFlowState == WorkFlowState.leadInitialized.rawValue {
            MasterDataProvider().getDropdownDataFor(.eposPOI) { (data) in
                weak var weakSelf = self
                weakSelf?.dropdownData = data
            }
            populateData(from: lead)
            currentWorkflowState = .leadInitialized
            textFieldGSTIN.isHidden = false
            checkbox.isHidden = false
            checkboxInfoLabel.isHidden = false
            companyTypeButton.isEnabled = false
            showPan()
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

    func populateData(from lead: Lead) {
        if let type = lead.leadProfile.firmType {
            textFieldCompanyType.text = type
        }
        if let pan = lead.leadProfile.pan {
            textFieldPAN.text = pan
        }
        if let panName = lead.leadProfile.name {
            textFieldNameOnPAN.text = panName
        }
        if let kyc = lead.leadProfile.kyc?.idType {
            textFieldDocumentType.text = kyc
        }
    }
    
    func hideAllTextFields() {
        textFieldPAN.isHidden = true
        textFieldNameOnPAN.isHidden = true
        textFieldGSTIN.isHidden = true
        textFieldDocumentType.isHidden = true
        textFieldDocumentInfo.isHidden = true
        textFieldDocumentState.isHidden = true
        checkbox.isHidden = true
        checkboxInfoLabel.isHidden = true
        dropdownImageView.isHidden = true
    }
    
    func hideDocumentFields(_ value: Bool) {
        textFieldDocumentType.isHidden = value
        textFieldDocumentInfo.isHidden = value
        textFieldDocumentState.isHidden = true
    }
    
    private func updatedOptionBasedOnSelectedProofType(proofType:String) {
          switch (proofType) {
          case DocumentType.voterId.rawValue:
                  let firmType = textFieldCompanyType.text!.uppercased()
                  if EntityType.proprietor.rawValue.elementsEqual(firmType) {
                    textFieldDocumentState.isHidden = false
                  }
            
          case DocumentType.udhyogAadhar.rawValue:
              break;
            
          case DocumentType.shopNEstablishment.rawValue:
                textFieldDocumentState.isHidden = false
//
//              case KYCType.DRIVING_LICENSE: {
//                  String firmType = spnCompanyType.getTag().toString();
//                  if (!EntityType.PROPRIETOR.equalsIgnoreCase(firmType)) {
//                      showShortToast(getString(R.string.err_dl_valid_for_proprietor));
//                      spnOtherDocument.setSelection(-1);
//                  } else {
//                      tipDob.setVisibility(View.VISIBLE);
//                  }
//              }
//              break;
//              case KYCType.UTILITY_BILL_ELEC: {
//                  String firmType = spnCompanyType.getTag().toString();
//                  if (!EntityType.PROPRIETOR.equalsIgnoreCase(firmType)) {
//                      showShortToast(getString(R.string.err_utility_bill_valid_for_proprietor));
//                      spnOtherDocument.setSelection(-1);
//                  } else {
//                      spnUtilityProvider.setDropDownItems(getStorageManager().getMasterDataDescByType(MASTER_ELECTRICITY_BOARD));
//                      spnUtilityProvider.setVisibility(View.VISIBLE);
//                  }
//              }
//              break;
//              case KYCType.UTILITY_BILL_LPG: {
//                  String firmType = spnCompanyType.getTag().toString();
//                  if (!EntityType.PROPRIETOR.equalsIgnoreCase(firmType)) {
//                      showShortToast(getString(R.string.err_utility_bill_valid_for_proprietor));
//                      spnOtherDocument.setSelection(-1);
//                  } else {
//                      spnLpgIdMobile.setDropDownItems(Arrays.asList(MVSProof.LPG_OPTIONS));
//                      spnLpgIdMobile.setVisibility(View.VISIBLE);
//                  }
//              }
//              break;
//              case KYCType.FSSAI: {
//                  String firmType = spnCompanyType.getTag().toString();
//                  if (!EntityType.PROPRIETOR.equalsIgnoreCase(firmType)) {
//                      showShortToast(getString(R.string.err_fssai_valid_for_proprietor));
//                      spnOtherDocument.setSelection(-1);
//                  }
//              }
//              break;
//              case KYCType.UAN: {
//                  String firmType = spnCompanyType.getTag().toString();
//                  if (!EntityType.PROPRIETOR.equalsIgnoreCase(firmType)) {
//                      showShortToast(getString(R.string.err_uan_valid_for_proprietor));
//                      spnOtherDocument.setSelection(-1);
//                  }
//              }
//              break;
          default:
            return;
        }
      }

    
    
    private func callMerchantVerificationService()
    {
        
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - Create lead API
    func createLead() {
        
        let response = Validation.shared.validate(values: (ValidationMode.pan, textFieldPAN.text as Any)
        ,(ValidationMode.alphabeticString,textFieldNameOnPAN.text  as Any))
        switch response {
        case .success:
            showLoading()
            let leadParams = CreateLeadParams(name: textFieldNameOnPAN.text!.lowercased(), pan: textFieldPAN.text!.lowercased(), firmType:textFieldCompanyType.text!.uppercased() , kyc: nil, typeOfLead: "EPOS")
            OnBoardingRequest.createLeadWith(params: leadParams) { [weak self] response in
                self?.hideLoading()
                switch response {
                case .success(_):
                    self?.refreshPage()
                case .failure(BaseError.errorMessage(let error)):
                    self?.showAlert(title:Constants.apiError.rawValue, message:error as? String)
                }
            }
        case .failure(_, let message):
            showAlert(title: Constants.apiError.rawValue, message: message.rawValue)
        }
    }
    
    //MARK: - get GSTIN details
    func varifyGSTIN() {
        let response = Validation.shared.validate(values: (ValidationMode.alphabeticString, textFieldGSTIN.text as Any))
        switch response {
        case .success:
//            if textFieldGSTIN.text!.contains(textFieldPAN.text!) {
                showLoading()
                OnBoardingRequest.getGSTDetails(gstNumber: textFieldGSTIN.text!) { [weak self] response in
                    self?.hideLoading()
                    switch response {
                    case .success(let response):
                        if let gstDetail = response as? GSTDetails {
                            self?.varifiedGST = gstDetail
                        }
                    case .failure(BaseError.errorMessage(let error)):
                        self?.showAlert(title:Constants.apiError.rawValue, message:error as? String)
                    }
                }
//            } else {
//                showAlert(title: "ERROR", message: "GSTIN must contain PAN number")
//            }
        case .failure(_, let message):
            showAlert(title: "ERROR", message: message.rawValue)
        }
    }
    func validateDocument() {
        showLoading()
        OnBoardingRequest.varifyDocumentWith(proofName: textFieldGSTIN.text!, proofNumber: textFieldDocumentInfo.text!, kycType: nil, additionalInfo: ["state" : textFieldDocumentState.text!]) { [weak self] response in
            self?.hideLoading()
            switch response {
            case .success(_):
                if let gstDetail = response as? GSTDetails {
                    self?.varifiedGST = gstDetail
                }
            case .failure(BaseError.errorMessage(let error)):
                self?.showAlert(title:Constants.apiError.rawValue, message:error as? String)
            }
        }
    }
}




//MARK: - textfield delegate
extension PersonalInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if currentWorkflowState == .leadInitialized {
            if textField == textFieldCompanyType || textField == textFieldPAN || textField == textFieldNameOnPAN {
                return false
            }
        }
        activeTextField = textField
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == textFieldCompanyType || textField == textFieldDocumentType {
//            return false
//        }
        if textField == textFieldPAN, textField.text!.count > 10 {
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textFieldNameOnPAN {
            let result = Validation.shared.validate(values: (ValidationMode.alphabeticString, textFieldNameOnPAN.text as Any))
            if case Valid.failure(_, let message) = result {
                textFieldNameOnPAN.trailingAssistiveLabel.text = message.rawValue
            } else {
                textFieldNameOnPAN.trailingAssistiveLabel.text = ""
            }
        }
        
        if textField == textFieldPAN {
            let resultDoc = Validation.shared.validate(values: (ValidationMode.pan, textFieldPAN.text as Any))
            if case Valid.failure(_, let message) = resultDoc {
                textFieldPAN.trailingAssistiveLabel.text = message.rawValue
                
            } else {
                textFieldPAN.trailingAssistiveLabel.text = ""
                
            }
        }
        
        if textField == textFieldDocumentInfo {
            let resultDoc = Validation.shared.validate(values: (ValidationMode.alphabeticString, textFieldDocumentInfo.text as Any))
            if case Valid.failure(_, _) = resultDoc {
                textFieldDocumentInfo.trailingAssistiveLabel.text = "Please provide valid ID"
                
            } else {
                textFieldDocumentInfo.trailingAssistiveLabel.text = ""
                
            }
        }
        
        if textField == textFieldGSTIN {
            let resultDoc = Validation.shared.validate(values: (ValidationMode.alphabeticString, textFieldGSTIN.text as Any))
            if case Valid.failure(_, _) = resultDoc {
                textFieldGSTIN.trailingAssistiveLabel.text = "GSTIN must contain PAN number"
//                nextButton.isEnabled = false
            } else {
                if !(textFieldGSTIN.text!.contains(textFieldPAN.text!)) {
                    textFieldGSTIN.trailingAssistiveLabel.text = "GSTIN must contain PAN number"
//                    nextButton.isEnabled = false
                } else {
                    textFieldGSTIN.trailingAssistiveLabel.text = ""
//                    nextButton.isEnabled = true
                }
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
            showDropdown(.businessType)
        } else if sender.tag == 2 {
            if textFieldDocumentType.isHidden == true {
                return
            }
            if textFieldDocumentType.isFirstResponder == false {
                textFieldDocumentType.becomeFirstResponder()
            }
            showDropdown(.eposPOI)
        }
    }

    private func showDropdown(_ type: MasterDataType) {
        let dropdownController = DropdownOptionsViewController.viewController(with: dropdownData, delegate: self, masterDataType: type)
        dropdownController.showOptionsFrom(self)
    }
    
    @IBAction func checkboxClicked(_ sender: CheckBox) {
        if sender.isChecked {
            sender.backgroundColor = .darkThemeColor()
            textFieldGSTIN.isEnabled = false
            hideDocumentFields(false)
        } else {
            sender.backgroundColor = .white
            textFieldGSTIN.isEnabled = true
            hideDocumentFields(true)
        }
    }

    @IBAction func nextClicked(_ sender: Any) {
        activeTextField.resignFirstResponder()
        if currentWorkflowState == .leadNotCreated {
            createLead()
        } else if currentLead != nil {
            if !checkbox.isChecked {
                varifyGSTIN()
            } else {
                if currentLead!.applicationId != nil {
                    let controller = MerchantDetailsViewController.viewController(appID: currentLead!.applicationId!)
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
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

extension PersonalInfoViewController : DropDownOptionsSelectedDelegate {
    func didSelectOption(_ controller: DropdownOptionsViewController, option: CodeData, type: MasterDataType) {
        if type == .businessType {
            textFieldCompanyType.text = option.defaultDescription
            showPan()
        } else {
            textFieldDocumentType.text = option.defaultDescription
            showState()
        }
        controller.dismissSheet()
    }
    
    
}
