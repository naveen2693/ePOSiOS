//
//  PrintAttribute.swift
//  ePOS
//
//  Created by Vishal Rathore on 13/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

enum PrintAttribute {
    static let PRINT_NORMAL_24             =    (0x01)                  //!< PRINT_NORMAL_24
    static let PRINT_NORMAL_48             =    (0x02)                  //!< PRINT_NORMAL_40
    static let PRINT_BOLD_24               =    (0x03)                  //!< PRINT_BOLD_24
    static let PRINT_BOLD_48               =    (0x04)                  //!< PRINT_BOLD_40
    static let PRINT_NORMAL_40             =    (0x05)                  //!< PRINT_NORMAL_40
    static let PRINT_BOLD_40               =    (0x06)                  //!< PRINT_BOLD_40
    static let PRINT_UNICODE_NORMAL_24     =    (0x07)                  //for Unicode normal 24
    static let PRINT_UNICODE_BOLD_24       =    (0x08)                  //for Unicode Bold 24
    static let PRINT_UNICODE_NORMAL_48     =    (0x09)                  //for Unicode normal 24
    static let PRINT_UNICODE_BOLD_48       =    (0x0A)                  //for Unicode Bold 24
    static let PRINT_UNICODE_NORMAL_40     =    (0x0B)                  //for Unicode normal 24
    static let PRINT_UNICODE_BOLD_40       =    (0x0C)                  //for Unicode Bold 24
}
