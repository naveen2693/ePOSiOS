//
//  CRC32.swift
//  ePOS
//
//  Created by Vishal Rathore on 12/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public class  CRC32{

    private var crc: Int = 0
    
    func update (buf: [Byte], off: Int, len: Int)
    {
        
    }
    
    func GetValue() -> Int64
    {
       return (Int64)(crc & 0xffffffff)
     }
    
}
