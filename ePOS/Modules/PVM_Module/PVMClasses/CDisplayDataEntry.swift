//
//  CDisplayDataEntry.swift
//  ePOS
//
//  Created by Abhishek on 06/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
class CDisplayDataEntry : CBaseNode {
    var m_inputMethod:enum_InputMethod;
    var m_max_val:Int;
    var m_min_val:Int;
    var m_bIsUnicodeDisplayDataEntry:Bool;
    var m_iFontId:Int;
    
    // MARK:-init
    public override init()
    {
        self.m_inputMethod = enum_InputMethod.NUMERIC_ENTRY;
        self.m_max_val = 0;
        self.m_min_val = 0;
        self.m_bIsUnicodeDisplayDataEntry = false;
        self.m_iFontId = 0;
    }
    
    // MARK:- AddPrivateParameters
    override func AddPrivateParameters(tagAttribute:XMLATTRIBUTE,nTotal:Int) -> Int
    {
        let retVal = RetVal.RET_OK;
        if (tagAttribute.IsUTF8)
        {
            m_bIsUnicodeDisplayDataEntry = true;
            m_iFontId = tagAttribute.fontId;
        }
        
        m_max_val = Int(tagAttribute.MaxLen);
        m_min_val = Int(tagAttribute.MinLen);
        pvmListParser = tagAttribute.pvmListParser
        ScanType = tagAttribute.ScanType;
        if (m_bIsUnicodeDisplayDataEntry)
        {
            if (tagAttribute.DisplayMessagelen > 0)
            {
                DisplayMessage = tagAttribute.DisplayMessage;
            }
        }
        else
        {
            DisplayMessage = tagAttribute.DisplayMessage;
        }
        return retVal;
    }
    
    // MARK:- getExecution_result_numeric
    func getExecution_result_numeric(ret:Int,global:GlobalData, buffer:[Byte],  bufferlen:Int) -> Int
    {
        var retval = ret
        m_max_val = m_max_val > 54 ? 54 : m_max_val;
        if (ExecutionResult._OK == retval) {
            if ((m_iTleEnabled) && (GlobalData.singleton.m_sMasterParamData?.m_iUsePineEncryptionKeys != 0))
            {
                if (bufferlen > 0)
                {
                    let objEncryption = CPineKeyInjection();
                    _ = [Byte](repeating: 0, count:bufferlen + 14);
                    if let uchArrEncOut = objEncryption.iFormatAndECBEncrypt(chArrInput: buffer, iInputLength: bufferlen, chPadChar: m_chPadChar, iPadType: m_iPadStyle, SlotID: AppConstant.DEFAULT_BIN_KEYSLOTID)
                    {
                        AddTLVDataWithTag(uiTag: HostTlvtag, Data: uchArrEncOut, length: uchArrEncOut.count);
                    }
                    else
                    {
                        retval = ExecutionResult._EXIT;
                    }
                }
                else
                {
                    retval = ExecutionResult._EXIT;
                }
            }
            else
            {
                if (m_iTleEnabled)
                {
                    var uchArrEncOut = [Byte](repeating: 0, count:bufferlen + 14);
                    var iOffset = 0;
                    uchArrEncOut[iOffset] = 0; // TLE NOT USED
                    iOffset += 1
                    uchArrEncOut[iOffset] = Byte(AppConstant.DEFAULT_BIN_KEYSLOTID & 0x000000FF);
                    iOffset += 1
                    uchArrEncOut[iOffset] = (m_chPadChar & 0x000000FF);
                    iOffset += 1
                    uchArrEncOut[iOffset] = Byte(m_iPadStyle);
                    uchArrEncOut[0..<bufferlen] = buffer[0..<bufferlen]
                    iOffset += bufferlen;
                    AddTLVDataWithTag(uiTag: HostTlvtag, Data: uchArrEncOut, length: iOffset);
                }
                else
                {
                    AddTLVData(Data: buffer, length: bufferlen);
                }
            }
        }
        return retval;
    }
    
