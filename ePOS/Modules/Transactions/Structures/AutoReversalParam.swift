//
//  AutoReversalParam.swift
//  ePOS
//
//  Created by Abhishek on 15/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct AutoReversalParams:Codable
{

    var m_bIsAutoReversalEnableFlag = false

    /*This will be used to send auto reversal request for first time*/
    var m_iAutoReversalFirstTryIntervalInSecs=120

    /*It will be used to send auto reversal after first retry*/
    var m_iAutoReversalRetryIntervalInSecs=60

    /*This counter defines the number of retry counts for sending auto reversal for a transaction*/
    var m_iAutoReversalMaxRetryCount=5

    var m_bIsDataChanged = false
}
