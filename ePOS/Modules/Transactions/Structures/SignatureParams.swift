//
//  SignatureParams.swift
//  ePOS
//
//  Created by Abhishek on 11/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct SignatureParams: Codable {
    var SignatureDeviceType = [Byte](repeating: 0x00, count: 20)
    var bArrSignatureComPort = [Byte](repeating: 0x00, count: 4)
    var IsSignDeviceConnected:Bool = false;
}
