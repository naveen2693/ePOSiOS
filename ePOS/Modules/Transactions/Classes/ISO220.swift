//
//  ISO220.swift
//  ePOS
//
//  Created by Vishal Rathore on 23/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

protocol CISO220Abstrct
{
    func GetTransactionResponse() -> Bool           //Get Online Txn Response
}

class CISO220: ISOMessage, CISO220Abstrct
{
    enum CLessTxnType {
        case CLESS_TC
        case CLESS_ARQC
    }

    enum CLessCVMType {
        case CLESS_CVMPROCESSED
        case CLESS_ONLINEPIN
        case CLESS_SIGNATURE
        case CLESS_MOBILE
        case CLESS_NOCVM
    }
    
    internal var m_ulLastRoc: Int64?
    internal var m_ulCurrentRoc: Int64?
    internal var m_ulBatchId: Int64?
    internal var m_uchMiniPVM = [Byte](repeating: 0x00, count: AppConstant.MAX_MINI_PVM_LEN + 2)
    internal var m_iMiniPVMOffset: Int?
    internal var m_bCurrentPacketCount: Int?
    internal var m_bTotalPacketCount: Int?
    internal var m_bMiniPVM: Bool?
    internal var m_iPrintDataPrinted: Int?
    internal var m_iPrintDataPrintedAmexEMVSale: Int?
    
    static internal var m_bArrDataToReplay = [Byte](repeating: 0x00, count: AppConstant.MAX_REPLAY_DATA_LEN + 1)
    static internal var m_iReplayDataLen: Int?
    static internal var m_bDataToReplay: Bool?
    internal var m_bPrintData = [Byte](repeating: 0x00, count: AppConstant.MAX_RESPONSE_DATA_LEN)
    internal var m_iCurrentPrintDumpOffset: Int?
    
    internal var m_bPrintDataAmexGprs = [Byte](repeating: 000, count: AppConstant.MAX_RESPONSE_DATA_LEN)
    internal var m_iCurrentPrintDumpOffsetAmexGprs: Int?


    //DR DATA
    internal var m_uchPtrDRData = [Byte](repeating: 0x00, count: AppConstant.MAX_RESPONSE_DATA_LEN)
    internal var m_iCurrentDRDataDumpOffset = 0

    //Signature Image Dump
    internal var m_uchPtrSignatureImage = [Byte](repeating: 0x00, count: AppConstant.MAX_RESPONSE_DATA_LEN)
    internal var m_iCurrentSignatureImageDumpOffset = 0
    internal var m_bIsSignatureImageMemoryAllocated = false


    public var m_ReversalFlag: Bool?
    public var m_iReqState: Int?
    public var m_iResState: Int?
    public var m_bTxnDeclined: Bool?
    public var m_bReward: Int?
    
    override init() {
        super.init() //Have to ASK
        
        m_uchMiniPVM = [Byte](repeating: 0x00, count: AppConstant.MAX_MINI_PVM_LEN + 2)
        m_bPrintData = [Byte](repeating: 0x00, count: AppConstant.MAX_RESPONSE_DATA_LEN)
        m_bPrintDataAmexGprs = [Byte](repeating: 000, count: AppConstant.MAX_RESPONSE_DATA_LEN)
        
        m_uchPtrDRData = [Byte](repeating: 0x00, count: AppConstant.MAX_RESPONSE_DATA_LEN)
        m_iCurrentDRDataDumpOffset = 0

        //Added code for Signature capture Image Dump
        m_uchPtrSignatureImage = [Byte](repeating: 0x00, count: AppConstant.MAX_RESPONSE_DATA_LEN)
        
        //m_uchPtrSignatureImage = null
        
        m_iCurrentSignatureImageDumpOffset = 0
        m_bIsSignatureImageMemoryAllocated = false
    }
    
    
    func CISO220C(_ iReqType: Int) {
        self.CISOMsgC()
        self.vFnSetTerminalActivationFlag(bTerminalActivationFlag: false)
        m_iMiniPVMOffset = 0x00
        m_bCurrentPacketCount = 0x00
        m_bTotalPacketCount = 0x00
        m_ReversalFlag = false
        m_bTxnDeclined = false
        m_bMiniPVM = false/*(byte)AppConst.FALSE*/
        m_iPrintDataPrinted = AppConstant.TRUE
        m_iPrintDataPrintedAmexEMVSale = AppConstant.TRUE
        m_iCurrentPrintDumpOffset = 0x00
        m_iCurrentPrintDumpOffsetAmexGprs = 0x00
        m_iCurrentDRDataDumpOffset = 0 //DR Data Offset
        m_iResState = ISO220ResponseState.ONLINE_RESPONSE_INVALID_PROCESSING_CODE
        m_bReward = AppConstant.FALSE

        if (iReqType != ISO220RequestState.ONLINE_REQUEST_EMV_FINAL_RESPONSE) {
            CISO220.m_iReplayDataLen = 0x00
            CISO220.m_bDataToReplay = false
            //memset(m_bArrDataToReplay,0x00,MAX_REPLAY_DATA_LEN+1)
            CISO220.m_bArrDataToReplay = [Byte](repeating: 0x00, count: AppConstant.MAX_REPLAY_DATA_LEN + 1 )
            //Arrays.fill(m_bArrDataToReplay, 0, AppConst.MAX_REPLAY_DATA_LEN + 1, (byte) "\u0000")
        }


        debugPrint("CISO220C iReqType[\(iReqType)]")

        switch (iReqType) {
            case ISO220RequestState.ONLINE_REQUEST_DEFAULT_TXN_REQUEST:
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_DEFAULT_TXN_REQUEST
            case ISO220RequestState.ONLINE_REQUEST_PENDING_TXN:
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_PENDING_TXN
                m_ReversalFlag = true
            case ISO220RequestState.ONLINE_REQUEST_EMV_ONLINE_AUTH:
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_EMV_ONLINE_AUTH
            case ISO220RequestState.ONLINE_REQUEST_EMV_FINAL_RESPONSE:
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_EMV_FINAL_RESPONSE
            case ISO220RequestState.ONLINE_REQUEST_SESSION_KEY:
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_SESSION_KEY
            case ISO220RequestState.ONLINE_REQUEST_GET_MISSING_DATA:
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_GET_MISSING_DATA
            case ISO220RequestState.ONLINE_DR_UPLOAD_TXN_START:
                m_iReqState = ISO220RequestState.ONLINE_DR_UPLOAD_TXN_START
            case ISO220RequestState.ONLINE_DR_UPLOAD_TXN_END:
                m_iReqState = ISO220RequestState.ONLINE_DR_UPLOAD_TXN_END
            case ISO220RequestState.ONLINE_SIGN_UPLOAD_TXN_START:
                m_iReqState = ISO220RequestState.ONLINE_SIGN_UPLOAD_TXN_START
            case ISO220RequestState.ONLINE_SIGN_UPLOAD_TXN_END:
                m_iReqState = ISO220RequestState.ONLINE_SIGN_UPLOAD_TXN_END
            default:
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED
        }
    }
    
    func ProcessData() -> Int {

        debugPrint("ProcessData")
        let Global = GlobalData.singleton

        GlobalData.IsMiniPVMPresent = false

        var iReturnee: Int = AppConstant.FALSE

        //Set Response state as per the Response from host to be used for next action
        _ = SetResponseState()

        //Check for data to replay
        CISO220.m_bDataToReplay = false
        if (bitmap[54 - 1]) {
            let p: [Byte] = data[54 - 1]
            let length: Int = len[54 - 1]
            CISO220.m_iReplayDataLen = length
            CISO220.m_bDataToReplay = true
            CISO220.m_bArrDataToReplay = [Byte](repeating: 0x00, count: AppConstant.MAX_REPLAY_DATA_LEN)
            CISO220.m_bArrDataToReplay = Array(p[0 ..< length])
            //System.arraycopy(p, 0, m_bArrDataToReplay, 0, length)
        }

        _ = CheckEMVResponse()
        if (bitmap[ISOFieldConstants.ISO_FIELD_7 - 1]) {
            setField7PrintPAD()
        }

        switch (m_iResState) {
        case ISO220ResponseState.ONLINE_RESPONSE_DECLINED:
            //do not add to txn history file
            m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED
            if (AppConstant.FALSE == HandleDeclineResponse()) {
                return AppConstant.FALSE
            }
            if (true == IsReward())//Amitesh::To check if full redeem required.
            {
                debugPrint("IsReward TRUE")
                m_bReward = AppConstant.TRUE//Amitesh:: Reward-Pay by points issue
                iReturnee = ProcessReponseData()
                if (iReturnee == ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH) {
                    debugPrint("RESPONSE_DATA_EXCEEDS_LENGTH")
                } else if (iReturnee == ISO220ResponseDataRetVal.RESPONSE_DATA_FINISHED) {
                    if (false == GetTransactionResponse()) {
                        return AppConstant.FALSE
                    }
                }
            }
            
        //REVERSAL RESPONSE ,TXN is completed
        case ISO220ResponseState.ONLINE_RESPONSE_PENDING_TXN:
            m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED
            if (false == GetTransactionResponse()) {
                return AppConstant.FALSE
            }
            
            //No Additional data ,TXN is completed , But either field 62 or field 53 should be set
        //We will clear the reversal flag for all transaction only if print data is found is printed
        case ISO220ResponseState.ONLINE_RESPONSE_NO_ADDITIONAL_INFO:
            m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED
            debugPrint("ONLINE_RESPONSE_NO_ADDITIONAL_INFO")
            if (EMVTxnType.ONLINE_AUTH == Global.m_iEMVTxnType) {
                if (false == GetTransactionResponse()) {
                    debugPrint("GetTransactionResponse False")
                    return AppConstant.FALSE
                }
            } else {
                iReturnee = ProcessReponseData()
                if (iReturnee == ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH) {
                    debugPrint("RESPONSE_DATA_EXCEEDS_LENGTH")
                } else if (iReturnee == ISO220ResponseDataRetVal.RESPONSE_DATA_FINISHED) {
                    if (false == GetTransactionResponse()) {
                        debugPrint("GetTransactionResponse AppConst.FALSE ")
                        return AppConstant.FALSE
                    }
                }
            }
            
        //Additional data response ,We will send the request for next packet
        case ISO220ResponseState.ONLINE_RESPONSE_MULTIPLE_ADDITIONAL_INFO:
            debugPrint("ONLINE_RESPONSE_MULTIPLE_ADDITIONAL_INFO")
            iReturnee = ProcessDownloadMiniPVM()
            m_iReqState = ISO220RequestState.ONLINE_REQUEST_MULTIPLE_ADDITIONAL_INFO
            if (iReturnee == AppConstant.MINI_PVM_EXCEEDS_LENGTH) {
                //display error message
                //cleanup and break
                debugPrint("MINI_PVM_EXCEEDS_LENGTH")
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED
            } else if (iReturnee == AppConstant.MINI_PVM_FINISHED) {
                GlobalData.IsMiniPVMPresent = true
                if (true /*TransactionHUB.txn_flow == TxnFlow.CLESS * TODO: yet to add TxnFlow */)//to handle mini PVM in case of CLESS
                {
                    TransactionHUB.cless_emv_mini_pvm = true
                }
                m_bMiniPVM = false/*((byte) AppConst.TRUE)*/
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_SINGLE_LAST_ADDITIONAL_INFO
            }
            
        //SINGLE/LAST Additional data ,we will send the request packet as same
        case ISO220ResponseState.ONLINE_RESPONSE_SINGLE_LAST_ADDITIONAL_INFO:
            iReturnee = ProcessDownloadMiniPVM()
            debugPrint("ONLINE_RESPONSE_SINGLE_LAST_ADDITIONAL_INFO")
            m_iReqState = ISO220RequestState.ONLINE_REQUEST_SINGLE_LAST_ADDITIONAL_INFO
            if (iReturnee == AppConstant.MINI_PVM_EXCEEDS_LENGTH) {
                //display error message
                //cleanup and break
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED
            } else if (iReturnee == AppConstant.MINI_PVM_FINISHED) {
                GlobalData.IsMiniPVMPresent = true
                if (true /*TransactionHUB.txn_flow == TxnFlow.CLESS * TODO: yet to add TxnFlow */)//to handle mini PVM in case of CLESS
                {
                    TransactionHUB.cless_emv_mini_pvm = true
                }
                m_bMiniPVM = false/*((byte) AppConst.TRUE)*/
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_SINGLE_LAST_ADDITIONAL_INFO
            }
            
            //Response coming in multi packet so we wil send request till
        //response ended is sent/ RESPONSE_DATA_FINISHED
        case ISO220ResponseState.ONLINE_RESPONSE_MULTI_PACKET_RESP_CONTINUED:
            m_iReqState = ISO220RequestState.ONLINE_REQUEST_MULTI_PACKET_RESP_CONTINUED
            debugPrint("ONLINE_RESPONSE_MULTI_PACKET_RESP_CONTINUED")
            iReturnee = ProcessReponseData()
            if (iReturnee == ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH) {
                debugPrint("RESPONSE_DATA_EXCEEDS_LENGTH")
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED
            } else if (iReturnee == ISO220ResponseDataRetVal.RESPONSE_DATA_FINISHED) {
                debugPrint("RESPONSE_DATA_FINISHED")
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED
                
                if (false == GetTransactionResponse()) {
                    debugPrint("GetTransactionResponse FALSE")
                    return AppConstant.FALSE
                }
                
            }
            
        case ISO220ResponseState.ONLINE_RESPONSE_MULTI_PACKET_RESP_ENDED:
            debugPrint("ONLINE_RESPONSE_MULTI_PACKET_RESP_ENDED")
            m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED
            
            if (true == IsReward())//Amitesh::To check if full redeem required.-code review changes
            {
                debugPrint("IsReward TRUE")
                m_bReward = AppConstant.TRUE//Amitesh:: Reward-Pay by points issue
            }
            
            iReturnee = ProcessReponseData()
            if (iReturnee == ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH) {
                debugPrint("RESPONSE_DATA_EXCEEDS_LENGTH")
            } else if (iReturnee == ISO220ResponseDataRetVal.RESPONSE_DATA_FINISHED) {
                if (false == GetTransactionResponse()) {
                    return AppConstant.FALSE
                }
            }
            
        case ISO220ResponseState.ONLINE_RESPONSE_INVALID_PROCESSING_CODE:
            debugPrint("ONLINE_RESPONSE_INVALID_PROCESSING_CODE")
            m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_ERR_TERMINATED
            
        case ISO220ResponseState.ONLINE_RESPONSE_SESSION_KEY:
            if (false == GetTransactionResponse()) {
                return AppConstant.FALSE
            }
            //        GetSessionKey()
            m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED
        case ISO220ResponseState.ONLINE_DR_UPLOAD_TXN_START:
            if (false == GetTransactionResponse()) {
                m_iReqState = ISO220RequestState.ONLINE_DR_UPLOAD_TXN_END
            }
        //        m_iReqState = ONLINE_DR_UPLOAD_TXN_START
        case ISO220ResponseState.ONLINE_DR_UPLOAD_TXN_END:
            if (false == GetTransactionResponse()) {
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_ERR_TERMINATED
            }
            m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED
            //amitesh::For Signature Upload
            
        case ISO220ResponseState.ONLINE_SIGN_UPLOAD_TXN_START:
            if (false == GetTransactionResponse()) {
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_ERR_TERMINATED
            }
            //        m_iReqState = ONLINE_DR_UPLOAD_TXN_START
            
        case ISO220ResponseState.ONLINE_SIGN_UPLOAD_TXN_END:
            if (false == GetTransactionResponse()) {
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_ERR_TERMINATED
            } else {
                m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED
            }
            
        default:
            m_iReqState = ISO220RequestState.ONLINE_REQUEST_TXN_ERR_TERMINATED
        }

        return AppConstant.TRUE
    }
    
