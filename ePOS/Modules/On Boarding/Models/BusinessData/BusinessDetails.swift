//
//  BusinessDetails.swift
//  ePOS
//
//  Created by Abhishek on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
// MARK:- BusinessDetails
public struct BusinessDetails:Codable{
    var address : [AddressDetails]?
    var websiteAddress:String?
    var externalId:String?
    var operateAs:String?
    var mccCode:String?
    var tradingCommencedDate:String?
    var kyc : [KYCDetails]?
    var registeredName:String?
    var tradeName:String?
    var name:String?
    var businessCategory:String?
    var annualTurnover:String?
    var incorporationDate:String?
    var contacts : [ContactDetails]?
    var id:String?
    var optlock:Int?
    private enum CodingKeys: String, CodingKey {
        case address = "address"
        case websiteAddress = "websiteAddress"
        case externalId = "externalId"
        case operateAs = "operateAs"
        case mccCode = "mccCode"
        case tradingCommencedDate = "tradingCommencedDate"
        case kyc = "kyc"
        case registeredName = "registeredName"
        case tradeName = "tradeName"
        case name = "name"
        case businessCategory = "businessCategory"
        case annualTurnover = "annualTurnover"
        case incorporationDate = "incorporationDate"
        case contacts = "contacts"
        case id = "id"
        case optlock = "optlock"
    }
}







