//
//  TerminalParamData.swift
//  ePOS
//
//  Created by Abhishek on 12/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public struct TerminalParamData:Codable {
    var m_bIsDataChanged = false;
    var m_iBatchState = BatchState.BATCH_EMPTY;
    var iBatchSize = 200;
    var m_strTerminalId = ""; // left padded with 0 if less than 10
    var m_strMerchantId = ""; // left padded with 0 if less than 10
    var iCurrentBatchId = 9001;
    
    var m_bIsDRPending = false;
    var m_ulDRLastUploadedROC = false;
    var m_ulDRLastDownloadedROC = false;
    
    var TotalTransactionsOfBatch = 0 ;
    var m_strParamDownloadDate = "";
    var m_EMVChipRetryCount = 0 ;
    var m_SecondaryIPMaxRetryCount = 0;
    
    var m_strClientId = "";
    var m_strSecurityToken = ""; // left padded with 0 if less than 10
    var m_strGUID = "";
    
    var m_bIsPPPAlwaysOn = false;
    var m_bIsTCPAlwaysOn = false;
    var m_bIsAmexEMVDE55HexTagDataEnable = false; // _Amex_Gprs_EMV_Field55_Hex_Data_Tag_Enable
    var m_bIsAmexEMVReceiptEnable = false; // _Amex_Gprs_EMV_Receipt_61_Dump_Enable
    var m_ulSignUploadChunkSize = false; // _Sign_Upload_Chunk_size
    var m_ulClessDefPreProcessAmount = false ; // _Cless_PreProcessing_Amount
    var bArrClessDefPreProcessTxnType:[UInt8] = [0]   // _Cless_PreProcessing_TxnType
    var m_strClessMasterParam = ""; // bArrClessMasterParam
    var m_strClessVisaParam = ""; // bArrClessVisaParam
    var m_strClessAmexParam = ""; // bArrClessAmexParam
    var m_sClessMaestroParam = ""; // bArrClessMasterParam
    var m_ulClessDefMaxTxnAmount:Int64 = 0; // _Cless_PreProcessing_Amount
    var m_ulClessMaxintTxnAmt:Int64 = 0 ; // _Cless_MaxintTxnAmt
    var m_iIsBiometricEnabled = 0; // Biometric enabled Flag
    var m_strNoPrintMessage = "";
    var m_parityErrorToIgnoredMagSwipe = 0;
    var m_iIsCRISEnabled = 0 ;            // //amitesh :: For CRIS/PVR integration
    var m_strMCCEMV = "";
    var m_iIsPasswdNeededForSpecificTxns = false ; //ghulam :: for adding functionality of EDC_ISPASSWORD_TXN_MAPPING_DOWNLOAD
    var m_iIsPasswordRequiredForSettlement = false;
    var m_strSettlementNSpecificTxnsPassword = ""; //merchant password for settlement and specific transaction
    
    var m_strHardwareSerialNumber = ""; //It stores Last 8 digit of IMEI number by default
}

