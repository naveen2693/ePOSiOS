//
//  st_CSVTxnIgnoreAmt.swift
//  ePOS
//
//  Created by Vishal Rathore on 24/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct StCSVTxnIgnoreAmt: Codable {
    var CsvTxnId: Int = 0
    var iIsIgnoreAmountEnabled: Bool = false
    var iIsSignatureRequired: Bool = false
}
