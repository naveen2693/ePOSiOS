//
//  IntitalDataModel.swift
//  ePOS
//
//  Created by Abhishek on 20/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
//CheckUserModel
public struct CheckUserModel:Codable
{
    var userExists:String?
    var isRefferedUser:String?
    var UserData:UserData?
    private enum CodingKeys: String, CodingKey {
        case userExists = "userExists"
        case isRefferedUser = "isRefferedUser"
        case UserData = "user"
    }
}
//SubModelOfCheckUser
public struct UserData:Codable
{
    var contactName:String?
    var mobileNum:String?
    var email:String?
    var establishmentName :String?
    var appUuid:String?
    var mobileVerified:String?
    private enum CodingKeys: String, CodingKey {
        case contactName = "contactName"
        case mobileNum = "mobileNumber"
        case establishmentName = "establishmentName"
        case email = "email"
        case appUuid = "appUuid"
        case mobileVerified = "mobileVerified"
    }
}
