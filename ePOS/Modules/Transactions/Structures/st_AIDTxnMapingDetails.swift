//
//  st_AIDTxnMapingDetails.swift
//  ePOS
//
//  Created by Vishal Rathore on 20/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct StAIDTxnMapingDetails: Codable {

    var ucAID = [Byte](repeating: 0x00, count: 16)
    var iHATTxnType: Int = 0
    var iCSVTxnType: Int = 0
    var iEMVTxnType: Int = 0
}
