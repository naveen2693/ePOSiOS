//
//  MasterData.swift
//  ePOS
//
//  Created by Matra Sharma on 26/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

enum MasterDataType: String {
    case businessType = "TYPE OF ENTITY"
    case eposPOI = "Epos_POI"
    case mccCode = "Mcc_code"
    case eposTurnover = "Epos_Turnover"
    case digiBanner = "Digi_banner"
    case leadStatus = "Lead_Status"
    case busRelationType = "Bus_Relation_Type"
    case individualTitle = "Individual_Title"
    case electricityBoard = "Electricity_Board"
//    case gasProvider = ""
    
}

struct CodeData: Codable {
    var codeKey: String = ""
    var defaultDescription: String = ""
    var sortOrder: Int = 0
    
    private enum CodingKeys: String, CodingKey {
        case codeKey
        case defaultDescription
        case sortOrder
    }
}

struct MasterCodeData: Codable {
    var masterCodeType: String = ""
    var masterCode: [CodeData]
    
    private enum CodingKeys: String, CodingKey {
        case masterCodeType
        case masterCode
    }
    
    func isMatching(with searchText: String) -> Bool {
        let searchString = searchText.lowercased()
        return  self.masterCodeType.lowercased().contains(searchString) 
    }
}

struct MasterDataWrapper: Codable {
    var masterData: [MasterCodeData]
    
    private enum CodingKeys: String, CodingKey {
        case masterData
    }
}
