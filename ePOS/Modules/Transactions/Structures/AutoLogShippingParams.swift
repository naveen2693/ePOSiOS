//
//  AutoLogShippingParams.swift
//  ePOS
//
//  Created by Abhishek on 14/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public struct AutoLogShippingParams:Codable {
    /**
     * 1- Enabled
     * 0 - Disabled
     * default - 0
     * If this flag is set to 1 only then auto Log Shipment will trigger
     */
    var  m_iAutoLogShippingEnabledFlag:Int=0;

    /**
     * the time is in hhmmss, in 24 hour clock format.
     * It’s a 6 digit len string.
     * E.g. if the value is 170000
     * then the timer will for automated settlement
     * will start at 5 PM of the running day.
     * Default is 220000, i.e. 10 PM
     */
    var  m_strLogShipmentStartTime = "070000";


    /**
     * This is the number of times the Log Shipment would be auto triggered
     * from the POS .
     * The minimum and default value is 1 and maximum is 48.
     * Not more that 30 minutes gap should be enabled
     * otherwise there will be problem of back to back timers.
     */
    var m_iLogShipmentFrequency:Int = 1;

    /**
     * this is the maximum number of attempts which terminal will attempt
     * if connectivity with central server has failed.
     * Default - 1
     */
    var m_iLogShipmentRetryCount:Int = 1;


    /**
     * This is timeout in seconds after will retry has to be done.
     * Default - 30
     */
    var m_iLogShipmentRetryInterval  = 30;

    var m_iLogShipmentLevel  = 0;
    var m_iLogShipmentRetentionDays = 4;
    var m_iLogShipmentRetentionSizeInMB = 1024;
    var m_sLogShippingDirecetorypath = "/data/ePOS";
    var m_strLogBlackListStartTime = "";
    var m_strLogBlackListEndTime = "";
    var m_bLogEnabledFlag = false;
    var m_iMaxLogFileSize = 0;
    var m_iMaxLogFileCountOfADay = 0;
}
