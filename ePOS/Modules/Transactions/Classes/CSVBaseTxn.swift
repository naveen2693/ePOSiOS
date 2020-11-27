//
//  CSVBaseTxn.swift
//  ePOS
//
//  Created by Vishal Rathore on 12/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

protocol CSVAbstractBaseTxn
{
    // ECR Transaction steps
    // To be overriden by Child classes
    func InitiateECRTransaction()

    func FinishECRTransaction()

    func HandleECRRequest()

    func HandleGetAmountResponse(_ data: [Byte])

    func HandleGetBharatQRTxnResponse()

    func HandleGetTrackDataResponse(_ data: [Byte], _ bCardType: Byte)

    func HandleGetInvoiceNoResponse(_ data: [Byte])

    func SendResponse(_ data: [Byte], _ length: Int, _ status: Byte) -> Bool
}

class CSVBaseTxn: CSVAbstractBaseTxn {
    
    static let TXN_SALE = 4001
    static let TXN_REFUND = 4002
    static let TXN_ADJUST = 4005
    static let TXN_VOID = 4006
    static let TXN_PRE_AUTH = 4007
    static let TXN_POST_AUTH = 4008
    static let TXN_TIP_ADJUST = 4015
    static let TXN_LOY_MINE_REDEMPTION = 4201
    static let TXN_P360_GV_ACTIVATION = 4202
    static let TXN_P360_GV_REDEMPTION = 4203
    static let TXN_P360_GV_BALANCEENQUIRY = 4204
    static let TXN_P360_LOYALTY_BALANCEENQUIRY = 4210
    static let TXN_P360_LOYALTY_AWARD = 4208
    static let TXN_P360_LOYALTY_REDEMPTION = 4209
    static let TXN_P360_GC_LOAD = 4211
    static let TXN_P360_GC_REDEEM = 4212
    static let TXN_P360_GC_BALANCEENQUIRY = 4213
    static let TXN_MWALLET_REDEMPTION = 4214
    static let TXN_P360_VOUCHER_REDEEEM = 4215
    static let TXN_PRINT_RECEIPT = 4216
    static let TXN_SHOPPERS_STOP_LOYALTY = 4301
    static let TXN_COUPON_CODE_SALE = 5001
    static let TXN_PAYBACK_AWARD = 4401
    static let TXN_PAYBACK_REDEEM = 4402
    static let TXN_PAYBACK_VOID = 4403
    static let TXN_SETTLEMENT_REQ = 6001
    //new txn type for CASH @PO
    static let TXN_SALE_WITH_CASH = 4502
    static let TXN_CASH_ONLY = 4503
    static let TXN_COD = 4504
    static let TXN_CARD = 4505
    static let TXN_PROMO_REDEMPTION_IN_INTEGRATON_MODE = 4801
    
    
    static let MAX_PRINTDATA = 50
    internal var m_ulCardSwipeTimeOut: Int64 = 0
    internal var m_ulAmount: Int64 = 0
    internal var m_ulTxnType: Int64?
    internal var m_btxnCompleted: Bool = false
    internal var m_bCSVResponseSend: Bool = false
    private var m_iTransactionHUBResponseCode: Int?
    
    var m_bIsCSVTxnInProcess: Bool = false
    internal var bArrSendRecvBuff: [Byte]?
    
    var SendResponseLocation: enSendResponseLocation?
    
    private class CSVChargeSlipLine {
        var s_iType: Int
        var s_bisBold: Bool
        var s_bisCenterAligned: Bool
        var s_iLineNumber: Int
        var s_chArrDatatoPrint: [Byte]?
        
        init() {
            s_iType = 0
            s_bisBold = false
            s_bisCenterAligned = true
            s_iLineNumber = 0
            s_chArrDatatoPrint = nil
        }
    }
    
    enum enSendResponseLocation {
        case BEFORE_PRINT_CHARGESLIP
        case AFTER_PRINT_CHARGESLIP
    }
    
    internal struct enEncryptionType {
        
        enum enumEncryptionType: Int {
            case _NO_ENCRYPTION = 1
            case _SERIAL_ENCRYPTION = 2
            case _USER_DATA_ENCRYPTION = 3
            case _SERIAL_SHA_ENCRYPTION = 4
        }
        
