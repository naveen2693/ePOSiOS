//
//  AutoPremiumServiceParams.swift
//  ePOS
//
//  Created by Abhishek on 15/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct AutoPremiumServiceParams:Codable
{
    var m_iAutoPremiumServiceEnableFlag = false;
    var m_iAutoPremiumServiceRetryIntervalInSeconds = 120;
    var m_strAutoPremiumServiceStartTime = "230000";
    var m_iAutoPremiumServiceFrequency = 2;
    var m_iAutoPremiumServiceRetryCount = 5;
    var m_bIsDataChanged = false;
}
