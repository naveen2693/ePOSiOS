//
//  TLVObject.swift
//  ePOS
//
//  Created by Vishal Rathore on 18/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class TLVObject: Codable {

    var iTag: Int
    var iLength: Int
    var bData: [Byte]

    init(tag: Int, length: Int, data: [Byte])
    {
        iTag    = tag
        iLength = length
        bData = [Byte](repeating: 0x00, count: iLength)
        bData = Array(data[0 ..< length])
    }

    static func GetTLVObject(buf: [Byte], iOffset: inout Int, length: Int) -> TLVObject?
    {
        var outTLV: TLVObject?
        var iLocalOffset: Int = iOffset

        if(iLocalOffset < length)
        {
            var iTag: Int = Int((Int(buf[iLocalOffset] << 8) & 0x0000FF00))
            iLocalOffset += 1
            iTag += Int((buf[iLocalOffset] & 0x000000FF))
            iLocalOffset += 1
            
            var iLocalLength: Int = Int(Int(buf[iLocalOffset] << 8) & 0x0000FF00)
            iLocalOffset += 1
            iLocalLength += Int(buf[iLocalOffset] & 0x000000FF)
            iLocalOffset += 1
            
            if(length < iLocalLength + iLocalOffset)
            {
                //ERROR
                return outTLV
            }

            var data = [Byte](repeating: 0x00, count: iLocalLength)
            data = Array(buf[iLocalOffset ..< iLocalOffset + iLocalLength])
            //System.arraycopy(buf, iLocalOffset, data, 0, iLocalLength)
            iLocalOffset += iLocalLength

            outTLV = TLVObject(tag: iTag, length: iLocalLength, data: data)

        }
        iOffset = iLocalOffset

        return outTLV
    }

    static func ParseTLVBuffer(buf: [Byte], iOffset: inout Int, length: Int) -> [TLVObject]?
    {
        var output: [TLVObject?]?

        while(iOffset < length)
        {
            let currentOffset = iOffset
            let tlvObject = GetTLVObject(buf: buf, iOffset: &iOffset, length: length)!
            if(currentOffset == iOffset)
            {
                break
            }
            
            var key: Int
            key = tlvObject.iTag
            output![key] = tlvObject
        }
        
        return output as? [TLVObject]
    }

}