        private var value: Int
        private static var map: [Int: enumEncryptionType] = [1: ._NO_ENCRYPTION, 2: ._SERIAL_ENCRYPTION, 3: ._USER_DATA_ENCRYPTION, 4: ._SERIAL_SHA_ENCRYPTION]
        
        private init(_ value: Int) {
            self.value = value
        }

        static func valueOf(_ value: Int) -> enumEncryptionType {
            return map[value]!
        }

        func getValue() -> Int {
            return value
        }
    }
    
    private var m_ChargeSlipHead = [CSVChargeSlipLine]()
    
    private var iPrintBufferSize = 0
    private var PrintBufferFinal: [Byte]?
    
    static let _PrintText = 0
    static let _PrintImage = 1
    static let _PrintBarcode = 2
    
    private init() {}
    private static var _shared: CSVBaseTxn?
    public static var singleton: CSVBaseTxn {
        get {
            if _shared == nil {
                DispatchQueue.global().sync(flags: .barrier) {
                    if _shared == nil {
                        _shared = CSVBaseTxn()
                    }
                }
            }
            return _shared!
        }
    }
    
    /***********************************************************
     * @fn AddTLVData
     * @brief This API adds TLV data in GlobalData.m_ptrCSVDATA.TlvData
     * @param  HostTlvtag, Data, length
     * @return
     **********************************************************/
    func AddTLVData(_ HostTlvtag: Int, _ Data: [Byte], _ length: Int) {
        //TODO: No TxnTLVData
    }
    
    /***********************************************************
     * @fn getTransactionType
     * @brief This API retrieves txn type from CSV
     * @param  chArrReceivedCSV, csvlen, ulTtransactionType
     * @return true/false
     **********************************************************/
    func getTransactionType(_ chArrReceivedCSV: [Byte], _ ulTtransactionType: inout Long) -> Bool {
        debugPrint( "Inside getTransactionType")
        var bRet: Bool = false
        do {
            var ulTxnType: Int64 = 0

            let strCSV: String = String(bytes: chArrReceivedCSV, encoding: .ascii)!
            let strCSVFields = strCSV.split(separator: ",")
            
            if (strCSVFields[0].count > 0) {
                debugPrint( "chArrTxnType[\(strCSVFields[0])]")
                let strTxnType: String = strCSVFields[0].replacingOccurrences(of: "^\"|\"$", with: "")
                ulTxnType = Int64(strTxnType)!
                debugPrint("ulTxnType[\(ulTxnType)]")
                ulTtransactionType.value = ulTxnType
                bRet = true
            }
        } catch
        {
            debugPrint("Exception Occurred : \(error)")
            let strResp: String = "Error: Invalid CSV"
            let bResp: [Byte] = [Byte](strResp.utf8)
            _ = SendResponse(bResp, bResp.count, (Byte)(0x00))
            m_btxnCompleted = true
            CSVHandler.singleton.sendMessage(CSVHandler.REQUEST_FOR_TERMINATE_ECR_TRANSACTION, ExecutionResult._CANCEL, -1, nil)
        }
        return bRet
    }

    /***********************************************************
     * @fn IsTleRequiredForTransaction
     * @brief This API retrieves if TLE is required for txntype from CSV
     * @param  chArrReceivedCSV, csvlen, ulTtransactionType
     * @return true/false
     **********************************************************/
    func IsTleRequiredForTransaction(_ chArrReceivedCSV: [Byte], _ csvlen: Int, _ ulTtransactionType: inout Long) -> Bool {
        debugPrint("Inside IsTleRequiredForTransaction")
        var bIsTle: Bool = false

        do {
            var ulTxnType: Int64 = 0

            let strCSV = String(bytes: chArrReceivedCSV, encoding: .ascii)!
            let strCSVFields = strCSV.split(separator: ",")

            if (strCSVFields[0].count > 0) {
                debugPrint("chArrTxnType[\(strCSVFields[0])]")
                let strTxnType = strCSVFields[0].replacingOccurrences(of: "^\"|\"$", with: "")
                ulTxnType = Int64(strTxnType)!
                debugPrint("ulTxnType[\(ulTxnType)]")
                ulTtransactionType.value = ulTxnType

                let globalData = GlobalData.singleton
                
                bIsTle = globalData.IsEncryptionEnabledCSVTxnMap(ulTxnType: ulTxnType)
                debugPrint("bIsTle[\(bIsTle)]")
            }
        } catch {
            debugPrint("Exception Occurred : \(error)")
            let strResp: String = "Error: Invalid CSV"
            let bResp: [Byte] = [Byte](strResp.utf8)
            _ = SendResponse(bResp, bResp.count, (Byte)(0x00))
            m_btxnCompleted = true
            CSVHandler.singleton.sendMessage(CSVHandler.REQUEST_FOR_TERMINATE_ECR_TRANSACTION, ExecutionResult._CANCEL, -1, nil)
        }
        return bIsTle
    }
    