    private func SetResponseState() -> Int {
        //Set Response state

        if (false == IsOK()) {
            m_iResState = ISO220ResponseState.ONLINE_RESPONSE_DECLINED
            m_bTxnDeclined = true
            //CGlobalData.m_bIsTxnDeclined=true

        } else if (data[3-1].elementsEqual(ProcessingCodeConstants.PC_ONLINE_TRANSACTION_REQ.utf8)) {
            //normal response for Online Txn Request.. Only One packet will be sent
            m_iResState = ISO220ResponseState.ONLINE_RESPONSE_NO_ADDITIONAL_INFO
        } else if (data[3-1].elementsEqual(ProcessingCodeConstants.PC_ONLINE_RESPONSE_GET_ADDTIONAL_INFO_START.utf8)) {
            //there is additional information but the packet is not enough...
            //Data to be send in Multiple packets
            //We will request for next packet in next request
            //miniPVM download in multiple packets
            m_iResState = ISO220ResponseState.ONLINE_RESPONSE_MULTIPLE_ADDITIONAL_INFO
        } else if (data[3-1].elementsEqual(ProcessingCodeConstants.PC_ONLINE_RESPONSE_GET_ADDTIONAL_INFO_END.utf8)) {
            //there is no additional information(miniPVM) and this packet is enough
            m_iResState = ISO220ResponseState.ONLINE_RESPONSE_SINGLE_LAST_ADDITIONAL_INFO
        } else if (data[3-1].elementsEqual(ProcessingCodeConstants.PC_ONLINE_RESPONSE_MULTI_PACKET_DATA_START.utf8)) {
            //multi packet response from the host ..
            //Data to be send in Multiple packets
            //We will request for next packet in next request
            m_iResState = ISO220ResponseState.ONLINE_RESPONSE_MULTI_PACKET_RESP_CONTINUED
        } else if (data[3-1].elementsEqual(ProcessingCodeConstants.PC_ONLINE_RESPONSE_MULTI_PACKET_DATA_END.utf8)) {
            //multi packet response data has ended..
            //This implies that Txn is completed
            m_iResState = ISO220ResponseState.ONLINE_RESPONSE_MULTI_PACKET_RESP_ENDED
        } else if (data[3-1].elementsEqual(ProcessingCodeConstants.PC_ONLINE_REVERSAL_RES_PCAKET.utf8)) {
            //Normal reversal response ..
            //Reversal is completed
            m_iResState = ISO220ResponseState.ONLINE_RESPONSE_PENDING_TXN
        } else if (data[3-1].elementsEqual(ProcessingCodeConstants.PC_ONLINE_KEY_EXCHANGE_REQ_PCAKET.utf8)) {
            //GET Session Key response
            m_iResState = ISO220ResponseState.ONLINE_RESPONSE_SESSION_KEY
        } else if (data[3-1].elementsEqual(ProcessingCodeConstants.PC_DR_DATA_UPLOAD_START.utf8)) {
            //GET Session Key response
            m_iResState = ISO220ResponseState.ONLINE_DR_UPLOAD_TXN_START
        } else if (data[3-1].elementsEqual(ProcessingCodeConstants.PC_DR_DATA_UPLOAD_END.utf8)) {
            //GET Session Key response
            m_iResState = ISO220ResponseState.ONLINE_DR_UPLOAD_TXN_END
        }
        //else if(memcmp(data[3-1],PC_ONLINE_SIGNATURE_UPLOAD_START,6) == 0)
        else if (data[3-1].elementsEqual(ProcessingCodeConstants.PC_ONLINE_SIGNATURE_UPLOAD_START.utf8)) {
            //GET Session Key response
            m_iResState = ISO220ResponseState.ONLINE_SIGN_UPLOAD_TXN_START//amitesh::For Signature Upload
        }
        //else if(memcmp(data[3-1],PC_ONLINE_SIGNATURE_UPLOAD_END,6) == 0)
        else if (data[3-1].elementsEqual(ProcessingCodeConstants.PC_ONLINE_SIGNATURE_UPLOAD_END.utf8)) {
            //GET Session Key response
            m_iResState = ISO220ResponseState.ONLINE_SIGN_UPLOAD_TXN_END
        } else {
            //invalid processing code and will no be processed ..
            //Txn will be aborted
            m_iResState = ISO220ResponseState.ONLINE_RESPONSE_INVALID_PROCESSING_CODE
        }
        return AppConstant.TRUE
    }
    
    
    private func CheckEMVResponse() -> Bool {
        debugPrint("Inside CheckEMVResponse")
        let global = GlobalData.singleton
        //let ulResponseVal: Int64 = Field20Values.INVALID_RESPONSE yet to add EMVModule supporting classes
        let bRetval: Bool = true
        //let objEMVModule = EMVModule.singleton Yet to add EMVModule

        debugPrint("global.m_iEMVTxnType[\(global.m_iEMVTxnType)]")
            //If this is any type of EMV transaction
        /*    if ((EMVTxnType.NOT_EMV != global.m_iEMVTxnType) && (EMVTxnType.ADDITONAL_DATA != global.m_iEMVTxnType)) {
    //            byte [] chArrEMVResponse = new byte[13]
                //memset(chArrEMVResponse,0,13)

                //Check for Feild 20 in response from HOST
                if (bitmap[20 - 1]) {
                    //memcpy(chArrEMVResponse, data[20-1], strlen(data[20-1]))
                    byte[] temp = new byte[data[20 - 1].length]
                    System.arraycopy(data[20 - 1], 0, temp, 0, data[20 - 1].length)
                    String chArrEMVResponse = new String(temp)
                    CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Feild 20[%s]", chArrEMVResponse)
                    ulResponseVal = Integer.parseInt(chArrEMVResponse, 16) //strtoul(chArrEMVResponse, NULL, 16)

                    objEMVModule.SetEMVResponseBitmask(ulResponseVal)
                    objEMVModule.m_bGotEMVBitMap = true

                }*/
    //        else // If Field is not present then we abort the transaction.
    //              // This handles the case in which txn is declined at Central host.
    //        {
    //            CLogger::TraceLog(TRACE_DEBUG,"Feild 20 = %s",chArrEMVResponse)
    //             objEMVModule.SetEMVResponseBitmask(0x10)
    //        }
    //        }
            return bRetval
    }
    
