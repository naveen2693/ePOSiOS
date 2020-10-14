//
//  LeadAgreementDetails.swift
//  ePOS
//
//  Created by Abhishek on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
// MARK:-LeadAgreement
public struct LeadAgreement:Codable{
    var id:Int?
    var description:String?
    var agreement:String?
    var optlock:Int?
    var status:Int?
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case description = "description"
        case agreement = "agreement"
        case optlock = "optlock"
        case status = "status"
    }
}