        /******************************************************************************
         * @fn RebuildCSV
         * @details This Function ReCreate the CSV from Tracks, seperate memory to be used
         *          for input and output
         * @return bool
         *******************************************************************************/
    func RebuildCSV(_ chArrInCSV: [Byte], _ chArrPattern: String, _ uchArrUserData: inout [Byte], _ chArrOutCSV: inout [Byte]) -> Bool  {
            var bRetVal: Bool = true
            do {
                var lenInCSV = 0
                _ = 0
                var iTrack1Len = 0
                var iTrack2Len = 0
                var iOffset = 0

                var chArrTrack1 = [Byte](repeating: 0x00, count: AppConstant.MAX_TRACK2_LEN)
                var chArrTrack2 = [Byte](repeating: 0x00, count: AppConstant.MAX_TRACK2_LEN)
                
                //track1 --------------------------------------
                iTrack1Len = Int(uchArrUserData[iOffset])
                iOffset += 1
                if (iTrack1Len > 0) {
                    chArrTrack1 = [Byte](uchArrUserData[iOffset ..< iOffset + iTrack1Len])
                    //System.arraycopy(uchArrUserData, iOffset, chArrTrack1, 0, iTrack1Len)
                }
                iOffset += iTrack1Len

                //track2 --------------------------------------
                iTrack2Len = Int(uchArrUserData[iOffset])
                iOffset += 1
                if (iTrack2Len > 0) {
                    chArrTrack2 = [Byte](uchArrUserData[iOffset ..< iOffset + iTrack1Len])
                    //System.arraycopy(uchArrUserData, iOffset, chArrTrack2, 0, iTrack2Len)
                }
                iOffset += iTrack2Len

                //Search and replace Pattern with track data

                lenInCSV = TransactionUtils.strlenByteArray(chArrInCSV)

                var chArrinputCSV = [Byte](repeating: 0x00, count: lenInCSV + iOffset + 100)
                chArrinputCSV = [Byte](chArrInCSV[0 ..< lenInCSV])
                //System.arraycopy(chArrInCSV, 0, chArrinputCSV, 0, lenInCSV)
                
                chArrinputCSV[lenInCSV] = 0x00

                if (!TransactionUtils.ReplaceStringPatterninBuffer(chArrinputCSV, &chArrOutCSV, chArrPattern, chArrTrack1)) {
                    bRetVal = false
                } else {
                    chArrinputCSV = [Byte](repeating: 0x00, count: lenInCSV + iOffset + 100)
                    chArrinputCSV = [Byte](chArrinputCSV[0 ..< TransactionUtils.strlenByteArray(chArrOutCSV)])
                    //System.arraycopy(chArrOutCSV, 0, chArrinputCSV, 0, CUtils.strlenByteArray(chArrOutCSV))

                    //Search and replace Pattern with track2
                    if (!TransactionUtils.ReplaceStringPatterninBuffer(chArrinputCSV, &chArrOutCSV, chArrPattern, chArrTrack2)) {
                        bRetVal = false
                    }
                }
            } catch {
                debugPrint( "Exception Occurred : \(error)")
                CSVHandler.singleton.sendMessage(CSVHandler.REQUEST_FOR_TERMINATE_ECR_TRANSACTION, ExecutionResult._CANCEL, -1, nil)
            }

            return bRetVal
        }

