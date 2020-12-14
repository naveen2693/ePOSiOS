//
//  QRCodeScanningParserVO.swift
//  ePOS
//
//  Created by Abhishek on 04/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct QRCodeScanningParserVO {
    var DM=""
    var HTL=0
    var MaxLen=0
    var MinLen=0
    var CurrencyName=""
    var scantype = ""
    var Decimals=0
    var InputMethod:enum_InputMethod = enum_InputMethod.ALPHANUMERIC_ENTRY
    var txtye=""
    var regx=""
    var defaultValue=""
    
    public func getInputMethod() -> enum_InputMethod {
        return InputMethod
    }

    public mutating func setInputMethod(_ inputMethod: enum_InputMethod) {
        InputMethod = inputMethod
    }
    
    public func getHTL()->Int {
         return HTL
     }

    public mutating func setHTL(_ htl:Int) {
         HTL = htl
     }

     public func getDM()->String {
         return DM
     }

    public mutating func setDM(_ dm:String) {
         DM = dm
     }

     public func getMaxLen()->Int {
         return MaxLen;
     }

    public mutating func setMaxLen(_ maxLen:Int) {
         MaxLen = maxLen
     }

     public func getMinLen()->Int {
         return MinLen
     }

    public mutating func setMinLen(_ minLen:Int) {
         MinLen = minLen
     }

     public func getCurrencyName()->String {
         return CurrencyName
     }

    public mutating func setCurrencyName(_ currencyName:String) {
         CurrencyName = currencyName
     }

     public func getDecimals()->Int {
         return Decimals
     }

    public mutating func setDecimals(_ decimals:Int) {
         Decimals = decimals
     }
}
