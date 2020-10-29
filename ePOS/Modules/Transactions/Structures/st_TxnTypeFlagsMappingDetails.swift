//
//  st_TxnTypeFlagsMappingDetails.swift
//  ePOS
//
//  Created by Vishal Rathore on 19/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct StTxnTypeFlagsMappingDetails: Codable {

    var iHATTxnType: Int = 0
    var iCSVTxnType: Int = 0
    var bIsCardDataEncryptionNeeded: Bool = false
    var iPrintingLocation: Int = 0
    var bIsIgnoreAmountEnabled: Bool = false
    var bIsSignatureRequired: Bool = false

}