        /******************************************************************************
         * @fn GoOnline
         * @details This Function sends txn control flow to transaction hub and proceeds txn online
         * @return
         *******************************************************************************/
        func GoOnline(IsTleEnabled: Int) {
            debugPrint("Inside GoOnline")
            do {
                TransactionHUB.singleton.sendMessage(m_iTransactionHUBResponseCode!, IsTleEnabled, -1, nil)
            } catch {
                debugPrint( "Exception Occurred : \(error)")
                CSVHandler.singleton.sendMessage(CSVHandler.REQUEST_FOR_TERMINATE_ECR_TRANSACTION, ExecutionResult._CANCEL, -1, nil)
            }
        }

        /******************************************************************************
         * @fn PrintMessage
         * @details This Function prints test print dump.
         * @return
         *******************************************************************************/
    internal func PrintMessage(_ DataLen: Int) -> Int {
            debugPrint("Test Print Request")
        let retVal: Int = RetVal.RET_OK
            do {
                let bDispStatus: Byte = Byte(0x00)

                var PrintBuffer = [Byte](repeating: 0x00, count: DataLen + 1)
                
                PrintBuffer = [Byte](bArrSendRecvBuff![5 ..< 5 + DataLen])
                //System.arraycopy(bArrSendRecvBuff, 5, PrintBuffer, 0, DataLen)


                let respStr = ""
                let data: [Byte] = [Byte](respStr.utf8)
                _ = SendResponse(data, data.count, bDispStatus)
            } catch
            {
                debugPrint( "Exception Occurred : \(error)")
            }
            return retVal
        }

        internal func HandlePrintChargeSlip() -> Int {
            debugPrint("Inside HandlePrintChargeSlip")
            let retVal: Int = RetVal.RET_OK

            return retVal
        }

    func PrintChargeSlip(_ PrintBuffer: [Byte], _ DataLen: Int) -> Int {
            debugPrint("PrintChargeSlip Len[\(DataLen)]")
        var retVal: Int = RetVal.RET_OK

            do {
                if (RetVal.RET_OK == ParseCSVChargeSlipData(PrintBuffer, DataLen)) {
                    debugPrint("PrintBuffer Parsed iPrintBufferSize[\(iPrintBufferSize)]")
                    PrintBufferFinal = [Byte](repeating: 0x00, count: iPrintBufferSize)
                    iPrintBufferSize = 0

                    for lineNo in 0 ..< m_ChargeSlipHead.count
                    {
                        let ChargeSlipLine: CSVChargeSlipLine = m_ChargeSlipHead[lineNo]
                        ParseCSVPrintLineAndFillBuffer(ChargeSlipLine)
                    }

                    SavePrintDumptoFile()
                    TransactionHUB.singleton.sendMessage(AppConstant.REQUEST_FOR_PRINT_INTEGRATED_SLIP, -1, -1, nil)
                    ClearChargeSlipList()
                } else {
                    retVal = RetVal.RET_NOT_OK
                }
            } catch {
                debugPrint("Exception Occurred : \(error)")
                let strResp: String = "\"99\",\"Printing Failed\""
                let globalData = GlobalData.singleton
                globalData.m_ptrCSVDATA.m_chBillingCSVData  = [Byte](repeating: 0x00, count: AppConstant.MAX_CSV_LEN)
                let bResp: [Byte] = [Byte](strResp.utf8)
                globalData.m_ptrCSVDATA.m_chBillingCSVData = [Byte](bResp[0 ..< strResp.count])
                
                //System.arraycopy(strResp.getBytes(), 0, GlobalData.m_ptrCSVDATA.m_chBillingCSVData, 0, strResp.length())
                globalData.m_ptrCSVDATA.bCSVreceived = true
                globalData.m_ptrCSVDATA.bStatus = 0x00
                CSVHandler.singleton.sendMessage(CSVHandler.REQUEST_FOR_TERMINATE_ECR_TRANSACTION, ExecutionResult._CANCEL, -1, nil)
            }

            return retVal
        }

