//
//  ZMK_KEY.swift
//  ePOS
//
//  Created by Abhishek on 09/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct ZMK_KEY {
    var iKeySlotID = 0;
    var uchArrPinZMKFinal = [Byte](repeating: 0, count:24);
    var uchArrKCVPinZMKFinal = [Byte](repeating: 0, count:3);
    var uchArrTLEZMKFinal = [Byte](repeating: 0, count:24);
    var uchArrKCVTLEZMKFinal = [Byte](repeating: 0, count:3);
}
