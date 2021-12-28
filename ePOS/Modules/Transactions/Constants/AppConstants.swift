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
    static let LocalTLE = false
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
    
    static let MAX_DR_RESPONSE_DATA_LEN = 20000
    static let MAX_SIG_IMAGE_RESPONSE_DATA_LEN = 20000
    
    static let DEFAULT_ORDINARY_USER = ""
    static let DEFAULT_ORDINARY_PIN = ""
    static let DEFAULT_ADMIN_USER = ""
    static let ORDINARY_USER_TYPE = 3
    static let ADM_USER_TYPE = 1
    
    static let MAX_TXN_STEPS_WITH_TLV_DATA = 100
    static let MAX_TXN_TLV_DATA_LEN  = 500
    static let  RESET_PTMK = (1)
    static let RENEW_PTMK = (2)
    static let keySlotMap:[[Int]] = [[10, 10, 12],
                                     [14, 14, 16],
                                     [18, 18, 20],
                                     [22, 22, 24],
                                     [26, 26, 28],
                                     [30, 30, 32],
                                     [34, 34, 36],
                                     [38, 38, 40]]
    
    static let ID_KEYSLOTID = 0
    static let ID_KEYSLOTPIN = 1
    static let ID_KEYSLOTTLE = 2
    static let KEYSLOT_PMK = 0x02
    static let KEYSLOT_ENCPMK = 0x01
    static let UNKNOWN_ERROR = 0x09
    static let INVALID_TAG = 0x0000
    static let INVALID_TAG_LEN = 0x00
    static let E_COM0 = 2
    static let COM0 = (1 << E_COM0)
    static let E_COM5 = 10                                    /*!< event number for COM5 */
    static let COM5 = (1 << E_COM5)/*!< event mask used as parameter for ttestall */
    
    static let E_COM_EXT = 26 /*!< event number for COM_EXT many drivers as COM20, COM21, COM_KEYSPAN, COM_SL, ... */
    static let COM_EXT = (1 << E_COM_EXT)/*!< event mask used as parameter for ttestall */
    
    
    static let NUM_KEYSLOTS = 8
    
    
    
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
    static let MAX_MINI_PVM_LEN = 10000

    static let MINI_PVM_EXCEEDS_LENGTH = 0x00
    static let MINI_PVM_ADDITIONAL_DATA_LEFT = 0x01
    static let MINI_PVM_FINISHED = 0x02
        
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
    
    static var MAX_LEN_TPDU = 5
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
    static var AC_DRDUMPREQ: String = "0095"
    static var AC_PARTIAL_SETTLEMENT: String = "5055"
    static var INVALID_CLIENT: String = "3333"
    
    static let BATCHCOMPLREQ = "0500"
    static let UPDATAREQ = "0220"
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
    
    //    static let ISO_LEN = 64
    //    static let MAX_LEN_DATE_TIME = 12
    //    static let MAX_LEN_TPDU = 5
    //    static let ISO_LEN_MTI = 4
    //    static let MAX_LEN_HARDWARE_SERIAL_NUMBER = 100
    static let ISO_PACKET_MAX_LEN = 19999
    static let LEN_ISO_PACKET_LEN = 2
    static let MAX_CONFIG_SIZE = 1000
    static let DEFAULT_BIN_KEYSLOTID = 10
    
    
    
    
    
    
    
    //   static let ACTION_DELETE = 0x00
    //   static let ACTION_ADD = 0x01
    //   static let TAG_DOWNLOAD_ALL = 4
    //   static let MAX_TXN_BIN_PARAMETERES = 4000
    //   static let LEN_INITIALIZATION_BITMAP = 8
    //   static let LEN_BITMAP_PACKET = 2
    //   static let MAX_APP_VERSION_LEN = 6
    //   static let MAX_CONNECTION_TIMEOUT_LEN = 6
    //   static let MAX_PHONENUMBER_LEN = 16
    //   static let MAX_LOGIN_ID_LEN = 20
    //   static let MAX_LOGIN_PASS_LEN = 20
    //   static let MAX_IPADDR_LEN = 20
    //   static let MAX_ISO_PORT_LEN = 10
    //   static let MAX_GPRS_SERVICES_PROVIDER_LEN = 20
    //   static let MAX_WIFI_PROFILE_NAME = 20
    //--------------Pad Style------------------
    static let _LEFT_PAD = 0
    static let _RIGHT_PAD = 1
    
    static let MAX_RESPONSE_SETTLEMENT_DATA_LEN = 50000
    
    static let MAX_CSV_LEN = 50000
    static let MAX_CSV_SCREEN_ACTION_DATA_LEN = 500
    static let MAX_REPLAY_DATA_LEN = 400
    static let MAX_RESPONSE_DATA_LEN = 50000
    
    static let MAX_DE55_SIZE = 1500
    static let MAX_APP_ID_LEN = 50
    static let MAX_TXN_AMOUNT_LEN = 25
    static let MAX_TRACK2_LEN = 200
    static let MAX_PIN_BLOCK_LEN = 20
    static let MAX_CARDHOLDER_NAME_LEN = 100
    
    
    static let REQUEST_FOR_CDISPLAYMENU_ACTIVITY = 0
    static let RESPONSE_FOR_CDISPLAYMENU_ACTIVITY = 1
    static let REQUEST_FOR_CDISPLAYWAIT_ACTIVITY = 2
    static let RESPONSE_FOR_CDISPLAYWAIT_ACTIVITY = 3
    static let REQUEST_FOR_CDISPLAYEVENTRECEIVED_ACTIVITY = 4
    static let RESPONSE_FOR_CDISPLAYEVENTRECEIVED_ACTIVITY = 5
    static let REQUEST_FOR_PIN_AFTER_EVENT_RECEIVED = 41
    static let RESPONSE_FOR_PIN_AFTER_EVENT_RECEIVED = 42
    static let REQUEST_FOR_ACCOUNT_SELECTION_ACTIVITY = 43
    static let RESPONSE_FOR_ACCOUNT_SELECTION_ACTIVITY = 43
    static let REQUEST_FOR_CDISPLAYGETAMOUNT_ACTIVITY = 6
    static let RESPONSE_FOR_CDISPLAYGETAMOUNT_ACTIVITY = 7
    static let REQUEST_FOR_CDISPLAYGETSECRETPIN_ACTIVITY = 8
    static let RESPONSE_FOR_CDISPLAYGETSECRETPIN_ACTIVITY = 9
    static let REQUEST_FOR_CDISPLAYMESSAGE_ACTIVITY = 10
    static let RESPONSE_FOR_CDISPLAYMESSAGE_ACTIVITY = 11
    static let REQUEST_FOR_CDISPLAY_CONFIRMATION_ACTIVITY = 12
    static let RESPONSE_FOR_CDISPLAY_CONFIRMATION_ACTIVITY = 13
    static let REQUEST_FOR_CDISPLAY_DATA_ENTRY_ACTIVITY = 14
    static let RESPONSE_FOR_CDISPLAY_DATA_ENTRY_ACTIVITY = 15
    static let REQUEST_FOR_CDISPLAYMENULIST_ACTIVITY = 16
    static let RESPONSE_FOR_CDISPLAYMENULIST_ACTIVITY = 17
    static let RESPONSE_FOR_TOUCH_EVENT_ON_WAITFOREVENT_ACTIVITY = 18
    static let REQUEST_FOR_PRINT_SLIP = 20
    //    public static final int REQUEST_FOR_SETTLEMENT_SLIP = 201
    static let REQUEST_FOR_WAITFOREVENT_ACTIVITY = 21
    static let RESPONSE_FOR_WAITFOREVENT_ACTIVITY = 22
    static let REQUEST_FOR_QR_CODE_ACTIVITY = 23
    static let RESPONSE_FOR_QR_CODE_ACTIVITY = 24
    static let REQUEST_FOR_SIGNATURE_CAPTURE = 25
    
    static let REQUEST_FOR_QRCODE_SCANNING_ACTIVITY = 25
    static let RESPONSE_FOR_QRCODE_SCANNING_ACTIVITY = 26
    
    /*    public static final int REQUEST_FOR_MERCHANT_LOGIN_ACTIVITY = 27
     public static final int RESPONSE_FOR_MERCHANT_LOGIN_ACTIVITY = 28*/
    
    static let FINISH_TRANSACTION_HUB_ACTIVITY = 30
    
    static let REQUEST_FOR_OFFLINE_PIN_ENTRY = 31
    static let RESPONSE_FOR_OFFLINE_PIN_ENTRY = 31
    
    //public static final int REQUEST_FOR_SERIAL_LISTENER = 31
    static let REQUEST_TO_GO_ONLINE_CSV_TXN_NORMAL = 32
    static let REQUEST_TO_GO_ONLINE_CSV_TXN_SWIPE = 33
    static let REQUEST_TO_GO_ONLINE_CSV_TXN_EMV_CLESS = 34
    
    static let REQUEST_TO_GO_ONLINE = 35
    
    static let REQUEST_FOR_GIF_VIDEO_ACTIVITY = 36
    static let RESPONSE_FOR_GIF_VIDEO_ACTIVITY = 37
    static let RESPONSE_FROM_PRINT_SLIP = 38
    
    static let REQUEST_FOR_CONFIRMATION_DIALOG = 38
    static let RESPONSE_FOR_CONFIRMATION_DIALOG = 39
    
    static let REQUEST_FOR_CDISPLAYGETPASSWORD_ACTIVITY = 40
    static let RESPONSE_FOR_CDISPLAYGETPASSWORD_ACTIVITY = 41
    
    static let REQUEST_FOR_CASCADING_LIST_ACTIVITY = 44
    static let RESPONSE_FOR_CASCADING_LIST_ACTIVITY = 45
    
    static let REQUEST_FOR_CDISPLAY_MULTI_DATA_ENTRY_ACTIVITY = 46
    static let RESPONSE_FOR_CDISPLAY_MULTI_DATA_ENTRY_ACTIVITY = 47
    static let REQUEST_FOR_PRINT_INTEGRATED_SLIP = 48
    
    static let RESPONSE_FOR_PRINT_INTEGRATED_SLIP = 49
    static let RESPONSE_FOR_UPI_BHARAT_QR_TXN = 50
    
    static let REQUEST_FOR_HOME_PAGE_ACTIVITY = 51
    static let RESPONSE_FOR_HOME_PAGE_ACTIVITY = 52
    
    static let API_RESULT_FAIL = 0x00
    static let API_RESULT_SUCCEEDED = 0x01
    
    //---------Printing Location constant------------
    static let EDCPrint = 1
    static let POSprint = 2
    static let NOPrint = 3
    
    
    //Transaction code to handle third party transaction
    static let TP_TXN_WALLET = "5102"
    static let TP_TXN_WALLET_VOID = "5104"
    static let TP_TXN_AIRTEL_MONEY = "5127"
    static let TP_TXN_AMAZON_PAY = "5129"
    static let TP_TXN_UPI = "5120"
    static let TP_TXN_UPI_GET_STATUS = "5122"
    static let TP_TXN_UPI_VOID = "5121"
    static let TP_TXN_BHARATQR = "5123"
    static let TP_TXN_PG_POS_CARD = "5561"
    static let TP_TXN_PG_POS_NETBANK = "5565"
    static let TP_TXN_PG_POS_BANKEMI = "5566"
    static let TP_TXN_PG_POS_BRANDEMI = "5567"
    static let TP_TXN_PG_POS_GET_STATUS = "5563"
    static let TP_TXN_PG_POS_VOID = "5562"
    static let TP_TXN_PG_POS_RESEND = "5564"
 
    /*--------------TXN History------------------*/
    static let TXN_CASH_ON_DELIVERY = "6101"
    static let TXN_UPI = "25233"
    static let TXN_UPI_GET_STATUS = "25235"
    static let TXN_UPI_VOID = "25236"
    static let TXN_BHARAT_QR = "25344"
    static let TXN_BHARAT_QR_GET_STATUS = "25235"
    static let TXN_BHARAT_QR_VOID = "25236"
    static let TXN_PHONEPE_WALLET = "25393"
    static let TXN_AMAZON_PAY_WALLET = "25366" //for Amazon
    static let TXN_PHONEPE_WALLET_GET_STATUS = "25395"
    static let TXN_PHONEPE_WALLET_VOID = "25396"
    static let TXN_FREECHARGE_WALLET = "25117"
    static let TXN_FREECHARGE_WALLET_VOID = "25106"
    static let TXN_AIRTEL_WALLET = "25362"
    static let TXN_AIRTEL_WALLET_VOID = "2536211" //todo change
    static let TXN_PG_AT_POS_CARD = "24705"
    static let TXN_PG_AT_POS_GET_STATUS = "24707"
    static let TXN_PG_AT_POS_VOID = "24708"
    static let TXN_PG_AT_POS_RESEND = "24712"
    static let TXN_PG_AT_POS_NETBANK = "24722"
    static let TXN_PG_AT_POS_BRAND_EMI = "24724"
    static let TXN_PG_AT_POS_BANK_EMI = "24723"
    static let TXN_PAPER_POS_TEMP = "255555500"
    
    static let WALLET_JIOMONEY_BANK = "101"
    static let WALLET_FREECHARGE_BANK = "103"
    static let WALLET_OXYGEN_BANK = "104"
    static let WALLET_PHONEPE_BANK = "105"
    static let WALLET_UPIAXIS_BANK = "107"
    static let WALLET_PAYZAPP_BANK = "108"
    static let WALLET_AMAZONPAY_BANK = "109"
 
    static let TXN_DATE_FORMAT = "%s-%s-%s"
    static let TXN_TIME_FORMAT = "%s:%s:%s.%s"
    
    
    static let T_NUM0: Byte = "0".bytes[0]                /*!< keys returned by KEYBOARD : '0' */
    static let T_NUM1: Byte = "1".bytes[0]                /*!< keys returned by KEYBOARD : '1' */
    static let T_NUM2: Byte = "2".bytes[0]                /*!< keys returned by KEYBOARD : '2' */
    static let T_NUM3: Byte = "3".bytes[0]                /*!< keys returned by KEYBOARD : '3' */
    static let T_NUM4: Byte = "4".bytes[0]                /*!< keys returned by KEYBOARD : '4' */
    static let T_NUM5: Byte = "5".bytes[0]                /*!< keys returned by KEYBOARD : '5' */
    static let T_NUM6: Byte = "6".bytes[0]                /*!< keys returned by KEYBOARD : '6' */
    static let T_NUM7: Byte = "7".bytes[0]                /*!< keys returned by KEYBOARD : '7' */
    static let T_NUM8: Byte = "8".bytes[0]                /*!< keys returned by KEYBOARD : '8' */
    static let T_NUM9: Byte = "9".bytes[0]                /*!< keys returned by KEYBOARD : '9' */
    static let T_PObyte: Byte = ".".bytes[0]              /*!< keys returned by KEYBOARD : '.' */
    static let T_APAP: Byte = 0x07                        /*!< keys returned by KEYBOARD : Paper Feed */
    static let T_VAL: Byte = 0x16                         /*!< keys returned by KEYBOARD : Green key */
    static let T_ANN: Byte = 0x17                         /*!< keys returned by KEYBOARD : Red key */
    static let T_CORR: Byte = 0x18                        /*!< keys returned by KEYBOARD : Yellow key */
    static let T_SK1: Byte = 0x19                         /*!< keys returned by KEYBOARD : F1 */
    static let T_SK2: Byte = 0x20                         /*!< keys returned by KEYBOARD : F2 */
    static let T_SK3: Byte = 0x21                         /*!< keys returned by KEYBOARD : F3 */
    static let T_SK4: Byte = 0x22                         /*!< keys returned by KEYBOARD : F4 */
    static let T_SKHAUT: Byte = 0x23                      /*!< keys returned by KEYBOARD : Up */
    static let T_SKBAS: Byte = 0x24                       /*!< keys returned by KEYBOARD : Down */
    static let T_SKVAL: Byte = 0x25                       /*!< keys returned by KEYBOARD : OK */
    static let T_SKCLEAR: Byte = 0x26                     /*!< keys returned by KEYBOARD : C */
    static let T_SK10: Byte = 0x28                        /*!< keys returned by KEYBOARD : F */
    static let NB_KEY = 24                                /*!< number of keys returned */
    static let EP_KEY = 0x30                              /*!< number of keys returned */

    static let TestKey = 500
}

enum enum_InputMethod {
    case NUMERIC_ENTRY, ALPHANUMERIC_ENTRY
}