        private func SavePrintDumptoFile() {
            do {
                debugPrint( "Inside SavePrintDumptoFile")
                var _: Int = 0
                let p: [Byte] = PrintBufferFinal!

                let chTxnField62Name = String(format: "%@", FileNameConstants.BILLINGAPPDUMPFILE)
                debugPrint("txn field 62 file name[\(chTxnField62Name)]")

                if (FileSystem.IsFileExist(strFileName: chTxnField62Name)) {
                    //should not come here
                    _ = FileSystem.DeleteFile(strFileName: chTxnField62Name)
                    debugPrint("DeleteFile[\(chTxnField62Name)]")
                }
                
                var tempData = [String]()
                tempData.append(String(bytes: p[0 ..< iPrintBufferSize], encoding: .ascii)!)
                
                _ = try FileSystem.AppendByteFile(strFileName: chTxnField62Name, with: tempData)
             
            } catch {
                debugPrint("Exception Occurred : \(error)")
                let strResp: String = "\"99\",\"Printing Failed\""
                
                let globalData = GlobalData.singleton
                globalData.m_ptrCSVDATA.m_chBillingCSVData  = [Byte](repeating: 0x00, count: AppConstant.MAX_CSV_LEN)
                let bResp: [Byte] = [Byte](strResp.utf8)
                globalData.m_ptrCSVDATA.m_chBillingCSVData = [Byte](bResp[0 ..< strResp.count])
                
                //System.arraycopy(strResp.getBytes(), 0, GlobalData.m_ptrCSVDATA.m_chBillingCSVData, 0, strResp.length())
                globalData.m_ptrCSVDATA.bCSVreceived = true
                globalData.m_ptrCSVDATA.bStatus = 0x00
                
                CSVHandler.singleton.sendMessage(CSVHandler.REQUEST_FOR_TERMINATE_ECR_TRANSACTION, ExecutionResult._CANCEL, -1, nil)
            }
        }

    func ParseCSVChargeSlipData(_ PrintBuffer: [Byte], _ iDataLen: Int) -> Int {
            debugPrint("ParseCSVChargeSlipData len[\(iDataLen)]")
        let retVal: Int = RetVal.RET_OK
            
            do {
                let strPrintBuffer: String = (String(bytes: PrintBuffer, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines))
                let PrintBufferLines = strPrintBuffer.split(separator: Character("\\|"))

                for lineIdx in 0 ..< PrintBufferLines.count
                {
                    debugPrint("ParsingLine = \(PrintBufferLines[lineIdx])")

                    let newLine: CSVChargeSlipLine = ParseOneLine(String(PrintBufferLines[lineIdx]))
                    if (newLine != nil || newLine.s_chArrDatatoPrint != nil || !newLine.s_chArrDatatoPrint!.isEmpty) {
                        AddChargeSlipLine(newLine)
                    }
                }
            } catch {
                debugPrint("Exception Occurred : \(error)")
                let strResp: String = "\"99\",\"Printing Failed\""
                
                let globalData = GlobalData.singleton
                globalData.m_ptrCSVDATA.m_chBillingCSVData  = [Byte](repeating: 0x00, count: AppConstant.MAX_CSV_LEN)
                let bResp: [Byte] = [Byte](strResp.utf8)
                globalData.m_ptrCSVDATA.m_chBillingCSVData = [Byte](bResp[0 ..< strResp.count])
                
                //System.arraycopy(strResp.getBytes(), 0, GlobalData.m_ptrCSVDATA.m_chBillingCSVData, 0, strResp.length())
                globalData.m_ptrCSVDATA.bCSVreceived = true
                globalData.m_ptrCSVDATA.bStatus = 0x00
                CSVHandler.singleton.sendMessage(CSVHandler.REQUEST_FOR_TERMINATE_ECR_TRANSACTION, ExecutionResult._CANCEL, -1, nil)
            }

            return retVal
        }

