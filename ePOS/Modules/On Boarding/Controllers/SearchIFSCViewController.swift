//
//  SearchIFSCViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 20/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

class SearchIFSCViewController: CustomNavigationStyleViewController {
    
    @IBOutlet private weak var textFieldBank: EPOSTextField!
    @IBOutlet private weak var textFieldState: EPOSTextField!
    @IBOutlet private weak var textFieldDistrict: EPOSTextField!
    @IBOutlet private weak var textFieldBranch: EPOSTextField!
    @IBOutlet private weak var nextButton: EPOSRoundButton!
    @IBOutlet private weak var buttonBank: UIButton!
    @IBOutlet private weak var buttonState: UIButton!
    @IBOutlet private weak var buttonDistrict: UIButton!
    @IBOutlet private weak var buttonBranch: UIButton!
    
    private weak var ifscDelegate: IFSCSelectedDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search IFSC Code"
        
        // Do any additional setup after loading the view.
    }

    class func viewController(delegate: IFSCSelectedDelegate?) -> SearchIFSCViewController {
        let controller = SearchIFSCViewController.init(nibName: SearchIFSCViewController.className, bundle: nil)
        controller.ifscDelegate = delegate
        return controller
    }
    
    @IBAction func getDetailButtonClicked(_ sender: UIButton) {
        switch sender {
        case buttonBank:
            prepareForSearchIFSC(.bankName)
        case buttonState:
            prepareForSearchIFSC(.state)
        case buttonDistrict:
            prepareForSearchIFSC(.district)
        case buttonBranch:
            prepareForSearchIFSC(.branch)
        default:
            break
        }
    }
    
    func resetAll()  {
        textFieldBranch.text = ""
        textFieldBank.text = ""
        textFieldDistrict.text = ""
        textFieldState.text = ""
        nextButton.isEnabled = false
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        prepareForSearchIFSC(.ifscCode)
    }

    
    private func prepareForSearchIFSC(_ type: SearchIFSCType) {
        var searchdata: SearchIFSCRequest!
        
        switch type {
        case .bankName:
            searchdata = SearchIFSCRequest()
            hitSearchIFSCodeWith(searchdata, for: type)
        case .state:
            if let text = textFieldBank.text, !text.isEmpty {
                searchdata = SearchIFSCRequest(bankName: text, state: nil, district: nil, branch: nil)
                hitSearchIFSCodeWith(searchdata, for: type)
            } else {
                showAlert(title: Constants.apiError.rawValue, message: "Select bank")
            }
        case .district:
            if let text = textFieldState.text, !text.isEmpty {
                searchdata = SearchIFSCRequest(bankName: textFieldBank.text!, state: text, district: nil, branch: nil)
                hitSearchIFSCodeWith(searchdata, for: type)
            } else {
                showAlert(title: Constants.apiError.rawValue, message: "Select state")
            }
        case .branch:
            if let text = textFieldDistrict.text, !text.isEmpty {
                searchdata = SearchIFSCRequest(bankName: textFieldBank.text!, state: textFieldState.text, district: text, branch: nil)
                hitSearchIFSCodeWith(searchdata, for: type)
            } else {
                showAlert(title: Constants.apiError.rawValue, message: "Select district")
            }
        case .ifscCode:
            let response = Validation.shared.validate(values:(ValidationMode.alphabeticString,textFieldBank.text  as Any)
            ,(ValidationMode.alphabeticString,textFieldState.text  as Any),
             (ValidationMode.alphabeticString,textFieldBranch.text  as Any),
            (ValidationMode.alphabeticString,textFieldDistrict.text  as Any))
            
            switch response {
                case .success:
                    searchdata = SearchIFSCRequest(bankName: textFieldBank.text!, state: textFieldState.text!, district: textFieldDistrict.text!, branch: textFieldBranch.text!)
                hitSearchIFSCodeWith(searchdata, for: type)
                case .failure(_, let message):
                    showAlert(title: Constants.apiError.rawValue, message: message.rawValue)
                }
        }
            
    }
        
    private func hitSearchIFSCodeWith(_ data: SearchIFSCRequest, for type: SearchIFSCType) {
        showLoading()
        OnBoardingRequest.searchIFSCCodeWith(data, for: type) { [weak self] response in
            self?.hideLoading()
            switch response {
            case .success(let response):
                self?.loadSearchIFSCResponse(response, for: type)
            case .failure(BaseError.errorMessage(let error)):
                self?.showAlert(title:Constants.apiError.rawValue, message:error as? String)
            }
        }
    }
    
    private func loadSearchIFSCResponse(_ response: AnyObject, for type: SearchIFSCType) {
        switch type {
        case .bankName:
            if let data = response as? Banks {
                showSearchControllerWith(data.bankNames, for: .bankName)
            }
        case .state:
            if let data = response as? States {
                showSearchControllerWith(data.stateNames, for: .state)
            }
        case .district:
            if let data = response as? Districts {
                showSearchControllerWith(data.districtNames, for: .district)
            }
        case .branch:
            if let data = response as? Branch {
                if data.branchNames.count > 1 {
                    showSearchControllerWith(data.branchNames, for: .branch)
                } else if !data.branchNames.isEmpty {
                    textFieldBranch.text = data.branchNames.first
                }
            }
        case .ifscCode:
            if let data = response as? IFSCDetail {
                let viewController = IFSCCodeDetailViewController.viewController(details: data, delegate: ifscDelegate)
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    private func showSearchControllerWith(_ data: [String], for type: SearchIFSCType) {
        let controller = CustomSearchViewController.viewController(type: .ifscSearch(type), data: data, delegate: self)

        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchIFSCViewController: SearchControllerDelegate {

    func didSelectedItem(_ controller: CustomSearchViewController, item: String, at index: Int, for type: SearchType) {
        switch type {
        case .ifscSearch(.bankName):
            textFieldBank.text = item
        case .ifscSearch(.district):
            textFieldDistrict.text = item
        case .ifscSearch(.state):
            textFieldState.text = item
        case .ifscSearch(.branch):
            nextButton.isEnabled = true
            textFieldBranch.text = item
        default:
            break
        }
        self.navigationController?.popViewController(animated: true)

    }

}

