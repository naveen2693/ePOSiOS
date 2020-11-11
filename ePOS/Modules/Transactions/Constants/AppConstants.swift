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
    static let LocalTLE = false;
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

    static let MAX_TXN_STEPS_WITH_TLV_DATA = 100;
    static let MAX_TXN_TLV_DATA_LEN  = 500
    static let  RESET_PTMK = (1);
    static let RENEW_PTMK = (2);
    static let keySlotMap:[[Int]] = [[10, 10, 12],
    [14, 14, 16],
    [18, 18, 20],
    [22, 22, 24],
    [26, 26, 28],
    [30, 30, 32],
    [34, 34, 36],
    [38, 38, 40]];

    static let ID_KEYSLOTID = 0;
    static let ID_KEYSLOTPIN = 1;
    static let ID_KEYSLOTTLE = 2;
    static let KEYSLOT_PMK = 0x02;
    static let KEYSLOT_ENCPMK = 0x01;
    static let UNKNOWN_ERROR = 0x09;
    static let INVALID_TAG = 0x0000;
    static let INVALID_TAG_LEN = 0x00;
    static let E_COM0 = 2;
    static let COM0 = (1 << E_COM0);
    static let E_COM5 = 10;                                    /*!< event number for COM5 */
    static let COM5 = (1 << E_COM5);/*!< event mask used as parameter for ttestall */

    static let E_COM_EXT = 26; /*!< event number for COM_EXT many drivers as COM20, COM21, COM_KEYSPAN, COM_SL, ... */
    static let COM_EXT = (1 << E_COM_EXT);/*!< event mask used as parameter for ttestall */


    static let NUM_KEYSLOTS = 8;

    
    
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
 
 
    static let PRINTDUMP_CHARGESLIPMODE: Byte = 0x01
    static let PRINTDUMP_RAWMODE: Byte = 0x02
    static let PRINTDUMP_IMAGEMODE: Byte = 0x03
    static let PRINTDUMP_BARCODEMODE: Byte = 0x04
    static let PRINTDUMP_PRINTMESSAGEMODE: Byte = 0x05
    static let PRINTDUMP_DISPLAYMODE: Byte = 0x06
    static let PRINTDUMP_QRCODEMODEBASE64: Byte = 0x0B
    static let PRINTDUMP_QRCODEMODE: Byte = 0x09
    static let PRINTDUMP_QRCODEPD: Byte = 0x0A
    
    static let PRINTDUMP_SIZE24: Int = 24
    static let PRINTDUMP_SIZE40: Int = 40
    static let PRINTDUMP_SIZE48: Int = 48
    
//    static let ISO_LEN = 64;
//    static let MAX_LEN_DATE_TIME = 12;
//    static let MAX_LEN_TPDU = 5;
//    static let ISO_LEN_MTI = 4;
//    static let MAX_LEN_HARDWARE_SERIAL_NUMBER = 100;
    static let ISO_PACKET_MAX_LEN = 19999;
    static let LEN_ISO_PACKET_LEN = 2;
    static let MAX_CONFIG_SIZE = 1000;
    static let DEFAULT_BIN_KEYSLOTID = 10;
    
    
    
    
    
    
    
//   static let ACTION_DELETE = 0x00;
//   static let ACTION_ADD = 0x01;
//   static let TAG_DOWNLOAD_ALL = 4;
//   static let MAX_TXN_BIN_PARAMETERES = 4000;
//   static let LEN_INITIALIZATION_BITMAP = 8;
//   static let LEN_BITMAP_PACKET = 2;
//   static let MAX_APP_VERSION_LEN = 6;
//   static let MAX_CONNECTION_TIMEOUT_LEN = 6;
//   static let MAX_PHONENUMBER_LEN = 16;
//   static let MAX_LOGIN_ID_LEN = 20;
//   static let MAX_LOGIN_PASS_LEN = 20;
//   static let MAX_IPADDR_LEN = 20;
//   static let MAX_ISO_PORT_LEN = 10;
//   static let MAX_GPRS_SERVICES_PROVIDER_LEN = 20;
//   static let MAX_WIFI_PROFILE_NAME = 20;
    //--------------Pad Style------------------
   static let _LEFT_PAD = 0;
   static let _RIGHT_PAD = 1;
    
    
    
}

enum enum_InputMethod {
    case NUMERIC_ENTRY, ALPHANUMERIC_ENTRY
}

