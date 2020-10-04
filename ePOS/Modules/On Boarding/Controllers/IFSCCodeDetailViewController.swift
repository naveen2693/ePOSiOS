//
//  IFSCCodeDetailViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 20/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

protocol IFSCSelectedDelegate: class {
    func didSelectedIFSC(_ controller: IFSCCodeDetailViewController, code: IFSCDetail)
}

class IFSCCodeDetailViewController: CustomNavigationStyleViewController {
    @IBOutlet weak var nextButton: EPOSRoundButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    private var ifscDetail : IFSCDetail!
    private weak var ifscDelegate: IFSCSelectedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search IFSC Code"
        registerCell()
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 54.0 ;
        tableView.rowHeight = UITableView.automaticDimension;
        // Do any additional setup after loading the view.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableViewHeightConstraint.constant = self.tableView.contentSize.height
    }
    
    class func viewController(details : IFSCDetail, delegate: IFSCSelectedDelegate?) -> IFSCCodeDetailViewController {
        let controller = IFSCCodeDetailViewController.init(nibName: IFSCCodeDetailViewController.className, bundle: nil)
        controller.ifscDetail = details
        controller.ifscDelegate = delegate
        return controller
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: IFSCDetailTableViewCell.className, bundle: nil), forCellReuseIdentifier: IFSCDetailTableViewCell.className)
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        ifscDelegate?.didSelectedIFSC(self, code: ifscDetail)
        navigationController?.popToViewController(ofClass: StatusDemoViewController.self)
    }
    
    @IBAction func moreIFSCClicked(_ sender: Any) {
        if let navController = navigationController, navController.viewControllers.count >= 2 {
             let viewController = navController.viewControllers[navController.viewControllers.count - 2] as? SearchIFSCViewController
            viewController?.resetAll()
        }
        navigationController?.popViewController(animated: true)
    }
}

//MARK: TableViewDelegate DataSource
extension IFSCCodeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IFSCDetailTableViewCell.className, for: indexPath) as? IFSCDetailTableViewCell else {
            fatalError("IFSCDetailTableViewCell not found for identifier IFSCDetailTableViewCell")
        }
        cell.selectionStyle = .none
        let title: String
        let value: String
        switch indexPath.row {
        case 0:
            title = "IFSC Code"
            value = ifscDetail.ifscCode
        case 1:
            title = "Bank"
            value = ifscDetail.bankName
        case 2:
            title = "Address"
            value = ifscDetail.address
        case 3:
            title = "District"
            value = ifscDetail.district
        case 4:
            title = "State"
            value = ifscDetail.state
        case 5:
            title = "Branch"
            value = ifscDetail.branch
        default:
            title = ""
            value = ""
        }
        
        cell.labelTitle.text = title
        cell.labelValue.text = value
        return cell
    }
    
}
