//
//  Lead.swift
//  ePOS
//
//  Created by Matra Sharma on 28/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct Lead: Codable {
    var workFlowState: String
    var nextWorkFlowState: String
    
    private enum CodingKeys: String, CodingKey {
        case workFlowState
        case nextWorkFlowState
    }
}
