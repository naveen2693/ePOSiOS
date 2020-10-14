//
//  CryptoHandler.swift
//  ePOS
//
//  Created by Naveen Goyal on 06/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CryptoHandler{
    
    
    enum EnXOREncryptionType: Int {
           case INVALID = 0
           case SERIAL_LINK_ENCRYPTION  = 1
           case USER_DATA_ENCRYPTION  = 2
           case SERIAL_LINK_SHA_ENCRYPTION = 3
    }
    
    static func padLeft(data: String, length: Int, padChar: Character) -> String {
        let remaining = length - data.count;

        var newData = data;
    
        for _ in 0..<remaining
        {
            newData.append(padChar)
            // padChar + newData;
        }

        return newData;
    }
    
    static func tripleDesEncrypt(masterKey: [Byte], Input: [Byte], padChar: Character) -> [Byte]?
    {
        return nil
    }

    static func XOREncrypt(rawdata: [Byte], cipherlen : Int, encrypted: [Byte], lenBuff: Int, uchDynamicInput: [Byte]?, DynamicInputLen: Int, encryptionType: Int) -> [Byte]
    {
        let byte = [Byte](repeating: 0x00, count: 50)
        return byte
    }
    
}
