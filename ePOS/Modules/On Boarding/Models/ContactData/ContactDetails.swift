//
//  ContactDetails.swift
//  ePOS
//
//  Created by Abhishek on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
// MARK:- Contact Request Keys
public struct ContactDetails:Codable{
    var isVerified:String?
    var description:String?
    var information:String?
    var type:String?
    var optlock:Int?
    private enum CodingKeys: String, CodingKey {
        case isVerified = "isVerified"
        case description = "description"
        case information = "information"
        case type = "type"
        case optlock = "optlock"
    }
}

