//
//  ISO220SwipeTxn.swift
//  ePOS
//
//  Created by Vishal Rathore on 23/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CISO220SwipeTxn: CISO220
{
    override init() {
        super.init() 
    }
    
    public override func SetTransactionRequestData()
    {
        do
        {
            debugPrint("Inside SetTransactionRequestData")
            let globalData = GlobalData.singleton
            var buffer = [Byte](repeating: 0x00, count: 50)

            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_ONLINE_TRANSACTION_REQ.utf8), bcd: true)

            let strROC: String = "\(m_ulCurrentRoc!)"
            let strROCTemp: String = TransactionUtils.StrLeftPad(data: strROC, length: 4, padChar: "0")
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_11, data1: [Byte](strROCTemp.utf8), bcd: true)

            let strBatchID = "\(m_ulBatchId!)"
            let strBatchIDTemp = TransactionUtils.StrLeftPad(data: strBatchID, length: 6, padChar: "0")
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_26, data1: [Byte](strBatchIDTemp.utf8), bcd: true)

            debugPrint("BatchID[\(strBatchID)], ROC[\(strROCTemp)]")

            //FEILD 48 ::Transaction Type
            if (true != globalData.m_ptrCSVDATA.bsendData)
            {            
                buffer = [Byte](repeating: 0x00, count: 50)
                if (globalData.m_sNewTxnData.uiTransactionType != 0)
                {
                    buffer[0] = Byte((globalData.m_sNewTxnData.uiTransactionType >> 8) & 0x000000ff)
                    buffer[1] = Byte((globalData.m_sNewTxnData.uiTransactionType) & 0x000000ff)
                    debugPrint("Transaction Type[\(globalData.m_sNewTxnData.uiTransactionType)]")
                    _ = self.addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_48, data1: buffer, length: 2)
                }
                else {
                    debugPrint("ERROR Transaction Type NOT SET")
                }

            }

            // FEILD 52 ::CSV DATA
            debugPrint("SetTransactionRequestData GlobalData.m_ptrCSVDATA.bsendData[\((globalData.m_ptrCSVDATA.bsendData))]")
            if (globalData.m_ptrCSVDATA.bsendData) {
                _ = addEncryptedLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_52, data1: globalData.m_ptrCSVDATA.m_chBillingCSVData, length: Int(TransactionUtils.strlenByteArray(globalData.m_ptrCSVDATA.m_chBillingCSVData)))
            }

            //FEILD 61 ::Transaction Data
            
            
            
            var iLocalOffset: Int = 0x00
            var iTotalNodes: Int = 0
            var iTag: Int = 0x00
            var iTagValLen: Int = 0x00
            iTotalNodes = globalData.m_sTxnTlvData.iTLVindex
            debugPrint("FEILD 61 Transaction Data::TotalTlvs[\(iTotalNodes)]")
            var Tranxbuffer: [Byte]?
            if (iTotalNodes > 0) {
                Tranxbuffer = [Byte](repeating: 0x00, count: iTotalNodes * 204)
            }
            if (Tranxbuffer != nil)
            {
                iLocalOffset = 0x00
                for i in 0 ..< iTotalNodes {
                    iTag = globalData.m_sTxnTlvData.objTLV[i].uiTag

                    Tranxbuffer![iLocalOffset] = Byte(((iTag) >> 8) & 0x000000FF)
                    iLocalOffset += 1
                    Tranxbuffer![iLocalOffset] = Byte(((iTag)) & 0x000000FF)
                    iLocalOffset += 1
                    iTagValLen = ((globalData.m_sTxnTlvData.objTLV[i].uiTagValLen))
                    Tranxbuffer![iLocalOffset] = Byte(((iTagValLen >> 8) & 0x000000FF))
                    iLocalOffset += 1
                    Tranxbuffer![iLocalOffset] = Byte(((iTagValLen) & 0x000000FF))
                    iLocalOffset += 1
                    
                    
                    Tranxbuffer![iLocalOffset ..< iLocalOffset + iTagValLen] = globalData.m_sTxnTlvData.objTLV[i].chArrTagVal[0 ..< iTagValLen]
                    //System.arraycopy(GlobalData.m_sTxnTlvData.objTLV[i].chArrTagVal, 0, Tranxbuffer, iLocalOffset, iTagValLen)
                    iLocalOffset += iTagValLen
                    debugPrint("TAG[\(iTag)] TAG LENGTH = [\(iTagValLen)] TAG VALUE = [\(globalData.m_sTxnTlvData.objTLV[i].chArrTagVal)]")

                }
                debugPrint("TRANSACTION DATA,Feild 61 :Total TLV length = \(iLocalOffset)")
            }
            if (iLocalOffset > 0) {
                var iLocalOffset1 = Int()
                iLocalOffset1 = iLocalOffset
                
                var tempData: [Byte]
                tempData = [Byte](Tranxbuffer![0 ..< iLocalOffset1])
                
                let hexString = TransactionUtils.byteArray2HexString(arr: tempData)
                debugPrint("plain Data \(hexString)")
                
                _ = addEncryptedLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61, data1: tempData, length: iLocalOffset1)
            }

            /*    ***************************************************************************
            FEILD 54 ::Data to replay
            ***************************************************************************/
            if (CISO220.m_bDataToReplay!) {
                debugPrint("Req->Setting field 54")
                _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_54, data1: CISO220.m_bArrDataToReplay, length: CISO220.m_iReplayDataLen!)
                CISO220.m_bDataToReplay = false
            }
        }
        catch
        {
            debugPrint("Error Occurred \(error)")
        }

    }

    public override func GetTransactionResponse() -> Bool
    {
        do {
            var bFoundAmex61Dump: Bool = false
            debugPrint("Inside GetTransactionResponse")
            let globalData = GlobalData.singleton
            
            if (false == IsOK()) {
                debugPrint("TXN DECLINED")
                /*TerminalTransactionData nsLastTxnData = GlobalData.ReadLastTxnEntry(m_iHostID)
                nsLastTxnData.status = PlutusTransactionStatus.TRANSACTION_STATUS_FAILURE
                GlobalData.UpDateLastTxnEntry(nsLastTxnData, m_iHostID)*/
                return false
            }else{
                //for transaction history
                //set transacion status
                var nsLastTxnData: TerminalTransactionData = globalData.ReadLastTxnEntry()!
                nsLastTxnData.status = PlutusTransactionStatus.TRANSACTION_STATUS_SUCCESS
                globalData.appendNewTxn(nsLastTxnData)
            }

            debugPrint("TXN RESPONSE OK")

            if ((true == globalData.m_ptrCSVDATA.bsendData) && (true != globalData.m_ptrCSVDATA.bPrintingFlag)) {
                var nsLastTxnData: TerminalTransactionData = globalData.ReadLastTxnEntry()!
                nsLastTxnData.bIsReversalPending = false
                _ = globalData.UpDateLastTxnEntry(nsLastTxnData)
                return true
            } else {
                //Check for field 61
                if (bitmap[61 - 1] != false && len[61 - 1] > 0) {
                    bFoundAmex61Dump = true
                    SaveDumptoFileAMEXGPRS()
                    m_iPrintDataPrintedAmexEMVSale = 0
                } else {
                    bFoundAmex61Dump = false
                }
                if (bFoundAmex61Dump == false) {
                    if (bitmap[62 - 1] == false) {
                        debugPrint("GetTransactionResponse Feild 62 not found ")
                        return false
                    }
                    SaveDumpForAll()
                    m_iPrintDataPrinted = AppConstant.FALSE
                }

                //SAVE DR DATA DUMP
                if (m_iCurrentDRDataDumpOffset > 0) {
                    SaveDRDumpToFile()
                }
                RenameSignatureFile()
                //Save Signature Image Dump to file
                if (m_iCurrentSignatureImageDumpOffset > 0) {

                    SaveSigDumpToFile()
                }
                if (true == globalData.m_ptrCSVDATA.bsendData) {
                    //clear reversal
                    _ = CISO220.ClearReversal()
                    m_iPrintDataPrinted = AppConstant.TRUE
                    return true
                }
            }
            return true
        }
        catch
        {
            debugPrint("Error Occurred \(error)")
            return false
        }
    }

    override func AfterDataExchange() -> Int
    {
        let globalData  = GlobalData.singleton
        _ = CISO220.ClearReversal()

        //Change for FG Pos Printing to be done Before sending CSV
        if (!m_bField7PrintPAD)
        {
            //Now Process The response and print the slip till all the data is printed
            if (true == globalData.m_ptrCSVDATA.bsendData)
            {
                //check whether we have got any CSV response back
                //if not just send empty data
                if (false == globalData.m_ptrCSVDATA.bCSVreceived)
                {
                    globalData.m_ptrCSVDATA.m_chBillingCSVData = [Byte](repeating: 0x00, count: AppConstant.MAX_CSV_LEN)
                    //Arrays.fill(GlobalData.m_ptrCSVDATA.m_chBillingCSVData, (byte)0x00)
                }
                var bStatus: Byte = 0x01
                if (m_iReqState == ISO220RequestState.ONLINE_REQUEST_TXN_ERR_TERMINATED)
                {
                    bStatus = 0x00
                }
                globalData.m_ptrCSVDATA.bStatus = bStatus
                if (CSVHandler.m_iRecCSVRequestMode != CSVHandler.CSV_TXN_REQUEST_FROM_LOCAL_BILLING_APP) {
                    CSVHandler.singleton.m_objCSVTxn!.SendResponseLocation = CSVBaseTxn.enSendResponseLocation.BEFORE_PRINT_CHARGESLIP
                }
            }
        }
        else
        {
            //Now Process The response and print the slip till all the data is printed
            if (true == globalData.m_ptrCSVDATA.bsendData)
            {
                //check whether we have got any CSV response back
                //if not just send empty data
                if (false == globalData.m_ptrCSVDATA.bCSVreceived)
                {
                    globalData.m_ptrCSVDATA.m_chBillingCSVData = [Byte](repeating: 0x00, count: AppConstant.MAX_CSV_LEN)
                    //Arrays.fill(GlobalData.m_ptrCSVDATA.m_chBillingCSVData, (byte)0x00)
                }
                var bStatus: Byte = 0x01
                if (m_iReqState == ISO220RequestState.ONLINE_REQUEST_TXN_ERR_TERMINATED)
                {
                    bStatus = 0x00
                }
                globalData.m_ptrCSVDATA.bStatus = bStatus
                CSVHandler.singleton.m_objCSVTxn!.SendResponseLocation = CSVBaseTxn.enSendResponseLocation.AFTER_PRINT_CHARGESLIP
            }
        }
        //Initialize TLV data for txn
        _ = globalData.InitializeTxnTlvData()
        return AppConstant.TRUE
    }
    
}
