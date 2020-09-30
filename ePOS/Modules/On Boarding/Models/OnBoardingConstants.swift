//
//  OnBoardingConstants.swift
//  ePOS
//
//  Created by Matra Sharma on 28/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

enum WorkFlowState: String  {
    case leadNotCreated = "LEAD_NOT_CREATED"
    case leadInitialized = "LEAD_INITIALIZED"
    case saveBUDetails = "SAVE_BU_DETAILS"
}

enum EntityType: String  {
    case individual = "INDIVIDUAL"
    case proprietor = "PROPRIETOR"
    case partnership = "PARTNERSHIP"
    case company = "COMPANY"
}

enum UserState: String {
    case merchant = "MERCHANT"
    case store = "STORE"
    case applicant = "APPLICANT"
}
