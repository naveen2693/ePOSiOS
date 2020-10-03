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
    private enum CodingKeys: String, CodingKey {
        case idInformation = "idInformation"
        case description = "description"
        case idType = "idType"
        case optlock = "optlock"
        case isVerified = "isVerified"
    }
}
