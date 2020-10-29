//
//  st_AIDTxnMapingDetails.swift
//  ePOS
//
//  Created by Vishal Rathore on 20/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct st_AIDTxnMapingDetails: Codable {

    var ucAID = [Byte](repeating: 0x00, count: 16)
    var iHATTxnType: Int
    var iCSVTxnType: Int
    var iEMVTxnType: Int
}
