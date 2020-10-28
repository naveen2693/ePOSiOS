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
    
    let applicationText = "Your epos application ID: "
    var ObjstateData = CityDataProvider();
    internal let dropDown = MakeDropDown()
    internal var dropDownRowHeight: CGFloat = 44
    internal var dropdownData: [CodeData] = [CodeData]()
    internal var mccCodeData: [CodeData] = [CodeData]()
    internal var businessTimestamp: String = ""
    
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIInitially()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
    }
    
    private func populateData()
    {
         if let currentLead = EPOSUserDefaults.CurrentLead() {
            if let appId = currentLead.applicationId {
                labelApplicationID?.text = applicationText + appId
            }
            
            if let businessDetails = currentLead.businessDetail {
                textFieldBusinessName.text = businessDetails.registeredName
                if let addresses = businessDetails.address, !addresses.isEmpty {
                    let address = addresses.filter({
                        $0.addressType == AddressType.store.rawValue
                        }).first
                    textFieldAddress.text = address?.address
                    textFieldCity.text = address?.city
                    textFieldState.text = address?.state
                    textFieldPinecode.text = address?.pincode
                }
                
//                if let turnover = businessDetails.annualTurnover {
//                    textFieldTurnover.text = turnover
//                }
//                if let mccCode = businessDetails.mccCode {
//                    textFieldMerchantCategory
//                }
            }
        }
    }
    
    class func viewController() -> MerchantDetailsViewController {
        let controller = MerchantDetailsViewController.init(nibName: MerchantDetailsViewController.className, bundle: nil)
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
                showLoading()
                let addressdetails:[AddressDetails] = [AddressDetails(ownershipType:OwnerShipType.owner.rawValue, city: textFieldCity.text, pincode:textFieldPinecode.text, address:textFieldAddress.text , addressType: AddressType.store.rawValue, entityName:textFieldBusinessName.text, landMark:textFieldCity.text, state:textFieldState.text)]
                let lead = EPOSUserDefaults.CurrentLead()
                if let companyType:String = lead?.leadProfile.firmType{
                    var businessDetails = lead?.businessDetail
                    businessDetails?.address = addressdetails
                    businessDetails?.annualTurnover = "\(textFieldTurnover.tag)"
                    businessDetails?.mccCode = "\(textFieldMerchantCategory.tag)"
                    businessDetails?.operateAs = companyType
                    businessDetails?.incorporationDate = businessTimestamp
                    businessDetails?.name = textFieldBusinessName.text
                    businessDetails?.registeredName = textFieldBusinessName.text
                    businessDetails?.tradeName = textFieldBusinessName.text
                var lead = EPOSUserDefaults.CurrentLead()
                    if var leadProfile = lead?.leadProfile, let pan = leadProfile.pan {
                        leadProfile.pan = pan.uppercased()
                        lead?.leadProfile = leadProfile
                    }
                lead?.businessDetail = businessDetails
                lead?.workFlowState = WorkFlowState.saveBUDetails.rawValue
                OnBoardingRequest.updateLead(leadData:lead,documents:nil, completion:{ [weak self] result in
                    self?.hideLoading()
                       switch result {
                       case .success(_):
                           let controller = BankDetailsViewController.viewController()
                           self?.navigationController?.pushViewController(controller, animated: true)
                       case .failure(let error):
                           self?.showAlert(title:Constants.apiError.rawValue, message:error as? String)
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
        prepareForSearchMerchantCategory()
    }
    
    func showDatePicker() {
        
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        let calendar = Calendar.current
        let backDate = calendar.date(byAdding: .year, value: -100, to: Date())
        datePicker.minimumDate = backDate
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
        textFieldBusinessSince.inputView = datePicker
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        textFieldBusinessSince.inputAccessoryView = toolBar
        
    }
    
    @objc func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textFieldBusinessSince.text = formatter.string(from: datePicker.date)
        businessTimestamp = "\(Int64((datePicker.date.timeIntervalSince1970 * 1000.0).rounded()))"
        
    }
    
    @objc func datePickerDone() {
        textFieldBusinessSince.resignFirstResponder()
    }
    
    private func prepareForSearchStates() {
        let stateArray = ObjstateData.fetchStateDataList()
        let states = stateArray.map { $0.state }
        showSearchControllerWith(states, for: .searchStateData(.state))
    }
    
    private func prepareForSearchCities() {
        if let text = textFieldState.text, !text.isEmpty {
            ObjstateData.searchStateData(with: text, completion: {[weak self] result in
                if let cities = result.first?.cities.map({ $0.name}) {
                  self?.showSearchControllerWith(cities, for: .searchStateData(.city))
                }
            })
        }
    }
    
    private func prepareForSearchMerchantCategory() {
        let categories = mccCodeData.map { $0.defaultDescription }
        showSearchControllerWith(categories, for: .mccCode)
    }
    
    private func showSearchControllerWith(_ data: [String], for type: SearchType) {
        let controller = CustomSearchViewController.viewController(type: type, data: data, delegate:self)
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
        case .mccCode:
            textFieldMerchantCategory.text =  item
            let categories = mccCodeData.filter({$0.defaultDescription == item})
            if !categories.isEmpty, let codeKey = categories.first?.codeKey {
                textFieldMerchantCategory.tag = Int(codeKey) ?? 0
            }
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
            weakSelf?.mccCodeData = data
        }
        
        populateData()
        showDatePicker()
    }
    
    
}


extension MerchantDetailsViewController : DropDownOptionsSelectedDelegate {
    func didSelectOption(_ controller: DropdownOptionsViewController, option: CodeData, type: MasterDataType) {
        if type == .eposTurnover {
            textFieldTurnover.text = option.defaultDescription
            textFieldTurnover.tag = Int(option.codeKey) ?? 0
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

