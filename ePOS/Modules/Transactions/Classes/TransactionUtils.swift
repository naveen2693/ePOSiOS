//
//  TransactionUtils.swift
//  ePOS
//
//  Created by Naveen Goyal on 14/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class TransactionUtils
{
    
    public static func a2bcd(_ buffer: [UInt8]) -> [UInt8]?
    {
        return HexArrayToByteArray(buffer)
    }
    
    public static func bcd2a(_ buffer: [UInt8]) -> [UInt8]?
    {
        return ByteArrayToHexArray(buffer)
    }
    
    public static func HexArrayToByteArray(_ buffer: [UInt8]) -> [UInt8]? {
        guard let string = String(bytes: buffer, encoding: String.Encoding.ascii) else { return nil }
        let byteArray = Array<UInt8>.init(hex: string)
        return byteArray
        
    }
    
    public static func ByteArrayToHexArray(_ buffer: [UInt8]) -> [UInt8]? {
        let string = buffer.toHexString()
        let hexArray = [UInt8] (string.utf8)
        return hexArray
    }
    
    public static func HexStringToByteArray(_ string: String) -> [UInt8]? {
        let byteArray = Array<UInt8>.init(hex: string)
        return byteArray
    }
    
    public static func ByteArrayToHexString(_ buffer: [UInt8]) -> String?{
        let string = buffer.toHexString()
        return string
    }
    
    public static func ByteArrayZeroPaddingtoLeft(to bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
      let paddingCount = blockSize - (bytes.count % blockSize)
      if paddingCount > 0 {
        return Array<UInt8>(repeating: 0, count: paddingCount) + bytes
      }
      return bytes
    }
    
    
    public static func ByteArrayZeroPaddingtoRight(to bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
      let paddingCount = blockSize - (bytes.count % blockSize)
      if paddingCount > 0 {
        return bytes + Array<UInt8>(repeating: 0, count: paddingCount)
      }
      return bytes
    }
    
}
