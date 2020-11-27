//
//  ISO800.swift
//  ePOS
//
//  Created by Vishal Rathore on 25/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CISO800: ISOMessage
{
    public var m_iLastRoc: Int?
    public var m_iBatchId: Int?
    
    public override init(){
        super.init() //Have to ASK
    }
    
    public func CISO800C(){
        self.CISOMsgC()
    }
    
    public func packIt(_ bArrSendDataToHost: inout [Byte]) -> Int
    {
        do
        {
            debugPrint("CISO800::packIt Inside method packit")
            // Filling the required data.*************************
            msgno = [Byte](ProcessingCodeConstants.NETWORKRECOVERYREQ.utf8)
            /*    ***************************************************************************
                  FIELD 3 :: PROC CODE
             ***************************************************************************/
            _ = addField(bitno: 3, data1: [Byte](ProcessingCodeConstants.PC_GET800DATA_REQ.utf8), bcd: true)


            SetROCandBatchId()
            /*    ***************************************************************************
            FIELD 11 ::ROC
            ***************************************************************************/
            let strROC = "\(String(describing: m_iLastRoc))"
            let strROCTemp = TransactionUtils.StrLeftPad(data: strROC, length: 4, padChar: "0")
            debugPrint("CISO800::packIt SetOnlineTransactionRequestData::ROC#: \(strROCTemp)")
            _ = addField(bitno: ISOFieldConstants.ISO_FIELD_11, data1: [Byte](strROCTemp.utf8), bcd: true)
            
            /*    ***************************************************************************
            FIELD 26 ::BatchId
            ***************************************************************************/
            let strBatchID = "\(String(describing: m_iBatchId))"
            let strBatchIDTemp = TransactionUtils.StrLeftPad(data: strBatchID, length: 6, padChar: "0")
            debugPrint("CISO800::packIt SetOnlineTransactionRequestData::BatchId#: \(strBatchIDTemp)")
            _ = addField(bitno: ISOFieldConstants.ISO_FIELD_26, data1: [Byte](strBatchIDTemp.utf8), bcd: true)

            // Packing the data in the base class function
            return packItHost(sendee: &bArrSendDataToHost)
        }
        catch
        {
            debugPrint("Exception Occurred : \(error)")
            return 0
        }
        
    }

    public func SetROCandBatchId()
    {
        do {
            debugPrint("CISO800::SetROCandBatchId Inside Method SetROCandBatchId")
            let globalData = GlobalData.singleton

            let m_sParamData: TerminalParamData = globalData.ReadParamFile()!
            m_iBatchId = Int(m_sParamData.iCurrentBatchId)
            m_iLastRoc = Int(m_sParamData.m_ulDRLastDownloadedROC)
            debugPrint("LAST DR ROC = \(String(describing: m_iLastRoc)) BatchID = \(String(describing: m_iBatchId))")
        }
        catch
        {
            debugPrint("Exception Occurred : \(error)")
        }
    }

    func ProcessData() -> Bool
    {
        do {
            debugPrint("ISO800::ProcessData Inside method ProcessData")
            if (data[3-1].elementsEqual(ProcessingCodeConstants.PC_GET800DATA_REQ.utf8)) {
                return ProcessLastROC()
            }
            else
            {
                debugPrint("ISO800::ProcessData INVALID PROCESSING CODE")
                return false
            }
        }
        catch
        {
            debugPrint("Exception Occurred : \(error)")
            return false
        }
        
    }
    
    func ProcessLastROC() -> Bool
    {
        do {
            debugPrint("CISO800::ProcessLastROC Inside method ProcessLastROC")
            var chArrTempROC = [Byte](repeating: 0x00, count: 7)
            if (!bitmap[11 - 1]) {
                return false
            }
            chArrTempROC = [Byte](data[11 - 1][0 ..< data[11 - 1].count])
            //System.arraycopy(data[11 - 1], 0, chArrTempROC, 0, data[11 - 1].length)

            let sTemp = String(bytes: chArrTempROC, encoding: .ascii)!
            let lROC: Int64 = Int64(atoi(sTemp))

            //store this as the current batch id in Global Data
            let globalData = GlobalData.singleton
            var m_sParamData: TerminalParamData = globalData.ReadParamFile()!
            m_sParamData.m_ulDRLastUploadedROC = lROC
            debugPrint("CISO800::ProcessLastROC ROC = \(lROC)")
            _  = globalData.WriteParamFile(listParamData: m_sParamData)
            return true
        }
        catch
        {
            debugPrint("Exception Occurred : \(error)")
            return false
        }
        
    }

}
