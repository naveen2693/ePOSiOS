//
//  KycDetails.swift
//  ePOS
//
//  Created by Abhishek on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
// MARK:- KYC Request Keys
public struct KYCDetails:Codable{
    var idInformation:String?
    var description:String?
    var idType:String?
    var optlock:Int?
    var isVerified:String?
    var errMsg:String?
    private enum CodingKeys: String, CodingKey {
        case idInformation = "id_information"
        case description = "description"
        case idType = "id_type"
        case optlock = "optlock"
        case isVerified = "isVerified"
        case errMsg = "errMsg"
    }
}
