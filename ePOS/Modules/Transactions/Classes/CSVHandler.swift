//
//  CSVHandler.swift
//  ePOS
//
//  Created by Vishal Rathore on 12/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public class CSVHandler {
    
    static var m_iRecCSVRequestMode: Int = 0
    //public CCSVBaseTxn m_objCSVTxn
    
    // Constants
    static let REQUEST_FOR_INITIATE_ECR_TRANSACTION = 1000
    static let REQUEST_FOR_TERMINATE_ECR_TRANSACTION = 1100
    static let REQUEST_FOR_HANDLE_ECR_TRANSACTION = 1001
    static let RESPONSE_FOR_GET_TRACK_DATA_SWIPE = 1002
    static let RESPONSE_FOR_GET_TRACK_DATA_EMV_CLESS = 1003
    static let RESPONSE_FOR_GET_AMOUNT = 1004
    static let RESPONSE_FOR_GET_INVOICE_NO = 1005
    static let RESPONSE_FOR_GET_UPI_BHARAT_QR_TXN = 1006
    
    static let CSV_TXN_REQUEST_FROM_PAD_CONTROLLER_SERIAL = 2001
    static let CSV_TXN_REQUEST_FROM_LOCAL_BILLING_APP = 2002
    static let PRINT_DUMP_REQUEST_FROM_LOCAL_BILLING_APP = 2003
    
    var m_objCSVTxn: CSVBaseTxn?
    
    private init() {}
    private static var _shared: CSVHandler?
    public static var singleton: CSVHandler {
        get {
            if _shared == nil {
                DispatchQueue.global().sync(flags: .barrier) {
                    if _shared == nil {
                        _shared = CSVHandler()
                    }
                }
            }
            return _shared!
        }
    }
    
    func sendMessage(_ REQUEST_TYPE: Int, _ result: Int, _ position: Int, _ buffer: NSObject?) {
        do {
            //TODO: Message yet to complete
            /*Message message = new Message()
            message.what = REQUEST_TYPE
            message.arg1 = result
            message.arg2 = position
            message.obj = buffer
            m_msgHandler.dispatchMessage(message)*/
        } catch {
            debugPrint("Exception Occurred : \(error)")
        }
    }
    
    
}
