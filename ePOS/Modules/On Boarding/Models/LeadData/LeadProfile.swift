//
//  LeadProfile.swift
//  ePOS
//
//  Created by Matra Sharma on 28/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
// MARK:-Lead State Keys
public struct LeadProfileDetails:Codable{
    var id:String?
    var isBusinessPan:String?
    var name:String?
    var pan:String?
    var firmType:String?
    var optlock:Int?
    var kyc :[KYCDetails]?
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case isBusinessPan = "isBusinessPan"
        case pan = "pan"
        case name = "name"
        case firmType = "firmType"
        case optlock = "optlock"
    }
}
