//
//  cUtilClass.swift
//  ePOS
//
//  Created by Abhishek on 16/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public class CUtil{
    public static func a2bcd(s:[Byte]) -> [Byte] {
        var len:Int = Int(s.count)
        len /= 2
        let data:[Byte] = [Byte](repeating:0, count: len) // Allocate 1 byte per 2 hex characters
        for _ in stride(from: 0, to:len, by: 2){
           // Convert each character into a integer (base-16), then bit-shift into place
//            data[i/2] = ((.digit(s[i], 16) << 4).bytes
//                + Character.digit(s[i+1], 16)).bytes
       }
       return data
   }
}
