//
//  FIleNameConstants.swift
//  ePOS
//
//  Created by Abhishek on 23/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
enum FileNameConstants
{
       static let TRANSACTIONDATA = "TxnData"
       static let TERMINALPARAMFILENAME = "Param"
       static let TRANSACTIONFILENAME = "Txn"
       static let CSVTRANSACTIONFILENAME = "CsvTxn"
       static let CSVTRANSACTIONFILENAME_HISTORY = "CsvTxnHistory"
       static let TRANSACTIONFILENAME_HISTORY = "TxnHistory"
       static let TRANSACTION_AMOUNT_FILE = "TxnAmt"
       static let PRINTDUMPTRANSACTIONFILE = "PrintTxn"
       static let TEMP_TRANSACTIONFILENAME = "tempTxn"
       static let TERMINALMASTERPARAMFILE = "MasterParam"

       static let CONNECTIONDATAFILENAME = "Conndata"
       static let TXNFEILD62NAME = "230dump"
       static let TEMP_TXNFEILD62NAME = "temp230dump"
       static let PRINTDUMPFILENAME = "230dump"
       static let TXNFEILD62NAMEAMEXGPRS = "230amex"
       static let TEMP_TXNFEILD62NAMEAMEXGPRS = "temp230amex"
       static let SETTLEMENTPRINTFILENAME = "STTLPRINT"
       static let PADTXNFEILD62NAME = "pad230data"
       static let PADSETTLEMENTPRINTFILENAME = "pad500data"
       static let DRTXNFILENAME = "drtxn"
       static let SGNBMPFILENAME = "sgnbmp"
       static let TMPSGNBMPFILENAME = "im10001000"
       static let TXNFEILD52NAME = "Csvdump"
       static let BILLINGAPPDUMPFILE = "billingappdump"
       static let CONNECTIONDATA1 = "Conndata1"
       static let CONNECTIONDATA2 = "Conndata2"
       static let CONNECTIONCFG = "Conncfg"

       static let TRANSACTIONFILE = "Txn"

       static let TERMINALPARAMFILE = "Params"
       static let TERMINALHUBPARAMFILE = "HubParams"
       static let USERINFOFILE = "UserInfo"
       static let TEMPVMFILE = "temppvm"
       static let TEMPCGFILE = "tempcg"
       static let AUTOSETTLEPARFILE = "AutSet"
       static let AUTOLOGSHIPMENTFILE = "LogShipment"
       static let AUTOLOGSHIPMENTSMTPCREDENTIAL = "LogShipmentCred"
       static let PREDIALINGSTATUS = "PreDial"
       static let LOGININFO = "Loginfo"
       static let CURRENT_PIN = "CurrentUserPIN"
       static let AUTOREVERSALPARFILE = "AutoRev"
       static let AUTOGPRSALWAYSONPARFILE = "AutoGprs"
       static let AUTOPREMIUMSERVICEPARFILE = "AutoPrem"
       static let PVMFILE = "PVM"
       static let MINIPVM = "MINIPVM"
       static let MASTERCGFILE = "MASTERCT"
       static let MASTERIMFILE = "MASTERIMG"
       static let MASTERCLRDIMFILE = "MASTERCLRDIMG"
       static let MASTERMESFILE = "MASTERMSG"
       static let ADDCTLIST = "ADDCTLIST"
       static let DELETECTLIST = "DELCTLIST"
       static let ADDIMLIST = "ADDIMLIST"
       static let DELETEIMLIST = "DELIMLIST"
       static let ADDCLRDIMLIST = "ADDCLRDIMLIST"
       static let DELETECLRDIMLIST = "DELCLRDIMLIST"
       static let ADDMSGLIST = "ADMSGLIST"
       static let DELETEMSGLIST = "DLMSGLIST"
       static let PRINTDATAFILE = "PRINTDATA"
       static let TXNFEILD62 = "230dump"
       static let SETTLEMENTPRINT = "STTLPRINT"

       static let MASTERMINIPVMFILE = "MASTERMINI"

