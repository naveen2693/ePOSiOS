//
//  PvmListParserVO.swift
//  ePOS
//
//  Created by Abhishek on 04/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct PvmListParserVO{
var DM="";
var HTL:Int=0;
var MaxLen:Int=0;
var MinLen:Int=0;
var CurrencyName="";
var Decimals:Int=0;
var InputMethod:enum_InputMethod = enum_InputMethod.NUMERIC_ENTRY
var ALPHANUMERIC_ENTRY:enum_InputMethod = enum_InputMethod.ALPHANUMERIC_ENTRY;
var txtye="";
var regx="";
var defaultValue="";
}
