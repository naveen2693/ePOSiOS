//
//  HostTransactionType.swift
//  ePOS
//
//  Created by Vishal Rathore on 26/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public enum HostTransactionType {
    //SALE RELATED TRANSACTIONS
    static let SALE_TXN                                          =    (0x1001)
    static let PREAUTH_TXN                                       =    (0x1102)
    static let SALECOMPLETE_TXN                                  =    (0x1103)
    static let TIP_TXN                                           =    (0x1105)

    static let TXN_TYPE_PLUTUS_SALE_INSTANT_DISCOUNT             =    (0x1101)
    static let TXN_TYPE_PLUTUS_SALE_SATYAM_DISCOUNT              =    (0x1201)

    static let TXN_TYPE_PLUTUS_CITI_LOYALTY                      =    (0x1109)
    static let TXN_TYPE_PLUTUS_TIP_SALE                          =    (0x1013)
    static let TXN_TYPE_PLUTUS_REDEMPTION_SALE                   =    (0x1016)

    //EMI RELATED
    static let TXN_TYPE_PLUTUS_SALE_EMI_VISA_LOUNGE_INITIATE     =    (0x1301)
    static let TXN_TYPE_PLUTUS_SALE_EMI_VISA_LOUNGE_BANKEMI      =    (0x1302)
    static let TXN_TYPE_EMI_VISA_LOUNGE_PRINT_EMI_OPTIONS        =    (0x1303)

    //Action Tags for Billing Server
    static let TXN_TYPE_BILLING_NORMAL_SALE                      =    (0x7102)
    static let TXN_TYPE_BILLING_PRIVILEGED_CUSTOMER_SALE         =    (0x7103)
    static let TXN_TYPE_BILLING_INCENTIVE_SALE                   =    (0x7104)
    static let TXN_TYPE_BILLING_COMPLEMENTARY_SALE               =    (0x7105)
    static let TXN_TYPE_BILLING_INSTITUTIONAL_SALE               =    (0x7106)

    //REFUND RELATED TRANSACTIONS
    static let REFUND_TXN                                        =     (0x1104)

    //amitesh:: CASHBACK RELATED TRANSACTIONS
    static let CASH_TXN                                          =      (0x1901)
    static let CASHBACK_TXN                                      =      (0x1965)
    static let COD_TXN                                           =      (0x6101)
    static let CARD_TXN                                          =      (0x6081)
    
    static let UPI_TXN                                           = (0x6291)
    static let TXN_UPI_GET_STATUS                                = "25235"
    static let TXN_UPI_VOID                                      = "25236"
    static let BHARAT_QR_TXN                                     = (0x6300)
    static let TXN_BHARAT_QR_GET_STATUS                          = "25235"
    static let TXN_BHARAT_QR_VOID                                = "25236"
    static let TXN_PHONEPE_WALLET                                = "25393"
    static let TXN_AMAZON_PAY_WALLET                             = "25366" //for Amazon
    static let TXN_PHONEPE_WALLET_GET_STATUS                     = "25395"
    static let TXN_PHONEPE_WALLET_VOID                           = "25396"
    static let TXN_FREECHARGE_WALLET                             = "25117"
    static let TXN_FREECHARGE_WALLET_VOID                        = "25106"
    static let TXN_AIRTEL_WALLET                                 = "25362"
    static let TXN_AIRTEL_WALLET_VOID                            = "2536211"
    static let TXN_PG_AT_POS_CARD                                = "24705"
    static let TXN_PG_AT_POS_GET_STATUS                          = "24707"
    static let TXN_PG_AT_POS_VOID                                = "24708"
    static let TXN_PG_AT_POS_RESEND                              = "24712"
    static let TXN_PG_AT_POS_NETBANK                             = "24722"
    static let TXN_PG_AT_POS_BRAND_EMI                           = "24724"
    static let TXN_PG_AT_POS_BANK_EMI                            = "24723"
    static let TXN_PAPER_POS_TEMP                                = "255555500"
    


}
