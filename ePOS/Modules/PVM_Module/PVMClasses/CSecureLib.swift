//
//  CSecureLib.swift
//  ePOS
//
//  Created by Abhishek on 09/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
class CSecureLib {
    
    var strTestLMK = "ED007B8DF07E787D96D281C3F5DBC930";
    var strSecureFileName = "LKIFile.txt";
    
    // MARK:- calcLocalKCV
    func calcLocalKCV(iKeySlotId:Int) -> [Byte]?
    {
        var KCV:[Byte]?;
        if let objSecureData:SecureData = GetKeyForKeySlotID(iKeySlotID: iKeySlotId)
        {
            KCV = TransactionUtils.a2bcd(objSecureData.strChecksum.bytes);
        }
        return KCV;
    }
    
    // MARK:-GetKeyForKeySlotID
    func GetKeyForKeySlotID(iKeySlotID:Int) -> SecureData?
    {
        var objRootSecureData:SecureData?;
        if  let  listSecureData:[SecureData] = FileSystem.ReadFile(strFileName: strSecureFileName)
        {
            for i in 0..<listSecureData.count
            {
                let objSecureData = listSecureData[i];
                if(objSecureData.iSlotID == iKeySlotID)
                {
                    objRootSecureData = objSecureData;
                    break;
                }
            }
        }
        return objRootSecureData;
    }
    
    // MARK:-SaveKeyForKeySlotID
    public func SaveKeyForKeySlotID(objMasterSecureData:SecureData) -> Bool
    {
        var index = -1;
        var bRet = false
        var listSecureDataValue:[SecureData]?
        listSecureDataValue = FileSystem.ReadFile(strFileName: strSecureFileName);
        if var listSecureData = listSecureDataValue
        {
            for i in 0..<listSecureData.count
            {
                let objSecureData = listSecureData[i];
                if(objSecureData.iSlotID == objMasterSecureData.iSlotID)
                {
                    listSecureData.remove(at: i);
                    index = i;
                }
            }
        }
        else
        {
            listSecureDataValue = [SecureData]();
        }
        listSecureDataValue?.append(objMasterSecureData);
        do
        {
            if let unwrappedlistSecureDataValue = listSecureDataValue
            {
                bRet = try FileSystem.ReWriteFile(strFileName: strSecureFileName, with: unwrappedlistSecureDataValue);
            }
        }
        catch
        {
            print("Rewrite")
        }
        return bRet;
    }
    
    // MARK:-SaveRootKey
    public  func SaveRootKey()
    {
        var objSecureData =  SecureData();
        objSecureData.iSlotID = 2;
        objSecureData.strMasterKey = strTestLMK;
        objSecureData.strChecksum = "000000";
        _ = SaveKeyForKeySlotID(objMasterSecureData: objSecureData);
    }
    
    // MARK:-calcKCVLocal
    func calcKCVLocal(key:String) -> String?
    {
        let strData = "0000000000000000";
        //Tripe DES NEED TO BE DONE
        let chArrOut = CryptoHandler.tripleDesDecrypt(key, strData)
        return chArrOut;
    }
    
    //Need to be done
    func LoadLocalTMK(chArrInput:[Byte],checksum:[Byte],iKeySlotRootKey:Int,iKeySlotMasterKey:Int) -> Bool
    {
        var ret = false;
        let temp1 = TransactionUtils.byteArray2HexString(arr: chArrInput);
        _ = TransactionUtils.byteArray2HexString(arr: checksum);
        if  let objRootSecureData:SecureData = GetKeyForKeySlotID(iKeySlotID: iKeySlotRootKey){
            if let strMasterKey = CryptoHandler.tripleDesDecrypt(objRootSecureData.strMasterKey,temp1){
                let chArr  = calcKCVLocal(key:strMasterKey)
                if let chArrKCV =  chArr?.bytes{
                    if((chArrKCV[0] == checksum[0]) &&
                        (chArrKCV[1] == checksum[1]) && (chArrKCV[2] == checksum[2]))
                    {
                        ret = true;
                    }
                    
                    if(ret)
                    {
                        var objSecureData = SecureData();
                        objSecureData.iSlotID = iKeySlotMasterKey;
                        objSecureData.strMasterKey = strMasterKey;
                        if let  bAsciiCheckSum:[Byte] = TransactionUtils.bcd2a(chArrKCV){
                            if case objSecureData.strChecksum = TransactionUtils.ByteArrayToHexString(bAsciiCheckSum){
                                ret = SaveKeyForKeySlotID(objMasterSecureData: objSecureData);
                            }
                        }
                    }
                }
            }
        }
        else
        {
            return false
        }
        return ret
        
    }
    
