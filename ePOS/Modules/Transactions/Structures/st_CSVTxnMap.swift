//
//  st_CSVTxnMap.swift
//  ePOS
//
//  Created by Vishal Rathore on 24/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct StCSVTxnMap: Codable {
    var ulTxnType: DataLong = 0
    var bUseEncryption: Byte?
}
