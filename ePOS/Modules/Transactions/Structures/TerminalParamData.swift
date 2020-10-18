//
//  TerminalParamData.swift
//  ePOS
//
//  Created by Naveen Goyal on 06/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public struct TerminalParamData: Codable {
    var m_bIsDataChanged: Bool
    var m_iBatchState: Int = BatchState.BATCH_EMPTY.rawValue
    var iBatchSize: Int = 200
    var m_strTerminalId: String = "" // left padded with 0 if less than 10
    var m_strMerchantId: String = "" // left padded with 0 if less than 10
    var iCurrentBatchId: Int = 9001

    var m_bIsDRPending: Bool
    var m_ulDRLastUploadedROC: Int64
    var m_ulDRLastDownloadedROC: Int64

    var TotalTransactionsOfBatch: Int
    var m_strParamDownloadDate: String = ""
    var m_EMVChipRetryCount: Int
    var m_SecondaryIPMaxRetryCount: Int

    var m_strClientId: String = ""
    var m_strSecurityToken: String = "" // left padded with 0 if less than 10
    var m_strGUID: String = ""

    var m_bIsPPPAlwaysOn: Bool
    var m_bIsTCPAlwaysOn: Bool
    var m_bIsAmexEMVDE55HexTagDataEnable: Bool // _Amex_Gprs_EMV_Field55_Hex_Data_Tag_Enable
    var m_bIsAmexEMVReceiptEnable: Bool // _Amex_Gprs_EMV_Receipt_61_Dump_Enable
    var m_ulSignUploadChunkSize: Int64 // _Sign_Upload_Chunk_size
    var m_ulClessDefPreProcessAmount: Int64 // _Cless_PreProcessing_Amount
    var bArrClessDefPreProcessTxnType = [Byte](repeating: 0, count: 2) // _Cless_PreProcessing_TxnType
    var m_strClessMasterParam: String = "" // bArrClessMasterParam
    var m_strClessVisaParam: String = "" // bArrClessVisaParam
    var m_strClessAmexParam: String = "" // bArrClessAmexParam
    var m_sClessMaestroParam: String = "" // bArrClessMasterParam
    var m_ulClessDefMaxTxnAmount: Int64 // _Cless_PreProcessing_Amount
    var m_ulClessMaxintTxnAmt: Int64 // _Cless_MaxintTxnAmt
    var m_iIsBiometricEnabled: Int // Biometric enabled Flag
    var m_strNoPrintMessage: String = ""
    var m_parityErrorToIgnoredMagSwipe: Int
    var m_iIsCRISEnabled: Int            // //amitesh :: For CRIS/PVR integration
    var m_strMCCEMV: String = ""
    var m_iIsPasswdNeededForSpecificTxns: Bool //ghulam :: for adding functionality of EDC_ISPASSWORD_TXN_MAPPING_DOWNLOAD
    var m_iIsPasswordRequiredForSettlement: Bool
    var m_strSettlementNSpecificTxnsPassword: String = "" //merchant password for settlement and specific transaction

    var m_strHardwareSerialNumber: String = "" //It stores Last 8 digit of IMEI number by default
}

