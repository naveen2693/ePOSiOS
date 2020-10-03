//
//  LeadScheduleDetails.swift
//  ePOS
//
//  Created by Abhishek on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
// MARK:-Lead Schedule 
public struct LeadScheduleDetails:Codable{
    var scheduleTime:String?
    var workFlowState:String?
    var description:String?
    var optlock:Int?
    private enum CodingKeys: String, CodingKey {
        case scheduleTime = "scheduleTime"
        case workFlowState = "workFlowState"
        case description = "description"
        case optlock = "optlock"
    }
}
