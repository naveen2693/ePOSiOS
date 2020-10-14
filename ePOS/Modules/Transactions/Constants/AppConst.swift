//
//  AppConst.swift
//  ePOS
//
//  Created by Vishal Rathore on 12/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public class AppConst{
    
    static var APP_VERSION: String = "080120";//ddmmyy
    static var TERMINAL_TYPE: String = "53" //Terminal Type in DB should be 83. Here hex value is sent as 0x53.
    static var DEFAULT_HOSTID: Int = 0x02
    static var MAX_LEN_HARDWARE_SERIAL_NUMBER: Int = 100
    
    static var TERMINALPARAMFILENAME: String = "Param"                //File storing Parameter data
    
    static var TRUE: Int = 1
    static var FALSE: Int = 0
    
    static var MAX_LEN_DATE_TIME: Int = 12
    static var ISO_LEN: Int = 64;
    
    static var PVMFILE: String = "PVM";
    
}
