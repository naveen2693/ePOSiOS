//
//  CPineKeyInjection.swift
//  ePOS
//
//  Created by Abhishek on 09/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public class CPineKeyInjection
{
    // MARK:-iFormatAndECBEncrypt
    func iFormatAndECBEncrypt(chArrInput:[Int],iInputLength:Int , chArrOutput:Byte,  iOutputLength:Int,chPadChar:Byte,iPadType:Int,iSlotID:Int) -> Int{
        return 0;
    }
    
    // MARK:- iFormatAndECBEncrypt
    public func iFormatAndECBEncrypt(chArrInput:[Byte],iInputLength:Int,chPadChar:Byte,iPadType:Int,SlotID:Int) -> [Byte]?
    {
        var iSlotID = SlotID;
        let iLen = chArrInput.count;
        var iPadOffset = 0;
        var iOffset = 0x00;
        let modulus = iLen % 8;
        if(modulus > 0)
        {
            iPadOffset = 8-modulus;
        }
        
        let iEncryptedDatalen = iLen + iPadOffset;
        var uchArrData = [Byte](repeating: 0x00, count:iLen+iPadOffset);
        if(iPadOffset > 0) {
            if (AppConstant._LEFT_PAD == iPadType)
            {
                for _ in uchArrData
                {
                    uchArrData.append(chPadChar);
                }
                uchArrData[iPadOffset..<iLen] = chArrInput[0..<iLen]
            }
            else
            {
                uchArrData[0..<iLen] = chArrInput[0..<iLen]
                for _ in iPadOffset..<(iLen-1)
                {
                    uchArrData.append(chPadChar)
                }
            }
        }
            
        else
        {
            uchArrData[0..<iLen] = chArrInput[0..<iLen]
        }
        
        _ = TransactionUtils.byteArray2HexString(arr: chArrInput);
        
        iSlotID = 0x04;
        
        _ = TransactionUtils.byteArray2HexString(arr: uchArrData);
        
        let uchArrEncryptedData = [Byte](repeating:0, count:iEncryptedDatalen)
        
        if(uchArrEncryptedData == nil)
        {
            GlobalData.singleton.m_csFinalMsgDoHubOnlineTxn = "Encrypting Mag Track failed!";
            return nil;
        }
        _ = TransactionUtils.byteArray2HexString(arr: uchArrEncryptedData);
        
        var uchFinalEncryptedData = [Byte](repeating:0, count:(iEncryptedDatalen+4))
        uchFinalEncryptedData[iOffset] = 0x01;
        iOffset += 1
        uchFinalEncryptedData[iOffset] = (Byte)(AppConstant.DEFAULT_BIN_KEYSLOTID & 0x000000FF);
        iOffset += 1
        uchFinalEncryptedData[iOffset] = (Byte)(chPadChar & 0x000000FF);
        iOffset += 1
        uchFinalEncryptedData[iOffset] = (Byte)(iPadType & 0x000000FF);
        iOffset += 1
        uchFinalEncryptedData[iOffset..<uchArrEncryptedData.count] = uchArrEncryptedData[0..<uchArrEncryptedData.count]
        _ = TransactionUtils.byteArray2HexString(arr:uchFinalEncryptedData);
        return uchFinalEncryptedData;
        
    }
    // MARK:-iResetPTMKTerminal
    func iResetPTMKTerminal(stResetResponse:RESET_RESPONSE) -> Bool
    {
        var iretPin = false, iretTLE = false;
        iretPin = iLoadPTMKPin(stResetResponse: stResetResponse, iRequestType: AppConstant.RESET_PTMK);
        iretTLE = iLoadPTMKTLE(stResetResponse: stResetResponse, iRequestType: AppConstant.RESET_PTMK);
        return iretPin || iretTLE;
    }
    
    // MARK:-iRenewPTMKTerminal
    func iRenewPTMKTerminal(stResetResponse:RESET_RESPONSE) -> Bool
    {
        var iretPin = false, iretTLE = false;
        iretPin = iLoadPTMKPin(stResetResponse: stResetResponse, iRequestType: AppConstant.RENEW_PTMK);
        iretTLE = iLoadPTMKTLE(stResetResponse: stResetResponse, iRequestType: AppConstant.RENEW_PTMK);
        return iretPin || iretTLE;
    }
    
    // MARK:-iLoadPTMKPin
    func iLoadPTMKPin(stResetResponse:RESET_RESPONSE,iRequestType:Int) -> Bool
    {
        var iret = false;
        var iKeySlotPMK = 0;
        var iKeySlotPTMKPin = 0;
        for it in 0..<stResetResponse.iNumKeySlots{
            if (iRequestType == AppConstant.RESET_PTMK)
            {
                iKeySlotPMK = AppConstant.KEYSLOT_PMK;
            }
            else
            {
                iKeySlotPMK = AppConstant.keySlotMap[it][AppConstant.ID_KEYSLOTPIN];
            }
            iKeySlotPTMKPin = AppConstant.keySlotMap[it][AppConstant.ID_KEYSLOTPIN];
            iret = iLoadVerifyZMK(iKeySlotMasterKey: iKeySlotPMK, iKeySlotRootKey: iKeySlotPTMKPin, chArrZMK: stResetResponse.sZMKKeys[it].uchArrPinZMKFinal, chArrChecksum: stResetResponse.sZMKKeys[it].uchArrKCVPinZMKFinal);
        }
        return iret;
    }
    
    // MARK:-iLoadPTMKTLE
    func iLoadPTMKTLE(stResetResponse:RESET_RESPONSE,iRequestType:Int) -> Bool
    {
        var iret = false;
        var iKeySlotPMK = 0;
        var iKeySlotPTMKTLE = 0;
        for it in 0..<stResetResponse.iNumKeySlots
        {
            if(iRequestType == AppConstant.RESET_PTMK)
            {
                iKeySlotPMK = AppConstant.KEYSLOT_PMK;
            }
            else
            {
                iKeySlotPMK = AppConstant.keySlotMap[it][AppConstant.ID_KEYSLOTTLE];
            }
            iKeySlotPTMKTLE = AppConstant.keySlotMap[it][AppConstant.ID_KEYSLOTTLE];
            iret = iLoadVerifyZMK(iKeySlotMasterKey: iKeySlotPMK, iKeySlotRootKey: iKeySlotPTMKTLE, chArrZMK: stResetResponse.sZMKKeys[it].uchArrTLEZMKFinal, chArrChecksum: stResetResponse.sZMKKeys[it].uchArrKCVTLEZMKFinal);
        }
        return iret;
    }
    
    // MARK:-iLoadVerifyZMK
    func iLoadVerifyZMK(iKeySlotMasterKey:Int,iKeySlotRootKey:Int,chArrZMK:[Byte],chArrChecksum:[Byte])  -> Bool
    {
        let secureLib = CSecureLib();
        
        var iret = false;
        if(AppConstant.LocalTLE)
        {
            iret = secureLib.LoadLocalTMK(chArrInput: chArrZMK, checksum: chArrChecksum, iKeySlotRootKey: iKeySlotMasterKey, iKeySlotMasterKey: iKeySlotRootKey);
        }
        else
        {
            //            iret = secureLib.iLoadKeyVerifyEncryptionKey(chArrZMK, chArrChecksum, iKeySlotMasterKey, iKeySlotRootKey);
        }
        return iret;
    }
    
    // MARK:-iLoadVerifySession
    func iLoadVerifySession(iKeySlotMasterKey:Int,iKeySlotRootKey:Int,chArrZMK:[Byte],chArrChecksum:[Byte],iType:Int) -> Bool
    {
        let secureLib = CSecureLib();
        var iret = false;
        if(AppConstant.LocalTLE)
        {
            iret = secureLib.LoadLocalSessionKey(chArrInput: chArrZMK, checksum: chArrChecksum, iKeySlotRootKey: iKeySlotMasterKey, iKeySlotMasterKey: iKeySlotRootKey, keyType: iType);
        }
        else
        {
            //iret = secureLib.iLoadKeyVerifySessionKey(chArrZMK, chArrChecksum, iKeySlotMasterKey, iKeySlotRootKey, iType);
        }
        return iret;
    }
    
    // MARK:-iGetPINTLEChecksum
    func iGetPINTLEChecksum(iKeySlotId:Int) -> [Byte]?
    {
        let secureLib = CSecureLib();
        let _:[Byte] = [0];
        if(AppConstant.LocalTLE)
        {
            if let KCV = secureLib.calcLocalKCV(iKeySlotId: iKeySlotId)
            {
                return KCV;
            }
        }
        return nil
    }
}
