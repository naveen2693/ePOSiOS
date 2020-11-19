//
//  TLVTxData.swift
//  ePOS
//
//  Created by Abhishek on 05/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct TLVTxData {
    var uiTag = 0;
    var uiTagValLen = 0;
    var chArrTagVal =  [Byte](repeating: 0, count:AppConstant.MAX_TXN_TLV_DATA_LEN);
    public mutating func reset()
    {
        uiTag = 0;
        uiTagValLen = 0;
        chArrTagVal = Array<Byte>(repeating: 0x00, count:AppConstant.MAX_TXN_TLV_DATA_LEN);
    }
}
