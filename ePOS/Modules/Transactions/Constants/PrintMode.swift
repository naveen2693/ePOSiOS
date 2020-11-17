//
//  PrintMode.swift
//  ePOS
//
//  Created by Vishal Rathore on 13/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

enum PrintMode {
    static let CHARGESLIPMODE       = (0x01)
    static let RAWMODE              = (0x02)
    static let IMAGEMODE            = (0x03)
    static let BARCODEMODE          = (0x04)
    static let PRINTMESSAGEMODE     = (0x05)
    static let DISPLAYMODE          = (0x06)
    static let INVALIDMODE          = (0x07)
    static let QRCODEMODE           = (0x09)
    static let QRCODECSV            = (0x0A)
}
