//
//  BankAccountDetails.swift
//  ePOS
//
//  Created by Abhishek on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
// MARK:- Bank Account
public struct BankAccountDetails:Codable{
    var isVerified:String?
    var accNo:String?
    var accHolderName:String?
    var pennyDropCount:String?
    var branchName:String?
    var bankName:String?
    var mobileNo:String?
    var bankAddress:String?
    var referenceId:String?
    var purposeOfAcc:String?
    var accType:String?
    var micrCode:String?
    var ifscCode:String?
    var id:String?
    var optlock:Int?
    private enum CodingKeys: String, CodingKey {
        case isVerified = "isVerified"
        case accNo = "accNo"
        case accHolderName = "accHolderName"
        case pennyDropCount = "pennyDropCount"
        case branchName = "branchName"
        case bankName = "bankName"
        case mobileNo = "mobileNo"
        case bankAddress = "bankAddress"
        case referenceId = "referenceId"
        case purposeOfAcc = "purposeOfAcc"
        case accType = "accType"
        case micrCode = "micrCode"
        case ifscCode = "ifscCode"
        case id = "id"
        case optlock = "optlock"
    }
}