    private func HandleDeclineResponse() -> Int {
            let retVal = AppConstant.TRUE
            let globalData = GlobalData.singleton
            debugPrint("Inside HandleDeclineResponse")

            if (bitmap[58 - 1] == false) {
                GlobalData.m_bIsFiled58Absent = true
            } else {
                GlobalData.m_csFinalMsgDoHubOnlineTxn = GlobalData.m_csFinalMsgDisplay58
            }
            //Display message handling
            //If It Was a reversal request Display message that Reversal was declined
            if (m_ReversalFlag == true) {
                if (bitmap[58 - 1] == false) {
                    //CUIHelper.SetMessageWithWait("REVERSAL DECLINED !!")
                    debugPrint("REVERSAL NOT COMPLETED !!")
                }
                return AppConstant.FALSE
            } else if (EMVTxnType.NOT_EMV == globalData.m_iEMVTxnType) {
                if (bitmap[58 - 1] == false) {
                    //CUIHelper.SetMessageWithWait("TXN DECLINED !!")
                    debugPrint("TXN DECLINED")
                }
            }

            /************ CSV ***********************/
            //Copy CSV Data if Found
            //Clear Reversal
            if (bitmap[52 - 1]) {

                let iCSVlen: Int = len[52 - 1]
                let p1: [Byte] = data[52 - 1]
                //Arrays.fill(GlobalData.m_ptrCSVDATA.m_chBillingCSVData, 0, AppConst.MAX_CSV_LEN, (byte) '\u0000')
                globalData.m_ptrCSVDATA.m_chBillingCSVData = [Byte](repeating: 0x00, count: iCSVlen)
                if (iCSVlen < AppConstant.MAX_CSV_LEN) {
                    
                    globalData.m_ptrCSVDATA.m_chBillingCSVData = [Byte](p1[0 ..< iCSVlen])
                    //System.arraycopy(p1, 0, GlobalData.m_ptrCSVDATA.m_chBillingCSVData, 0, iCSVlen)
                    globalData.m_ptrCSVDATA.bCSVreceived = true
                    debugPrint("RECEIVED_CSV_DATA")
                    debugPrint("CSV[\(String(describing: String(bytes: globalData.m_ptrCSVDATA.m_chBillingCSVData, encoding: .ascii)?.trimmingCharacters(in: .whitespacesAndNewlines)))]")
                    
                    //todo check
                    let transactionData: PlutusTransactionData = parseCSVData(globalData)
                    SaveCSVDumptoFile()
                    saveTransactionFile(transactionData)
                } else {
                    //CUIHelper.SetMessageWithWait("Very LARGE CSV DATA")
                }
            }

            //NOT EMV Transactions
            if (globalData.m_iEMVTxnType == EMVTxnType.NOT_EMV) {
                _ = CISO220.ClearReversal()
            } else //EMV TRANSACTION
            {
                debugPrint("EMV TRANSACTION")
                /*      *//************ NORMAL/EMV UPLOAD ***********************//*
                //Clear Reversal
                CEMVModule objEMVModule = CEMVModule.GetInstance()
    //            byte []  chArrEMVResponse= new byte[13]
                //memset(chArrEMVResponse, 0, 13)

                long ulResponseVal = Field20Values.INVALID_RESPONSE
                if (GlobalData.m_iEMVTxnType != EMVTxnType.ONLINE_AUTH) //OFFLINE_UPLOAD//ONLINE_UPLOAD//FALLBACK//ADDITONAL_DATA
                {
                    ClearReversal(m_iHostID)
                    if (GlobalData.m_iEMVTxnType == EMVTxnType.ONLINE_UPLOAD
                            || GlobalData.m_iEMVTxnType == EMVTxnType.OFFLINE_UPLOAD) {
                        //Check for Feild 20 in response from HOST
                        if (bitmap[20 - 1]) {
                            //memcpy(chArrEMVResponse, data[20 - 1], strlen(data[20 - 1]))
                            byte[] temp = new byte[data[20 - 1].length]
                            System.arraycopy(data[20 - 1], 0, temp, 0, data[20 - 1].length)
                            String chArrEMVResponse = new String(temp)
                            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Feild 20[%s]",
                                    chArrEMVResponse)
                            ulResponseVal = Integer.parseInt(chArrEMVResponse, 16) //strtoul(chArrEMVResponse, NULL, 16)

                            objEMVModule.SetEMVResponseBitmask(ulResponseVal)

                        } else {
                            objEMVModule.SetEMVResponseBitmask(0x10)
                        }

                    }
                } else {
                    //Check for Feild 20 in response from HOST
                    if (bitmap[20 - 1]) {
                        //memcpy(chArrEMVResponse, data[20 - 1], strlen(data[20 - 1]))
                        byte[] temp = new byte[data[20 - 1].length]

                        System.arraycopy(data[20 - 1], 0, temp, 0, data[20 - 1].length)
                        String chArrEMVResponse = new String(temp)
                        CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Feild 20[%s]",
                                chArrEMVResponse)
                        ulResponseVal = Integer.parseInt(chArrEMVResponse, 16)//strtoul(chArrEMVResponse, NULL, 16)

                        objEMVModule.SetEMVResponseBitmask(ulResponseVal)

                    } else {
                        objEMVModule.SetEMVResponseBitmask(0x10)
                    }

                }*/
            }
            /************ SESSION KEY ***********************/
            //Nothing to do

            /************ EMV AUTH ***********************/
            //check for Issuer data if available
            //Reversal is not cleared at this step will be cleared in case of


            return retVal
        }
    
    
    public static func DeleteDumpFile() {
        debugPrint("DeleteDumpFile")
        let strTxnFileName = FileNameConstants.TXNFEILD62NAME
        debugPrint("txn field 62 file name[\(strTxnFileName)]")
        _ = FileSystem.DeleteFile(strFileName: strTxnFileName)
    }

    public static func DeleteDumpFileAMEXGPRS() {
        debugPrint("DeleteDumpFileAMEXGPRS")
        let strTxnFile62Name = FileNameConstants.TXNFEILD62NAMEAMEXGPRS
        debugPrint("txn field 62 file name[\(strTxnFile62Name)")
        _ = FileSystem.DeleteFile(strFileName: strTxnFile62Name)
    }

    /**
     * ClearReversal
     *
     * @return
     * @details Clear Reversal Flag for current transaction
     */
    public static func ClearReversal() -> Int {
        do {
            debugPrint("Inside ClearReversal")
            let globalData = GlobalData.singleton
            var nsLastTxnData: TerminalTransactionData = globalData.ReadLastTxnEntry()!
            if (nsLastTxnData == nil) {
                return AppConstant.FALSE
            }
            debugPrint("LAST TXN  ROC[\(nsLastTxnData.ulROC)], BatchID[\(nsLastTxnData.ulBatchId)], bIsReversalPending[\(nsLastTxnData.bIsReversalPending)]")

            nsLastTxnData.bIsReversalPending = false
            _ = globalData.UpDateLastTxnEntry(nsLastTxnData)

            debugPrint("LAST TXN  ROC[\(nsLastTxnData.ulROC)], BatchID[\(nsLastTxnData.ulBatchId)], bIsReversalPending[\(nsLastTxnData.bIsReversalPending)]")
        
            return AppConstant.TRUE
        } catch {
            debugPrint("Exception Occurred : \(error)")
            return AppConstant.FALSE
        }
    }
    
    func ProcessReponseData() -> Int {

        var bFoundAmex61DumpProcessed: Bool = false

        debugPrint("Inside ProcessReponseData")
        let Global = GlobalData.singleton
        var iReturnee: Int = ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH

        //Check for CSV data
        iReturnee = GetCSVResponseData()
        if (iReturnee == ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH) {
            debugPrint("RESPONSE_DATA_EXCEEDS_LENGTH in CSV")
            return ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH
        }

        //Do NoT Check in case it is EMV Online Auth
        if (EMVTxnType.ONLINE_AUTH != Global.m_iEMVTxnType) {
            debugPrint("IS NOT EMV AUTH REQ")

            // Check for AMEX GPRS PrinterDemo Dump
            
            iReturnee = GetPrintDumpDataAMEXGPRS()
            if (ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH == iReturnee) {
                debugPrint("RESPONSE_DATA_EXCEEDS_LENGTH in PrinterDemo Dump")
                //return RESPONSE_DATA_EXCEEDS_LENGTH
                bFoundAmex61DumpProcessed = false
            } else
            {
                bFoundAmex61DumpProcessed = true
            }
            
            if (bFoundAmex61DumpProcessed == false) {
                //Check For PrinterDemo Dump
                iReturnee = GetPrintDumpData()
                if (ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH == iReturnee) {
                    debugPrint("RESPONSE_DATA_EXCEEDS_LENGTH in PrinterDemo Dump")
                    return ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH
                }
            }
        }

        //Check For DR Data -- It is Assumed that DR Dump will end with or before PrinterDemo Dump
        if (AppConstant.FALSE == GetDRDumpData()) {
            debugPrint("RESPONSE_DATA_EXCEEDS_LENGTH in PrinterDemo Dump")
            return ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH
        }

        //Check For Signature Dump
        if (AppConstant.FALSE == GetSignatureImageDump()) {
            debugPrint("RESPONSE_DATA_EXCEEDS_LENGTH in Signature Dump")
            return ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH
        }

        //Check for Total Number of packets to Exchange
        iReturnee = GetPacketCount()

        debugPrint("GetPacketCount return \(iReturnee)")
        return iReturnee
        
    }

    
    private func GetCSVResponseData() -> Int {

        debugPrint("GetCSVResponseData")
        //CSV data shall not come in MultiPacket response
        //Otherwise Newer response will be copied
        //This Function return only wether more data can be accomodated or not.
        //Normal retrun is to be RESPONSE_DATA_FINISHED
        //In case of error :RESPONSE_DATA_EXCEEDS_LENGTH

        let globalData = GlobalData.singleton
        var iReturnee: Int = ISO220ResponseDataRetVal.RESPONSE_DATA_FINISHED

        //Check for CSV data
        if (bitmap[52 - 1]) {
            let iCSVlen: Int = len[52 - 1]
            let p1: [Byte] = data[52 - 1]

            //Arrays.fill(GlobalData.m_ptrCSVDATA.m_chBillingCSVData, 0, AppConst.MAX_CSV_LEN, (byte) '\u0000')
            globalData.m_ptrCSVDATA.m_chBillingCSVData = [Byte](repeating: 0x0, count: iCSVlen)
            if (iCSVlen < AppConstant.MAX_CSV_LEN) {
                
                globalData.m_ptrCSVDATA.m_chBillingCSVData = [Byte](p1[0 ..< iCSVlen])
                //System.arraycopy(p1, 0, GlobalData.m_ptrCSVDATA.m_chBillingCSVData, 0, iCSVlen)
                globalData.m_ptrCSVDATA.bCSVreceived = true
                debugPrint("RECEIVED_CSV_DATA")
                //parse CSV DATA
                debugPrint("GlobalData.m_ptrCSVDATA.m_chBillingCSVData:    \(String(describing: String(bytes: globalData.m_ptrCSVDATA.m_chBillingCSVData, encoding: .ascii)))")
                let transactionData: PlutusTransactionData = parseCSVData(globalData)
                SaveCSVDumptoFile()
                saveTransactionFile(transactionData)
                debugPrint("CSV[\(String(describing: String(bytes: globalData.m_ptrCSVDATA.m_chBillingCSVData, encoding: .ascii)?.trimmingCharacters(in: .whitespacesAndNewlines)))]")
            } else {
                //CUIHelper.SetMessageWithWait("Very LARGE CSV DATA")
                iReturnee = ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH
                debugPrint("CSV[\(globalData.m_ptrCSVDATA.m_chBillingCSVData)] Exceed Length")
            }
        } else {
            debugPrint("CSV[NO CSV DATA]")
        }

        return iReturnee

    }

