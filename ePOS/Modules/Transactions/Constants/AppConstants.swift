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
    static let TERMINALMASTERPARAMFILE = "MasterParam.txt";    //File storing master parame
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
    static let MASTERCLRDIMFILE = "MASTERCLRDIMG"
    static let MASTERFCGFILE = "MASTERFCT"
    static let MASTERIMFILE = "MASTERIMG"
    static let MASTERFONTFILE = "MASTERFON"
    static let MASTERLIBFILE = "MASTERLIB"
    static let MASTERMINIPVMFILE = "MASTERMINI"
    static let DEFAULT_ORDINARY_USER = ""
    static let DEFAULT_ORDINARY_PIN = ""
    static let DEFAULT_ADMIN_USER = ""
    static let ORDINARY_USER_TYPE = 3;
    static let ADM_USER_TYPE = 1;
    
    
    
    static let MAX_EMV_TAG_TLV_LENGTH = 20;
    static let DEFAULT_HOSTID = 0x02;
    static let DEFAULT_CENTRAL_HOSTID = 0x01;
    static let DEFAULT_HUB_HOSTID = 0x02;
    static let DEFAULT_LAST_ROC = 100;
    static let DEFAULT_FIRST_BATCHID = 9001;
    static let DEFAULT_BATCH_SIZE = 200;
    
    static let NoPrintDefaultMessage = "    No Print Enabled\n\n\n   "
    
}



