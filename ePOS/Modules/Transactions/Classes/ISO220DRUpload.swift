//
//  ISO220DRUpload.swift
//  ePOS
//
//  Created by Vishal Rathore on 26/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CISO220DRUpload: CISO220
{
    private var bRecordNumUpdated: Bool = false
    private var iRecordNum: Int = 0
   
    override init(){
        super.init() //Have to ASK
        
        bRecordNumUpdated = false
        iRecordNum = 0
    }

    
    override func SetTransactionRequestData()
    {
        debugPrint("DRUpload:SetTransactionRequestData")
        /******************************************************************************
         *     Field 61 : DR Dump for each ROC
         *****************************************************************************/
        //set dump here
        _ = GetDRDump()
    }
    
    public override func GetTransactionResponse() -> Bool
    {
        debugPrint("DRUpload:GetTransactionResponse")
        if(IsOK()){
            return true
        }
        return false
    }
    
    public override func AfterDataExchange() -> Int
    {
        debugPrint("DRUpload:AfterDataExchange")
        return 1
    }
    
    func GetDRDump() -> Int {
        debugPrint("DRUpload:GetDRDump")
        
        var iRet: Bool = false// 0

        var bContinue: Bool = true
        let  globalData = GlobalData.singleton
        var tParamData = TerminalParamData()
        //memset(&tParamData, 0x00 , sizeof(TerminalParamData))
        tParamData  = globalData.ReadParamFile()!

        let ulROC: Int64 = tParamData.m_ulDRLastUploadedROC
        let iTotalNumRecords: Int = globalData.GetNumRecordsTxnEntry()

        var tTxnData = TerminalTransactionData()
        //memset(&tTxnData, 0x00, sizeof(TerminalTransactionData))

        //sprintf(chDRTxnFileName,"%s%d.txt",AppConst.DRTXNFILENAME,iHostID)
        //sprintf(chDRTxnFileName,"%s%d.txt",DRTXNFILENAME,m_iHostID)
        let res = String(format: "%@",FileNameConstants.DRTXNFILENAME)
        debugPrint("DRtxn file name[\(res)]")


        //RUN in loop while we get a DR data to upload
        repeat {

            //memset(&tTxnData, 0x00, sizeof(TerminalTransactionData))

            if (!bRecordNumUpdated) {
                // Fetch Record on the basis of ROC returned by HOST
                var recordno = Int()
                recordno = iRecordNum
                iRet = globalData.ReadTxnEntryByROC(&tTxnData, ulROC, &recordno)
                iRecordNum = recordno
                if(false == iRet){   //FALSE
                    return 0    //FALSE
                }
                bRecordNumUpdated = true
            } else {
                // Continue Fetching Other ROCs
                if(iTotalNumRecords < iRecordNum)
                {
                    break
                }
                _ = globalData.ReadTxnEntryByRecordNum(&tTxnData, iRecordNum)
            }

            if (tTxnData.iDRLength > 0)
            {
            /*    ***************************************************************************
                FEILD 11 ::ROC
                ***************************************************************************/
                let strROC = "\(tTxnData.ulROC)"
                let strROCTemp = TransactionUtils.StrLeftPad(data: strROC, length: 4, padChar: "0")
                debugPrint("GetDRDump ROC#: \(strROCTemp)")
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_11, data1: [Byte](strROCTemp.utf8), bcd: true)

            /*    ***************************************************************************
                FEILD 26 ::BatchId
                ***************************************************************************/

                let strBatchID = "\(tTxnData.ulBatchId)"
                let strBatchIDTemp = TransactionUtils.StrLeftPad(data: strBatchID, length: 6, padChar: "0")
                debugPrint("GetDRDump::BatchId#: \(strBatchIDTemp)")
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_26, data1: [Byte](strBatchIDTemp.utf8), bcd: true)


                /*    ***************************************************************************
                    FEILD 61 ::DR DUMP
                    ***************************************************************************/


                var bLocalBuffer = [Byte](repeating: 0x00, count: tTxnData.iDRLength + 1)// (BYTE*) umalloc(tTxnData.iDRLength + 1)

                var tempData = [[Byte]]()
                tempData = FileSystem.SeekRead(strFileName: res, iOffset: tTxnData.iDrOffset)!

                _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61,  data1: bLocalBuffer, length: tTxnData.iDRLength)
                bLocalBuffer = [Byte](repeating: 0x00, count: tTxnData.iDRLength + 1)
                debugPrint("Req->Setting field 61")
                bContinue = false
                iRecordNum += 1
            } else {
                iRecordNum += 1
            }

        } while (bContinue)


        //If we have finished send PROC CODE END
        if(iTotalNumRecords < iRecordNum)
        {
            debugPrint("iTotalNumRecords[%d] < iRecordNum[%d]", iTotalNumRecords, iRecordNum)
            debugPrint("Req->Setting field 3")
            _ = self.addField(bitno: 3, data1: [Byte](ProcessingCodeConstants.PC_DR_DATA_UPLOAD_END.utf8), bcd: true)
        }else if(tParamData.m_ulDRLastDownloadedROC == tTxnData.ulROC)
        {
            //in that case end proc code would be sent
            debugPrint("tParamData.m_ulDRLastDownloadedROC[\(tParamData.m_ulDRLastDownloadedROC)] == tTxnData.ulROC[\(tTxnData.ulROC)]")
            debugPrint("Req->Setting field 3")
            _ = self.addField(bitno: 3, data1: [Byte](ProcessingCodeConstants.PC_DR_DATA_UPLOAD_END.utf8), bcd: true)
        }else{
            debugPrint("Req->Setting field 3")
            _ = self.addField(bitno: 3, data1: [Byte](ProcessingCodeConstants.PC_DR_DATA_UPLOAD_START.utf8), bcd: true)
        }

        return 1
    }
    
}