    // MARK:-execute
    public override func execute() -> Int
    {
        let global = GlobalData.singleton;
        var retval = getExecutionResult(iResult: iResult);
        if(retval == ExecutionResult._OK)
        {
            var buffer:[Byte] = [0];
            var bufferlen = 0;
            if let pvmListParser = pvmListParser
            {
                if (pvmListParser.count > 0)
                {
                    if let buffervalue = iBuffer
                    {
                        let m_valuelist = buffervalue.split(separator: ",",maxSplits: -1);
                        for i in 0..<pvmListParser.count {
                            m_inputMethod = pvmListParser[i].InputMethod;
                            m_max_val = pvmListParser[i].MaxLen;
                            m_min_val = pvmListParser[i].MinLen;
                            HostTlvtag = pvmListParser[i].HTL
                            buffer = m_valuelist[i].bytes;
                            bufferlen = buffer.count;
                            switch (m_inputMethod)
                            {
                            case enum_InputMethod.NUMERIC_ENTRY:
                            retval = getExecution_result_numeric(ret: retval,global: global,buffer: buffer, bufferlen: bufferlen);
                            case enum_InputMethod.ALPHANUMERIC_ENTRY: fallthrough
                            default:
                                m_max_val = m_max_val > 38 ? 38 : m_max_val;
                                if (ExecutionResult._OK == retval)
                                {
                                    bufferlen = buffer.count;
                                    if ((m_iTleEnabled) && (GlobalData.singleton.m_sMasterParamData?.m_iUsePineEncryptionKeys != 0))
                                    {
                                        if (bufferlen > 0)
                                        {
                                            let objEncryption = CPineKeyInjection();
                                            _ = [Byte](repeating: 0, count:bufferlen + 14);
                                            if let uchArrEncOut = objEncryption.iFormatAndECBEncrypt(chArrInput: buffer, iInputLength: bufferlen, chPadChar: m_chPadChar, iPadType: m_iPadStyle, SlotID: AppConstant.DEFAULT_BIN_KEYSLOTID)
                                            {
                                                AddTLVDataWithTag(uiTag: HostTlvtag, Data: uchArrEncOut, length: uchArrEncOut.count);
                                            }
                                            else
                                            {
                                                retval = ExecutionResult._EXIT;
                                            }
                                        }
                                        else
                                        {
                                            retval = ExecutionResult._EXIT;
                                        }
                                    }
                                    else
                                    {
                                        if (m_iTleEnabled)
                                        {
                                            var uchArrEncOut = [Byte](repeating: 0, count:bufferlen + 14);
                                            var iOffset = 0;
                                            uchArrEncOut[iOffset] = 0; // TLE NOT USED
                                            iOffset += 1
                                            uchArrEncOut[iOffset] = Byte(AppConstant.DEFAULT_BIN_KEYSLOTID & 0x000000FF);
                                            iOffset += 1
                                            uchArrEncOut[iOffset] = (m_chPadChar & 0x000000FF);
                                            iOffset += 1
                                            uchArrEncOut[iOffset] = Byte(m_iPadStyle);
                                            uchArrEncOut[0..<bufferlen] = buffer[0..<bufferlen]
                                            iOffset += bufferlen;
                                            AddTLVDataWithTag(uiTag: HostTlvtag, Data: uchArrEncOut, length: iOffset);
                                        }
                                        else
                                        {
                                            AddTLVData(Data: buffer, length: bufferlen);
                                        }
                                    }
                                }
                            }
                            
                            if (ExecutionResult._OK == retval)
                            {
                                AddAmountFromXmlinTlV();
                                SetCurrencyCodeInEMVModule();
                            }
                            
                        }
                    }
                    else
                    {
                        
                        buffer = iBuffer?.bytes ?? [0];
                        bufferlen = buffer.count;
                        m_max_val = maxLen;
                        switch (m_inputMethod) {
                        case enum_InputMethod.NUMERIC_ENTRY:
                            retval = getExecution_result_numeric(ret: retval, global: global, buffer: buffer, bufferlen: bufferlen);
                        case enum_InputMethod.ALPHANUMERIC_ENTRY: fallthrough
                        default:
                            m_max_val = m_max_val > 38 ? 38 : m_max_val;
                            if (ExecutionResult._OK == retval)
                            {
                                bufferlen = buffer.count;
                                if ((m_iTleEnabled) && (GlobalData.singleton.m_sMasterParamData?.m_iUsePineEncryptionKeys != 0))
                                {
                                    if (bufferlen > 0)
                                    {
                                        let objEncryption =  CPineKeyInjection();
                                        _ = [Byte](repeating: 0, count:bufferlen + 14);
                                        if let uchArrEncOut = objEncryption.iFormatAndECBEncrypt(chArrInput: buffer, iInputLength: bufferlen, chPadChar: m_chPadChar, iPadType: m_iPadStyle, SlotID: AppConstant.DEFAULT_BIN_KEYSLOTID)
                                        {
                                            AddTLVDataWithTag(uiTag: HostTlvtag, Data: uchArrEncOut, length: uchArrEncOut.count);
                                        }
                                        else
                                        {
                                            retval = ExecutionResult._EXIT;
                                        }
                                    }
                                    else
                                    {
                                        retval = ExecutionResult._EXIT;
                                    }
                                }
                                else
                                {
                                    if (m_iTleEnabled)
                                    {
                                        var uchArrEncOut = [Byte](repeating: 0, count: bufferlen + 14);
                                        var iOffset = 0;
                                        uchArrEncOut[iOffset] = 0; // TLE NOT USED
                                        iOffset += 1
                                        uchArrEncOut[iOffset] = Byte(AppConstant.DEFAULT_BIN_KEYSLOTID & 0x000000FF);
                                        iOffset += 1
                                        uchArrEncOut[iOffset] = (m_chPadChar & 0x000000FF);
                                        iOffset += 1
                                        uchArrEncOut[iOffset] = Byte(m_iPadStyle);
                                        uchArrEncOut[0..<bufferlen] = buffer[0..<bufferlen]
                                        iOffset += bufferlen;
                                        AddTLVDataWithTag(uiTag: HostTlvtag, Data: uchArrEncOut, length: iOffset);
                                    }
                                    else
                                    {
                                        AddTLVData(Data: buffer, length: bufferlen);
                                    }
                                }
                            }
                        }
                        
                        if (ExecutionResult._OK == retval)
                        {
                            AddAmountFromXmlinTlV();
                            SetCurrencyCodeInEMVModule();
                        }
                    }
                }
            }
        }
        
        reset();
        return retval;
    }
    
    public override func prepareTimer(time:Int)
    {
    }
    public override func startTimer()
    {
    }
    public override func cancelTimer()
    {
    }
    public override func onExecuted()
    {
    }
}
