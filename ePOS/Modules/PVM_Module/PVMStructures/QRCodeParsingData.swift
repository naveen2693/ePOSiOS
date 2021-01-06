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
    
    public func getPod() -> Int {
        return pod
    }

    public mutating func setPod(_ pod: Int) {
        self.pod = pod
    }

    public func getQsn() -> Int {
        return qsn
    }

    public mutating func setQsn(_ qsn: Int) {
        self.qsn = qsn
    }

    public func getQcc() -> Int {
        return qcc
    }

    public mutating func setQcc(_ qcc: Int) {
        self.qcc = qcc
    }

    public func getQclen() -> Int {
        return qclen
    }

    public mutating func setQclen(_ qclen: Int) {
        self.qclen = qclen
    }

    public func getQc() -> [QRCodeData]? {
        return qc!
    }

    public mutating func setQc(_ qc: [QRCodeData]) {
        self.qc = qc;
    }

    public func getPrdc() -> Int {
        return prdc
    }

    public mutating func setPrdc(_ prdc: Int) {
        self.prdc = prdc
    }

    public func getPrdl() -> Int {
        return prdl
    }

    public mutating func setPrdl(_ prdl: Int) {
        self.prdl = prdl
    }

    public func getPrd() -> [PrintData]? {
        return prd!
    }

    public mutating func setPrd(_ prd: [PrintData]) {
        self.prd = prd
    }

    public func getDmh() -> String {
        return dmh
    }

    public mutating func setDmh(_ dmh: String) {
        self.dmh = dmh
    }

    public func getDmf() -> String {
        return dmf
    }

    public mutating func setDmf(_ dmf: String) {
        self.dmf = dmf
    }
}
