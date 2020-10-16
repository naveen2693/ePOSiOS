//
//  AutoGPRSNetworkParams.swift
//  ePOS
//
//  Created by Abhishek on 15/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct AutoGPRSNetworkParams:Codable {
    var m_bIsAutoGPRSNetworkEnableFlag = false;
    var m_iAutoGPRSNetworkRetryInterval = 60;
    var m_bIsDataChanged = false;
}
