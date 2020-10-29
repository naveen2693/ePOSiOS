//
//  st_BINRange.swift
//  ePOS
//
//  Created by Abhishek on 14/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct st_BINRange:Codable {
     var iKeySlotID = 0 ;
    //int iLenBinMax;
    //int iLenBinMin;
    //unsigned char uchArrBinMin[10];
    //unsigned char uchArrBinMax[10];
    var  ulBinHigh:Int64 = 0;
    var ulBinLow:Int64 = 0;
}
