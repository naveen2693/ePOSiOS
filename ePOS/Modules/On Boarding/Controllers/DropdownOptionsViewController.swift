//
//  DropdownOptionsViewController.swift
//  ePOS
//
//  Created by Matra Sharma on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

protocol DropDownOptionsSelectedDelegate: class {
    func didSelectOption(_ controller: DropdownOptionsViewController, option: CodeData, type: MasterDataType)
}

class DropdownOptionsViewController: BottomSheetViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var masterDataOptions: [CodeData]!
    private var masterDataType: MasterDataType!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    static func viewController(with data: [CodeData], delegate: DropDownOptionsSelectedDelegate?, masterDataType: MasterDataType) -> DropdownOptionsViewController {
        let controller = DropdownOptionsViewController.init(nibName: DropdownOptionsViewController.className, bundle: nil)
        controller.masterDataOptions = data
        controller.optionDelegate = delegate
        controller.masterDataType = masterDataType
        return controller
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: DropdownTableViewCell.className, bundle: nil), forCellReuseIdentifier: DropdownTableViewCell.className)
    }
    
    func showOptionsFrom(_ controller: UIViewController) {
        requiredMaxHeight = 200
        if masterDataType == .eposPOI {
            requiredMaxHeight = 420
        }
        self.addOverlayTo(controller: controller)
        controller.addChild(self)
        controller.view.addSubview(self.view)
        self.didMove(toParent: controller)
        
        let height = controller.view.frame.height
        let width  = controller.view.frame.width
        self.view.frame = CGRect(x: 0, y: controller.view.frame.maxY, width: width, height: height)
    }

    @IBAction func checkboxSelected(_ sender: CheckBox) {
        optionDelegate?.didSelectOption(self, option: masterDataOptions![sender.tag - 1] , type: masterDataType)
    }
}

//MARK: TableViewDelegate DataSource
extension DropdownOptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        optionDelegate?.didSelectOption(self, option: masterDataOptions![indexPath.row] , type: masterDataType)
    }
}

extension DropdownOptionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if masterDataOptions != nil {
            return masterDataOptions.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropdownTableViewCell.className, for: indexPath) as? DropdownTableViewCell else {
            fatalError("DropdownTableViewCell not found for identifier DropdownTableViewCell")
        }
        cell.selectionStyle = .none
        cell.titleLabel?.text = masterDataOptions[indexPath.row].defaultDescription
        cell.checkbox?.tag = indexPath.row + 1
        return cell
    }
    
    
}
