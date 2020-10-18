//
//  CryptoHandler.swift
//  ePOS
//
//  Created by Naveen Goyal on 06/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
import CommonCrypto
import CryptoSwift

enum XOREncryptionType {
       static let INVALID = 0
       static let SERIAL_LINK_ENCRYPTION  = 1
       static let USER_DATA_ENCRYPTION  = 2
       static let SERIAL_LINK_SHA_ENCRYPTION = 3
}

class CryptoHandler{
    
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
    
    
    func vFnGetSHA1(_ buffer: [UInt8]) -> String
    {
        let SHA1HexString = buffer.sha1().toHexString().uppercased()
        return SHA1HexString
    }
    
    func vFnGetSHA256(_ buffer: [UInt8]) -> String
    {
        let SHA256HexString = buffer.sha256().toHexString().uppercased()
        return SHA256HexString
    }
    
    
    static func XOREncrypt(_ bArrDataToEncrypt: [UInt8] , _ encryptionType: Int) -> [UInt8]?
    {
        guard let key = getEncryptionKey(encryptionType) else { return nil }
        
        let iInputLength = bArrDataToEncrypt.count
        let iKeySize = key.count
        
        var bArrEncryptedData = [UInt8](repeating: 0, count: iInputLength)
        
        for i in 0..<iInputLength
        {
            bArrEncryptedData[i]=circularLeftRotate((UInt8)(bArrDataToEncrypt[i] ^ 0xFF),        (Int)(key[i%iKeySize] & 0x00FF)) ;
        }
        
        return bArrEncryptedData
    }
    
    static func XORDecrypt(_ bArrDataToDecrypt: [UInt8] , _ encryptionType: Int) -> [UInt8]?
    {
        guard let key = getEncryptionKey(encryptionType) else { return nil }
        
        let iInputLength = bArrDataToDecrypt.count
        let iKeySize = key.count
        
        var bArrDecryptedData = [UInt8](repeating: 0, count: iInputLength)
        
        for i in 0..<iInputLength
        {
            bArrDecryptedData[i]=circularRightRotate((UInt8)(bArrDataToDecrypt[i] ^ 0xFF),        (Int)(key[i%iKeySize] & 0x00FF)) ;
        }
        
        return bArrDecryptedData
    }
    
    static func getEncryptionKey(_ keyType: Int) -> [UInt8]?
    {
        switch keyType {
        case XOREncryptionType.SERIAL_LINK_ENCRYPTION:
             let key = [UInt8]("GODISGREAT".utf8)
             return key
        case XOREncryptionType.USER_DATA_ENCRYPTION:
            guard var hardwareSerialNumber = PlatFormUtils.GetHardWareSerialNumber() else {return nil}
            if hardwareSerialNumber.count < 15 {
                hardwareSerialNumber = TransactionUtils.ByteArrayZeroPaddingtoLeft(to: hardwareSerialNumber,blockSize:15)
            }
            let key = hardwareSerialNumber
            return key
        case XOREncryptionType.SERIAL_LINK_SHA_ENCRYPTION:
            //Not required for epos as we are not using serial communication
            break
        default:
            return nil
        }
        
        return nil
    }
    
    static func circularLeftRotate(_ bytetoRotate : UInt8, _ iNumberOfTimes : Int) -> UInt8
    {
        var iRotate = iNumberOfTimes - 1
        var byte = bytetoRotate
        while((iRotate > 0)){
            byte = (UInt8)((((byte<<1)) | ((byte & 0x80)>>7)))
            iRotate = iRotate - 1
        }
        return bytetoRotate;
    }
    
    static func circularRightRotate(_ bytetoRotate : UInt8, _ iNumberOfTimes : Int) -> UInt8
    {
        var iRotate = iNumberOfTimes - 1
        var byte = bytetoRotate
        while((iRotate > 0)){
            byte = (UInt8)((((byte>>1) & 0x7F) | ((byte & 0x01)<<7)))
            iRotate = iRotate - 1
        }
        return bytetoRotate;
    }

    static func vFnGetSHA256(key:String) -> String
    {
      return key.hmac(key: key)
    }

}
