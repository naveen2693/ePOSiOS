//
//  QRCodeParsingData.swift
//  ePOS
//
//  Created by Abhishek on 04/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct QRCodeParsingData {

var qsn = 0;//1(on tap move to next node),0=sync(restrict user on screen)
var qcc = 0;//QR code data list count
var qclen = 0;//QR code data length
var qc:[QRCodeData]?;//QR code data list
var prdc = 0;//print data list count
var prdl = 0;//print data length
var prd:[PrintData]?;//print data list
var dmh = "";//display message header
var dmf = "";//display message footer
var pod = 0;
}
