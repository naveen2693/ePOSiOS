//
//  MerchantData.swift
//  ePOS
//
//  Created by Abhishek on 06/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//


import Foundation
public struct MerchantDetails:Codable{
    var tradeName:String?
    var address:AddressDetails?
    private enum CodingKeys: String, CodingKey {
        case tradeName = "tradeName"
        case address = "address"
    }
}