    private func ParseOneLine(_ strPrintBuffer: String) -> CSVChargeSlipLine {
        var _: Int = 0
            var ChargeSlipLine = CSVChargeSlipLine()

            do {
                let chArrParam = strPrintBuffer.split(separator: ";")
                for numberOfParams in 0 ..< chArrParam.count {
                    debugPrint("ParamNo[\(numberOfParams + 1)] ParamVal[\(chArrParam[numberOfParams])]")

                    switch (numberOfParams + 1) {
                        case 1:
                            ChargeSlipLine.s_iType = Int(String(chArrParam[numberOfParams]))!
                        case 2:
                            if (chArrParam[numberOfParams].caseInsensitiveCompare("True") == .orderedSame) {
                                ChargeSlipLine.s_bisBold = true
                            } else {
                                ChargeSlipLine.s_bisBold = false
                            }

                        case 3:
                            if (chArrParam[numberOfParams].caseInsensitiveCompare("True") == .orderedSame)
                            {
                                ChargeSlipLine.s_bisCenterAligned = true
                            } else {
                                ChargeSlipLine.s_bisCenterAligned = false
                            }

                        case 4:
                            ChargeSlipLine.s_iLineNumber = Int(String(chArrParam[numberOfParams]))!

                        case 5:
                            ChargeSlipLine.s_chArrDatatoPrint = [Byte](String(chArrParam[numberOfParams]).utf8)
                            iPrintBufferSize += ChargeSlipLine.s_chArrDatatoPrint!.count + 10
                        default:
                            ChargeSlipLine = CSVChargeSlipLine()
                    }
                }
                debugPrint("Retruning PARSEONeLine")
            } catch {
                debugPrint("Exception Occurred : \(error)")
                let strResp: String = "\"99\",\"Printing Failed\""
                
                let globalData = GlobalData.singleton
                globalData.m_ptrCSVDATA.m_chBillingCSVData  = [Byte](repeating: 0x00, count: AppConstant.MAX_CSV_LEN)
                let bResp: [Byte] = [Byte](strResp.utf8)
                globalData.m_ptrCSVDATA.m_chBillingCSVData = [Byte](bResp[0 ..< strResp.count])
                
                //System.arraycopy(strResp.getBytes(), 0, GlobalData.m_ptrCSVDATA.m_chBillingCSVData, 0, strResp.length())
                globalData.m_ptrCSVDATA.bCSVreceived = true
                globalData.m_ptrCSVDATA.bStatus = 0x00
                CSVHandler.singleton.sendMessage(CSVHandler.REQUEST_FOR_TERMINATE_ECR_TRANSACTION, ExecutionResult._CANCEL, -1, nil)
            }

            return ChargeSlipLine
        }

        private func AddChargeSlipLine(_ newLine: CSVChargeSlipLine) {
            m_ChargeSlipHead.append(newLine)
        }

        private func ClearChargeSlipList() {
            m_ChargeSlipHead.removeAll()
        }

