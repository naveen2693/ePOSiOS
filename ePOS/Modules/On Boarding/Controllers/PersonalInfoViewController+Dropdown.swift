//
//  PersonalInfoViewController+Dropdown.swift
//  ePOS
//
//  Created by Matra Sharma on 16/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit

//extension PersonalInfoViewController {
//    func setUpDropDownFor(_ type: MasterDataType){
//        dropDown.makeDropDownIdentifier = type.rawValue
//        dropDown.cellReusableIdentifier = "DropdownTableViewCell"
//        dropDown.makeDropDownDataSourceProtocol = self
//        if type == .businessType {
//            dropDown.setUpDropDown(viewPositionReference: (textFieldCompanyType.frame), offset: 86)
//        } else if type == .eposPOI {
//            dropDown.setUpDropDown(viewPositionReference: (textFieldDocumentType.frame), offset: -60)
//            dropDown.isDropdownUpsideDown = true
//            dropDown.flipDropdownUpsideDown()
//        }
//        dropDown.nib = UINib(nibName: DropdownTableViewCell.className, bundle: nil)
//        dropDown.setRowHeight(height: dropDownRowHeight)
//        view.insertSubview(dropDown, belowSubview: textFieldCompanyType)
//    }
//    
//}
//
//extension PersonalInfoViewController: MakeDropDownDataSourceProtocol {
//    func getDataToDropDown(cell: UITableViewCell, indexPos: Int, makeDropDownIdentifier: String) {
//        if let customCell = cell as? DropdownTableViewCell {
//            customCell.titleLabel?.text = dropdownData[indexPos].defaultDescription
//        }
//    }
//    
//    func numberOfRows(makeDropDownIdentifier: String) -> Int {
//        return dropdownData.count
//    }
//    
//    func selectItemInDropDown(indexPos: Int, makeDropDownIdentifier: String) {
//        let masterDataType = MasterDataType(rawValue: makeDropDownIdentifier)
//        if masterDataType == .businessType {
//            textFieldCompanyType.text = dropdownData[indexPos].defaultDescription
//            showPan()
//        } else if masterDataType == .eposPOI {
//            textFieldDocumentType.text = dropdownData[indexPos].defaultDescription
//            showState()
//        }
//        dropDown.hideDropDown()
//    }
//}
