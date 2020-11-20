//
//  ISO500Settlement.swift
//  ePOS
//
//  Created by Naveen Goyal on 05/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class ISO500Settlement: ISOMessage
{
    static let SUBTEMPLATE_TAG = 1032;
    static let DULICATE_PRINT_TAG = 1033;
    static let PARTIAL_SETTLEMENT = 5055;
    static let MAX_RESPONSE_SETTLEMENT_DATA_LEN = 50000
    
    var m_iChangeNumber: Int = 0
    var m_bCurrentPacketCount: Int = 0
    var m_bTotalPacketCount: Int = 0
    var m_bSettlementPrintData =  [Byte](repeating: 0x00, count: AppConstant.MAX_RESPONSE_SETTLEMENT_DATA_LEN)
    var iCurrentPrintDumpOffset: Int = 0
    var m_bIsPartialSettlement: Bool = false
    
    
    override func packIt(sendee: inout [Byte]) -> Int
    {
        let Global = GlobalData.singleton

        self.vFnSetTerminalActivationFlag(bTerminalActivationFlag: false)
    /*    ***************************************************************************
                  FEILD 0 :: Message Type
        ***************************************************************************/
        self.msgno = [Byte](AppConstant.BATCHCOMPLREQ.utf8)
    /*    ***************************************************************************
                  FEILD 3 :: Batch Id
        ***************************************************************************/
        if(m_iChangeNumber==1)
        {
            _ = addField(bitno: 3, data1: [Byte](ProcessingCodeConstants.PC_SETTLEMENT_START.utf8), bcd: true);
        }
        /*    ***************************************************************************
        FEILD 26 ::BatchId
        ***************************************************************************/
        let m_sParamData: TerminalParamData = Global.ReadParamFile()!
        let strBatchIDTemp: String = String(m_sParamData.iCurrentBatchId)
        let strBatchID = TransactionUtils.StrLeftPad(data: strBatchIDTemp, length: 6, padChar: "0")
        debugPrint("BatchID[\(strBatchID)]")
        _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_26, data1: [Byte](strBatchID.utf8), bcd: true)

        /*    ***************************************************************************
        FEILD 52 ::CSV DATA
        ***************************************************************************/
        debugPrint("GlobalData->m_ptrCSVDATA->bsendData[\(Global.m_ptrCSVDATA.bsendData)]")
        if(true == Global.m_ptrCSVDATA.bsendData)
        {
            _ = addEncryptedLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_52, data1: Global.m_ptrCSVDATA.m_chBillingCSVData, length: Int(TransactionUtils.strlenByteArray(Global.m_ptrCSVDATA.m_chBillingCSVData)))
        }

    /*    ***************************************************************************
                  FEILD 53 ::  Data Def
        ***************************************************************************/
        if(self.m_bCurrentPacketCount > 0){
            var buffer = [Byte](repeating: 0x00, count: 10)
            var iLocalOffset: Int = 0x00
            var b: Int =  m_bCurrentPacketCount

            //Current Packet count 2 bytes
            buffer[iLocalOffset] = Byte((b >> 8) & 0x000000FF)
            iLocalOffset += 1
            buffer[iLocalOffset] = Byte(b & 0x000000FF)
            iLocalOffset += 1
            
            b = Int(m_bTotalPacketCount)

            //Total Packet count 2 bytes
            buffer[iLocalOffset] = Byte((b >> 8) & 0x000000FF)
            iLocalOffset += 1
            buffer[iLocalOffset] = Byte(b & 0x000000FF)
            iLocalOffset += 1
                
            _ = self.addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_53, data1: buffer, length: iLocalOffset);
            debugPrint("Req->Setting field 53")
        }

        return self.packItHost(sendee: &sendee)

    }
    
    //MARK:- ProcessSettlementReport() -> Bool
    private func ProcessSettlementReport() -> Bool
    {
        let p: [Byte] = data[62-1]
        let length: Int = len[62-1]

        let globalData = GlobalData.singleton
        if(!IsOK())
        {
            if(bitmap[58-1]==false) {
                GlobalData.m_bIsFiled58Absent = true
            }
            else {
                GlobalData.m_csFinalMsgBatchSettlement = GlobalData.m_csFinalMsgDisplay58;
            }

            m_bIsPartialSettlement = false;

            guard let strRespCode: String = String(bytes: data[39 - 1], encoding: .utf8) else{return false}
            
            if (!(self.data[39-1].isEmpty) && strRespCode.caseInsensitiveCompare(AppConstant.AC_DRDUMPREQ) == ComparisonResult.orderedSame)
            {
                var m_sParamData: TerminalParamData  = globalData.ReadParamFile()!
                m_sParamData.m_bIsDRPending = true;
                _ = globalData.WriteParamFile(listParamData: m_sParamData)
                return true;
            }

            //Unlock batch -- in all other cases.
            _ = globalData.UnlockBatch()

            if(!(self.data[39-1].isEmpty) && strRespCode.caseInsensitiveCompare(AppConstant.AC_PARTIAL_SETTLEMENT) == ComparisonResult.orderedSame) {
                m_bIsPartialSettlement = true;
            }
            else {
                //If DR is not requested and Field 39 is not 0000 return false
                return false;
            }
        }

        if (bitmap[62 - 1] && bitmap[53 - 1]) {

            if (iCurrentPrintDumpOffset + length < AppConstant.MAX_RESPONSE_SETTLEMENT_DATA_LEN) {
                m_bSettlementPrintData = [Byte](p[iCurrentPrintDumpOffset ..< iCurrentPrintDumpOffset + length])
                //System.arraycopy(p, 0, m_bSettlementPrintData, iCurrentPrintDumpOffset, length)
                iCurrentPrintDumpOffset += length;
            }

            let pChargeSlipDataVal: [Byte] = data[53 - 1]
            let ilength: Int = len[53 - 1]
            
            if (ilength >= 2) {
                var offset: Int = 0
                self.m_bCurrentPacketCount = Int(Int(pChargeSlipDataVal[offset] << 8) & Int(0x0000FF00))
                offset += 1
                self.m_bCurrentPacketCount |= Int(pChargeSlipDataVal[offset] & 0x000000FF)
                offset += 1

                self.m_bTotalPacketCount = Int(Int(pChargeSlipDataVal [offset] << 8) & Int(0x0000FF00))
                offset += 1
                self.m_bTotalPacketCount |= Int((pChargeSlipDataVal [offset]) & 0x000000FF)
                offset += 1

                debugPrint("Response->Field 53 found")
            }

            if (self.m_bCurrentPacketCount == self.m_bTotalPacketCount)
            {
                //PrinterDemo first
                SaveDumpForAll()

                let chSettlementFileName = String(format: "%@", FileNameConstants.SETTLEMENTPRINTFILENAME)
               debugPrint("Settlement PrinterDemo file name[\(chSettlementFileName)]")

                if (!m_bIsPartialSettlement)
                {
                    ResetROC()
                    ProcessBatchState()
                    ProcessBatchId()
                }
            }
        }
        else
        {
            debugPrint("ERROR no::field 61 and 53 found for Settlement Report")
            return false;
        }

        return true;
    }
    
    
    //MARK:- SaveDumpForAll()
    private func SaveDumpForAll()
    {
        debugPrint("Inside SaveDumpForAll")

        let iPrintingLocation: Int = GetEDCPrintingLocation()

        debugPrint("iPrintingLocation[\(iPrintingLocation)]");
        if(iPrintingLocation == 0)
        {
            if(m_bField7PrintPAD)
            {
                SaveDumptoFileForPADPrinting()
            }
            else
            {
                let globalData = GlobalData.singleton
                globalData.m_bPrinterData = m_bSettlementPrintData;
                globalData.m_iPrintLen = iCurrentPrintDumpOffset;
                SaveDumptoFile(iPrintingLocation);
            }
        }
        else if(iPrintingLocation == AppConstant.EDCPrint)
        {
            SaveDumptoFile(iPrintingLocation);
        }
        else if(iPrintingLocation == AppConstant.POSprint)
        {
            SaveDumptoFileForPADPrinting();
        }
        else if(iPrintingLocation == AppConstant.NOPrint)
        {
            SaveDumptoFile(iPrintingLocation);
        }
    }
    
    //MARK:- SaveDumptoFileForPADPrinting()
    func SaveDumptoFileForPADPrinting()
    {
        let m_ByteArray: [Byte] = m_bSettlementPrintData;
        _ = iCurrentPrintDumpOffset;
        
        let chPADSettlementFileName = String(format: "%@", FileNameConstants.PADSETTLEMENTPRINTFILENAME)
        debugPrint("PAD Settlement PrinterDemo file name[\(chPADSettlementFileName)]");
        
        if(true == FileSystem.IsFileExist(strFileName: chPADSettlementFileName))
        {
            _ = FileSystem.DeleteFileComplete(strFileName: chPADSettlementFileName);
            debugPrint("DeleteFile[\(chPADSettlementFileName)]")
        }
        
        do{
            _ = try FileSystem.AppendFile(strFileName: chPADSettlementFileName, with: m_ByteArray)
        }catch{
            debugPrint("Error in AppendFile \(chPADSettlementFileName)")
        }
    }
    
    //MARK:- SaveDumptoFile(_ iPrintingLocation: Int)
    private func SaveDumptoFile(_ iPrintingLocation: Int)
    {
        let strSettlementFileName = String(format: "%@", FileNameConstants.SETTLEMENTPRINTFILENAME).trimmingCharacters(in: .whitespacesAndNewlines)
        debugPrint("Settlement PrinterDemo file name[\(strSettlementFileName)]")

        if(true == FileSystem.IsFileExist(strFileName: strSettlementFileName))
        {
            //should not come here
            _ = FileSystem.DeleteFileComplete(strFileName: strSettlementFileName)
            debugPrint("DeleteFile[\(strSettlementFileName)]")
        }

        if(iPrintingLocation != 3)
        {
            //CFileSystem.AppendFile(m_cntx,new String(chSettlementFileName),ByteArrayObj2, ByteArray[].class);
            do{
                _ = try FileSystem.AppendFile(strFileName: strSettlementFileName, with: m_bSettlementPrintData)
            }
            catch{
                debugPrint("Error in AppendFile \(strSettlementFileName)")
            }
        }
        else
        {
            var m_ByteArray = [Byte](repeating: 0x00, count: 100)
            
            var ioffset: Int = 0
            var EmptyData = [Byte](repeating: 0x00, count: 30)
            let bEmptyData: [Byte] = [Byte]("    No PrinterDemo Enabled   ".utf8)
            EmptyData = [Byte](bEmptyData[0 ..< bEmptyData.count])
        
            //System.arraycopy("    No PrinterDemo Enabled    ", 0, EmptyData, 0, "    No PrinterDemo Enabled    ".length());
            let templen: Int = EmptyData.count //strlen(EmptyData);

            m_ByteArray[ioffset] = Byte(PrintMode.RAWMODE)
            ioffset += 1
            ioffset += 2
            let lenoffset = ioffset

            m_ByteArray[ioffset] = Byte(PrintAttribute.PRINT_NORMAL_24)
            ioffset += 1

            m_ByteArray[ioffset] = Byte(((templen+1) >> 8) & 0x000000FF);
            ioffset += 1

            m_ByteArray[ioffset] = Byte((templen + 1) & 0x000000FF);
            ioffset += 1

            m_ByteArray = [Byte](EmptyData[ioffset ..< ioffset + templen])
            //System.arraycopy(EmptyData, 0, ByteArrayObj1.m_ByteArray, ioffset, templen);

            ioffset += templen;

            m_ByteArray[ioffset] = 0x0A;
            ioffset += 1
            let datalen: Int = ioffset - lenoffset;
            m_ByteArray[1] = Byte((datalen >> 8) & 0x000000FF)
            m_ByteArray[2] = Byte((datalen) & 0x000000FF)
            
            debugPrint("data saved len[%d]", ioffset);
            debugPrint(ioffset, /*PrintingData*/m_ByteArray);

            do{
                _ = try FileSystem.AppendFile(strFileName: strSettlementFileName,with: m_ByteArray)
            }
            catch
            {
                debugPrint("Error in AppendFile \(error)")
            }
           // CFileSystem.AppendFile(m_cntx,new String(chSettlementFileName),ByteArrayObj1,ByteArray[].class/*ioffset*/);
        }
    }
        
    
    //MARK:- DeleteDumpFile()
    static func DeleteDumpFile()
    {
        let strSettlementFileName = String(format: "%s",FileNameConstants.SETTLEMENTPRINTFILENAME)
        debugPrint("Settlement PrinterDemo file name[\(strSettlementFileName)]")
        _ = FileSystem.DeleteFileComplete(strFileName: strSettlementFileName)
    }
    
    //MARK:- ResetROC()
    private func ResetROC(){
        
        let strTxnFileName = String(format: "%s", FileNameConstants.TRANSACTIONFILENAME);
        
        let listTxnData: [TerminalTransactionData] = FileSystem.ReadFile(strFileName: strTxnFileName)!
        if(listTxnData != nil || !listTxnData.isEmpty) {
            
            for txnData in listTxnData
            {
                let tempData: TerminalTransactionData = txnData
                let iFileIndex: Int = Int(10001000 + tempData.ulROC);
                let SignatureIndexFile = String(format: "im%08d", iFileIndex);
                _ = FileSystem.DeleteFileComplete(strFileName: SignatureIndexFile);
            }
        }
        
        //delete sign files if remains forcefully
        DeleteSignatureFiles()
        _ = FileSystem.DeleteFileComplete(strFileName: strTxnFileName)
        
        let strDRTxnFileName = String(format: "%s", FileNameConstants.DRTXNFILENAME)
        _ = FileSystem.DeleteFileComplete(strFileName: strDRTxnFileName)
    }
    
    
    //MARK:- ProcessBatchState()
    private func ProcessBatchState(){
        //store this as the current batch id in Global Data
        let globalData = GlobalData.singleton
        _ = globalData.ClearBatch()
    }
    
    //MARK:- DeleteSignatureFiles()
    private func DeleteSignatureFiles()
    {
        debugPrint("Inside DeleteSignatureFiles")
        let strTxnFileName = String(format: "%@", FileNameConstants.TRANSACTIONFILENAME);
        
        let listTxnData: [TerminalTransactionData] = FileSystem.ReadFile(strFileName: strTxnFileName)!
        if(listTxnData != nil || !listTxnData.isEmpty) {
            
            for txnData in listTxnData
            {
                let tempData: TerminalTransactionData = txnData
                let iFileIndex: Int = Int(10001000 + tempData.ulROC);
                let SignatureIndexFile = String(format: "im%08d", iFileIndex);
                _ = FileSystem.DeleteFileComplete(strFileName: SignatureIndexFile);
            }
        }
        
    }
    
    //MARK:- ProcessBatchId()
    private func ProcessBatchId()
    {
        var chArrTempBatch = [Byte](repeating: 0x00, count: data[26-1].count)
        chArrTempBatch = [Byte](data[26-1][0 ..< data[26-1].count])
        
        //System.arraycopy(data[26-1],0,chArrTempBatch,0,data[26-1].length);
        let ulBatchID: Int16 = Int16(atoi(String(bytes: chArrTempBatch, encoding: .ascii)!)) //strtoul(chArrTempBatch, NULL, 10);
        //store this as the current batch id in Global Data
        
        let  globalData = GlobalData.singleton
        var m_sParamData = TerminalParamData()
        
        m_sParamData = globalData.ReadParamFile()!
        m_sParamData.iCurrentBatchId = Int(ulBatchID)
        m_sParamData.TotalTransactionsOfBatch = 0
        m_sParamData.m_ulDRLastDownloadedROC = 0
        m_sParamData.m_ulDRLastUploadedROC = 0
        debugPrint("ulBatchID[\(ulBatchID)]")
        _ = globalData.WriteParamFile(listParamData: m_sParamData)
    }

    private func Start(){
        m_iChangeNumber = 1
        m_bCurrentPacketCount = 0x00
        iCurrentPrintDumpOffset = 0x00
    }

    
    //MARK:- ProcessData() -> Bool
    private func ProcessData() -> Bool
    {
        debugPrint("Inside ProcessData")
        _ = GetCSVReponseData()

        if(bitmap[ISOFieldConstants.ISO_FIELD_7 - 1]){
            setField7PrintPAD()
        }
        //for testing setting field 7 true. should be removed
        if(m_iChangeNumber == 0x01)
        {
            debugPrint("m_iChangeNumber[0x01]")
            if(data[3-1].elementsEqual(ProcessingCodeConstants.PC_SETTLEMENT_START.utf8) ||
                data[3-1].elementsEqual(ProcessingCodeConstants.PC_SETTLEMENT_END.utf8))
            {
                if(!ProcessSettlementReport()){
                    return false;
                }
            }else
            {
                debugPrint("INVALID PROCESSING CODE");
                //CUIHelper.SetMessageWithWait("INVALID PROCESSING CODE");
                return false;
            }
        }

        switch(m_iChangeNumber){
            case 1:
                if(data[3-1].elementsEqual(ProcessingCodeConstants.PC_SETTLEMENT_END.utf8)) {
                m_bCurrentPacketCount = 0;
                m_bTotalPacketCount = 0;
                m_iChangeNumber += 1
            }
            default:
                break
        }

        return true;
    }
    
    
    //MARK:- GetCSVReponseData() -> Int
    private func GetCSVReponseData() -> Int
    {
        debugPrint("Inside GetCSVReponseData");
        //CSV data shall not come in MultiPacket response
        //Otherwise Newer response will be copied
        //This Function return only wether more data can be accomodated or not.
        //Normal retrun is to be RESPONSE_DATA_FINISHED
        //In case of error :RESPONSE_DATA_EXCEEDS_LENGTH

        let  globalData = GlobalData.singleton
        //TODO: ISO 220 yet to implement
        //int iReturnee = ISO220ResponseDataRetVal.RESPONSE_DATA_FINISHED.getValue();
        let iReturnee: Int = 0
        
        //Check for CSV data
        if(bitmap[52-1])
        {
            let iCSVlen: Int = len[52-1]
            let p1: [Byte]    = data[52-1]

            //Initialize the CSV data packet
            debugPrint("iCSVlen[\(iCSVlen)]");
            //memset(GlobalData.m_ptrCSVDATA.m_chBillingCSVData,0x00,AppConst.MAX_CSV_LEN);

            if(iCSVlen < AppConstant.MAX_CSV_LEN)
            {
                //memcpy(GlobalData->m_ptrCSVDATA->m_chBillingCSVData,p1,iCSVlen);
                
                globalData.m_ptrCSVDATA.m_chBillingCSVData = [Byte](p1[0 ..< iCSVlen])
                //System.arraycopy(p1,0,GlobalData.m_ptrCSVDATA.m_chBillingCSVData,0,iCSVlen);
                globalData.m_ptrCSVDATA.bCSVreceived = true;
                debugPrint("RECEIVED_CSV_DATA");
                debugPrint("CSV[\(String(bytes: globalData.m_ptrCSVDATA.m_chBillingCSVData, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines))]");
            }
            else
            {
                //CUIHelper.SetMessageWithWait("Very LARGE CSV DATA");
                //TODO: ISO 220 yet to implement
                //iReturnee = ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH.getValue();
            }
        }

        return iReturnee;
    }
    
    //MARK:- DeleteDumpFileForPADPrinting()
    static func DeleteDumpFileForPADPrinting()
    {
        let strPADSettlementFileName = String(format: "%s",FileNameConstants.PADSETTLEMENTPRINTFILENAME)
        debugPrint("PAD Settlement PrinterDemo file name[\(strPADSettlementFileName)]")
        _ = FileSystem.DeleteFileComplete(strFileName: strPADSettlementFileName)
    }
    
    //MARK:- AfterDataExchange() -> Bool
    private func AfterDataExchange() -> Bool
    {
        do{
            debugPrint("Inside AfterDataExchange");
            let retVal: Bool = true;
            let globalData = GlobalData.singleton;
        
            if (m_bField7PrintPAD)
            {
                if (true == globalData.m_ptrCSVDATA.bsendData)
                {
                    var bStatus: Byte = 0x01;
                    if (false == globalData.m_ptrCSVDATA.bCSVreceived)
                    {
                        globalData.m_ptrCSVDATA.m_chBillingCSVData = [Byte](repeating: 0x00, count: AppConstant.MAX_CSV_LEN)
                        //Arrays.fill(GlobalData.m_ptrCSVDATA.m_chBillingCSVData, (byte)0x00);
                        bStatus = 0x00;
                    }
                    globalData.m_ptrCSVDATA.bStatus = bStatus;
                    if (CSVHandler.m_iRecCSVRequestMode != CSVHandler.CSV_TXN_REQUEST_FROM_LOCAL_BILLING_APP)
                    {
                        CSVHandler.singleton.m_objCSVTxn!.SendResponseLocation = CSVBaseTxn.enSendResponseLocation.BEFORE_PRINT_CHARGESLIP;
                    }
                }
            }
            else
            {
                if (true == globalData.m_ptrCSVDATA.bsendData)
                {
                    var bStatus: Byte = 0x01
                    if (false == globalData.m_ptrCSVDATA.bCSVreceived)
                    {
                        globalData.m_ptrCSVDATA.m_chBillingCSVData = [Byte](repeating: 0x00, count: AppConstant.MAX_CSV_LEN)
                        //Arrays.fill(GlobalData.m_ptrCSVDATA.m_chBillingCSVData, (byte)0x00);
                        bStatus = 0x00;
                    }
                    globalData.m_ptrCSVDATA.bStatus = bStatus;
                    CSVHandler.singleton.m_objCSVTxn!.SendResponseLocation = CSVBaseTxn.enSendResponseLocation.AFTER_PRINT_CHARGESLIP
                }
            }
            return retVal;
        }
        catch
        {
            debugPrint("Exception Occurred : \(error)");
            return false;
        }
    }
    
    
}
