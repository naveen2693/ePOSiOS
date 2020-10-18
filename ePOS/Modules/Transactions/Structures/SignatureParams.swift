//
//  SignatureParams.swift
//  ePOS
//
//  Created by Abhishek on 11/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public struct SignatureParams {
    var SignatureDeviceType:[UInt8] = [0];
    var bArrSignatureComPort:[UInt8] = [0];
    var IsSignDeviceConnected:Bool = false;
}
