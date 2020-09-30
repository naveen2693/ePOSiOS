//
//  UserProfile.swift
//  ePOS
//
//  Created by Matra Sharma on 26/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct UserProfile:Codable
{
    let id : Int?
    let email : String?
    let userType : String?
    let mobileNumber : String?
    let contactName : String?
    let status : String?
    let mobileVerified : String?
    let emailVerified : String?
    let establishmentName : String?
    let merchantId : String?
    let dateOfBirth : String?
    let storeIds : String?
    let permissions : [String]?
    let services : [String]?
    let imei : String?
    let appUuid : String?
    let linkedQrList : [String]?
    let isNFCEnabledDevice : String?
    let isNFCOptedByUser : String?
    let isNFCOptedByMerchant : String?
    let appIdentifier : String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case email
        case userType
        case mobileNumber
        case contactName
        case status
        case mobileVerified
        case emailVerified
        case establishmentName
        case merchantId
        case dateOfBirth
        case storeIds
        case permissions
        case services
        case imei
        case appUuid
        case linkedQrList
        case isNFCEnabledDevice
        case isNFCOptedByUser
        case isNFCOptedByMerchant
        case appIdentifier
    }
}
