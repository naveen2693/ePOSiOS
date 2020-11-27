//
//  DeviceState.swift
//  ePOS
//
//  Created by Abhishek on 11/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public struct DeviceState :Codable {
   static let S_INITIAL     = 0
   static let S_ACTIVATED   = 1
   static let S_INITIALIZED = 2
   static let S_READY       = 3
}
