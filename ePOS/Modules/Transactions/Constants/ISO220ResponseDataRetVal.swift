//
//  ISO220ResponseDataRetVal.swift
//  ePOS
//
//  Created by Vishal Rathore on 24/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

enum ISO220ResponseDataRetVal {
    static let RESPONSE_DATA_EXCEEDS_LENGTH: Int  = 0
    static let RESPONSE_ADDITIONAL_DATA_LEFT: Int = 1
    static let RESPONSE_DATA_FINISHED: Int = 2
}
