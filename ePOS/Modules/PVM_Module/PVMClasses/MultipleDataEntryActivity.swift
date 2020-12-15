//
//  MultipleDataEntryActivity.swift
//  ePOS
//
//  Created by Vishal Rathore on 14/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class MultipleDataEntryActivity: CBaseNode {
    //global variable
    private var m_inputMethod:enum_InputMethod
    private var m_bIsUnicodeDisplayDataEntry: Bool             //Added abhishek for unicode
    private var m_iFontId: Int                                //Added abhishek for unicode (surbhi currently not applicable in landi pos )
    public var m_max_val: Int
    public var m_min_val: Int

    override init() {
        m_inputMethod = enum_InputMethod.NUMERIC_ENTRY
        m_max_val = 0
        m_min_val = 0
        m_bIsUnicodeDisplayDataEntry = false
        m_iFontId = 0
    }

    public override func AddPrivateParameters(tagAttribute: XMLATTRIBUTE, nTotal: Int) -> Int {

        let retVal = RetVal.RET_OK
        // Added for set Unicode flag and font id used in display unicode message
        if (tagAttribute.IsUTF8) {
            m_bIsUnicodeDisplayDataEntry = true
            m_iFontId = tagAttribute.fontId//used for unicode  currently not applicable for landi pos
        }

        m_max_val = Int(tagAttribute.MaxLen)
        m_min_val = Int(tagAttribute.MinLen)
        if let value = tagAttribute.InputMethod
        {
            m_inputMethod = value
        }
        
        pvmListParser = tagAttribute.pvmListParser


        // Added for copy on basis of unicode length
        if (m_bIsUnicodeDisplayDataEntry) {
            if (tagAttribute.DisplayMessagelen > 0) {
                DisplayMessage = tagAttribute.DisplayMessage
            }
        } else {
            DisplayMessage = tagAttribute.DisplayMessage
        }
        return retVal;
    }

    public override func prepareTimer(time: Int) {

    }

    public override func startTimer() {

    }

    public override func cancelTimer() {

    }

    public override func onExecuted() {

    }

    public override func execute() -> Int
    {
        let global = GlobalData.singleton
        var retval = getExecutionResult(iResult: iResult)
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
                            m_inputMethod = pvmListParser[i].InputMethod
                            m_max_val = pvmListParser[i].MaxLen
                            m_min_val = pvmListParser[i].MinLen
                            HostTlvtag = pvmListParser[i].HTL
                            buffer = m_valuelist[i].bytes
                            bufferlen = buffer.count
                            switch (m_inputMethod)
                            {
                            case enum_InputMethod.NUMERIC_ENTRY:
                                retval = getExecution_result_numeric(retval: &retval,global: global,buffer: buffer, bufferlen: bufferlen)
                            case enum_InputMethod.ALPHANUMERIC_ENTRY: fallthrough
                            default:
                                m_max_val = m_max_val > 38 ? 38 : m_max_val
                                if (ExecutionResult._OK == retval)
                                {
                                    bufferlen = buffer.count
                                    if ((m_iTleEnabled) && (GlobalData.singleton.m_sMasterParamData?.m_iUsePineEncryptionKeys != 0))
                                    {
                                        if (bufferlen > 0)
                                        {
                                            let objEncryption = CPineKeyInjection()
                                            _ = [Byte](repeating: 0, count:bufferlen + 14)
                                            if let uchArrEncOut = objEncryption.iFormatAndECBEncrypt(chArrInput: buffer, iInputLength: bufferlen, chPadChar: m_chPadChar, iPadType: m_iPadStyle, SlotID: AppConstant.DEFAULT_BIN_KEYSLOTID)
                                            {
                                                AddTLVDataWithTag(uiTag: HostTlvtag, Data: uchArrEncOut, length: uchArrEncOut.count)
                                            }
                                            else
                                            {
                                                retval = ExecutionResult._EXIT
                                            }
                                        }
                                        else
                                        {
                                            retval = ExecutionResult._EXIT
                                        }
                                    }
                                    else
                                    {
                                        if (m_iTleEnabled)
                                        {
                                            var uchArrEncOut = [Byte](repeating: 0, count:bufferlen + 14)
                                            var iOffset = 0;
                                            uchArrEncOut[iOffset] = 0 // TLE NOT USED
                                            iOffset += 1
                                            uchArrEncOut[iOffset] = Byte(AppConstant.DEFAULT_BIN_KEYSLOTID & 0x000000FF)
                                            iOffset += 1
                                            uchArrEncOut[iOffset] = (m_chPadChar & 0x000000FF)
                                            iOffset += 1
                                            uchArrEncOut[iOffset] = Byte(m_iPadStyle);
                                            uchArrEncOut[0..<bufferlen] = buffer[0..<bufferlen]
                                            iOffset += bufferlen
                                            AddTLVDataWithTag(uiTag: HostTlvtag, Data: uchArrEncOut, length: iOffset)
                                        }
                                        else
                                        {
                                            AddTLVData(Data: buffer, length: bufferlen)
                                        }
                                    }
                                }
                            }
                            
                            if (ExecutionResult._OK == retval)
                            {
                                AddAmountFromXmlinTlV()
                                SetCurrencyCodeInEMVModule()
                            }
                            
                        }
                    }
                    else
                    {
                        
                        buffer = iBuffer?.bytes ?? [0]
                        bufferlen = buffer.count
                        m_max_val = maxLen
                        switch (m_inputMethod) {
                        case enum_InputMethod.NUMERIC_ENTRY:
                            retval = getExecution_result_numeric(retval: &retval, global: global, buffer: buffer, bufferlen: bufferlen)
                        case enum_InputMethod.ALPHANUMERIC_ENTRY: fallthrough
                        default:
                            m_max_val = m_max_val > 38 ? 38 : m_max_val
                            if (ExecutionResult._OK == retval)
                            {
                                bufferlen = buffer.count;
                                if ((m_iTleEnabled) && (GlobalData.singleton.m_sMasterParamData?.m_iUsePineEncryptionKeys != 0))
                                {
                                    if (bufferlen > 0)
                                    {
                                        let objEncryption =  CPineKeyInjection()
                                        _ = [Byte](repeating: 0, count:bufferlen + 14)
                                        if let uchArrEncOut = objEncryption.iFormatAndECBEncrypt(chArrInput: buffer, iInputLength: bufferlen, chPadChar: m_chPadChar, iPadType: m_iPadStyle, SlotID: AppConstant.DEFAULT_BIN_KEYSLOTID)
                                        {
                                            AddTLVDataWithTag(uiTag: HostTlvtag, Data: uchArrEncOut, length: uchArrEncOut.count)
                                        }
                                        else
                                        {
                                            retval = ExecutionResult._EXIT
                                        }
                                    }
                                    else
                                    {
                                        retval = ExecutionResult._EXIT
                                    }
                                }
                                else
                                {
                                    if (m_iTleEnabled)
                                    {
                                        var uchArrEncOut = [Byte](repeating: 0, count: bufferlen + 14)
                                        var iOffset = 0
                                        uchArrEncOut[iOffset] = 0 // TLE NOT USED
                                        iOffset += 1
                                        uchArrEncOut[iOffset] = Byte(AppConstant.DEFAULT_BIN_KEYSLOTID & 0x000000FF)
                                        iOffset += 1
                                        uchArrEncOut[iOffset] = (m_chPadChar & 0x000000FF)
                                        iOffset += 1
                                        uchArrEncOut[iOffset] = Byte(m_iPadStyle)
                                        uchArrEncOut[0..<bufferlen] = buffer[0..<bufferlen]
                                        iOffset += bufferlen
                                        AddTLVDataWithTag(uiTag: HostTlvtag, Data: uchArrEncOut, length: iOffset)
                                    }
                                    else
                                    {
                                        AddTLVData(Data: buffer, length: bufferlen)
                                    }
                                }
                            }
                        }
                        
                        if (ExecutionResult._OK == retval)
                        {
                            AddAmountFromXmlinTlV()
                            SetCurrencyCodeInEMVModule()
                        }
                    }
                }
            }
        }
        
        reset()
        return retval
    }
    
    private func getExecution_result_numeric(retval: inout Int, global: GlobalData, buffer: [Byte], bufferlen: Int) -> Int {
        m_max_val = m_max_val > 54 ? 54 : m_max_val

        if (ExecutionResult._OK == retval) {
            if ((m_iTleEnabled) && (global.m_sMasterParamData!.m_iUsePineEncryptionKeys != 0)) {
                if (bufferlen > 0) {
                    let objEncryption = CPineKeyInjection()
                    var uchArrEncOut = [Byte](repeating: 0x00, count: bufferlen + 14)
                    uchArrEncOut = objEncryption.iFormatAndECBEncrypt(chArrInput: buffer, iInputLength: bufferlen, chPadChar: m_chPadChar, iPadType: m_iPadStyle, SlotID: AppConstant.DEFAULT_BIN_KEYSLOTID)!
                    if (uchArrEncOut != nil && !uchArrEncOut.isEmpty) {
                        AddTLVDataWithTag(uiTag: HostTlvtag, Data: uchArrEncOut, length: uchArrEncOut.count)
                    } else {
                    }
                } else {
                    retval = ExecutionResult._EXIT
                }
            } else {
                if (m_iTleEnabled) {
                    var uchArrEncOut = [Byte](repeating: 0x00, count: bufferlen + 14)
                    var iOffset = 0;

                    uchArrEncOut[iOffset] = 0 // TLE NOT USED
                    iOffset += 1
                    uchArrEncOut[iOffset] = Byte(AppConstant.DEFAULT_BIN_KEYSLOTID & 0x000000FF)
                    iOffset += 1
                    uchArrEncOut[iOffset] = Byte(m_chPadChar & 0x000000FF)
                    iOffset += 1
                    uchArrEncOut[iOffset] = Byte(m_iPadStyle)
                    iOffset += 1
                    uchArrEncOut[iOffset ..< iOffset + bufferlen] = buffer[0 ..< bufferlen]
                    
                    //System.arraycopy(buffer, 0, uchArrEncOut, iOffset, bufferlen)
                    iOffset += bufferlen;
                    AddTLVDataWithTag(uiTag: HostTlvtag, Data: uchArrEncOut, length: iOffset)
                } else {
                    AddTLVData(Data: buffer, length: bufferlen)
                }
            }
        }
        return retval
    }
}
