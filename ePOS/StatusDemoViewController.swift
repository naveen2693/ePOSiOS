//
//  StatusDemoViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 10/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit




class StatusDemoViewController: CustomNavigationStyleViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "First Screen"
        setRightTitle(withTitle: "1/3")
        
//        appDelegate.getOnBoardingData()
//        OnBoardingRequest.getUserProfileAndProceedToLaunch(showProgress: true, completion:{result in
//            switch result {
//            case .success(let response):
//                if let workflowState = response as? WorkFlowState {
//                    let controller = PersonalInfoViewController.viewController(workflowState)
//                }
//            case .failure(let error):
//                if let error = error as? APIError, error == .noNetwork {
//
//                    self.showAlert(title: "ERROR", message: Constants.noNetworkMsg.rawValue)
//                }
//            }
//        });
//
//        let controller = EmptyDataViewController.viewController(NoUserItem(), delegate: self)
//        let controller = PersonalInfoViewController.init(nibName: PersonalInfoViewController.className, bundle: nil)
        //self.navigationController?.pushViewController(controller, animated: true)
        // Do any additional setup after loading the view.
//        showLoading()
//        perform(#selector(hideLoader), with: nil, afterDelay: 5.0)
    }
    
    @objc func hideLoader() {
//        stopLoading()
    }

    @IBAction func firstClicked(_ sender: Any) {
        let controller = SearchIFSCViewController.viewController(delegate: self)
        self.navigationController?.pushViewController(controller, animated: true)
//        let allData = [
//            "Andhra Pradesh",
//            "Assam",
//            "Bihar",
//            "Jharkhand",
//            "Kerala",
//            "Nagaland",
//            "Uttarakhand"
//        ]
//
//            let controller = CustomSearchViewController.viewController(type: .state, data: allData, delegate: self)
//            self.navigationController?.pushViewController(controller, animated: true)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StatusDemoViewController: EmptyDataControllerDelegate {
    func actionButtonClicked(_ controller: EmptyDataViewController, for itemType: EmptyViewItemProtocol) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

//extension StatusDemoViewController: SearchControllerDelegate {
//    func didSelectedItem(_ controller: CustomSearchViewController, item: String, at index: Int, for type: SearchType) {
//        self.navigationController?.popViewController(animated: true)
//    }
//}

extension StatusDemoViewController: IFSCSelectedDelegate {
    func didSelectedIFSC(_ controller: IFSCCodeDetailViewController, code: IFSCDetail) {
        
    }
}