       static let DWNLDPVMINFO = "dwpvminfo"
       static let TRACEFILE = "Trace"
       static let TEMPTRACEFILE = "TempTrace"
       static let DWNLDCHUNKINFO = "dwchnkinfo"
       static let DWNLDCONTENTINFO = "dwcontentinfo"   //
       static let SGNCHUNKINFO = "sgchnkinfo"
       static let TEMEMVPARFILE = "tempemv"
       static let DWNLDEMVPARINFO = "dwemvinfo"
       static let DWNLDEMVPARCHUNKINFO = "emvchkinf"
       static let EMVPARFILE = "EMVPAR.XML" //EMV PAR xml file
       static let TEMPSKFILE = "temppsk"
       static let DWNLDPSKINFO = "dwpskinfo"
       static let DWNLDPSKCHUNKINFO = "pskchkinf"
       static let PSKSDWNLDFILE = "pskfile"
       static let TEMCACRTFILE = "tempcacrt"
       static let DWNLDCACRTINFO = "dwcacrtinfo"
       static let DWNLDCACRTCHUNKINFO = "cacrtchkinf"
       static let CACRTFILE = "ca.crt"  //CA CRT file
       static let TEMPBINRANGEFILE = "tmpbinrng"
       static let BINRANGEFILE = "binrange"    //Bin Range file
       static let TEMPCSVTXNMAPFILE = "tmpcsvmap"
       static let CSVTXNMAPFILE = "csvtxnmap"
       //Transaction Bin
       static let TEMPTXNBINFILE = "tmptxnbin"
       static let TXNBINFILE = "txnbin"    //Transaction Bin File
       static let TEMPCSVTXNIGNAMT = "tmpignamt"
       static let CSVTXNIGNAMT = "ignamt"   //Transaction Bin File
       static let EDCAPPDISKNAME = "DISKAPP"    //EDC APP DISK NAME
       static let COMMPARDSKNAME = "DISKCOMM"
       static let TEMEDCAPPFILE = "tempedc"
       static let DWNLDEDCAPPINFO = "dwedcinfo"
       static let DWNLDEDCAPPCHUNKINFO = "edcchkinf"
       static let EDCAPPFILE = "PLUTUSPLUS.apk"//EDC App file
       static let EDCINITSTATUS = "APP.INIT"
       static let EDCFONTSTATUS = "FONT.INIT"
       static let MASTERFCGFILE = "MASTERFCT"
       static let ADDFCTLIST = "ADDFCTLIS"
       static let DELETEFCTLIST = "DELFCTLIST"
       static let TEMPFCGFILE = "tempfcg"
       static let DWNLDCGFINFO = "dwcfginfo"
       //Font file download for UniCode dispay/print::Amitesh
       static let MASTERFONTFILE = "MASTERFON"
       static let ADDFONTLIST = "ADDFONLIST"
       static let DELETEFONTLIST = "DELFONLIST"
       static let TEMPFONTFILE = "tempfon"
       static let DWNLDFONTINFO = "dwcfoninfo"
       static let EDCLIBSTATUS = "LIB"
       //EMV TAG download::Amitesh
       static let TEMPEMVTAGLIST = "tmpemvtaglist"

       static let EMVTAGLIST = "emvtaglist"

       static let TMPSIGNATURECAPTURFILE = "tmpsigfile"
       static let SIGNATUREPARAMFILE = "signparam"
       static let TEMPCLESSPARAM = "tmpcless"
       static let CLESSPARAM = "clessparam"
       static let TEMCLESSPARFILE = "tempcless"
       static let DWNLDCLESSPARINFO = "dwclesinfo"
       static let DWNLDCLESSPARCHUNKINFO = "cleschkinf"
       static let CLESSPARFILE = "CLESSPAR"
       static let POSPRINTINGLOCATIONFILE = "POSLocation"
       static let TEMPAIDEMVTXNTYPEFILE = "AIDEmvTxn"
       static let POSAIDEMVTXNTYPEFILE = "AIDEmvTxn"
       static let TEMPTXNTYPEFLAGSMAPPINGFILE = "TxnTypeFlags.tmp"
       static let POSTXNTYPEFLAGSMAPPINGFILE = "TxnTypeFlags"
       //LIB file download ::Amites
       static let MASTERLIBFILE = "MASTERLIB"
       static let ADDLIBLIST = "ADDLIBLIST"
       static let DELETELIBLIST = "DELLIBLIST"
       static let TEMPLIBFILE = "templib"
       static let DWNLDLIBINFO = "dwclibinfo"
       //CIMB MIni PVM download:: amitesh
       static let ADDMINIPVMLIST = "ADDMPVM"
       static let DELETEMINIPVMLIST = "DELMINIPVM"


       static let DWNLDMINIPVMINFO = "dwmpvminfo"
       static let TEMMINIPVMFILE = "tempmpvm"
       static let TEMPCSVTXNTYPEMINIPVMMAPPINGFILE = "TmpTxnMPvm"
       static let CSVTXNTYPEMINIPVMMAPPINGFILE = "TxnTypeMPvm"
       static let ISPASSWORDMAPPINGFILE = "ISPass"
       static let MASTERHTLFILE = "MASTERHTL"
       static let ADDHTLLIST = "ADDHTLLIST"
       static let DELETEHTLLIST = "DELHTLLIST"
       static let DEVICE_STATE = "DeviceState"

    
       static let CONTENT_SERVER_PARAM_FILE = "content_server_parm_file"
       static let CONTENT_SERVER_APK_INFO_FILE = "content_server_apk_info_file"
       static let CONTENT_SERVER_LIB_INFO_FILE = "content_server_lib_info_file"
       static let CONTENT_SERVER_CONTENT_INFO_FILE = "content_server_content_info_file"
    
       //Folder Path
       static let IMAGE = "images"
       static let GIF = "gifs"
       static let VIDEO = "videos"
       static let DOCUMENT = "documents"
       static let MUSIC = "music"
       static let THEME = "theme"
       static let FONT = "font"
       static let UKNOWN_CONTENT_TYPE = "unknown_content_type"
    

}
