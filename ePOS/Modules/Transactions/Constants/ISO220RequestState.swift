//
//  ISO220RequestState.swift
//  ePOS
//
//  Created by Vishal Rathore on 23/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation


enum ISO220RequestState {
    static let INVALID_ENUM_ONLY_INDICATIVE                    =    0
    static let ONLINE_REQUEST_DEFAULT_TXN_REQUEST              =    1
    /*********Mini-PVM download request ***********/
    static let ONLINE_REQUEST_MULTIPLE_ADDITIONAL_INFO         =    2

    /*********Mini-PVM  response ***********/
    static let ONLINE_REQUEST_SINGLE_LAST_ADDITIONAL_INFO      =    3

    /*********Multi-Packet download request ***********/
    static let ONLINE_REQUEST_MULTI_PACKET_RESP_CONTINUED       =    4

    /*********REVERSAL ***********/
    static let ONLINE_REQUEST_PENDING_TXN                      =    5

    /*********EMV ****************/
    static let ONLINE_REQUEST_EMV_ONLINE_AUTH                  =    6
    static let ONLINE_REQUEST_EMV_FINAL_RESPONSE               =    7

    /*********Session Key ****************/
    static let ONLINE_REQUEST_SESSION_KEY                      =    8
    static let ONLINE_REQUEST_GET_MISSING_DATA                 =    9

    /*********Completion ***********/
    static let ONLINE_REQUEST_TXN_ERR_TERMINATED               =    10
    static let ONLINE_REQUEST_TXN_COMPLETED                    =    11

    /***************DR UPLOAD TXN ************/
    static let ONLINE_DR_UPLOAD_TXN_START                      =    12
    static let ONLINE_DR_UPLOAD_TXN_END                        =    13

    /***************Signature UPLOAD TXN ************/
    static let ONLINE_SIGN_UPLOAD_TXN_START                    =    14
    static let ONLINE_SIGN_UPLOAD_TXN_END                      =    15
}
