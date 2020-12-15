//
//  FixedHostTags.swift
//  ePOS
//
//  Created by Vishal Rathore on 14/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

enum FixedHostTags {
    static let TAG_TYPE_ACCOUNT_SEL                                          =    (0x1107)
    static let TAG_PIN_BYPASS                                                =    (0x1551)
    //----------------- TLE TAGS ---------------------------------
    static let TAG_TYPE_TLE_CARDHOLDER_NAME                                  =    (0x1552)
    static let TAG_TYPE_TLE_CARD_EXPIRY_DATE                                 =    (0x1553)
    static let TAG_TYPE_TLE_CARD_SERVICE_CODE                                =    (0x1554)
    static let TAG_TYPE_TLE_CARD_MASKED_PAN                                  =    (0x1555)
    static let TAG_TYPE_TLE_CARD_SHA1_PAN                                    =    (0x1556)

    //------------------ TAG Containing Encrypted data -----------
//------ Data format (first Byte Slot Id Rest Encrypted value
//- TAGS in Range 0x1601 - 0x16FF to be reserved for TLE Encryption from Device
    static let TAG_TYPE_TLE_CARD_ENCRYPTED_TRACK1                            =    (0x1601)
    static let TAG_TYPE_TLE_CARD_ENCRYPTED_TRACK2                            =    (0x1602)
    static let TAG_TYPE_TLE_CARD_ENCRYPTED_PAN                               =    (0x1603)
    static let TAG_TYPE_PINE_KEY_ENCRYPTED_PIN_BLOCK                         =    (0x1604)

    // Added for Cless PayPass and ExpressPay transactions
    static let TAG_TYPE_TLE_CARD_ENCRYPTED_TRACK1_CLESS                      =    (0x1605)
    static let TAG_TYPE_TLE_CARD_ENCRYPTED_TRACK2_CLESS                      =    (0x1606)

    static let TAG_TYPE_TLE_CARD_ENCRYPTED_TRACK1_CLESS_PAYPASS              =    (0x1607)
    static let TAG_TYPE_TLE_CARD_ENCRYPTED_TRACK2_CLESS_PAYPASS              =    (0x1608)

    static let TAG_TYPE_TLE_CARD_ENCRYPTED_TRACK1_CLESS_EXPRESSPAY           =    (0x1609)
    static let TAG_TYPE_TLE_CARD_ENCRYPTED_TRACK2_CLESS_EXPRESSPAY           =    (0x160A)
    static let TAG_TYPE_SUPPLEMENTARY_CARD_PINBLOCK_WITH_PINE_KEYS           =    (0x1614)
    static let TAG_TYPE_SUPPLEMENTARY_CARD_REPEAT_PINBLOCK_WITH_PINE_KEYS    =    (0x1615)

    static let TAG_TYPE_BIOMETRIC_DEVICE_SERIAL_NUMBER                       =    (0x1616)       //added abhishek for Biometric
    static let TAG_TYPE_BIOMETRIC_DEVICE_INFORMATION                         =    (0x1617)       //added abhishek for Biometric
    static let TAG_TYPE_ORIGINAL_BIOMETRIC_DATA_LENGTH                       =    (0x1618)       //added abhishek for Biometric
    static let TAG_TYPE_TLE_CLEAR_PAN                                        =    (0x1557)        //added amitesh for MANUAL PAN
    static let TAG_TYPE_MOBILE_NUMBER                                        =    (0x1018)           //added amitesh for MANUAL MOBILE
    static let TAG_TYPE_MANUALPAN_NUMBER                                     =    (0x1014)        //added amitesh for MANUAL MOBILE
}