        private func ParseCSVPrintLineAndFillBuffer(_ ChargeSlipLine: CSVChargeSlipLine) {
            do {
                switch (ChargeSlipLine.s_iType) {
                case CSVBaseTxn._PrintText:
                        PrintBufferFinal![iPrintBufferSize] = AppConstant.PRINTDUMP_RAWMODE
                        iPrintBufferSize += 1
                        let iPrintDumpLen: Int = ChargeSlipLine.s_chArrDatatoPrint!.count
                        PrintBufferFinal![iPrintBufferSize] = Byte((iPrintDumpLen >> 8) & 0xFF)
                        iPrintBufferSize += 1
                        PrintBufferFinal![iPrintBufferSize] = Byte((iPrintDumpLen) & 0xFF)
                        iPrintBufferSize += 1
                        PrintBufferFinal![iPrintBufferSize] = ChargeSlipLine.s_bisBold ? Byte(0x01) : Byte(0x02)
                        iPrintBufferSize += 1
                        
                        PrintBufferFinal![iPrintBufferSize ..< iPrintBufferSize + ChargeSlipLine.s_chArrDatatoPrint!.count] = ChargeSlipLine.s_chArrDatatoPrint![0 ..< ChargeSlipLine.s_chArrDatatoPrint!.count]
                        //System.arraycopy(ChargeSlipLine.s_chArrDatatoPrint, 0, PrintBufferFinal, iPrintBufferSize, ChargeSlipLine.s_chArrDatatoPrint.length)
                        iPrintBufferSize += ChargeSlipLine.s_chArrDatatoPrint!.count

                case CSVBaseTxn._PrintImage:
                        PrintBufferFinal![iPrintBufferSize] = AppConstant.PRINTDUMP_IMAGEMODE
                        iPrintBufferSize += 1
                        let iImagePathLength: Int = ChargeSlipLine.s_chArrDatatoPrint!.count
                        PrintBufferFinal![iPrintBufferSize] = Byte((iImagePathLength >> 24) & 0xFF)
                        iPrintBufferSize += 1
                        PrintBufferFinal![iPrintBufferSize] = Byte((iImagePathLength >> 16) & 0xFF)
                        iPrintBufferSize += 1
                        PrintBufferFinal![iPrintBufferSize] = Byte((iImagePathLength >> 8) & 0xFF)
                        iPrintBufferSize += 1
                        PrintBufferFinal![iPrintBufferSize] = Byte((iImagePathLength) & 0xFF)
                        iPrintBufferSize += 1
                        
                        PrintBufferFinal![iPrintBufferSize ..< iPrintBufferSize + ChargeSlipLine.s_chArrDatatoPrint!.count] = ChargeSlipLine.s_chArrDatatoPrint![0 ..< ChargeSlipLine.s_chArrDatatoPrint!.count]
                        
                        //System.arraycopy(ChargeSlipLine.s_chArrDatatoPrint, 0, PrintBufferFinal, iPrintBufferSize, ChargeSlipLine.s_chArrDatatoPrint.length)
                        iPrintBufferSize += ChargeSlipLine.s_chArrDatatoPrint!.count

                case CSVBaseTxn._PrintBarcode:
                        PrintBufferFinal![iPrintBufferSize] = AppConstant.PRINTDUMP_BARCODEMODE
                        iPrintBufferSize += 1
                        let iBarCodeDumpLen: Int = ChargeSlipLine.s_chArrDatatoPrint!.count
                        iPrintBufferSize += 1
                        PrintBufferFinal![iPrintBufferSize] = Byte((iBarCodeDumpLen) & 0xFF)
                        
                        PrintBufferFinal![iPrintBufferSize ..< iPrintBufferSize + ChargeSlipLine.s_chArrDatatoPrint!.count] = ChargeSlipLine.s_chArrDatatoPrint![0 ..< ChargeSlipLine.s_chArrDatatoPrint!.count]
                        //System.arraycopy(ChargeSlipLine.s_chArrDatatoPrint, 0, PrintBufferFinal, iPrintBufferSize, iBarCodeDumpLen)
                        iPrintBufferSize += iBarCodeDumpLen

                    default:
                        break
                }
            } catch {
                debugPrint("Exception Occurred : \(error)")
                let strResp: String = "\"99\",\"Printing Failed\""
                let globalData = GlobalData.singleton
                globalData.m_ptrCSVDATA.m_chBillingCSVData  = [Byte](repeating: 0x00, count: AppConstant.MAX_CSV_LEN)
                let bResp: [Byte] = [Byte](strResp.utf8)
                globalData.m_ptrCSVDATA.m_chBillingCSVData = [Byte](bResp[0 ..< strResp.count])
                
                //System.arraycopy(strResp.getBytes(), 0, GlobalData.m_ptrCSVDATA.m_chBillingCSVData, 0, strResp.length())
                globalData.m_ptrCSVDATA.bCSVreceived = true
                globalData.m_ptrCSVDATA.bStatus = 0x00
                CSVHandler.singleton.sendMessage(CSVHandler.REQUEST_FOR_TERMINATE_ECR_TRANSACTION, ExecutionResult._CANCEL, -1, nil)
            }
        }

        /********************************************************************
         * @fn HandleHeartBeatRequest
         * @brief This API send Heart Beat ACK
         * @return
         *******************************************************************/
        internal func HandleHeartBeatRequest() -> Int {
            debugPrint("Handle Heart Beat Request")
            do {
                let retVal: Int = RetVal.RET_OK
                let bDispStatus = Byte(0x01)
                //Send response back
                let respString: String = ""
                let data: [Byte] = [Byte](respString.utf8)
                _ = SendResponse(data, data.count, bDispStatus)
                return retVal
            } catch {
                debugPrint("Exception Occurred : \(error)")
                return RetVal.RET_NOT_OK
            }
        }
    
    // ECR Transaction steps
    // To be overriden by Child classes
    func InitiateECRTransaction(){}

    func FinishECRTransaction(){}
    
    func HandleECRRequest(){}
    
    func HandleGetAmountResponse(_ data: [Byte]){}
    
    func HandleGetBharatQRTxnResponse(){}
    
    func HandleGetTrackDataResponse(_ data: [Byte], _ bCardType: Byte){}
    
    func HandleGetInvoiceNoResponse(_ data: [Byte]){}
    
    func SendResponse(_ data: [Byte], _ length: Int, _ status: Byte) -> Bool{ return true }
    
}
