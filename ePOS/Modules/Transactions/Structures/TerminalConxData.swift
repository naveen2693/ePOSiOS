//
//  TerminalParamData.swift
//  ePOS
//
//  Created by Naveen Goyal on 06/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public struct TerminalConxData:Codable{
//Connection Type
    var iConnType:Int = 0
    var bIsConnectionActive = false
    var iConxPriority = 0 
    var bIsDataChanged = false 

  //timeouts
    var iConnTimeout = 0
    var iSendRecTimeout:Int = 0
    var iInterCharTimeout = 0
    var iComPort = 0
    var strLoginID =   ""
    var strPassword = ""

   //IP Layer
    var bTransactionSSLIPRetryCounter:Int16 = 0
    var strTransactionSSLServerIP:String = ""
    var iTransactionSSLPort:Int = 0
    var strSecondaryTransactionSSLServerIP:String = ""
    var iSecondaryTransactionSSLPort = 0
    var strGPRSServiceProvider:String = ""
    var strAPN:String = ""

  //WiFi specific configuration
    var strWiFiProfileName = ""

}
