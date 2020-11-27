//
//  ISO220SIGNUpload.swift
//  ePOS
//
//  Created by Vishal Rathore on 25/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CISO220SIGNUpload: CISO220 {

    var m_iChunkSize: Int = 3000
    var m_iFilesize: Int = 0
    var m_CurrentPacketCount: Int = 0
    var m_iLastPacketCount: Int = 0
    var m_TotalPacketCount: Int = 0
    var m_bIsFirstRequest: Bool = true
    var m_bArrLocalBuffer: [Byte]?            //added Abhishek
    var m_bArrResponseData: [Byte]?
    
    override init(){
        super.init() //Have to ASK
        
        m_CurrentPacketCount = 0
        m_iLastPacketCount = 0
        m_TotalPacketCount = 0
        m_bIsFirstRequest = true
        m_bArrLocalBuffer = [Byte]()                //added Abhishek
        m_bArrResponseData = [Byte]()
        m_iChunkSize = 3000              //default chunk size
        m_iFilesize = 0
    }

    public override func AfterDataExchange() -> Int {
        debugPrint("DRUpload:AfterDataExchange")

        let globalData = GlobalData.singleton                          //added for update Upload flag in file
        var sLastTxnData: TerminalTransactionData = globalData.ReadLastTxnEntry()!
        sLastTxnData.bIsSignUploaded = true
        _ = globalData.UpDateLastTxnEntry(sLastTxnData)
        return AppConstant.TRUE
    }
    
    
    public override func GetTransactionResponse() -> Bool
    {
        if(IsOK()){
            return true
        }

        debugPrint("CISO220SIGNUpload:GetTransactionResponse")
        var uchLastCount = Int()
        var uchTotalCount = Int()
        let pFieldEMVparDef: [Byte] = data[ISOFieldConstants.ISO_FIELD_53 - 1]
        let ilength: Int = len[ISOFieldConstants.ISO_FIELD_53 - 1]

        debugPrint("ilength = \(ilength)")

        if ((ilength >= 2) && (pFieldEMVparDef != nil && !pFieldEMVparDef.isEmpty))
        {
            //Amitesh::moving packet count to 2 bytes
            var ioffset: Int = 0
            uchLastCount = Int((pFieldEMVparDef[ioffset]<<8)) & (0x0000FF00)
            ioffset += 1
            uchLastCount |= Int((pFieldEMVparDef[ioffset]) & 0x000000FF)
            ioffset += 1
            uchTotalCount = Int(Int(pFieldEMVparDef[ioffset]<<8) & Int(0x0000FF00))
            ioffset += 1
            uchTotalCount |= Int((pFieldEMVparDef[ioffset]) & 0x000000FF)
            ioffset += 1
            ioffset += 1

            debugPrint("uchLastCount = \(uchLastCount)")
            debugPrint("uchTotalCount = \(uchTotalCount)")
            m_iLastPacketCount = uchLastCount
        }
        else{
            return false
        }
        
        return false
    }

    override func SetTransactionRequestData()
    {
        do {
            debugPrint("CISO220SIGNUpload:SetTransactionRequestData")
            let globalData = GlobalData.singleton

            let temp = [Byte]( repeating: 0x00, count: 13)
            let buftemp = [Byte](repeating: 0x00, count: 7)

            let sLastTxnData: TerminalTransactionData = globalData.ReadLastTxnEntry()!
            if (sLastTxnData == nil)
            {
                return
            }
            
            if (m_bIsFirstRequest) {
                    //Read file in Buffer
                let iFileIndex = 10001000 + sLastTxnData.ulROC

                let chsgnbmpFileName = String(format: "im%08d", iFileIndex)
                debugPrint("SIGN BMP file name[\(chsgnbmpFileName)]")

                m_iFilesize = FileSystem.GetFileSize(strFileName: chsgnbmpFileName)

                m_iChunkSize=m_iFilesize

                if (m_iFilesize <= 0) {
                    _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_ONLINE_SIGNATURE_UPLOAD_END.utf8), bcd: true)
                    return
                        //return with Completion
                }

                let tempData: [String] = FileSystem.ReadByteFile(strFileName: chsgnbmpFileName)!
                if(!tempData.isEmpty){
                    m_bArrLocalBuffer = [Byte](tempData[0].utf8)
                    
                    if (m_bArrLocalBuffer == nil) {
                        _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_ONLINE_SIGNATURE_UPLOAD_END.utf8), bcd: true)
                        return
                    }
                    
                    debugPrint("m_bArrLocalBuffer [\(String(describing: m_bArrLocalBuffer))]")
                }
                
                let tParamData: TerminalParamData = globalData.ReadParamFile()!

                if (tParamData.m_ulSignUploadChunkSize > 0) {
                    m_iChunkSize = Int(tParamData.m_ulSignUploadChunkSize)
                }

                debugPrint("ChunkSize -- \(m_iChunkSize)")

                m_bIsFirstRequest = false
            }

                if (m_iFilesize <= 0) {
                    _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_ONLINE_SIGNATURE_UPLOAD_END.utf8), bcd: true)
                    return
                    //return with Completion
                }


            /*    ***************************************************************************
                      FEILD 11 ::ROC
            ***************************************************************************/
            let strROC: String = "\(sLastTxnData.ulROC)"
            let strROCTemp = TransactionUtils.StrLeftPad(data: strROC, length: 4, padChar: "0")
            debugPrint("Signature RequestData::ROC#: \(temp)")
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_11, data1: [Byte](strROCTemp.utf8), bcd: true)

                /*    ***************************************************************************
                      FEILD 26 ::BatchId
             ***************************************************************************/
            let strBatchID = "\(String(describing: m_ulBatchId))"
            let strBatchIDTemp = TransactionUtils.StrLeftPad(data: strBatchID, length: 6, padChar: "0")
            debugPrint("Signature RequestData::BatchId#: \(String(bytes: buftemp, encoding: .ascii)!)")
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_26, data1: [Byte](strBatchIDTemp.utf8), bcd: true)

            /****************************************************************************
                 FEILD 45 ::chunk size
            ***************************************************************************/

            debugPrint("sign chunk size = \(m_iChunkSize)")
            let strChunkSize = "\(m_iChunkSize)"
            let strChunkSizeTemp = TransactionUtils.StrLeftPad(data: strChunkSize, length: 6, padChar: "0")
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_45, data1: [Byte](strChunkSizeTemp.utf8), bcd: true)
            debugPrint("sign Req->Setting field 45 : \(strChunkSizeTemp)")

            /****************************************************************************
                FEILD 61 ::chunk size  byte Array
            ***************************************************************************/
            m_bArrResponseData = GetBufferChunkForSignature(m_bArrLocalBuffer!, m_iFilesize, m_iChunkSize)

            if (m_bArrResponseData == nil) {
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_ONLINE_SIGNATURE_UPLOAD_END.utf8), bcd: true)
                debugPrint("Error in GetBufferChunkForSignature")
                return
            }


            //******************pack in filed 61 ***************************
            _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61, data1: m_bArrResponseData!, length: m_bArrResponseData!.count)


            if (nil != m_bArrResponseData) {
                m_bArrResponseData = nil
            }

            //******************set counters field ***********************
            var buffer = [Byte](repeating: 0x00, count: 4)
            var iLocalOffset: Int = 0x00


            //amitesh::making 2 byte packet counts
            var b: Int = m_CurrentPacketCount
            
            //Current Packet count 2 bytes
            buffer[iLocalOffset] = Byte((b >> 8) & 0x000000FF)
            iLocalOffset += 1
            buffer[iLocalOffset] = Byte(b & 0x000000FF)
            iLocalOffset += 1

            b = m_TotalPacketCount
            //Total Packet count 2 bytes
            buffer[iLocalOffset] = Byte((b >> 8) & 0x000000FF)
            iLocalOffset += 1
            buffer[iLocalOffset] = Byte(b & 0x000000FF)
            iLocalOffset += 1

                /** Add to field 53**/
            _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_53, data1: buffer, length: iLocalOffset)

            
            /*    ***************************************************************************
             FEILD 3 ::Processing Code
             ***************************************************************************/
            if (m_CurrentPacketCount == m_TotalPacketCount) {
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_ONLINE_SIGNATURE_UPLOAD_END.utf8), bcd: true)
                if (nil != m_bArrLocalBuffer) {
                    m_bArrLocalBuffer = nil
                }
            } else {
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_ONLINE_SIGNATURE_UPLOAD_START.utf8), bcd: true)
            }
        }
        catch
        {
            debugPrint("Exception occurred in Set Response Data in Sign Upload = \(error)")
            return
        }
    }

    func GetBufferChunkForSignature(_ chArrFileBuffer: [Byte], _ iBuffersize: Int, _ iChunkSize: Int) -> [Byte]?
    {
        do{
            debugPrint("Enter in GetBufferChunkForSignature")
            var iOffset: Int = 0
            var iSizeToRead: Int = 0

            m_TotalPacketCount=iBuffersize / iChunkSize

            if (iBuffersize % iChunkSize != 0)
            {
                m_TotalPacketCount += 1
            }

            if (m_CurrentPacketCount >= m_TotalPacketCount) {
                return nil
            }

            if ((m_TotalPacketCount - m_CurrentPacketCount) > 1)
            {
                iOffset = iChunkSize * m_CurrentPacketCount
                iSizeToRead = iChunkSize
                m_CurrentPacketCount += 1
                m_bArrResponseData = [Byte](repeating: 0x00, count: iSizeToRead)
                m_bArrResponseData = [Byte](chArrFileBuffer[iOffset ..< iOffset + iSizeToRead])
                //System.arraycopy(chArrFileBuffer, iOffset, m_bArrResponseData, 0, iSizeToRead)    //Check not required - Swapnil
            }
            else
            {
                iOffset = iChunkSize * m_CurrentPacketCount
                iSizeToRead = iBuffersize - iOffset
                m_CurrentPacketCount += 1
                m_bArrResponseData = [Byte](repeating: 0x00, count: iSizeToRead)
                if (iSizeToRead <= iChunkSize)
                {
                    m_bArrResponseData = [Byte](chArrFileBuffer[iOffset ..< iOffset + iSizeToRead])
                    //System.arraycopy(chArrFileBuffer, iOffset, m_bArrResponseData, 0, iSizeToRead)  //Check already present - Swapnil
                }
                else
                {
                    return nil
                }
            }
                return m_bArrResponseData
        }
        catch
        {
            debugPrint("Exception Occurred : \(error)")
            return nil
        }
    }
    
}
