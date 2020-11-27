//
//  PlutusTransactionStatus.swift
//  ePOS
//
//  Created by Vishal Rathore on 24/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public enum PlutusTransactionStatus {

    static let TRANSACTION_STATUS_SUCCESS: Int = 1
    static let TRANSACTION_STATUS_CANCELLED: Int = 2
    static let TRANSACTION_STATUS_REVERSAL: Int = 3
    static let TRANSACTION_STATUS_SETTLED: Int = 4
    static let TRANSACTION_STATUS_PENDING_HOST: Int = 5
    static let TRANSACTION_STATUS_PENDING_PC: Int = 7
    static let TRANSACTION_STATUS_FAILURE: Int = 9
    static let TRANSACTION_STATUS_PENDING: Int = 6

    static let TRANSACTION_STATUS_SUCCESS_MSG: String = "APPROVED"
    static let TRANSACTION_STATUS_VOID_SUCCESS_MSG: String = "SUCCESS"
    static let TRANSACTION_STATUS_PENDING_MSG: String = "TRANSACTION INITIATED CHECK GET STATUS"
    static let TRANSACTION_STATUS_COMPLETE_GET_STATUS_MSG: String = "COMPLETE SALE BY GET STATUS BEFORE VOID"
    static let INVOICE_TRANSACTION_STATUS_SUCCESS_MSG: String = "Received"
    static let INVOICE_TRANSACTION_STATUS_PENDING_MSG: String = "Pending"
    static let INVOICE_TRANSACTION_STATUS_CANCELLED_MSG: String = "Cancelled"
    static let INVOICE_TRANSACTION_STATUS_FAILURE_MSG: String = "Failed"
    static let INVOICE_TRANSACTION_STATUS_RESEND_LINK_SUCCESS_MSG: String = "Link Sent Successfully"
    static let TIME_OUT: String = "TIME_OUT"
    static let BACK_BUTTON: String = "BACK_BUTTON"
    static let RESPONSE: String = "RESPONSE"
    static let PENDING_MSG: String = "Awaiting transaction confirmation"
}