    // MARK:- LoadLocalSessionKey
    func LoadLocalSessionKey(chArrInput:[Byte],checksum:[Byte],iKeySlotRootKey:Int, iKeySlotMasterKey:Int,keyType:Int) -> Bool
    {
        var ret = false;
        let temp1 = TransactionUtils.byteArray2HexString(arr: chArrInput);
        _ = TransactionUtils.byteArray2HexString(arr: checksum);
        if  GetKeyForKeySlotID(iKeySlotID: iKeySlotRootKey) != nil
        {
            if  let objRootSecureData:SecureData = GetKeyForKeySlotID(iKeySlotID: iKeySlotRootKey)
            {
                if let strMasterKey = CryptoHandler.tripleDesDecrypt(objRootSecureData.strMasterKey,temp1)
                {
                    let chArr  = calcKCVLocal(key:strMasterKey)
                    if let chArrKCV =  chArr?.bytes
                    {
                        if((chArrKCV[0] == checksum[0]) &&
                            (chArrKCV[1] == checksum[1]) &&
                            (chArrKCV[2] == checksum[2]))
                        {
                            ret = true;
                        }
                        
                        if(ret)
                        {
                            var objSecureData = SecureData();
                            objSecureData.iSlotID = iKeySlotMasterKey;
                            objSecureData.strMasterKey = strMasterKey;
                            if let  bAsciiCheckSum:[Byte] = TransactionUtils.bcd2a(chArrKCV)
                            {
                                if case objSecureData.strChecksum = TransactionUtils.ByteArrayToHexString(bAsciiCheckSum)
                                {
                                    ret = SaveKeyForKeySlotID(objMasterSecureData: objSecureData);
                                    ret = SaveKeyForKeySlotID(objMasterSecureData: objSecureData);
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        else
        {
            return false
        }
        return ret;
    }
    
    // MARK:-EncryptLocalData
    func EncryptLocalData(iKeySlot:Int,strData:String) -> [Byte]?
    {
        if let  objRootSecureData = GetKeyForKeySlotID(iKeySlotID: iKeySlot)
        {
            var chArrOut = CryptoHandler.tripleDesEncrypt(objRootSecureData.strMasterKey, strData);
            return chArrOut;
        }
        return nil
    }
    
//
//     func EncryptPinBlock(strPAN16Digit:String, != nilstrPin:String,iKeySlot:Int)
//    //    {
    //        var encryptedPinBlock = [Byte](repeating:0, count: 16);
    //        var strEncryptedPinBlock = "";
    //
    //        var strPinComp = "";
    //        strPinComp = "0"+strPin.count;
    //        strPinComp += strPin;
    //        strPinComp = TransactionUtils.StrRightPad(strPinComp, 16, "F");
    //        byte[] bPinComp = CUtils.a2bcd(strPinComp.getBytes());
    //
    //
    //        String strPANComp = "";
    //        strPANComp = strPAN16Digit.substring(strPAN16Digit.length() - 13, strPAN16Digit.length() - 1);
    //        strPANComp = CUtils.StrLeftPad(strPANComp, 16, '0');
    //        byte[] bPANComp = CUtils.a2bcd(strPANComp.getBytes());
    //
    //        byte[] pinBlock = CUtils.vFnXOR(bPinComp, bPANComp, bPinComp.length);
    //        String strPinBlock = BytesUtil.bytes2HexString(pinBlock);
    //
    //        encryptedPinBlock =   EncryptLocalData(iKeySlot, strPinBlock);
    //        strEncryptedPinBlock = BytesUtil.bytes2HexString(encryptedPinBlock);
    //
    //        return  strEncryptedPinBlock;
    //    }
    //
    //    public String GetMaskedPAN(String csPAN)
    //    {
    //        String csMaskedPAN = csPAN;
    //        if(csPAN.length() > 6)
    //        {
    //            if(csPAN.length() >= 16)
    //            {
    //                csMaskedPAN = csPAN.substring(0, 6);
    //                csMaskedPAN = CUtils.StrRightPad(csMaskedPAN, csPAN.length()-4, '*');
    //                csMaskedPAN = csMaskedPAN + csPAN.substring(csPAN.length()-4, csPAN.length());
    //            }
    //            else
    //            {
    //                if(csPAN.length() > 12) {
    //                    csMaskedPAN = csPAN.substring(0, 6);
    //                    csMaskedPAN = CUtils.StrRightPad(csMaskedPAN, 12, '*');
    //                    csMaskedPAN = csMaskedPAN + csPAN.substring(12, csPAN.length());
    //                }
    //                else{
    //                    csMaskedPAN = csPAN.substring(0, 6);
    //                    csMaskedPAN = CUtils.StrRightPad(csMaskedPAN, csPAN.length(), '*');
    //                }
    //            }
    //        }
    //        return csMaskedPAN;
    //    }
}
