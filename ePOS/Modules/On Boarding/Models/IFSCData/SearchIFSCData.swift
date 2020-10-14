//
//  SearchIFSCData.swift
//  ePOS
//
//  Created by Matra Sharma on 04/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

enum SearchIFSCType: String {
    case bankName
    case state
    case district
    case branch
    case ifscCode
}


struct IFSCDetail {
    var ifscCode: String
    var bankName: String
    var state: String
    var district: String
    var branch: String
    var city: String
    var address: String
    var phoneNumber: String

    enum CodingKeys: String, CodingKey {
        case ifscData
    }

    enum IFSCKeys: String, CodingKey {
        case ifscCode, bankName, state, district, branch, city, address, phoneNumber
    }
}

extension IFSCDetail: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let ifsc = try values.nestedContainer(keyedBy: IFSCKeys.self, forKey: .ifscData)
        self.ifscCode = try ifsc.decode(String.self, forKey: .ifscCode)
        self.bankName = try ifsc.decode(String.self, forKey: .bankName)
        self.state = try ifsc.decode(String.self, forKey: .state)
        self.district = try ifsc.decode(String.self, forKey: .district)
        self.branch = try ifsc.decode(String.self, forKey: .branch)
        self.city = try ifsc.decode(String.self, forKey: .city)
        self.address = try ifsc.decode(String.self, forKey: .address)
        self.phoneNumber = try ifsc.decode(String.self, forKey: .phoneNumber)
    }
}

struct Banks: Codable {
    var bankNames : [String]
    
    private enum CodingKeys: String, CodingKey {
        case bankNames = "bankName"
    }
}


struct States: Codable {
    var stateNames : [String]
    
    private enum CodingKeys: String, CodingKey {
        case stateNames = "state"
    }
}

struct Districts: Codable {
    var districtNames : [String]
    
    private enum CodingKeys: String, CodingKey {
        case districtNames = "district"
    }
}

struct Branch: Codable {
    var branchNames : [String]
    
    private enum CodingKeys: String, CodingKey {
        case branchNames = "branch"
    }
}
