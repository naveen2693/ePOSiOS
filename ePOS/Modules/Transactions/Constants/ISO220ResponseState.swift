//
//  ISO220ResponseState.swift
//  ePOS
//
//  Created by Vishal Rathore on 23/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

enum ISO220ResponseState {
    static let ONLINE_RESPONSE_NOT_VALID                          = 0
    static let ONLINE_RESPONSE_NO_ADDITIONAL_INFO                 = 1
    static let ONLINE_RESPONSE_MULTIPLE_ADDITIONAL_INFO           = 2
    static let ONLINE_RESPONSE_SINGLE_LAST_ADDITIONAL_INFO        = 3
    static let ONLINE_RESPONSE_MULTI_PACKET_RESP_CONTINUED        = 4
    static let ONLINE_RESPONSE_MULTI_PACKET_RESP_ENDED            = 5
    static let ONLINE_RESPONSE_PENDING_TXN                        = 6
    static let ONLINE_RESPONSE_EMV_ONLINE_AUTH                    = 7
    static let ONLINE_RESPONSE_EMV_FINAL_RESPONSE                 = 8
    static let ONLINE_RESPONSE_SESSION_KEY                        = 9
    static let ONLINE_RESPONSE_DECLINED                           = 10
    static let ONLINE_RESPONSE_INVALID_PROCESSING_CODE            = 11
    static let ONLINE_DR_UPLOAD_TXN_START                         = 12
    static let ONLINE_DR_UPLOAD_TXN_END                           = 13
    static let ONLINE_SIGN_UPLOAD_TXN_START                       = 14
    static let ONLINE_SIGN_UPLOAD_TXN_END                         = 15
}
