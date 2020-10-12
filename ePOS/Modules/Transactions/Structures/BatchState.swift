//
//  BatchState.swift
//  ePOS
//
//  Created by Abhishek on 12/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public enum BatchState {
    static let BATCH_EMPTY     = 0;
    static let BATCH_OPEN      = 1;
    static let BATCH_LOCKED    = 2;
}
