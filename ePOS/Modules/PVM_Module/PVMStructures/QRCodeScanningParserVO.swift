//
//  QRCodeScanningParserVO.swift
//  ePOS
//
//  Created by Abhishek on 04/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct QRCodeScanningParserVO {
    var DM="";
    var HTL=0;
    var MaxLen=0;
    var MinLen=0;
    var CurrencyName="";
    var Decimals=0;
    var scantype = ""
    var InputMethod:enum_InputMethod = enum_InputMethod.NUMERIC_ENTRY
    var ALPHANUMERIC_ENTRY:enum_InputMethod = enum_InputMethod.ALPHANUMERIC_ENTRY;
    var txtye="";
    var regx="";
    var defaultValue="";
}
