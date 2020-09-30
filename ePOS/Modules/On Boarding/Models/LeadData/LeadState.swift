//
//  LeadState.swift
//  ePOS
//
//  Created by Matra Sharma on 28/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct LeadState : Codable {
    let id : Int?
    let optlock : Int?
    let createdDate : Int?
    let workFlowState : String?
    let leadStatus : String?
    let description : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case optlock = "optlock"
        case createdDate = "createdDate"
        case workFlowState = "workFlowState"
        case leadStatus = "leadStatus"
        case description = "description"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        optlock = try values.decodeIfPresent(Int.self, forKey: .optlock)
        createdDate = try values.decodeIfPresent(Int.self, forKey: .createdDate)
        workFlowState = try values.decodeIfPresent(String.self, forKey: .workFlowState)
        leadStatus = try values.decodeIfPresent(String.self, forKey: .leadStatus)
        description = try values.decodeIfPresent(String.self, forKey: .description)
    }

}