    private func parseCSVData(_ globalData: GlobalData) -> PlutusTransactionData {
        var csvString: String = String(bytes: globalData.m_ptrCSVDATA.m_chBillingCSVData, encoding: .ascii)!
        if (csvString.isEmpty) {
            csvString = "105,\"7261A9\",\"APPROVED\",\"438624*******2802\",\"0406\",\"AMITMOHAN\",\"VISA\",11,2,\"30000001\",1,\"PROCESSED\", \"Acquiring Bank 1\", \"000100090015607\",\"624615343002\",1,1,\"HPCL Area 18\",\"Kamala Mills\",\"Noida\",\"1.51 ICICI BANK\",02, ,\"\n" + "\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"\",\"02012011\",\"210403\",12345,9002,105"
        }

        let strval = csvString.split(separator: ",")
        let responseParsingCSVData = ResponseParsingCSVData()
        let transactionData = PlutusTransactionData()
        for i in 0 ..< strval.count {
            let val: String = strval[i].trimmingCharacters(in: .whitespacesAndNewlines).replaceAll(of: "\"", with: "")
            do {
                switch (i) {
                    case IndexUtil.INDEX_BILLING_REF_ID:   //used as billing ref num
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setBillingReferenceId(val)
                            transactionData.setBillingReferenceId(val)
                            transactionData.setOriginalBillingReferenceNumber(val)
                        }
                    case IndexUtil.INDEX_AUTH_CODE:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setAuthCode(val)
                            transactionData.setAuthCode(val)
                        }
                    case IndexUtil.INDEX_TXN_RESPONSE:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setTransactionResponse(val)
                            transactionData.setTransactionResponse(val)
                        }
                    case IndexUtil.INDEX_CARD_MASKED_PAN:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setCardMaskedPan(val)
                            transactionData.setCardMaskedPan(val)
                            transactionData.setCustomerVPA(val)  //for UPI
                            transactionData.setMobileNumber(val) //for wallet
                        }
                    case IndexUtil.INDEX_CARD_EXPIRY_DATE:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setExpiryDate(val)
                            transactionData.setExpiryDate(val)
                        }
                    case IndexUtil.INDEX_CARD_HOLDER_NAME:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setCardholderName(val)
                            transactionData.setName(val)
                        }
                    case IndexUtil.INDEX_HOST_TYPE:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setHostType(val)
                            transactionData.setHostType(val)
                        }
                    case IndexUtil.INDEX_EDC_ROC:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setEdcROC(val)
                            transactionData.setEdcROC(Int64(val)!)
                        }
                    case IndexUtil.INDEX_EDC_BATCH_ID:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setEdcBatchId(val)
                            transactionData.setEdcBatchId(Int64(val)!)
                        }
                    case IndexUtil.INDEX_TERMINAL_ID:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setTerminalID(val)
                            transactionData.setTerminalId(val)
                        }
                    case IndexUtil.INDEX_LOYALTY_POINTS_REWARD:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setLoyaltyPointsReward(val)
                        }
                    case IndexUtil.INDEX_REMARK:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setRemark(val)
                        }
                    case IndexUtil.INDEX_ACQUIRER_NAME:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setTransactionAcquirerName(val)
                            transactionData.setAcquirer(val)
                        }
                    case IndexUtil.INDEX_MERCHANT_ID:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setMerchantID(val)
                            transactionData.setMerchantId(val)
                        }
                    case IndexUtil.INDEX_RRN:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setRetrievalReferenceNumber(val)
                            transactionData.setRrn(val)
                        }
                    case IndexUtil.INDEX_ENTRY_MODE:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setCardEntryMode(val)
                        }
                    case IndexUtil.INDEX_PRINT_CARDHOLDER_NAME:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setPrintCardholderNameOnReceipt(val)
                        }
                    case IndexUtil.INDEX_MERCHANT_NAME:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setMerchantName(val)
                        }
                    case IndexUtil.INDEX_MERCHANT_ADDRESS:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setMerchantAddress(val)
                        }
                    case IndexUtil.INDEX_MERCHANT_CITY:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setMerchantCity(val)
                        }
                    case IndexUtil.INDEX_PLUTUS_VERSION:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setPlutusVersion(val)
                        }
                    case IndexUtil.INDEX_ACQUIRER_CODE:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setAcquirerCode(val)
                        }
                    case IndexUtil.INDEX_EMI_TENURE:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setEmiTenure(val)
                            transactionData.setEmiTenure(Int(val)!)
                        }
                    case IndexUtil.INDEX_EMI_PROCESSING_FEE:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setEmiProcessingFee(val)
                            transactionData.setEmiProcessingFee(Double(val)!)
                        }
                    case IndexUtil.INDEX_REWARD_BALANCE_AMOUNT:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setEmiProcessingFee(val)
                        }
                    case IndexUtil.INDEX_EMI_INTEREST_RATE:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setEmiInterestRate(val)
                            transactionData.setEmiInterestRate(Double(val)!)
                        }
                    case IndexUtil.INDEX_CHARGE_SLIP_PRINT_DATA:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setEmiInterestRate(val)
                        }
                    case IndexUtil.INDEX_COUPON_CODE:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setCouponCode(val)
                        }
                    case IndexUtil.INDEX_AMOUNT_PROCESSED:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setTransactionAmountProcessed(val)
                            transactionData.setAmount(Double(val)!)
                        }
                    case IndexUtil.INDEX_RFU3:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setRfu3(val)
                        }
                    case IndexUtil.INDEX_SETTLEMENT_SUMMARY:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setSettlementSummary(val)
                        }
                    case IndexUtil.INDEX_DATE:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setDateOfTransaction(val)
                            var date: String = ""
                            transactionData.setDate(setTxnDateTime(&date, val, nil)!)
                        }
                    case IndexUtil.INDEX_TIME:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setTimeOfTransaction(val)
                            var date: String = transactionData.getDate()!
                            transactionData.setDate(setTxnDateTime(&date, nil, val)!)
                        }
                    case IndexUtil.INDEX_TRANSACTION_ID:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setTransactionId(val)
                            transactionData.setTransactionId(Int64(val)!)
                        }
                    case IndexUtil.INDEX_TXN_AMOUNT:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setTransactionAmount(val)
                        }
                    case IndexUtil.INDEX_TXN_TYPE:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setTransactionType(val)
                            transactionData.setTransactionType(val)
                        }
                    case IndexUtil.INDEX_RESERVED:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setReservedField(val)
                        }
                    case IndexUtil.INDEX_EMI_PRODUCT_CAT:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setEmiProductCategory(val)
                            transactionData.setProductCategory(val)
                        }
                    case IndexUtil.INDEX_EMI_PRODUCT_NAME:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setEmiProductName(val)
                            transactionData.setOemName(val)
                        }
                    case IndexUtil.INDEX_EMI_PRODUCT_DESCRIPTION:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setEmiProductDescription(val)
                            transactionData.setProductDesc(val)
                        }
                    case IndexUtil.INDEX_IMEI:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setImei(val)
                            transactionData.setProductSerial(val)
                        }
                    case IndexUtil.INDEX_MASKED_MOBILE:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setMaskedMobileNumber(val)
                            transactionData.setMobileNumber(val)
                        }
                    case IndexUtil.INDEX_EMI_ORIGINAL_TXN_AMOUNT:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setOriginalTransactionAmount(val)
                            transactionData.setEmiTxnAmount(Double(val)!)
                        }
                    case IndexUtil.INDEX_ISSUER_NAME:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setIssuerName(val)
                            transactionData.setCardIssuer(val)
                        }
                    case IndexUtil.INDEX_EMI_PRINCIPLE_AMOUNT:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setEmiPrincipleAmount(val)
                            transactionData.setEmiLoanAmount(Double(val)!)
                        }
                    case IndexUtil.INDEX_EMI_AMOUNT:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setEmiAmount(val)
                            transactionData.setEmiAmount(Double(val)!)
                        }
                    case IndexUtil.INDEX_EMI_TOTAL_AMOUNT:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setEmiTotalAmount(val)
                            transactionData.setEmiTotalAmount(Double(val)!)
                        }
                    case IndexUtil.INDEX_EMAIL:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setCustomerEmail(val)
                            transactionData.setEmailId(val)
                        }
                    case IndexUtil.INDEX_ORIGINAL_BILLING_DETAILS:
                        if (!val.isEmpty/*!TextUtils.isEmpty(val) TODO: yet to add TextUtils**/) {
                            responseParsingCSVData.setOriginalBillingDetails(val)
                            let values = val.split(separator: Character("\\|"))
                            if (values.count >= 2) {
                                do {
                                    transactionData.setOriginalEdcBatchId(Int64(values[0])!)
                                    transactionData.setOriginalEdcROC(Int64(values[1])!)
                                } catch {
                                    debugPrint("Error Occurred \(error)")
                                }
                            }
                            if (values.count > 2) {
                                transactionData.setOriginalBillingReferenceNumber(String(values[2]))
                            }
                        }
                    default:
                        debugPrint("CSV", "Unexpected index")
                }
            } catch  {
                debugPrint("Exception ParseCSV \(error)")
            }
        }
        setTxnType(transactionData, responseParsingCSVData)
        GlobalData.singleton.setTransactionAmount(transactionData)
        GlobalData.singleton.updateTxnEntry(transactionData)
        return transactionData
    }

    
    
    private func setTxnDateTime(_ txnDate: inout String, _ date: String?, _ time: String?) -> String? {
        if (date == nil && time == nil && !date!.isEmpty && !time!.isEmpty) {
            return nil
        }
        if (txnDate == nil && !txnDate.isEmpty) {
            txnDate = ""
        }
        if (date != nil && !date!.isEmpty) {
            //input format ddmmyyyy, convert to yyyy-mm-dd
            if (date!.count > 7) {
                txnDate = String(format: AppConstant.TXN_DATE_FORMAT, date!.substring(from: 4, to: 8), date!.substring(from: 0, to: 2), date!.substring(from: 2, to: 4))
            }
        }
        if (time != nil && !time!.isEmpty) {
            if (time!.count > 5) {
                //input format HHmmss, convert to HH:mm:ss.SSS
                let txnTime = String(format: AppConstant.TXN_TIME_FORMAT, time!.substring(from: 0, to: 2), time!.substring(from: 2, to: 4), time!.substring(from: 4, to: 6), "000")
                txnDate = "\(txnDate)" + " " + "\(txnTime)"
            }
        }
        return txnDate
    }

    //set transaction type and status
    private func setTxnType(_ transactionData: PlutusTransactionData, _ responseParsingCSVData: ResponseParsingCSVData) {
                
        if let responseCode = transactionData.getTransactionResponse(), let authCode = transactionData.getAuthCode()
        {
            if responseCode != nil || !responseCode.isEmpty
            {
                if ((authCode != nil || !authCode.isEmpty) && PlutusTransactionStatus.TRANSACTION_STATUS_SUCCESS_MSG.caseInsensitiveCompare(responseCode) == .orderedSame) {
                    transactionData.setStatus(PlutusTransactionStatus.TRANSACTION_STATUS_SUCCESS)
                } else if (PlutusTransactionStatus.TRANSACTION_STATUS_VOID_SUCCESS_MSG.caseInsensitiveCompare(responseCode) == .orderedSame) {
                    transactionData.setStatus(PlutusTransactionStatus.TRANSACTION_STATUS_CANCELLED)
                } else {
                    if (PlutusTransactionStatus.TRANSACTION_STATUS_PENDING_MSG.caseInsensitiveCompare(responseCode) == .orderedSame ||
                        PlutusTransactionStatus.TRANSACTION_STATUS_COMPLETE_GET_STATUS_MSG.caseInsensitiveCompare(responseCode) == .orderedSame) {
                        transactionData.setStatus(PlutusTransactionStatus.TRANSACTION_STATUS_PENDING)
                    } else {
                        transactionData.setStatus(PlutusTransactionStatus.TRANSACTION_STATUS_FAILURE)
                    }
                }
                
                if (GlobalData.singleton.isThirdPartyBillingAppRequest) {
                    if(PlutusTransactionStatus.TRANSACTION_STATUS_VOID_SUCCESS_MSG.caseInsensitiveCompare(responseCode) == .orderedSame){
                        var csvString = String(bytes: GlobalData.singleton.m_ptrCSVDATA.m_chBillingCSVData, encoding: .ascii)
                        if(!csvString!.isEmpty/*!TextUtils.isEmpty(csvString) TODO: yet to add TextUtils**/){
                            csvString = csvString!.replaceAll(of: PlutusTransactionStatus.TRANSACTION_STATUS_VOID_SUCCESS_MSG, with: PlutusTransactionStatus.TRANSACTION_STATUS_SUCCESS_MSG)
                            GlobalData.singleton.m_ptrCSVDATA.m_chBillingCSVData = [Byte](csvString!.bytes)
                        }
                    }
                    checkTransactionTypeForThirdPartyAppRequest(transactionData, responseParsingCSVData)
                }
            }
        }
    }
    
    private func checkTransactionTypeForThirdPartyAppRequest(_ transactionData: PlutusTransactionData, _ responseParsingCSVData: ResponseParsingCSVData) {
        let txnType: String = getTxnTypeForThirdPartyTransaction(responseParsingCSVData)!
        if (!txnType.isEmpty/*!TextUtils.isEmpty(txnType) TODO: yet to add TextUtils*/) {
            transactionData.setTransactionType(txnType)
        }
    }
    
    private func getTxnTypeForThirdPartyTransaction(_ responseParsingCSVData: ResponseParsingCSVData) -> String? {
        if (GlobalData.singleton.isThirdPartyBillingAppRequest) {
            switch (responseParsingCSVData.getTransactionType()) {
                case AppConstant.TP_TXN_WALLET:
                    switch (responseParsingCSVData.getAcquirerCode()) {
                        case AppConstant.WALLET_FREECHARGE_BANK:
                            return AppConstant.TXN_FREECHARGE_WALLET
                        case AppConstant.WALLET_PHONEPE_BANK:
                            return AppConstant.TXN_PHONEPE_WALLET
                        default:
                            return nil
                    }
                case AppConstant.TP_TXN_AMAZON_PAY:
                    return AppConstant.TXN_AMAZON_PAY_WALLET
                case AppConstant.TP_TXN_AIRTEL_MONEY:
                    return AppConstant.TXN_AIRTEL_WALLET
                case AppConstant.TP_TXN_UPI:
                    return AppConstant.TXN_UPI
                case AppConstant.TP_TXN_BHARATQR:
                    return AppConstant.TXN_BHARAT_QR
                case AppConstant.TP_TXN_PG_POS_CARD:
                    return AppConstant.TXN_PG_AT_POS_CARD
                case AppConstant.TP_TXN_PG_POS_NETBANK:
                    return AppConstant.TXN_PG_AT_POS_NETBANK
                case AppConstant.TP_TXN_PG_POS_BANKEMI:
                    return AppConstant.TXN_PG_AT_POS_BANK_EMI
                case AppConstant.TP_TXN_PG_POS_BRANDEMI:
                    return AppConstant.TXN_PG_AT_POS_BRAND_EMI
                default:
                    return nil
            }
        }
        return nil
    }
    
    
    private func GetPrintDumpDataAMEXGPRS() -> Int {

        //Check for PrinterDemo Buffer..
        //If PrinterDemo Buffer is not present than we Decline The Txn
        //This Function return only wether more data can be accomodated or not.
        //Normal retrun is to be RESPONSE_ADDITIONAL_DATA_LEFT
        //In case of error :RESPONSE_DATA_EXCEEDS_LENGTH

        if ((!bitmap[61 - 1]) /*&& ( true != GlobalData->m_ptrCSVDATA->bPrintingFlag)*/) {
            debugPrint("ProcessReponseData !bitmap[61-1]")
            return ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH
        }
        let p: [Byte] = data[61 - 1]
        let length: Int = len[61 - 1]
        var iReturnee: Int = ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH

        debugPrint("GetPrintDumpDataAMEXGPRS m_iCurrentPrintDumpOffset = \(String(describing: m_iCurrentPrintDumpOffsetAmexGprs)) length = \(length)")

        //If We can Accomodate this printing data than for this function we have more data left
        if ((m_iCurrentPrintDumpOffsetAmexGprs! + length) < AppConstant.MAX_RESPONSE_DATA_LEN) {

            //memcpy(m_bPrintDataAmexGprs + m_iCurrentPrintDumpOffsetAmexGprs,p,length)
            m_bPrintDataAmexGprs[m_iCurrentPrintDumpOffsetAmexGprs! ..< m_iCurrentPrintDumpOffsetAmexGprs! + length] = (p[0 ..< length])
            //System.arraycopy(p, 0, m_bPrintDataAmexGprs, m_iCurrentPrintDumpOffsetAmexGprs, length)
            m_iCurrentPrintDumpOffsetAmexGprs! += length

            debugPrint("ProcessReponseData iReturnee = RESPONSE_ADDITIONAL_DATA_LEFT")
            iReturnee = ISO220ResponseDataRetVal.RESPONSE_ADDITIONAL_DATA_LEFT
        } else {
            //valid case
            //invalid case display an error message
            // "INVALID ADDITIONAL"
            //"IFNORMATION REQUEST"
            debugPrint("ProcessReponseData iReturnee = RESPONSE_DATA_EXCEEDS_LENGTH")
            iReturnee = ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH
        }
        return iReturnee

    }

    private func GetPrintDumpData() -> Int {
        //Check for PrinterDemo Buffer..
        //If PrinterDemo Buffer is not present than we Decline The Txn
        //This Function return only wether more data can be accomodated or not.
        //Normal retrun is to be RESPONSE_ADDITIONAL_DATA_LEFT
        //In case of error :RESPONSE_DATA_EXCEEDS_LENGTH

        if ((!bitmap[62 - 1]) /*&& ( true != GlobalData->m_ptrCSVDATA->bPrintingFlag)*/) {
            debugPrint("ProcessReponseData bitmap[62-1][\(bitmap[62 - 1])]")
            return ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH
        }
        let p: [Byte] = data[62 - 1]
        let length: Int = len[62 - 1]
        var iReturnee = ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH

        //If We can Accomodate this printing data than for this function we have more data left
        if ((m_iCurrentPrintDumpOffset! + length) < AppConstant.MAX_RESPONSE_DATA_LEN) {
            debugPrint("ProcessReponseData m_iCurrentPrintDumpOffset[\(String(describing: m_iCurrentPrintDumpOffset))] length[\(length)]")
            m_bPrintData[m_iCurrentPrintDumpOffset! ..< m_iCurrentPrintDumpOffset! + length] = (p[0 ..< length])
            //System.arraycopy(p, 0, m_bPrintData, m_iCurrentPrintDumpOffset, length)
            
            m_iCurrentPrintDumpOffset! += length
            debugPrint("ProcessReponseData, iReturnee = RESPONSE_ADDITIONAL_DATA_LEFT")
            iReturnee = ISO220ResponseDataRetVal.RESPONSE_ADDITIONAL_DATA_LEFT
        } else {
            //valid case
            //invalid case display an error message
            // "INVALID ADDITIONAL"
            //"IFNORMATION REQUEST"
            //CUIHelper.SetMessageWithWait("Very LARGE PRINT DATA")
            debugPrint("ProcessReponseData, iReturnee = RESPONSE_DATA_EXCEEDS_LENGTH")
            iReturnee = ISO220ResponseDataRetVal.RESPONSE_DATA_EXCEEDS_LENGTH
        }
        return iReturnee
    }
    
    
    private func ProcessDownloadMiniPVM() -> Int {
         debugPrint("Inside ProcessDownloadMiniPVM")

         let p: [Byte] = data[57 - 1]
         let length: Int = len[57 - 1]
         //String s  = new String(p)
         //Log.d("MINI PVM", s)
        var iReturnee: Int = AppConstant.MINI_PVM_EXCEEDS_LENGTH

        if ((m_iMiniPVMOffset! + length) < AppConstant.MAX_MINI_PVM_LEN) {
            
            m_uchMiniPVM[m_iMiniPVMOffset! ..< m_iMiniPVMOffset! + length] = (p[0 ..< length])
            //System.arraycopy(p, 0, m_uchMiniPVM, m_iMiniPVMOffset, length)
            m_iMiniPVMOffset! += length
            iReturnee = AppConstant.MINI_PVM_ADDITIONAL_DATA_LEFT
        } else {
            return iReturnee //valid case //invalid case display an error message
        }

        let pFieldPVMDef: [Byte] = data[53 - 1]
        let ilength: Int = len[53 - 1]
         if (ilength >= 2) {
            var offset: Int = 0
            self.m_bCurrentPacketCount = (Int(pFieldPVMDef[offset]) << 8) & Int(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount! |= (Int(pFieldPVMDef[offset])) & Int(0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = (Int(pFieldPVMDef[offset]) << 8) & Int(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount! |= (Int(pFieldPVMDef[offset])) & Int(0x000000FF)
            offset += 1

            if (self.m_bCurrentPacketCount == self.m_bTotalPacketCount) {
                do{
                    
                    var tempData = [String]()
                    tempData.append(String(bytes: [Byte](m_uchMiniPVM[0 ..< m_iMiniPVMOffset!]), encoding: .ascii)!)
                    
                    _ = try FileSystem.WriteByteFile(strFileName: FileNameConstants.MINIPVM, with: tempData)
                }
                catch{
                    debugPrint("Error in WriteByteFile \(FileNameConstants.MINIPVM)")
                }
                
                iReturnee = AppConstant.MINI_PVM_FINISHED
                m_uchMiniPVM = [Byte](repeating: 0x00, count: AppConstant.MAX_MINI_PVM_LEN)
                m_iMiniPVMOffset = 0
            }
         }
         return iReturnee
     }
    
    private func GetDRDumpData() -> Int {

        //Check for DR buffer
        //If PrinterDemo Buffer is not present than we Decline The Txn
        //This Function return only wether more data can be accomodated or not.
        //Normal retrun is to be RESPONSE_ADDITIONAL_DATA_LEFT
        //In case of error :RESPONSE_DATA_EXCEEDS_LENGTH

        if ((bitmap[ISOFieldConstants.ISO_FIELD_63 - 1])) {

            let p: [Byte] = data[ISOFieldConstants.ISO_FIELD_63 - 1]
            let length: Int = len[ISOFieldConstants.ISO_FIELD_63 - 1]

            //If We can Accomodate this printing data than for this function we have more data left
            if ((m_iCurrentDRDataDumpOffset + length) < AppConstant.MAX_DR_RESPONSE_DATA_LEN) {

                debugPrint("ProcessReponseData, m_iCurrentDRDataDumpOffset[\(m_iCurrentDRDataDumpOffset)], length[\(length)]")
                m_uchPtrDRData[m_iCurrentDRDataDumpOffset ..< m_iCurrentDRDataDumpOffset + length] = (p[0 ..< length])
                //System.arraycopy(p, 0, m_uchPtrDRData, m_iCurrentDRDataDumpOffset, length)
                m_iCurrentDRDataDumpOffset += length

                debugPrint("ProcessReponseData, iReturnee = RESPONSE_ADDITIONAL_DATA_LEFT")
                //iReturnee = RESPONSE_ADDITIONAL_DATA_LEFT
            } else {

                //valid case
                //invalid case display an error message
                // "INVALID ADDITIONAL"
                //"IFNORMATION REQUEST"
                //CUIHelper.SetMessageWithWait("Very LARGE DR DUMP")
                debugPrint("ProcessReponseData, iReturnee = RESPONSE_DATA_EXCEEDS_LENGTH")

                return AppConstant.FALSE

            }
        }
        return AppConstant.TRUE


    }

    private func GetSignatureImageDump() -> Int {

        //Check for DR buffer
        //If PrinterDemo Buffer is not present than we Decline The Txn
        //This Function return only wether more data can be accomodated or not.
        //Normal retrun is to be RESPONSE_ADDITIONAL_DATA_LEFT
        //In case of error :RESPONSE_DATA_EXCEEDS_LENGTH

        if ((bitmap[ISOFieldConstants.ISO_FIELD_60 - 1])) {

            if (!m_bIsSignatureImageMemoryAllocated) {
                m_uchPtrSignatureImage = [Byte](repeating: 0x00, count: AppConstant.MAX_SIG_IMAGE_RESPONSE_DATA_LEN)
                m_bIsSignatureImageMemoryAllocated = true
            }

            let p: [Byte] = data[ISOFieldConstants.ISO_FIELD_60 - 1]
            let length: Int = len[ISOFieldConstants.ISO_FIELD_60 - 1]

            //If We can Accomodate this printing data than for this function we have more data left
            if ((m_iCurrentSignatureImageDumpOffset + length) < AppConstant.MAX_SIG_IMAGE_RESPONSE_DATA_LEN) {

               debugPrint("ProcessReponseData, m_iCurrentSignatureImageDumpOffset[\(m_iCurrentSignatureImageDumpOffset)] length[\(length)]")

                m_uchPtrSignatureImage[m_iCurrentSignatureImageDumpOffset ..< m_iCurrentSignatureImageDumpOffset + length] = (p[0 ..< length])
                //System.arraycopy(p, 0, m_uchPtrSignatureImage, m_iCurrentSignatureImageDumpOffset, length)
                m_iCurrentSignatureImageDumpOffset += length

            } else {
                //valid case
                //invalid case display an error message
                // "INVALID ADDITIONAL"
                //"IFNORMATION REQUEST"
                //CUIHelper.SetMessageWithWait("Very LARGE SIG DUMP")
                debugPrint("GetSignatureImageDump,  RESPONSE_DATA_EXCEEDS_LENGTH")

                return AppConstant.FALSE
            }
        }
        return AppConstant.TRUE

    }
    
    private func GetPacketCount() -> Int {
        //Get the packet count in case of multipacket response..
        //If PrinterDemo Buffer is not present than we Decline The Txn
        //This Function return only wether more data can be accomodated or not.
        //Normal retrun is to be RESPONSE_ADDITIONAL_DATA_LEFT
        //In case of packet exchange is completed :RESPONSE_DATA_FINISHED

        var iReturnee: Int = ISO220ResponseDataRetVal.RESPONSE_ADDITIONAL_DATA_LEFT
        let pFieldPVMDef = data[53 - 1]
        let ilength = len[53 - 1]
        if (ilength >= 2) {
            //Amitesh::moving packet count to 2 bytes
            var offset: Int = 0
            self.m_bCurrentPacketCount = Int(Int(pFieldPVMDef[offset] << 8) & Int(0x0000FF00))
            offset += 1
            self.m_bCurrentPacketCount! |= Int((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = Int(Int(pFieldPVMDef[offset] << 8) & Int(0x0000FF00))
            offset += 1
            self.m_bTotalPacketCount! |= Int((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1

            if (self.m_bCurrentPacketCount == self.m_bTotalPacketCount) {
                iReturnee = ISO220ResponseDataRetVal.RESPONSE_DATA_FINISHED
                
                debugPrint("ProcessReponseData, iReturnee = RESPONSE_DATA_FINISHED")
            }
        }
        return iReturnee

    }
    
    func SaveDumptoFileAMEXGPRS() {
        debugPrint("Inside SaveDumptoFileAMEXGPRS")
        var iOffset: Int = 0
        let p: [Byte] = m_bPrintDataAmexGprs
        var length = [Byte](repeating: 0x00, count: 4)
        length[iOffset] = Byte((m_iCurrentPrintDumpOffsetAmexGprs! >> 24) & 0x000000FF)
        iOffset += 1
        length[iOffset] = Byte((m_iCurrentPrintDumpOffsetAmexGprs! >> 16) & 0x000000FF)
        iOffset += 1
        length[iOffset] = Byte((m_iCurrentPrintDumpOffsetAmexGprs! >> 8) & 0x000000FF)
        iOffset += 1
        length[iOffset] = Byte(m_iCurrentPrintDumpOffsetAmexGprs! & 0x000000FF)
        iOffset += 1

        let chTxnField62Name = String(format: "%@", FileNameConstants.TXNFEILD62NAMEAMEXGPRS)
        debugPrint("txn field 62 file name[\(chTxnField62Name)]")

        if (true == FileSystem.IsFileExist(strFileName: chTxnField62Name)) {
            //should not come here
            _ = FileSystem.DeleteFile(strFileName: chTxnField62Name)
            debugPrint("DeleteFile[\(chTxnField62Name)]")
        }
        //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "data saved len[%d]", length)
        //CLogger.TraceBuffer(length.value, p)
        
        do{
            var tempData = [String]()
            tempData.append(String(bytes: [Byte](length[0 ..< iOffset]), encoding: .ascii)!)
            
            _ = try FileSystem.AppendByteFile(strFileName: chTxnField62Name, with: tempData)
        }
        catch{
            debugPrint("Error in AppendFile \(chTxnField62Name)")
        }
        
        do{
            var tempData = [String]()
            tempData.append(String(bytes: p[0 ..< m_iCurrentPrintDumpOffsetAmexGprs!], encoding: .ascii)!)
            
            _ = try FileSystem.AppendByteFile(strFileName: chTxnField62Name, with: tempData)
        }
        catch{
            debugPrint("Error in AppendFile \(chTxnField62Name)")
        }
    }

    func RenameSignatureFile() {
        do {
            debugPrint("Inside RenameSignatureFile")
            let ret = FileSystem.IsFileExist(strFileName: FileNameConstants.TMPSIGNATURECAPTURFILE)

            if (ret) {

                let globalData = GlobalData.singleton
                var nsLastTxnData: TerminalTransactionData = globalData.ReadLastTxnEntry()!

                nsLastTxnData.bIsSignatureCapturedForTransaction = globalData.m_bIsSignCapturedSuccessfully
                
                _ = globalData.UpDateLastTxnEntry(nsLastTxnData)

                nsLastTxnData = globalData.ReadLastTxnEntry()!

                //Rename Sign File
                if (nsLastTxnData.bIsSignatureCapturedForTransaction) {
                    let iFileIndex: Int = Int(10001000 + nsLastTxnData.ulROC)
                    let chsgnbmpFileName = String(format: "im%08d", iFileIndex)
                    _ = FileSystem.RenameFile(strNewFileName: chsgnbmpFileName, strFileName: FileNameConstants.TMPSIGNATURECAPTURFILE)
                }
            }
        } catch {
            debugPrint("Exception Occured \(error)")
        }
    }
    
    /**
     * AfterDataExchange
     *
     * @return
     * @details Base Class Function
     */
    func AfterDataExchange() -> Int {
        //dummy function
        return AppConstant.TRUE
    }
    
    private func SaveDumptoFileForPADPrinting() {
        debugPrint("Inside SaveDumptoFileForPADPrinting")
        let p: [Byte] = m_bPrintData
        var length = Int()
        length = m_iCurrentPrintDumpOffset!

        let chPADTxnField62Name = String(format: "%@", FileNameConstants.PADTXNFEILD62NAME)
        //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "PAD txn field 62 file name[%s]", chPADTxnField62Name)

        if (true == FileSystem.IsFileExist(strFileName: chPADTxnField62Name)) {
            //should not come here
            _ = FileSystem.DeleteFile(strFileName: chPADTxnField62Name)
            debugPrint("DeleteFile[\(chPADTxnField62Name)]")
        }
        debugPrint("data saved len[\(length)]")
        //CLogger.TraceBuffer(length.value, p)


        do{
            var tempData = [Int]()
            tempData.append(length)
            
            _ = try FileSystem.AppendFile(strFileName: chPADTxnField62Name, with: tempData)
        }
        catch{
            debugPrint("Error in AppendFile \(chPADTxnField62Name)")
        }
    
        m_iCurrentPrintDumpOffset = length
        
        do{
            //TODO: recheck
            var tempData = [String]()
            tempData.append(String(bytes: p, encoding: .ascii)!)
            
            _ = try FileSystem.AppendByteFile(strFileName: chPADTxnField62Name, with: tempData)
        }
        catch{
            debugPrint("Error in AppendFile \(chPADTxnField62Name)")
        }
        //CFileSystem.AppendByteFile(m_cntx, chPADTxnField62Name, p, length.value)
    }

    public static func DeleteDumpFileForPADPrinting() {
        debugPrint("Inside DeleteDumpFileForPADPrinting")
        let strFilePADTxnField = String(format: "%@", FileNameConstants.PADTXNFEILD62NAME)
        debugPrint("PAD txn field 62 file name[\(strFilePADTxnField)]")
        _ = FileSystem.DeleteFile(strFileName: strFilePADTxnField)
    }

    private func GetDefaultPrintingData() -> [Byte]? {
        do {
            debugPrint("Inside GetDefaultPrintingData")

            var bArrDefaultPrintingData = [Byte]()
            let globalData = GlobalData.singleton
            let m_sParamData: TerminalParamData = globalData.ReadParamFile()!

            let iMessagelen: Int = m_sParamData.m_strNoPrintMessage.count
            debugPrint("Messagelen[\(iMessagelen)]")

            if (iMessagelen > 0) {
                bArrDefaultPrintingData =  [Byte]( repeating: 0x00, count: iMessagelen)
                
                let tempBytes = [Byte](m_sParamData.m_strNoPrintMessage.utf8)
                bArrDefaultPrintingData = [Byte](tempBytes[0 ..< iMessagelen])
                
                //System.arraycopy(m_sParamData.m_strNoPrintMessage.getBytes(), 0, bArrDefaultPrintingData, 0, iMessagelen)
            } else {
                bArrDefaultPrintingData = [Byte]("    No Print Enabled    \n\n\n\n".utf8)
            }
            debugPrint("DefaultPrintingData[\(String(describing: String(bytes: bArrDefaultPrintingData, encoding: .ascii)?.trimmingCharacters(in: .whitespacesAndNewlines)))]")

            return bArrDefaultPrintingData
        } catch {
            debugPrint("Exception Occured \(error)")
            return nil
        }
    }
    private func AppendNewTxnEntry() -> Int {
        do {
            debugPrint("Inside AppendNewTxnEntry")

            let globalData = GlobalData.singleton
            globalData.m_sNewTxnData.bIsOnline = true
            globalData.m_sNewTxnData.ulBatchId = m_ulBatchId!
            globalData.m_sNewTxnData.ulROC = m_ulCurrentRoc!


            m_chArrISOPacketDate = TransactionUtils.GetCurrentDateTime()
            globalData.m_sNewTxnData.chArrTxDateTime = String(bytes: m_chArrISOPacketDate, encoding: .ascii)!
            globalData.m_sNewTxnData.bIsReversalPending = true


            let resDRTxnFileName = String(format: "%@", FileNameConstants.DRTXNFILENAME)
            debugPrint("Txn file name[\(resDRTxnFileName)]")


            let iFileSize = FileSystem.GetFileSize(strFileName: resDRTxnFileName)
            globalData.m_sNewTxnData.iDrOffset = Int(iFileSize)
            globalData.m_sNewTxnData.iDRLength = 0

            // added abhishek for Signature capture
            globalData.m_sNewTxnData.bIsSignatureCapturedForTransaction = globalData.m_bIsSignCapturedSuccessfully
            globalData.m_sNewTxnData.bIsSignUploaded = false

            let iRetVal: Int = globalData.AppendNewTxnEntry()
            return iRetVal
        } catch {
            debugPrint("Exception Occured \(error)")
            return -1
        }
    }
    
    
    public override func packIt(sendee: inout [Byte]) -> Int {
        do {
            debugPrint("Inside packIt")
            debugPrint( "m_iReqState[\(String(describing: m_iReqState))], m_iResState[\(String(describing: m_iResState))]")
            
            //TODO: yet to add EMVModule
            //CEMVModule objEMVModule = CEMVModule.singleton
            var iRetVal = AppConstant.FALSE

            GlobalData.m_csFinalMsgDoHubOnlineTxn = ""

            //Swapnil:Change for Schoalistic tpe of transactions. Where EMV transaction is started in a miniPVM
            //TODO: yet to add StateMachine
            /*let sttmch = CStateMachine.singleton
            if (sttmch.bRunMiniPVm) {
                m_bMiniPVM = (sttmch.bRunMiniPVm)
            }*/
            parseDataSaveInterminalTransactionDataObj()
            //set ROC and Batch ID in the class variables
            SetROCandBatchId()

            /*    ***************************************************************************
                    FEILD 0 ::Message Type
             ***************************************************************************/

            msgno = [Byte](AppConstant.UPDATAREQ.bytes)

            switch (m_iReqState) {
            case ISO220RequestState.ONLINE_REQUEST_PENDING_TXN:
                SetTransactionRequestData()
                
            case ISO220RequestState.ONLINE_REQUEST_DEFAULT_TXN_REQUEST:
                iRetVal = AppendNewTxnEntry()
                if (iRetVal != AppConstant.TRUE) {
                    return -1
                }
                SetTransactionRequestData()
                
            case ISO220RequestState.ONLINE_REQUEST_MULTIPLE_ADDITIONAL_INFO:
                SetOnlineGetMiniPVMData()
                
            case ISO220RequestState.ONLINE_REQUEST_SINGLE_LAST_ADDITIONAL_INFO:
                SetTransactionRequestData()
                
            case ISO220RequestState.ONLINE_REQUEST_MULTI_PACKET_RESP_CONTINUED:
                SetAdditionalResponseData()
                
            /*EMV CODE START **/
            case ISO220RequestState.ONLINE_REQUEST_EMV_ONLINE_AUTH:
                    //Swapnil:Change for Schoalistic tpe of transactions. Where EMV transaction is started in a miniPVM
                    /*   if (!m_bMiniPVM) {
                        if (!objEMVModule.m_bIsGetAdditionalDataFetched) {
                            iRetVal = AppendNewTxnEntry()
                            if (iRetVal != AppConst.TRUE) {
                                return -1
                            }
                        } else {
                            iRetVal = UpdateTxnInfo(m_ulCurrentRoc)
                            if (iRetVal != AppConst.TRUE) {
                                return -1
                            }
                        }
                    }
                    SetTransactionRequestData()*/
                    debugPrint("EMV ONLINE AUTH")

            case ISO220RequestState.ONLINE_REQUEST_EMV_FINAL_RESPONSE:
                    /*  //Append new txn if this is a OFFLINE FINAL RESPONSE CASE
                    if ((AppConst.OFFLINE_FINAL_APPROVED == globalData.m_sEMVDATA.TxnStatus) ||
                            (AppConst.OFFLINE_FINAL_DECLINED == globalData.m_sEMVDATA.TxnStatus)) {
                        //Swapnil:Change for Schoalistic tpe of transactions. Where EMV transaction is started in a miniPVM
                        if (!m_bMiniPVM) {
                            if (!objEMVModule.m_bIsGetAdditionalDataFetched) {
                                iRetVal = AppendNewTxnEntry()
                                if (iRetVal != AppConst.TRUE) {
                                    return -1
                                }
                            } else {
                                iRetVal = UpdateTxnInfo(m_ulCurrentRoc)
                                if (iRetVal != AppConst.TRUE) {
                                    return -1
                                }
                            }
                        }
                    }
                    SetTransactionRequestData()*/
                debugPrint("EMV FINAL RESPONSE")
                //Case added for Getting additional data from HOST in case of EMV transaction
            case ISO220RequestState.ONLINE_REQUEST_GET_MISSING_DATA:
                if (!m_bMiniPVM!) {
                    iRetVal = AppendNewTxnEntry()
                    if (iRetVal != AppConstant.TRUE) {
                        return -1
                    }
                }
                SetTransactionRequestData()
                
                case ISO220RequestState.ONLINE_REQUEST_SESSION_KEY:
                    SetTransactionRequestData()

                /*EMV CODE END **/
                //Will Not Come to this Point
                case ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED:
                    break

                /****** DR UPLOAD TXN ****/
                case ISO220RequestState.ONLINE_DR_UPLOAD_TXN_START:
                    SetTransactionRequestData()
                case ISO220RequestState.ONLINE_DR_UPLOAD_TXN_END:
                    SetTransactionRequestData()

                /****** SIGN UPLOAD TXN ****/
                case ISO220RequestState.ONLINE_SIGN_UPLOAD_TXN_START:
                    SetTransactionRequestData()
                case ISO220RequestState.ONLINE_SIGN_UPLOAD_TXN_END:
                    SetTransactionRequestData()
            default:
                break
            }


            /*    ***************************************************************************
                    FEILD 49 ::PED Hardware Serial Number
             *
             ***************************************************************************/
            //#ifdef TLE_ENCRYPTION
                self.vFnSetPEDHardwareSerialNumer()
            //#endif

            // Packing the common data in the base class function
            return packItHost(sendee: &sendee)
            
        } catch  {
            debugPrint("Exception Occurred : \(error)")
            return 0
        }
    }

    private func parseDataSaveInterminalTransactionDataObj() {
        let cGlobalData = GlobalData.singleton
        
        var iLocalOffset: Int = 0x00
        var iTotalNodes: Int = 0
        var iTag: Int = 0x00
        var iTagValLen: Int = 0x00
        
        iTotalNodes = cGlobalData.m_sTxnTlvData.iTLVindex
        debugPrint("FEILD 61 Transaction Data::TotalTlvs[\(iTotalNodes)]")
        var Tranxbuffer = [Byte]()
        
        if (iTotalNodes > 0) {
            Tranxbuffer = [Byte](repeating: 0x00, count: iTotalNodes * 204)
        }
        if (Tranxbuffer != nil && !Tranxbuffer.isEmpty) {
            iLocalOffset = 0x00
            for i in 0 ..< iTotalNodes {
                iTag = cGlobalData.m_sTxnTlvData.objTLV[i].uiTag

                Tranxbuffer[iLocalOffset] = Byte(((iTag) >> 8) & 0x000000FF)
                iLocalOffset += 1
                Tranxbuffer[iLocalOffset] = Byte(((iTag)) & 0x000000FF)
                iLocalOffset += 1
                iTagValLen = ((cGlobalData.m_sTxnTlvData.objTLV[i].uiTagValLen))
                Tranxbuffer[iLocalOffset] = Byte(((iTagValLen >> 8) & 0x000000FF))
                iLocalOffset += 1
                Tranxbuffer[iLocalOffset] = Byte(((iTagValLen) & 0x000000FF))
                iLocalOffset += 1
                
                Tranxbuffer[iLocalOffset ..< iLocalOffset + iTagValLen] = (cGlobalData.m_sTxnTlvData.objTLV[i].chArrTagVal[0 ..< iTagValLen])
                //System.arraycopy(cGlobalData.m_sTxnTlvData.objTLV[i].chArrTagVal, 0, Tranxbuffer, iLocalOffset, iTagValLen)
                
                iLocalOffset += iTagValLen
                if (iTag == 0x1021) {
                    cGlobalData.m_sNewTxnData.uiAmount = String(bytes: cGlobalData.m_sTxnTlvData.objTLV[i].chArrTagVal, encoding: .ascii)!
                    GlobalData.txnAmount = cGlobalData.m_sNewTxnData.uiAmount
                }
                
                //for bug 88910 below changes made
                //Log.e("CIS220", String.format("TAG[%d] TAG LENGTH=[%d] TAG VALUR= [%s]", iTag, iTagValLen, new String(cGlobalData.m_sTxnTlvData.objTLV[i].chArrTagVal).trim()))
                debugPrint("TAG[\(iTag)] TAG LENGTH=[\(iTagValLen)] TAG VALUR= [\(cGlobalData.m_sTxnTlvData.objTLV[i].chArrTagVal)]")
            }
            
            debugPrint("TRANSACTION DATA,Feild 61 :Total TLV length = \(iLocalOffset)")
        }
    }
    
    func SetROCandBatchId() {
        do {
            debugPrint("Iniside SetROCandBatchId")
            let globalData = GlobalData.singleton

            let TxnFileName = FileNameConstants.TRANSACTIONFILENAME

            //LOAD DATA FROM LAST TXN IF TXN FILE DOESNOT EXIST THIS IS FIRST TXN
            //SET bIsReversalPending of LAST TRANSACTION AS FALSE
            if (false == FileSystem.IsFileExist(strFileName: TxnFileName)) {
                    //FISRT TRANSACTION
                debugPrint("This is FISRT TRANSACTION")
                m_ulLastRoc = Int64(AppConstant.DEFAULT_LAST_ROC)
                let m_sParamData: TerminalParamData = globalData.ReadParamFile()!
                m_ulBatchId = Int64(m_sParamData.iCurrentBatchId)
                m_ulCurrentRoc = m_ulLastRoc! + 1
            } else {
                var sLastTxnData: TerminalTransactionData = globalData.ReadLastTxnEntry()!
                m_ulLastRoc = sLastTxnData.ulROC
                let m_sParamData: TerminalParamData = globalData.ReadParamFile()!
                m_ulBatchId = Int64(m_sParamData.iCurrentBatchId)
                sLastTxnData.ulBatchId = Int64(m_sParamData.iCurrentBatchId)

                if (true == (sLastTxnData.bIsReversalPending)) {
                    m_ulCurrentRoc = m_ulLastRoc
                } else if (true == m_bMiniPVM) {
                    debugPrint("MINI PVM DATA")
                    m_ulCurrentRoc = m_ulLastRoc
                    m_bMiniPVM = false
                } else {
                    m_ulCurrentRoc = m_ulLastRoc! + 1
                }

                debugPrint( "Current ROC[\(String(describing: m_ulCurrentRoc))], LAST ROC[\(String(describing: m_ulLastRoc))], BatchID[\(String(describing: m_ulBatchId))], bIsReversalPending[\(sLastTxnData.bIsReversalPending)]")
            }
        } catch {
            debugPrint("Error Occurred \(error)")
        }
    }

    func SetTransactionRequestData() {
        debugPrint("Inside SetTransactionRequestData")

        var buffer = [Byte](repeating: 0x00, count: 50)
        let globalData = GlobalData.singleton

        /*    ***************************************************************************
            FEILD 3 ::Processing Code
         ***************************************************************************/
        _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_ONLINE_TRANSACTION_REQ.bytes), bcd: true)

        /*    ***************************************************************************
            FEILD 11 ::ROC
         ***************************************************************************/
        let strROC: String = "\(String(describing: m_ulCurrentRoc))"
        let strROCTemp = TransactionUtils.StrLeftPad(data: strROC, length: 4, padChar: "0")
        debugPrint("ROC[\(strROCTemp)]")
        _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_11, data1: [Byte](strROCTemp.bytes), bcd: true)

        /*    ***************************************************************************
            FEILD 26 ::BatchId
        ***************************************************************************/

        let strBatchID: String = "\(String(describing: m_ulBatchId))"
        let strBatchIDTemp = TransactionUtils.StrLeftPad(data: strBatchID, length: 6, padChar: "0")
        debugPrint("BatchId[\(strBatchIDTemp)]")
        _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_26, data1: [Byte](strBatchIDTemp.bytes), bcd: true)


        /*    ***************************************************************************
            FEILD 48 ::Transaction Type
        ***************************************************************************/
        if (true != globalData.m_ptrCSVDATA.bsendData) {
            buffer = [Byte](repeating: 0x00, count: 50)
            //Arrays.fill(buffer, (byte) 0)
            
            if (globalData.m_sNewTxnData.uiTransactionType != 0) {
                buffer[0] = Byte((globalData.m_sNewTxnData.uiTransactionType >> 8) & 0x000000ff)
                buffer[1] = Byte((globalData.m_sNewTxnData.uiTransactionType) & 0x000000ff)
                debugPrint("Transaction Type[\(globalData.m_sNewTxnData.uiTransactionType)]")
                _ = self.addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_48, data1: buffer, length: 2)
            } else {
               debugPrint("ERROR Transaction Type NOT SET")
            }

        }
    /*    ***************************************************************************
        FEILD 52 ::CSV DATA
        ***************************************************************************/
        debugPrint("GlobalData.m_ptrCSVDATA.bsendData[\(globalData.m_ptrCSVDATA.bsendData)]")
        if (globalData.m_ptrCSVDATA.bsendData) {
            _ = addEncryptedLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_52, data1: globalData.m_ptrCSVDATA.m_chBillingCSVData, length: Int(TransactionUtils.strlenByteArray(globalData.m_ptrCSVDATA.m_chBillingCSVData)))
        }
    /*    ***************************************************************************
        FEILD 61 ::Transaction Data
        ***************************************************************************/
        var iLocalOffset = 0x00
        var iTotalNodes = 0
        var iTag = 0x00
        var iTagValLen = 0x00
        
        iTotalNodes = globalData.m_sTxnTlvData.iTLVindex
        debugPrint("FEILD 61 :Transaction Data::TotalTlvs[\(iTotalNodes)]")
        var Tranxbuffer = [Byte]()
        
        if (iTotalNodes > 0) {
            Tranxbuffer = [Byte](repeating: 0x00, count: iTotalNodes * 204)
        }
        
        if (Tranxbuffer != nil && !Tranxbuffer.isEmpty) {
            iLocalOffset = 0x00
            for i in 0 ..< iTotalNodes {
                iTag = globalData.m_sTxnTlvData.objTLV[i].uiTag

                Tranxbuffer[iLocalOffset] = Byte(((iTag) >> 8) & 0x000000FF)
                iLocalOffset += 1
                Tranxbuffer[iLocalOffset] = Byte(((iTag)) & 0x000000FF)
                iLocalOffset += 1
                
                debugPrint("TAG = 0x%x", iTag)
                iTagValLen = ((globalData.m_sTxnTlvData.objTLV[i].uiTagValLen))
                debugPrint("TagLen = \(iTagValLen)")
                Tranxbuffer[iLocalOffset] = Byte(((iTagValLen >> 8) & 0x000000FF))
                iLocalOffset += 1
                Tranxbuffer[iLocalOffset] = Byte(((iTagValLen) & 0x000000FF))
                iLocalOffset += 1
                
                Tranxbuffer[iLocalOffset ..< iLocalOffset + iTagValLen] = (globalData.m_sTxnTlvData.objTLV[i].chArrTagVal[0 ..< iTagValLen])
                //System.arraycopy(GlobalData.m_sTxnTlvData.objTLV[i].chArrTagVal, 0, Tranxbuffer, iLocalOffset, iTagValLen)
            
                iLocalOffset += iTagValLen
                debugPrint("TagVal[\(String(bytes: globalData.m_sTxnTlvData.objTLV[i].chArrTagVal, encoding: .ascii)!)]")
            }
            
            debugPrint("TRANSACTION DATA,Feild 61 :Total TLV length[\(iLocalOffset)]")
        }
        if (iLocalOffset > 0) {
            var iLocalOffset1 = Int()
            iLocalOffset1 = iLocalOffset
            _ = addEncryptedLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61, data1: Tranxbuffer, length: iLocalOffset1)
        }


    /*    ***************************************************************************
        FEILD 54 ::Data to replay
        ***************************************************************************/

        if (CISO220.m_bDataToReplay!) {
            debugPrint(" Req->Setting field 54")
            _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_54, data1: CISO220.m_bArrDataToReplay, length: CISO220.m_iReplayDataLen!)
                CISO220.m_bDataToReplay = false
        }
    }
    
    private func SetOnlineGetMiniPVMData() {
        do {
            debugPrint("Inside SetOnlineGetMiniPVMData")

            //field 3
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_ONLINE_RESPONSE_GET_ADDTIONAL_INFO_START.bytes), bcd: true)
            self.vFnSetTerminalActivationFlag(bTerminalActivationFlag: false)


            if (self.m_bCurrentPacketCount! > 0) {
                var buffer = [Byte](repeating: 0x00, count: 33)
                var iLocalOffset: Int = 0x00
                var b: Int = m_bCurrentPacketCount!

                //Current Packet count 2 bytes
                buffer[iLocalOffset] = Byte((b >> 8) & 0x000000FF)
                iLocalOffset += 1
                buffer[iLocalOffset] = Byte(b & 0x000000FF)
                iLocalOffset += 1
                
                b = m_bTotalPacketCount!

                //Total Packet count 2 bytes
                buffer[iLocalOffset] = Byte((b >> 8) & 0x000000FF)
                iLocalOffset += 1
                buffer[iLocalOffset] = Byte(b & 0x000000FF)
                iLocalOffset += 1
                
                debugPrint("Req->Setting field 53")
                _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_53, data1: buffer, length: iLocalOffset)
            }
        } catch {
            debugPrint("Exception Occured \(error)")
        }

        /*    ***************************************************************************
            FEILD 54 ::Data to replay
        ***************************************************************************/
            
        if (CISO220.m_bDataToReplay!) {
            debugPrint(" Req->Setting field 54")
            _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_54, data1: CISO220.m_bArrDataToReplay, length: CISO220.m_iReplayDataLen!)
            CISO220.m_bDataToReplay = false
        }
    }

    private func SetAdditionalResponseData() {
        do {
            debugPrint("Inside SetAdditionalResponseData")
            self.vFnSetTerminalActivationFlag(bTerminalActivationFlag: false)

            /*    ***************************************************************************
                   FEILD 3 ::Processing Code
             ***************************************************************************/
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_ONLINE_RESPONSE_MULTI_PACKET_DATA_START.bytes), bcd: true)

            /*    ***************************************************************************
                   FEILD 53 :: Packet Data Definition
             (this will denote the current packet count out of max packets)
             ***************************************************************************/

            if (self.m_bCurrentPacketCount! > 0) {
                var buffer = [Byte](repeating: 0x00, count: 33)
                var iLocalOffset: Int = 0x00
                var b: Int = m_bCurrentPacketCount!

                //Current Packet count 2 bytes
                buffer[iLocalOffset] = Byte((b >> 8) & 0x000000FF)
                iLocalOffset += 1
                buffer[iLocalOffset] = Byte(b & 0x000000FF)
                iLocalOffset += 1
                
                b = m_bTotalPacketCount!

                //Total Packet count 2 bytes
                buffer[iLocalOffset] = Byte((b >> 8) & 0x000000FF)
                iLocalOffset += 1
                buffer[iLocalOffset] = Byte(b & 0x000000FF)
                iLocalOffset += 1
                
                debugPrint("Req->Setting field 53")
                _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_53, data1: buffer, length: iLocalOffset)
            }
            /*    ***************************************************************************
             FEILD 54 ::Data to replay
             ***************************************************************************/

            if (CISO220.m_bDataToReplay!) {
                debugPrint(" Req->Setting field 54")
                _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_54, data1: CISO220.m_bArrDataToReplay, length: CISO220.m_iReplayDataLen!)
                CISO220.m_bDataToReplay = false
            }
        }
        catch {
            debugPrint("Exception Occured \(error)")
        }
    }
    
    func SaveDRDumpToFile() {
        do {
            debugPrint("Inside SaveDRDumpToFile")

            let chDRTxnFileName = String(format: "%@", FileNameConstants.DRTXNFILENAME)
            debugPrint("DRtxn file name[\(chDRTxnFileName)]")

            do{
                var tempData = [String]()
                tempData.append(String(bytes: [Byte](m_uchPtrDRData[0 ..< m_iCurrentDRDataDumpOffset]), encoding: .ascii)!)
                
                _ = try FileSystem.AppendByteFile(strFileName: chDRTxnFileName, with: tempData)
            }
            catch{
                debugPrint("Error in AppendByteFile \(chDRTxnFileName)")
            }

            let globalData = GlobalData.singleton
            var nsLastTxnData: TerminalTransactionData = globalData.ReadLastTxnEntry()!

            debugPrint("LAST TXN  ROC = \(nsLastTxnData.ulROC) BatchID = \(nsLastTxnData.ulBatchId) iDRLength = \(nsLastTxnData.iDRLength) iDROffset = \(nsLastTxnData.iDrOffset)")

            nsLastTxnData.iDRLength = m_iCurrentDRDataDumpOffset
            _ = globalData.UpDateLastTxnEntry(nsLastTxnData)

            debugPrint("UPDATED TXN  ROC = \(nsLastTxnData.ulROC) BatchID = \(nsLastTxnData.ulBatchId) iDRLength = \(nsLastTxnData.iDRLength) iDROffset = \(nsLastTxnData.iDrOffset)")

            //Save This ROC to LastDRRoc
            var tParamData: TerminalParamData = globalData.ReadParamFile()!
            tParamData.m_ulDRLastDownloadedROC = nsLastTxnData.ulROC
            
            _ = globalData.WriteParamFile(listParamData: tParamData)
        } catch {
            debugPrint("Error Occured \(error)")
        }

    }

    func SaveDumpForAll() {
        do {
            debugPrint("Inside SaveDumpForAll")
            let iPrintingLocation = GetEDCPrintingLocation()
            debugPrint("PrintingLocation[\(iPrintingLocation)]")

            if (iPrintingLocation == 0) {
                if (m_bField7PrintPAD) {
                    SaveDumptoFileForPADPrinting()
                } else {
                    let globalData = GlobalData.singleton
                    globalData.m_bPrinterData = m_bPrintData
                    globalData.m_iPrintLen = m_iCurrentPrintDumpOffset!
                    SaveDumptoFile(iPrintingLocation)
                }
            } else if (iPrintingLocation == AppConstant.EDCPrint) {
                SaveDumptoFile(iPrintingLocation)
            } else if (iPrintingLocation == AppConstant.POSprint) {
                SaveDumptoFileForPADPrinting()
            } else if (iPrintingLocation == AppConstant.NOPrint) {
                SaveDumptoFile(iPrintingLocation)
            }
        } catch {
            debugPrint("Error Occurred \(error)")
        }
    }
    
    private func SaveDumptoFile(_ iPrintingLocation: Int) {
        do {
            debugPrint("Inside SaveDumptoFile")

            var length: Int
            length = m_iCurrentPrintDumpOffset!

            var bArrtemp = [Byte](repeating: 0x00, count: m_iCurrentPrintDumpOffset!)
            
            bArrtemp = [Byte](m_bPrintData[0 ..< m_iCurrentPrintDumpOffset!])
            //System.arraycopy(m_bPrintData, 0, bArrtemp, 0, m_iCurrentPrintDumpOffset)

            let chTxnField62Name = String(format: "%@", FileNameConstants.TXNFEILD62NAME)

            if (true == FileSystem.IsFileExist(strFileName: chTxnField62Name)) {
                    //should not come here
                _ = FileSystem.DeleteFile(strFileName: chTxnField62Name)
                 debugPrint( "DeleteFile[\(chTxnField62Name)]")
            }

            if (iPrintingLocation != 3) {
                debugPrint("Data saved len[\(length)]")
                m_iCurrentPrintDumpOffset = length
                do{
                    var tempData = [String]()
                    tempData.append(String(bytes: bArrtemp, encoding: .ascii)!)
                    
                    _ = try FileSystem.AppendByteFile(strFileName: chTxnField62Name, with: tempData)
                }
                catch{
                    debugPrint("Error in AppendByteFile \(chTxnField62Name)")
                }

            } else {

                let bArrDefaultPrintingData: [Byte] = GetDefaultPrintingData()!
                let iDefaultDatalen = bArrDefaultPrintingData.count

                var PrintingData = [Byte](repeating: 0x00, count: bArrDefaultPrintingData.count + 10)
                var ioffset: Int = 0

                PrintingData[ioffset] = Byte(PrintMode.RAWMODE)
                ioffset += 1
                    //length will add later in 2nd and 3rd byte
                ioffset += 2

                PrintingData[ioffset] = Byte(PrintAttribute.PRINT_NORMAL_24)
                ioffset += 1
                PrintingData[ioffset] = Byte(((iDefaultDatalen) >> 8) & 0x000000FF)
                ioffset += 1
                PrintingData[ioffset] = Byte((iDefaultDatalen) & 0x000000FF)
                ioffset += 1
                PrintingData[ioffset ..< ioffset + iDefaultDatalen] = (bArrDefaultPrintingData[0 ..< iDefaultDatalen])
                //System.arraycopy(bArrDefaultPrintingData, 0, PrintingData, ioffset, iDefaultDatalen)
               
                ioffset += iDefaultDatalen
                let datalen = ioffset - 3
                PrintingData[1] = Byte((datalen >> 8) & 0x000000FF)
                PrintingData[2] = Byte((datalen) & 0x000000FF)

                debugPrint("Data saved len[\(ioffset)]")
                
                do{
                    
                    var tempData = [String]()
                    tempData.append(String(bytes: PrintingData, encoding: .ascii)!)
                    
                    _ = try FileSystem.AppendByteFile(strFileName: chTxnField62Name, with: tempData)
                }
                catch
                {
                    debugPrint("Error in AppendFile \(chTxnField62Name)")
                }
            }
        }
        catch {
            debugPrint("Error Occured \(error)")
        }
    }

    func SaveSigDumpToFile() {
        do {
            debugPrint("Inside SaveSigDumpToFile")

            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TMPSGNBMPFILENAME)

            if ((m_iCurrentSignatureImageDumpOffset > 0) && !m_uchPtrSignatureImage.isEmpty) {
              
                do{
                    
                    var tempData = [String]()
                    tempData.append(String(bytes: m_uchPtrSignatureImage, encoding: .ascii)!)
                    
                    _ = try FileSystem.AppendByteFile(strFileName: FileNameConstants.TMPSGNBMPFILENAME, with: tempData)
                }
                catch
                {
                    debugPrint("Error in AppendByteFile \(FileNameConstants.TMPSGNBMPFILENAME)")
                }
            }
        }
        catch  {
                debugPrint("Exception Occurred : \(error)")
            }
        }
    
    
    private func SaveCSVDumptoFile() {
        debugPrint("SaveCSVDumptoFile")

        let iCSVlen: Int = len[52 - 1]
        var bArrField52Data = [Byte](repeating: 0x00, count: iCSVlen)
        bArrField52Data = [Byte](data[52 - 1][0 ..< iCSVlen])
        //System.arraycopy(data[52 - 1], 0, bArrField52Data, 0, iCSVlen)

        let strTxnField52Name: String = String(format: "%@", FileNameConstants.TXNFEILD52NAME)
        debugPrint("txn field 52 file name[\(FileNameConstants.TXNFEILD52NAME)]")

        if (true == FileSystem.IsFileExist(strFileName: strTxnField52Name)) {
            //should not come here
            _ = FileSystem.DeleteFile(strFileName: strTxnField52Name)
            debugPrint("DeleteFile[\(strTxnField52Name)]")
        }
        do{
            
            var tempData = [String]()
            tempData.append(String(bytes: bArrField52Data, encoding: .ascii)!)
            
            _ = try FileSystem.WriteByteFile(strFileName: strTxnField52Name, with: tempData)
        }
        catch{
            debugPrint("Error in WriteByteFile \(strTxnField52Name)")
        }
        
        debugPrint("CSV Data=[\(String(describing: String(bytes: bArrField52Data, encoding: .ascii)))]")
    }

    private func saveTransactionFile(_ transactionData: PlutusTransactionData) {

        let strTxnPrintFile: String = FileNameConstants.PRINTDUMPTRANSACTIONFILE

        if (FileSystem.IsFileExist(strFileName: strTxnPrintFile)) {
            //should not come here
            _ = FileSystem.DeleteFile(strFileName: strTxnPrintFile)
        }
        do{
            var tempData = [PlutusTransactionData]()
            tempData.append(transactionData)
            
            _ = try FileSystem.ReWriteFile(strFileName: strTxnPrintFile, with: tempData)
            //CFileSystem.writeFile(PlutusApplication.getContext(), strTxnPrintFile, transactionData)
        }
        catch
        {
            debugPrint("Error in ReWriteFile \(strTxnPrintFile)")
        }
    }

    func GetTransactionResponse() -> Bool {
        return true
    }
    
}
