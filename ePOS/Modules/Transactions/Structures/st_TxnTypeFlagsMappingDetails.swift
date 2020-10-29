//
//  st_TxnTypeFlagsMappingDetails.swift
//  ePOS
//
//  Created by Vishal Rathore on 19/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct st_TxnTypeFlagsMappingDetails: Codable {

    var iHATTxnType: Int
    var iCSVTxnType: Int
    var bIsCardDataEncryptionNeeded: Bool
    var iPrintingLocation: Int
    var bIsIgnoreAmountEnabled: Bool
    var bIsSignatureRequired: Bool

}
