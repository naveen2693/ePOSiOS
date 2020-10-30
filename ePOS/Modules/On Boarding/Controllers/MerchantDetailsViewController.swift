//
//  MerchantDetailsViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 20/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class MerchantDetailsViewController: CustomNavigationStyleViewController {
    
    
    @IBOutlet private weak var textFieldBusinessName: EPOSTextField!
    @IBOutlet private weak var textFieldAddress: EPOSTextField!
    @IBOutlet private weak var textFieldCity: EPOSTextField!
    @IBOutlet private weak var textFieldState: EPOSTextField!
    @IBOutlet private weak var textFieldPinecode: EPOSTextField!
    @IBOutlet private weak var textFieldTurnover: EPOSTextField!
    @IBOutlet private weak var textFieldMerchantCategory: EPOSTextField!
    @IBOutlet private weak var textFieldBusinessSince: EPOSTextField!
    @IBOutlet private weak var nextButton: EPOSRoundButton!
    @IBOutlet weak var labelApplicationID: EPOSLabel?
    
    private var eposApplicationID: String = ""
    var ObjstateData = CityDataProvider();
    internal let dropDown = MakeDropDown()
    internal var dropDownRowHeight: CGFloat = 44
    internal var dropdownData: [CodeData] = [CodeData]()
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         populateData()
        configureUIInitially()
        // Do any additional setup after loading the view.
    }
    
    
    private func populateData()
    {
         labelApplicationID?.text = eposApplicationID
        if EPOSUserDefaults.CurrentLead() != nil {
//             if currentLead.workFlowState != nil {
//                 let workflowState = WorkFlowState(rawValue: currentLead.workFlowState!)
//                let businessDetails:BusinessDetails = WorkFlowState.saveBUDetails
//                textFieldBusinessName.text = businessDetails.registeredName
                
        }
    }
    
    class func viewController(appID : String) -> MerchantDetailsViewController {
        let controller = MerchantDetailsViewController.init(nibName: MerchantDetailsViewController.className, bundle: nil)
        controller.eposApplicationID = appID
        return controller
    }
    
    @IBAction func needHelpClicked(_ sender: Any) {
    }
    @IBAction func nextButtonClicked(_ sender: Any) {
       
        
        let response = Validation.shared.validate(values: (ValidationMode.businessNameValidation, textFieldBusinessName.text as Any)
                   ,(ValidationMode.contactNameValidation,textFieldAddress.text  as Any)
                   ,(ValidationMode.city,textFieldCity.text  as Any)
                   ,(ValidationMode.state,textFieldState.text  as Any)
                   ,(ValidationMode.annualTurnover,textFieldTurnover.text  as Any)
                   ,(ValidationMode.merchantCategory,textFieldMerchantCategory.text  as Any)
                   ,(ValidationMode.businessStartDate,textFieldBusinessSince.text  as Any)
                   ,(ValidationMode.pincode,textFieldPinecode.text  as Any))
               
               switch response {
               case .success:
                
                let addressdetails:[AddressDetails] = [AddressDetails(ownershipType:OwnerShipType.owner.rawValue, pincode:textFieldPinecode.text, address:textFieldAddress.text , addressType: AddressType.store.rawValue, entityName:textFieldBusinessName.text, landMark:textFieldCity.text, state:textFieldState.text)]
                let lead = EPOSUserDefaults.CurrentLead()
                if let companyType:String = lead?.leadProfile.firmType{
                    let objBusinessDetails:[BusinessDetails] = [BusinessDetails(address:addressdetails,operateAs:companyType, registeredName: textFieldBusinessName.text, tradeName: textFieldAddress.text,name:textFieldBusinessName.text)]
                var lead = EPOSUserDefaults.CurrentLead()
                lead?.businessDetail = objBusinessDetails
                OnBoardingRequest.updateLead(leadData:lead,documents:nil, completion:{ result in
                       switch result {
                       case .success(_):
                           let controller = BankDetailsViewController.viewController(appID: "34h35h43h54h5")
                           self.navigationController?.pushViewController(controller, animated: true)
                       case .failure(let error):
                           print(error)
                       }
                       
                   })
                }
               case .failure(_, let message):
                   self.showAlert(title:Constants.validationFailure.rawValue, message:message.rawValue)
               }
           }
    
    @IBAction func stateClicked(_ sender: Any) {
        
        prepareForSearchStates()
    }
    
    @IBAction func cityClicked(_ sender: Any) {
        prepareForSearchCities()
        
    }
    
    @IBAction func turnoverClicked(_ sender: Any) {
        if textFieldTurnover.isFirstResponder == false {
            textFieldTurnover.becomeFirstResponder()
        }
        showDropdown(.eposTurnover)
        
    }
    @IBAction func merchantCategoryClicked(_ sender: Any) {
        if textFieldMerchantCategory.isFirstResponder == false {
            textFieldMerchantCategory.becomeFirstResponder()
        }
        showDropdown(.mccCode)
    }
    func showDatePicker(){
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.bordered, target: self, action: Selector(("donedatePicker")))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: Selector(("cancelDatePicker")))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        textFieldBusinessSince.inputAccessoryView = toolbar
        textFieldBusinessSince.inputView = datePicker
        
    }
    
    func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textFieldBusinessSince.text = formatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
    
    func cancelDatePicker(){
        
        self.view.endEditing(true)
    }
    
    private func prepareForSearchStates()
    {
        let stateArray = ObjstateData.fetchStateDataList()
        let states = stateArray.map { $0.state }
        showSearchControllerWith(states, for: .state)
    }
    private func prepareForSearchCities()
    {
        if let text = textFieldState.text, !text.isEmpty {
            ObjstateData.searchStateData(with: text, completion: {[weak self] result in
                let cities = result.map { $0.cities}
                for value in cities
                {
                    let cityName = value.map { $0.name}
                    self?.showSearchControllerWith(cityName, for: .city)
                }
            })
        }
    }
    
    private func showSearchControllerWith(_ data: [String], for type: SearchStateData) {
        let controller = CustomSearchViewController.viewController(type: .searchStateData(type), data: data, delegate:self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    private func showDropdown(_ type: MasterDataType) {
        let dropdownController = DropdownOptionsViewController.viewController(with: dropdownData, delegate: self, masterDataType: type)
        dropdownController.showOptionsFrom(self)
        
        
    }
}
extension MerchantDetailsViewController: SearchControllerDelegate {
    func didSelectedItem(_ controller: CustomSearchViewController, item: String, at index: Int, for type: SearchType) {
        switch type {
        case .searchStateData(.state):
            textFieldState.text = item
        case .searchStateData(.city):
            textFieldCity.text =  item
        default:
            break
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
}




private
extension MerchantDetailsViewController {
    //MARK: - ConfigureUI
    func configureUIInitially() {
        navigationItem.title = "Merchant Details"
        textFieldTurnover.inputView = UIView()
        textFieldTurnover.inputAccessoryView = UIView()
        textFieldMerchantCategory.inputView = UIView()
        textFieldMerchantCategory.inputAccessoryView = UIView()
        
        MasterDataProvider().getDropdownDataFor(.eposTurnover) { (data) in
            weak var weakSelf = self
            weakSelf?.dropdownData = data
        }
        MasterDataProvider().getDropdownDataFor(.mccCode) { (data) in
            weak var weakSelf = self
            weakSelf?.dropdownData = data
        }
    }
    
    
}


extension MerchantDetailsViewController : DropDownOptionsSelectedDelegate {
    func didSelectOption(_ controller: DropdownOptionsViewController, option: CodeData, type: MasterDataType) {
        if type == .eposTurnover {
            textFieldTurnover.text = option.defaultDescription
        }
        if type == .mccCode {
            textFieldTurnover.text = option.defaultDescription
        }
        controller.dismissSheet()
    }
}

extension MerchantDetailsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == textFieldBusinessName) {
            let response = Validation.shared.validate(values: (type: ValidationMode.businessNameValidation, inputValue:textFieldBusinessName.text as Any))
            switch response {
            case .success:
                textFieldBusinessName.trailingAssistiveLabel.text = ""
            case .failure(_, let message):
                textFieldBusinessName.trailingAssistiveLabel.text = message.rawValue
            }
        }
        else if (textField == textFieldAddress) {
            let response = Validation.shared.validate(values: (type: ValidationMode.businessAddress, inputValue:textFieldAddress.text as Any))
            switch response {
            case .success:
                textFieldAddress.trailingAssistiveLabel.text = ""
            case .failure(_, let message):
                textFieldAddress.trailingAssistiveLabel.text = message.rawValue
            }
        }
      
}
}

