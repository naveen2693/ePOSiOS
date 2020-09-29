//
//  LeadProfile.swift
//  ePOS
//
//  Created by Matra Sharma on 28/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct LeadProfile : Codable {
    let id : Int?
    let optlock : Int?
    let pan : String?
    let name : String?
    let isBusinessPan : String?
    let firmType : String?
    let kyc : [String]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case optlock = "optlock"
        case pan = "pan"
        case name = "name"
        case isBusinessPan = "isBusinessPan"
        case firmType = "firmType"
        case kyc = "kyc"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        optlock = try values.decodeIfPresent(Int.self, forKey: .optlock)
        pan = try values.decodeIfPresent(String.self, forKey: .pan)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        isBusinessPan = try values.decodeIfPresent(String.self, forKey: .isBusinessPan)
        firmType = try values.decodeIfPresent(String.self, forKey: .firmType)
        kyc = try values.decodeIfPresent([String].self, forKey: .kyc)
    }

}
