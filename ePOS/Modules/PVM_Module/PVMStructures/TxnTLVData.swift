//
//  TxnTLVData.swift
//  ePOS
//
//  Created by Abhishek on 05/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct TxnTLVData {
    var objTLV = Array<TLVTxData>()
    var iTLVindex = 0;         //TLVindex to set while
    var uicardGrpId = [Int](repeating: 0, count: AppConstant.MAX_TXN_STEPS_WITH_TLV_DATA)

    public mutating func TxnTLVData()
    {
        for i in 0..<AppConstant.MAX_TXN_STEPS_WITH_TLV_DATA
        {
            objTLV[i] =  TLVTxData();
        }
    }

    public mutating func reset()
    {
         for i in 0..<AppConstant.MAX_TXN_STEPS_WITH_TLV_DATA
        {
            objTLV[i].reset();
        }
        iTLVindex = 0;
    }

}
