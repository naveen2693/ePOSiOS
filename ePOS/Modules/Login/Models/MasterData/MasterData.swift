//
//  MasterData.swift
//  ePOS
//
//  Created by Matra Sharma on 26/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

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
