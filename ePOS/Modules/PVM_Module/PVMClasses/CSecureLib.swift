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

/*    boolean iLoadKeyVerifyEncryptionKey(byte[] chArrInput, byte[] checksum, int iKeySlotMasterKey, int iKeySlotRootKey) {
        boolean ret = false;
        try {
            ret = pinpadMK.open();
            ret = pinpadMK.isKeyExist(iKeySlotMasterKey);
            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "isKeyExist at Slot[%d[, Result[%s]", iKeySlotMasterKey, Boolean.toString(ret));
            if (ret) {
                ret = pinpadMK.loadEncKey(KeyType.MAIN_KEY, iKeySlotMasterKey, iKeySlotRootKey, chArrInput, checksum);
                CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "LoadKey[%s]", Boolean.toString(ret));
                byte[] KCV = ArkeSdkDemoApplication.pinpadMK.calcKCV(iKeySlotRootKey); //  if Source & Dest Id is same "loadEncKey" returns false, but key is actually loaded
                ret = ByteBuffer.wrap(checksum, 0, 3).equals(ByteBuffer.wrap(KCV, 0, 3));
                System.out.println(iKeySlotRootKey + " kcv:" + BytesUtil.bytes2HexString(ArkeSdkDemoApplication.pinpadMK.calcKCV(iKeySlotRootKey)));
            }
        }
        catch (Exception e) {
            ret = false;
            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(e));
        }
        return ret;
    }

    boolean iLoadKeyVerifySessionKey(byte[] chArrInput, byte[] checksum, int iKeySlotMasterKey, int iKeySlotRootKey, int keyType) {
        boolean ret = false;
        try {
            ret = pinpadMK.open();
            ret = pinpadMK.isKeyExist(iKeySlotMasterKey);
            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "isKeyExist at Slot[%d], Result[%s]", iKeySlotMasterKey,Boolean.toString(ret));
            ret = pinpadMK.loadEncKey(keyType, iKeySlotMasterKey, iKeySlotRootKey, chArrInput, checksum);
            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "LoadKey[%s]", Boolean.toString(ret));
        }
        catch (RemoteException e) {
            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(e));
        }
        return ret;
    }

    byte[] calcKCV(int iKeySlotId){
        byte[] bRet = null;
        try{

            bRet = pinpadMK.calcKCV(iKeySlotId);
        }
        catch (RemoteException e) {
            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(e));
        }
        return bRet;
    }*/

    func calcLocalKCV(iKeySlotId:Int) -> [Byte]?{
        var KCV:[Byte]?;

        if let objSecureData:SecureData = GetKeyForKeySlotID(iKeySlotID: iKeySlotId){
            KCV = TransactionUtils.a2bcd(objSecureData.strChecksum.bytes);
        }
        return KCV;
    }

    func GetKeyForKeySlotID(iKeySlotID:Int) -> SecureData?
    {
        var objRootSecureData:SecureData?;
        if  let  listSecureData:[SecureData] = FileSystem.ReadFile(strFileName: strSecureFileName){
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


    public func SaveKeyForKeySlotID(objMasterSecureData:SecureData) -> Bool
    {
        var index = -1;
        var bRet = false
        var listSecureDataValue:[SecureData]?
        listSecureDataValue = FileSystem.ReadFile(strFileName: strSecureFileName);
        if var listSecureData = listSecureDataValue{
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
        else {
            listSecureDataValue = [SecureData]();
        }
        listSecureDataValue?.append(objMasterSecureData);
        do{
        if let unwrappedlistSecureDataValue = listSecureDataValue{
        bRet = try FileSystem.ReWriteFile(strFileName: strSecureFileName, with: unwrappedlistSecureDataValue);
        }
        }catch{
            print("Rewrite")
        }
        return bRet;
    }

    public  func SaveRootKey()
    {
        var objSecureData =  SecureData();
        objSecureData.iSlotID = 2;
        objSecureData.strMasterKey = strTestLMK;
        objSecureData.strChecksum = "000000";
        SaveKeyForKeySlotID(objMasterSecureData: objSecureData);
    }

    func calcKCVLocal(key:String) ->String?{

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

    func LoadLocalSessionKey(chArrInput:[Byte],checksum:[Byte],iKeySlotRootKey:Int, iKeySlotMasterKey:Int,keyType:Int) -> Bool {
        var ret = false;
        let temp1 = TransactionUtils.byteArray2HexString(arr: chArrInput);
        _ = TransactionUtils.byteArray2HexString(arr: checksum);
        if  let objRootSecureData = GetKeyForKeySlotID(iKeySlotID: iKeySlotRootKey){
            if  let objRootSecureData:SecureData = GetKeyForKeySlotID(iKeySlotID: iKeySlotRootKey){
                if let strMasterKey = CryptoHandler.tripleDesDecrypt(objRootSecureData.strMasterKey,temp1){
                let chArr  = calcKCVLocal(key:strMasterKey)
                    if let chArrKCV =  chArr?.bytes{
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
                        if let  bAsciiCheckSum:[Byte] = TransactionUtils.bcd2a(chArrKCV){
                            if case objSecureData.strChecksum = TransactionUtils.ByteArrayToHexString(bAsciiCheckSum){
                                ret = SaveKeyForKeySlotID(objMasterSecureData: objSecureData);
                                ret = SaveKeyForKeySlotID(objMasterSecureData: objSecureData);  }
                        }
                    }
                    
                    
                }}
        }
    }
    else
    {
    return false
    }
    return ret;
}

     func EncryptLocalData(iKeySlot:Int,strData:String) -> [Byte]? {
        if let  objRootSecureData = GetKeyForKeySlotID(iKeySlotID: iKeySlot){
            var chArrOut = CryptoHandler.tripleDesEncrypt(objRootSecureData.strMasterKey, strData);
             return chArrOut;
        }
       return nil
    }


//
//
//    public func EncryptPinBlock(strPAN16Digit:String,strPin:String,iKeySlot:Int)
//    {
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
