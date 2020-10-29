//
//  st_TxnBin.swift
//  ePOS
//
//  Created by Vishal Rathore on 24/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct StTxnBin: Codable {
    var iBinID: Int = 0
    var ulBinHigh: DataLong = 0
    var ulBinLow: DataLong = 0
    var iEMVAccountSelection: Byte?
    var iIsPinNeeded: Byte?
}
