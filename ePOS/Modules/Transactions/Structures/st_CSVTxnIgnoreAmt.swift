//
//  st_CSVTxnIgnoreAmt.swift
//  ePOS
//
//  Created by Vishal Rathore on 24/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct st_CSVTxnIgnoreAmt: Codable {
    var CsvTxnId: Int
    var iIsIgnoreAmountEnabled: Bool
    var iIsSignatureRequired: Bool
}
