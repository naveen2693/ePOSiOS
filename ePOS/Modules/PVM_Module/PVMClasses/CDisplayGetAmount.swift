//
//  CDisplayGetAmount.swift
//  ePOS
//
//  Created by Abhishek on 06/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
class CDisplayGetAmount: CBaseNode
{
    var  m_CurrencyName:String;
    var m_Decimals:Int;
    var  m_MaxLen:Int16;
    var  m_MinLen:Int16;
    var  m_bIsUnicodeDisplayGetAmount:Bool
    var m_iFontId:Int;
    var m_DisplayMessage:String;
    
    // MARK:-init
    public override init(){
        m_MaxLen = 0;
        m_MinLen = 0;
        m_Decimals = 0;
        m_bIsUnicodeDisplayGetAmount = false;
        m_iFontId = 0;
        m_CurrencyName = "";
        m_DisplayMessage = ""
    }
    
    // MARK:- AddPrivateParameters
    override func AddPrivateParameters(tagAttribute:XMLATTRIBUTE,nTotal:Int) -> Int
    {
        let retVal = RetVal.RET_OK;
        if (tagAttribute.IsUTF8)
        {
            m_bIsUnicodeDisplayGetAmount = true;
            m_iFontId = tagAttribute.fontId;
        }
        m_MaxLen = tagAttribute.MaxLen;
        m_MinLen = tagAttribute.MinLen;
        m_Decimals = Int(tagAttribute.Decimals);
        if (m_bIsUnicodeDisplayGetAmount)
        {
            if (tagAttribute.DisplayMessagelen > 0)
            {
                m_DisplayMessage = tagAttribute.DisplayMessage;
            }
        }
        else
        {
            m_DisplayMessage = tagAttribute.DisplayMessage;
        }
        m_CurrencyName = tagAttribute.CurrencyName;
        return retVal;
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
    
    override func execute() -> Int
    {
        let retVal = getExecutionResult(iResult: iResult);
        if (ExecutionResult._OK == retVal)
        {
            if let buffer = iBuffer
            {
                AddTLVData(Data: buffer.bytes, length: buffer.count);
            }
        }
        reset();
        return retVal;
    }
}
