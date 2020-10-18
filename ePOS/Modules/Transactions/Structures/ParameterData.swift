//
//  ParameterData.swift
//  ePOS
//
//  Created by Vishal Rathore on 16/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct ParameterData {
    var uiHostID: Int
    var ulParameterId: Int
    var ulParameterLen: Int
    var chArrParameterVal: [Byte]
}

