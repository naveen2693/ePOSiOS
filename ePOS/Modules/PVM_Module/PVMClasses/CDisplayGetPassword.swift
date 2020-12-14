//
//  CDisplayGetPassword.swift
//  ePOS
//
//  Created by Vishal Rathore on 10/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CDisplayGetPassword: CBaseNode {
    
    var m_inputMethod:enum_InputMethod
    var MaxLen:Int64
    var MinLen:Int64
    var m_bIsUnicodeDisplayGetPassword:Bool
    var m_iFontId:Int
    
    override init() {
        m_inputMethod = enum_InputMethod.NUMERIC_ENTRY;
        MaxLen = 0
        MinLen = 0
        m_bIsUnicodeDisplayGetPassword = false
        m_iFontId = 0
        
        super.init()
        DisplayMessage = ""
    }

    public override func AddPrivateParameters(tagAttribute: XMLATTRIBUTE, nTotal: Int) -> Int {
        let retVal: Int = RetVal.RET_OK;
        if (tagAttribute.IsUTF8) {
            m_bIsUnicodeDisplayGetPassword = true;
            m_iFontId = tagAttribute.fontId;
        }

        MaxLen = Int64(tagAttribute.MaxLen)
        MinLen = Int64(tagAttribute.MinLen)
        
        if tagAttribute.InputMethod != nil
        {
            m_inputMethod = InputMethod!
        }
        
        // Added for copy on basis of unicode length
        if (m_bIsUnicodeDisplayGetPassword) {
            if (tagAttribute.DisplayMessagelen > 0) {
                DisplayMessage = tagAttribute.DisplayMessage;
            }
        } else {
            DisplayMessage = tagAttribute.DisplayMessage;
        }
        return retVal
    }

    public override func prepareTimer(time: Int) {

    }

    public override func startTimer() {

    }

    public override func cancelTimer() {

    }

    public override func onExecuted() {

    }

    public override func execute() -> Int {
        debugPrint("Inside execute")
        let retVal: Int = getExecutionResult(iResult: iResult)

        if(ExecutionResult._OK == retVal) {
            var szPin = [Byte]()
            var pinLen: Int
            
            if let buffer = iBuffer {
                szPin = buffer.bytes
            }
            pinLen = szPin.count
            //Add TLV data
            AddTLVData(Data: szPin,length: pinLen);
            //If amount is present in XML add to TLV node
            AddAmountFromXmlinTlV();
            //if currency code present in XML, set the value in EMV Module
            SetCurrencyCodeInEMVModule();
        }
        return retVal;
    }
}
