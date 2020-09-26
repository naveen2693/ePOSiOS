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
    var contactName:String?
    var mobileNum:String?
    var email:String?
    var linkedQrList :String?
    var appUuid:String?
    var dateOfBirth:String?
    var appIdentifier:String?
    var imei:String?
    var userType:String?
    var storeIds :String?
    var mobileVerified:String?
    var id:String?
    var establishmentName:String?
    var services:String?
    var merchantId:String?
    var emailVerified:String?
    var permissions :String?
    
    private enum CodingKeys: String, CodingKey {
        case contactName
        case mobileNum
        case email
        case linkedQrList
        case appUuid
        case dateOfBirth
        case appIdentifier
        case imei
        case userType
        case storeIds
        case mobileVerified
        case id
        case establishmentName
        case services
        case merchantId
        case emailVerified
        case permissions
    }
}
