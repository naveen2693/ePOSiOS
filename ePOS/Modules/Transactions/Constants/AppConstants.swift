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
    static let MAX_COMMUNICATION_CHANNEL = 4;
    static let iMaxSerialOnlineSessionLength = 200;
    static let iMinConxTimeout = 5
    static let iInterCharTimeout = 5;
    static let iMinConxTimeoutSerial = 20;
    static let iConnectionTimeout = 60;
    static let iSendReceiveTimeout = 120;
    static let iComPort = 0;
    static let iMaxTimeOn24Clock = 235959;
    static let iMaxHourOn24Clock = 23;
    static let iMaxMinutesOn24Clock = 59
    static let iMaxSecondsOn24Clock = 59;
    static let HOST_PORT = 8094
    
    //-------------Default Primary, Secondary IP and Port----------------
    static let PRIMARY_IP = "180.179.219.225"
    static let SECONDARY_IP = "110.50.35.2";
    static let strConxLoginID = "";
    static let strConxPassword = "";
    static let strGPRSServiceProvider = "";
    static let strAPN = ""
    static let iMaxInSeconds = (24 * 3600);
    
    
    static let TRUE = 1;
    static let FALSE = 0;
    
    
    
    

    
    
    static let MAX_COUNT_CHARGE_SLIP_IMAGES:Int = 100;
    
    
    
    
    //File Name
    static let TRANSACTIONDATA = "TxnData";                //File storing Parameter data
    static let TERMINALPARAMFILENAME = "Param";                //File storing Parameter dat
    static let TRANSACTIONFILENAME = "Txn";            //File storing transaction data
    static let CSVTRANSACTIONFILENAME = "CsvTxn";            //File storing transaction dat
    static let CSVTRANSACTIONFILENAME_HISTORY = "CsvTxnHistory";            //File storing
    static let TRANSACTIONFILENAME_HISTORY = "TxnHistory";            //File storing transa
    static let TRANSACTION_AMOUNT_FILE = "TxnAmt";            //File storing transaction da
    static let PRINTDUMPTRANSACTIONFILE = "PrintTxn";            //File storing transaction
    static let TEMP_TRANSACTIONFILENAME = "tempTxn";            //temp File storing transac
    static let CONNECTIONDATAFILENAME = "Conndata";  //File storing Connection preference
    static let TXNFEILD62NAME = "230dump";//DUMP of chargeslip Data
    static let TEMP_TXNFEILD62NAME = "temp230dump";//temp DUMP of chargeslip Data
    static let PRINTDUMPFILENAME = "230dump";//DUMP of chargeslip Data
    static let TXNFEILD62NAMEAMEXGPRS = "230amex";// Ascii dump charge slip
    static let TEMP_TXNFEILD62NAMEAMEXGPRS = "temp230amex";// temp Ascii dump charge slip
    static let SETTLEMENTPRINTFILENAME = "STTLPRINT";            //DUMP of PRINT SLIP for S
    static let PADTXNFEILD62NAME = "pad230data";        //DUMP of chargeslip Data for PADPr
    static let PADSETTLEMENTPRINTFILENAME = "pad500data";        //DUMP of PRINT SLIP for S
    static let DRTXNFILENAME = "drtxn";        //DUMP of field 63 for DR data
    static let SGNBMPFILENAME = "sgnbmp";    //DUMP of field 61 for SIGNATURE DATA UPLOAD
    static let TMPSGNBMPFILENAME = "im10001000";        //Tmp Downloaded Signature file
    static let TXNFEILD52NAME = "Csvdump";    //DUMP of CSV Data
    static let BILLINGAPPDUMPFILE = "billingappdump";
    static let DEVICE_STATE = "DeviceState"
    static let USERINFOFILE = "UserInfo"
    static let  MASTERCGFILE = "MASTERCT"
    static let MASTERMESFILE = "MASTERMSG"
    static let MASTERCLRDIMFILE = "MASTERCLRDIMG"
    static let PSKSDWNLDFILE = "pskfile"
    static let AUTOLOGSHIPMENTSMTPCREDENTIAL = "LogShipmentCred"
    static let AUTOLOGSHIPMENTFILE = "LogShipment"
    static let MASTERFCGFILE = "MASTERFCT"
    static let TERMINALMASTERPARAMFILE = "MasterParam"
    static let MASTERIMFILE = "MASTERIMG"
    static let MASTERFONTFILE = "MASTERFON"
    static let MASTERLIBFILE = "MASTERLIB"
    static let BINRANGEFILE = "binrange"
    static let CONTENT_SERVER_PARAM_FILE = "content_server_parm_file"
    static let AUTOREVERSALPARFILE = "AutoRev"
    static let MASTERMINIPVMFILE = "MASTERMINI"
    static let AUTOGPRSALWAYSONPARFILE = "AutoGprs"
    static let AUTOSETTLEPARFILE = "AutSet"
    static let MASTERHTLFILE = "MASTERHTL"
    static let TEMPCSVTXNMAPFILE = "tmpcsvmap"
    static let  TEMPTXNBINFILE = "tmptxnbin"
    static let  TEMPBINRANGEFILE = "tmpbinrng"
    static let AUTOPREMIUMSERVICEPARFILE = "AutoPrem"
    static let DEFAULT_ORDINARY_USER = ""
    static let DEFAULT_ORDINARY_PIN = ""
    static let DEFAULT_ADMIN_USER = ""
    static let ORDINARY_USER_TYPE = 3;
    static let ADM_USER_TYPE = 1;
    static let APP_VERSION = "080120"
    
    
    static let MAX_EMV_TAG_TLV_LENGTH = 20;
    static let DEFAULT_HOSTID = 0x02;
    static let DEFAULT_CENTRAL_HOSTID = 0x01;
    static let DEFAULT_HUB_HOSTID = 0x02;
    static let DEFAULT_LAST_ROC = 100;
    static let DEFAULT_FIRST_BATCHID = 9001;
    static let DEFAULT_BATCH_SIZE = 200;
    
    static let NoPrintDefaultMessage = "    No Print Enabled\n\n\n   "
    
    
    
    
    
    
    
    
    
    
   static let ACTION_DELETE = 0x00;
   static let ACTION_ADD = 0x01;
   static let TAG_DOWNLOAD_ALL = 4;
   static let MAX_TXN_BIN_PARAMETERES = 4000;
   static let LEN_INITIALIZATION_BITMAP = 8;
   static let LEN_BITMAP_PACKET = 2;
   static let MAX_APP_VERSION_LEN = 6;
   static let MAX_CONNECTION_TIMEOUT_LEN = 6;
   static let MAX_PHONENUMBER_LEN = 16;
   static let MAX_LOGIN_ID_LEN = 20;
   static let MAX_LOGIN_PASS_LEN = 20;
   static let MAX_IPADDR_LEN = 20;
   static let MAX_ISO_PORT_LEN = 10;
   static let MAX_GPRS_SERVICES_PROVIDER_LEN = 20;
   static let MAX_WIFI_PROFILE_NAME = 20;
    
    
    
}



