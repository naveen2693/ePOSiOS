//
//  AppConstants.swift
//  ePOS
//
//  Created by Abhishek on 08/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

enum AppConstant
{
    static let MAX_COMMUNICATION_CHANNEL = 4
    static let iMaxSerialOnlineSessionLength = 200
    static let iMinConxTimeout = 5
    static let iInterCharTimeout = 5
    static let iMinConxTimeoutSerial = 20
    static let iConnectionTimeout = 60
    static let iSendReceiveTimeout = 120
    static let iComPort = 0
    static let iMaxTimeOn24Clock = 235959
    static let iMaxHourOn24Clock = 23
    static let iMaxMinutesOn24Clock = 59
    static let iMaxSecondsOn24Clock = 59
    static let HOST_PORT = 8094
    
    //-------------Default Primary, Secondary IP and Port----------------
    static let PRIMARY_IP = "180.179.219.225"
    static let SECONDARY_IP = "110.50.35.2"
    static let strConxLoginID = ""
    static let strConxPassword = ""
    static let strGPRSServiceProvider = ""
    static let strAPN = ""
    static let iMaxInSeconds = (24 * 3600)
    
    
    static let TRUE = 1
    static let FALSE = 0

    
    static let MAX_COUNT_PARAMETERS: Int = 250
    static let MAX_COUNT_CHARGE_SLIP_IMAGES:Int = 100
    static let MAX_TXN_PRINTING_LOCATION_PARAMETERES = 200
    
    static let DEFAULT_ORDINARY_USER = ""
    static let DEFAULT_ORDINARY_PIN = ""
    static let DEFAULT_ADMIN_USER = ""
    static let ORDINARY_USER_TYPE = 3
    static let ADM_USER_TYPE = 1
    
    
    static let MAX_EMV_TAG_TLV_LENGTH = 20
    static let DEFAULT_CENTRAL_HOSTID = 0x01
    static let DEFAULT_HUB_HOSTID = 0x02
    static let DEFAULT_LAST_ROC = 100
    static let DEFAULT_FIRST_BATCHID = 9001
    static let DEFAULT_BATCH_SIZE = 200
    
    static let NoPrintDefaultMessage = "    No Print Enabled\n\n\n   "
    
    static let MAX_TXN_ISPASSWORD_PARAMETERES = 200
    
    static let ACTION_DELETE = 0x00
    static let ACTION_ADD = 0x01
    static let TAG_DOWNLOAD_ALL = 4
    static let MAX_TXN_BIN_PARAMETERES = 4000
    static let LEN_INITIALIZATION_BITMAP = 8
    static let LEN_BITMAP_PACKET = 2
    static let MAX_APP_VERSION_LEN = 6
    static let MAX_CONNECTION_TIMEOUT_LEN = 6
    static let MAX_PHONENUMBER_LEN = 16
    static let MAX_LOGIN_ID_LEN = 20
    static let MAX_LOGIN_PASS_LEN = 20
    static let MAX_IPADDR_LEN = 20
    static let MAX_ISO_PORT_LEN = 10
    static let MAX_GPRS_SERVICES_PROVIDER_LEN = 20
    static let MAX_WIFI_PROFILE_NAME = 20
    
    static let TAG_TLV_LOGIN_INFO_OBJECT = 0x1001
    static let TAG_TLV_LOGIN_INFO_USER_NAME = 0x1002
    static let TAG_TLV_LOGIN_INFO_PASSWORD_HASH = 0x1003
    static let TAG_TLV_LOGIN_INFO_USER_CREATION_TYPE = 0x1004
    static let TAG_TLV_LOGIN_INFO_CREATION_DATE_TIME = 0x1005
    static let TAG_TLV_LOGIN_INFO_USER_ROLE = 0x1006
    static let TAG_TLV_LOGIN_INFO_GUID = 0x1007

    static var APP_VERSION: String = "080120"   //ddmmyy
    static var TERMINAL_TYPE: String = "53"     //Terminal Type in DB should be 83. Here hex value is sent as 0x53.
    static var DEFAULT_HOSTID: Int = 0x02
    static var MAX_LEN_HARDWARE_SERIAL_NUMBER: Int = 100
    
    static var MAX_MESSAGE_LEN: Int = 300
    static var MAX_COUNT_MESSAGES: Int = 100
    static var MAX_COUNT_MINIPVM: Int = 50
    static var MAX_COUNT_HTL = 1000
    static var MAX_LIB_FILE: Int = 100
    
    static var MAX_LEN_TPDU = 5;
    static var MAX_LEN_DATE_TIME: Int = 12
    static var ISO_LEN: Int = 64
    static var ISO_LEN_MTI: Int = 4
    
    static var AC_PRINT_PAD: String = "02"
    
    /* DialUp Connection Variables */
    static var DIALUP_SERIAL = 1
    static var DIALUP_WIFI = 2
    static var DIALUP_GPRS = 3
    static var DIALUP_ETHERNET = 4
    
    static var MAX_DATE_LEN = 13
    
    static var MAX_BIN_RANGE_PARAMETERES = 4000
    static var MAX_CSV_TXN_TYPE_PARAMETERES = 100
    static var MAX_MESSAGE_LENGTH = 101000        //100K to accomodate very large printdump buffer
    
    static var STR_AC_SUCCESS: String = "0000"  //String
    static var AC_PARTIAL_SETTLEMENT: String = "5055"
    static var INVALID_CLIENT: String = "3333"
 
    static let DOWNDATAREQ = "0320"
    
    static let MAX_COUNT_LIBRARY = 500
    static let DEFAULT_NUM_KEYSLOT = 1
    static let NUM_KEYSLOTS = 8
    static let keySlotMap: [[Int]] =
    [
      [10, 10, 12],
      [14, 14, 16],
      [18, 18, 20],
      [22, 22, 24],
      [26, 26, 28],
      [30, 30, 32],
      [34, 34, 36],
      [38, 38, 40]
    ]
    
    static let ID_KEYSLOTID = 0
    static let ID_KEYSLOTPIN = 1
    static let ID_KEYSLOTTLE = 2
    
}
