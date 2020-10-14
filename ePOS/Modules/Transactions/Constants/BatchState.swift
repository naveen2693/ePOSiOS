//
//  BatchState.swift
//  ePOS
//
//  Created by Vishal Rathore on 12/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

enum BatchState: Int {
    case BATCH_EMPTY     = 0
    case BATCH_OPEN      = 1
    case BATCH_LOCKED    = 2
}
