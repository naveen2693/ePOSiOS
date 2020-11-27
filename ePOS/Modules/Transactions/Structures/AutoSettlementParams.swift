//
//  AutoSettlementParams.swift
//  ePOS
//
//  Created by Abhishek on 14/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct AutoSettlementParams:Codable
{
    /**
     * 1- Enabled
     * 0 - Disabled
     * default - 0
     * If this flag is set to 1 only then auto settlement will trigger
     */
   var m_iAutoSettlementEnabledflag = false

    /**
     * the time is in hhmiss, in 24 hour clock format.
     * It’s a 6 digit len string.
     * E.g. if the value is 170000
     * then the timer will for automated settlement
     * will start at 5 PM of the running day.
     * Default is 220000, i.e. 10 PM
     */
    var m_strSettlementStartTime = "233000"

    /**
     * This is the number of times the settlement would be auto triggered
     * from the POS .
     * The minimum and default value is 1 and maximum is 48.
     * Not more that 30 minutes gap should be enabled
     * otherwise there will be problem of back to back timers.
     */
    var  m_iSettlementFrequency = 1

    /**
     * this is the maximum number of attempts which terminal will attempt
     * if connectivity with central server has failed.
     * Default - 5
     */
   var m_iSettlementRetryCount = 5

    /**
     * This is timeout in seconds after will retry has to be done.
     * Default - 120
     */
    var m_iSettlementRetryIntervalInSeconds = 120

    var m_bIsDataChanged = false

}
