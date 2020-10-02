//
//  MerchantVerificationAddressData.swift
//  ePOS
//
//  Created by Abhishek on 01/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct MerchantverificationAddress:Codable {
    var completeAddress:String?;
    var type:String?;
    enum CodingKeys: String, CodingKey {
        case completeAddress = "completeAddress"
        case type = "type"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        completeAddress = try values.decodeIfPresent(String.self, forKey: .completeAddress)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
}
