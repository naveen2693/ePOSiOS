//
//  TransactionHUB.swift
//  ePOS
//
//  Created by Vishal Rathore on 12/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class TransactionHUB {
    
    
    private var isAddionalData: Bool = false
    var iServiceCode6: Bool = false
    var iAccountSelection: Bool = false

    var eventReceivedNode: CBaseNode?
    
    var tData = TerminalParamData()
    var isPasswordRequiredForSpecificTransaction: Bool = false

    /**
     * principle login changes as per requirement
     */
    var iPrincipleLoginFailed: Int = 1

    /**
     * To keep count of pin retry
     */
    var m_iEmvPinRetryCount: Int = 0

    //For EMV full redeem Reward transaction
    var iReward: Int = 0

    /**
     * To keep State of cless swipe data
     */
    var m_bClessSwipeData: Bool = false

    var isCLessFallback: Bool = false
    
    var m_isoProcessor: ISOProcessor?
    private var globalData = GlobalData.singleton
    
    static var bIsCSVPLUTUSBILLING: Bool = false
    static var bIsCSVTrackDataRequest: Bool = false
    static var bIsCSVInvoiceNoRequest: Bool = false
    static var bIsCSVGetAmountRequest: Bool = false
    
    static var txn_flow: Int?   // this could SWIPE/EMV/CLESS depending upon the transaction flow
    static var cless_emv_mini_pvm: Bool = false
    static var cless_preprocessing_amount: String = "0"  // This amount is needed in case of Contactless Txn as it has to perform preprocessing .

    
    private init() {}
    private static var _shared: TransactionHUB?
    public static var singleton: TransactionHUB {
        get {
            if _shared == nil {
                DispatchQueue.global().sync(flags: .barrier) {
                    if _shared == nil {
                        _shared = TransactionHUB()
                    }
                }
            }
            return _shared!
        }
    }
    
    // MARK:- AddTLVDataWithTag
    public static func AddTLVDataWithTag(uiTag:Int,Data:[Byte],length:Int) {
        if ((length > 0) && (uiTag > 0) && (GlobalData.singleton.m_sTxnTlvData.iTLVindex < AppConstant.MAX_TXN_STEPS_WITH_TLV_DATA)) {
            GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex] =  TLVTxData()
            GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex].uiTag = uiTag
            GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex].uiTagValLen = length
            GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex].chArrTagVal = [Byte](repeating: 0, count: length)
            GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex].chArrTagVal[0 ..< length] = Data[0 ..< length]
            GlobalData.singleton.m_sTxnTlvData.iTLVindex =  GlobalData.singleton.m_sTxnTlvData.iTLVindex + 1
            
        }
    }

    func sendMessage(_ REQUEST_TYPE: Int, _ result: Int, _ position: Int, _ buffer: NSObject?) {
        debugPrint("Sending message to functionalityHandler: REQUEST_TYPE[\(REQUEST_TYPE)], result[\(result)], position[\(position)]")
            //TODO: Message yet to complete
            /*Message message = new Message()
            message.what = REQUEST_TYPE
            message.arg1 = result
            message.arg2 = position
            message.obj = buffer
            functionalityHandler.sendMessage(message)*/
      
    }
    
    func goToNode(_ node:CBaseNode)
    {
        
    }
}
