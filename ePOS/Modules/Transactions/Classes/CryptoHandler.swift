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
    
    //MARK:- padLeft(data: String, length: Int, padChar: Character) -> String
    static func padLeft(data: String, length: Int, padChar: Character) -> String {
        let remaining = length - data.count;
        
        var newData = data;
        
        for _ in 0..<remaining
        {
            newData = String(padChar) + newData            // padChar + newData;
        }
        return newData;
    }
    
    
   
    
    
//    static func tripleDesDecrypt(masterKey:String, Input:String) -> String
//    {
//
//
//        return ""
//    }
//
//    static func tripleDesEncrypt(masterKey:String, Input:String) -> [Byte]?
//      {
//
//
//          return nil
//      }
//
    
  //MARK:- vFnGetSHA1(_ buffer: [UInt8]) -> String
    static func vFnGetSHA1(_ buffer: [UInt8]) -> String
    {
        let SHA1HexString = buffer.sha1().toHexString().uppercased()
        return SHA1HexString
    }
    
    //MARK:- vFnGetSHA256(_ buffer: [UInt8]) -> String
    static func vFnGetSHA256(_ buffer: [UInt8]) -> String
    {
        let SHA256HexString = buffer.sha256().toHexString().uppercased()
        return SHA256HexString
    }
    
    //MARK:- vFnGetCRC32(_ buffer: [UInt8]) -> String
    static func GetCRC32(_ buffer: [UInt8]) -> UInt32
    {
        let crcValue = buffer.crc32()
        return crcValue
    }
    
    //MARK:- XOREncrypt(_ bArrDataToEncrypt: [UInt8] , _ encryptionType: Int) -> [UInt8]?
    static func XOREncrypt(_ bArrDataToEncrypt: [UInt8] , _ encryptionType: Int) -> [UInt8]?
    {
        guard let key = getEncryptionKey(encryptionType) else { return nil }
        
        let iInputLength = bArrDataToEncrypt.count
        let iKeySize = key.count
        
        var bArrEncryptedData = [UInt8](repeating: 0, count: iInputLength)
        
        for i in 0..<iInputLength
        {
            bArrEncryptedData[i] = circularLeftRotate((UInt8)(bArrDataToEncrypt[i] ^ 0xFF), (Int)(key[i%iKeySize] & 0x00FF))
        }
        
        return bArrEncryptedData
    }
    
    //MARK:- XORDecrypt(_ bArrDataToDecrypt: [UInt8] , _ encryptionType: Int) -> [UInt8]?
    static func XORDecrypt(_ bArrDataToDecrypt: [UInt8] , _ encryptionType: Int) -> [UInt8]?
    {
        guard let key = getEncryptionKey(encryptionType) else { return nil }
        
        let iInputLength = bArrDataToDecrypt.count
        let iKeySize = key.count
        
        var bArrDecryptedData = [UInt8](repeating: 0, count: iInputLength)
        
        for i in 0..<iInputLength
        {
            bArrDecryptedData[i] = circularRightRotate((UInt8)(bArrDataToDecrypt[i] ^ 0xFF), (Int)(key[i%iKeySize] & 0x00FF))
        }
        
        return bArrDecryptedData
    }
    
    //MARK:- getEncryptionKey(_ keyType: Int) -> [UInt8]?
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


    //MARK:- vFnGetSHA256(key:String) -> String
    static func vFnGetSHA256(key: String) -> String
    {
      return key.hmac(key: key)
    }

    //MARK:- circularLeftRotate(_ bytetoRotate : UInt8, _ iNumberOfTimes : Int) -> UInt8

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
    
    //MARK:- circularRightRotate(_ bytetoRotate : UInt8, _ iNumberOfTimes : Int) -> UInt8
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
    
    //MARK:- tripleDesEncrypt(_ bArrData:[UInt8] , _ bArrKey:[UInt8]) -> [UInt8]?
    static func tripleDesEncrypt(_ bArrData:[UInt8] , _ bArrKey:[UInt8]) -> [UInt8]? {
        
        //Used 3DES/ECB/NoPadding
        let iRemainder:Int = (bArrData.count) % 8
        var bArrDataNew:[UInt8]
        if iRemainder != 0  {
            let iNewSize = bArrData.count+8 - iRemainder
            bArrDataNew = TransactionUtils.ByteArrayZeroCharacterPaddingtoRight(to:bArrData , blockSize:iNewSize)
        }
        else{
            bArrDataNew = bArrData
        }
       
        var bArrKeyNew = [UInt8](repeating:0,count:24)
        bArrKeyNew[0...15] = bArrKey[0...15]
        bArrKeyNew[16...23] = bArrKey[0...7]
    
    
        let myKeyData : Data = Data(bArrKeyNew)
        let myRawData : Data = Data(bArrDataNew)
        let buffer_size : size_t = myRawData.count
        let buffer = UnsafeMutablePointer<NSData>.allocate(capacity: buffer_size)
        var num_bytes_encrypted : size_t = 0
        let operation: CCOperation = UInt32(kCCEncrypt)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithm3DES)
        let options:   CCOptions   = UInt32(kCCOptionECBMode)
        let keyLength        = size_t(kCCKeySize3DES)
        let Crypto_status: CCCryptorStatus = CCCrypt(operation, algoritm, options, (myKeyData as NSData).bytes, keyLength, nil, (myRawData as NSData).bytes, myRawData.count, buffer, buffer_size, &num_bytes_encrypted)
            if UInt32(Crypto_status) == UInt32(kCCSuccess){
            let myResult: Data = Data(bytes: buffer, count: num_bytes_encrypted)
            let encryptedBytes = myResult.bytes
            debugPrint(encryptedBytes)
            guard let temp3 = TransactionUtils.ByteArrayToHexString(encryptedBytes)?.uppercased() else               {return nil}
            debugPrint(temp3)
            free(buffer)
            return encryptedBytes
        }else{
            free(buffer)
            return nil
        }
    }
    
    //MARK:- tripleDesDecrypt(_ strKey:String , _ strData:String) -> String?
    static func tripleDesDecrypt(_ strKey:String , _ strData:String) -> String?{
        //Used 3DES/ECB/NoPadding
        guard let bArrKey = TransactionUtils.HexStringToByteArray(strKey) else {return nil}
                       
              
        var bArrKeyNew = [UInt8](repeating:0,count:24)
        bArrKeyNew[0...15] = bArrKey[0...15]
        bArrKeyNew[16...23] = bArrKey[0...7]
        guard let bArrDataNew = TransactionUtils.HexStringToByteArray(strData) else {return nil}
      
        let myKeyData : Data = Data(bArrKeyNew)
        let myRawData : Data = Data(bArrDataNew)
        let buffer_size : size_t = myRawData.count
        let buffer = UnsafeMutablePointer<NSData>.allocate(capacity: buffer_size)
        var num_bytes_encrypted : size_t = 0
        let operation: CCOperation = UInt32(kCCDecrypt)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithm3DES)
        let options:   CCOptions   = UInt32(kCCOptionECBMode)
        let keyLength        = size_t(kCCKeySize3DES)
        let Crypto_status: CCCryptorStatus = CCCrypt(operation, algoritm, options, (myKeyData as
    NSData).bytes, keyLength, nil, (myRawData as NSData).bytes, myRawData.count, buffer,
    buffer_size, &num_bytes_encrypted)
        if UInt32(Crypto_status) == UInt32(kCCSuccess){
            let myResult: Data = Data(bytes: buffer, count: num_bytes_encrypted)
            let decryptedBytes = myResult.bytes
            debugPrint(decryptedBytes)
            guard let decryptedHex =
    TransactionUtils.ByteArrayToHexString(decryptedBytes)?.uppercased() else {return
    nil}
            debugPrint(decryptedHex)
            free(buffer)
            return decryptedHex
        }else{
            free(buffer)
            return nil
        }
    }
    
    //MARK:- tripleDesEncrypt(_ strKey:String , _ strData:String) -> [UInt8]?
    static func tripleDesEncrypt(_ strKey:String , _ strData:String) -> [UInt8]? {
        
        //Used 3DES/ECB/NoPadding
        guard let bArrKey = TransactionUtils.HexStringToByteArray(strKey) else {return nil}
                       
        
        var bArrKeyNew = [UInt8](repeating:0,count:24)
        bArrKeyNew[0...15] = bArrKey[0...15]
        bArrKeyNew[16...23] = bArrKey[0...7]
        
        guard let bArrDataNew = TransactionUtils.HexStringToByteArray(strData) else {return nil}
        
        let myKeyData : Data = Data(bArrKeyNew)
        let myRawData : Data = Data(bArrDataNew)
        
        let buffer_size : size_t = myRawData.count
        let buffer = UnsafeMutablePointer<NSData>.allocate(capacity: buffer_size)
        var num_bytes_encrypted : size_t = 0
        let operation: CCOperation = UInt32(kCCEncrypt)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithm3DES)
        let options:   CCOptions   = UInt32(kCCOptionECBMode)
        let keyLength        = size_t(kCCKeySize3DES)
        let Crypto_status: CCCryptorStatus = CCCrypt(operation, algoritm, options, (myKeyData as NSData).bytes, keyLength, nil, (myRawData as NSData).bytes, myRawData.count, buffer, buffer_size, &num_bytes_encrypted)
        if UInt32(Crypto_status) == UInt32(kCCSuccess){
            let myResult: Data = Data(bytes: buffer, count: num_bytes_encrypted)
            let encryptedBytes = myResult.bytes
            debugPrint(encryptedBytes)
            guard let temp3 = TransactionUtils.ByteArrayToHexString(encryptedBytes) else {return nil}
            debugPrint(temp3)
            free(buffer)
            return encryptedBytes
        }else{
            free(buffer)
            return nil
        }
    }

    
}
