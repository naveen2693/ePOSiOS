//
//  TerminalMasterParamData.swift
//  ePOS
//
//  Created by Naveen Goyal on 06/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public struct TerminalMasterParamData:Codable
{
    var ulPvmVersion: Int64 = 0
    var bIsDataChanged = false;
    var m_uchArrBitmap320CentralChangeNumber:[Byte] = [(Byte(AppConstant.LEN_INITIALIZATION_BITMAP)+Byte(1))];
    var m_uchArrBitmap320HUBChangeNumber:[Byte] = [(Byte(AppConstant.LEN_INITIALIZATION_BITMAP)+Byte(1))];
    var m_uchArrBitmap320ActiveHost:[Byte] = [(Byte(AppConstant.LEN_BITMAP_PACKET)+Byte(1))];
    var m_uchArrBitmap440ActiveHost:[Byte] = [(Byte(AppConstant.LEN_BITMAP_PACKET)+Byte(1))];
    var m_uchArrBitmap500ActiveHost:[Byte] = [(Byte(AppConstant.LEN_BITMAP_PACKET)+Byte(1))];
    var bIsBitmap320ActiveHostSet = false;
    var bIsBitmap440ActiveHostSet = false;
    var bIsBitmap500ActiveHostSet = false;
    var ulCACRTVersion:Int64 = 0;
    var m_strAppVersion:String = ""
    var totalCTids:Int = 0;
    var totalImageIds:Int = 0;
    var m_strEMVParVersion = "";
    var m_strCSVTxnMapVersion = "";
    var ulTotalCSVTxnType:Int64 = 0 ;
    var m_strBinRangeDownloadDate = "";
    var ulTotalBinRange:Int64 = 0;
    var m_bIsBinRangeChanged = false;
    var m_bIsPKExchangePacket = false;
    var m_strHSMPrimaryIP = "";
    var m_lHSMPrimaryPort:Int64 = 0;
    var m_strHSMSecondaryIP = "";
    var m_lHSMSecondaryPort:Int64 = 0;
    var  m_iHSMRetryCount:Int = 0;
    var m_iUsePineEncryptionKeys = 0; // Use Pine Encryption Key
    var m_iUseDefaultKeySlotOnly = false; // Use Default Key Slot Only
    //public // Additional Parameters
    var m_iOnlinePinFirstCharTimeout = 0;
    var m_iOnlinePinInterCharTimeout = 0;
    var m_iMinPinLength = 0;
    var m_iMaxPinLength = 0;
    var m_iDisplayMenuTimeout = 0;
    var m_iDisplayMessasgeTimeout = 0;
    var m_iHotKeyConfirmationTimeout = 0;
    //public // Transaction Bin
    var m_strTxnBinDownloadDate = "";
    var ulTotalTxnBin:Int64 = 0;
    var m_bIsTxnBinChanged = false;
    var m_bIsAskPInForServiceCode6 = false;
    var m_bIsPinBypassForServiceCode6 = false;
    var m_bIsIngnoreIngeratedAmountEMVTxn = false;
    var m_strIgnoreAmtCSVTxnListDownloadDate = "";
    var m_ulTotalCSVTxnIgnAmtList:Int64 = 0;
    // EMV Tag List Download
    var m_strEMVTagListDownloadDate = "";
    var m_ulTotalEMVTagList:Int64 = 0;
    // CLess Param Download
    var m_strCLessParamDownloadDate = "";
    var m_strCLESSEMVParVersion = "";
    var m_strAIDEMVTXNTYPEDownloadDate = "";
    var m_strTxnTypeFlagsMappingDownloadDate = "";
    var m_strCsvTxnTypeMiniPvmMappingDownloadDate = "";
    var m_strISPasswordDownloadDate = "";
    var m_strLogShippingDownloadDate = "";
}
