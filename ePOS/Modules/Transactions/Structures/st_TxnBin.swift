//
//  st_TxnBin.swift
//  ePOS
//
//  Created by Vishal Rathore on 24/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct st_TxnBin: Codable {
    var iBinID: Int
    var ulBinHigh: long
    var ulBinLow: long
    var iEMVAccountSelection: Byte
    var iIsPinNeeded: Byte
}
