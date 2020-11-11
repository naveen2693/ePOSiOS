//
//  CDisplayMessage.swift
//  ePOS
//
//  Created by Abhishek on 06/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
class CDisplayMessage : CBaseNode {

    public var m_bIsUnicodeDisplayMessage:Bool;  // Added abhishek for unicode
    public var m_iFontId:Int;                         // added abhishek for unicode
    public var isIdeFlagEnabled:Bool;

    public override init(){
        m_bIsUnicodeDisplayMessage = false;
        m_iFontId = 0;
        isIdeFlagEnabled = false;
    }

    override func AddPrivateParameters(tagAttribute:XMLATTRIBUTE,nTotal:Int) -> Int{

        if (tagAttribute.IsUTF8) {
            m_bIsUnicodeDisplayMessage = true;
            m_iFontId = tagAttribute.fontId;
        }

        // Added for copy on basis of unicode length
        if (m_bIsUnicodeDisplayMessage) {
            if (tagAttribute.DisplayMessagelen > 0) {
                DisplayMessage = tagAttribute.DisplayMessage;
            }
            if (tagAttribute.DisplayMessageLine2len > 0) {
                DisplayMessageLine2 = tagAttribute.DisplayMessageLine2;
            }
            if (tagAttribute.DisplayMessageLine3len > 0) {
                DisplayMessageLine3 = tagAttribute.DisplayMessageLine3;
            }
            if (tagAttribute.DisplayMessageLine4len > 0) {
                DisplayMessageLine4 = tagAttribute.DisplayMessageLine4;
            }
        } else {
            DisplayMessage      = tagAttribute.DisplayMessage;
            DisplayMessageLine2 = tagAttribute.DisplayMessageLine2;
            DisplayMessageLine3 = tagAttribute.DisplayMessageLine3;
            DisplayMessageLine4 = tagAttribute.DisplayMessageLine4;
        }
        isIdeFlagEnabled = tagAttribute.isIdeFlagEnabled;
        return RetVal.RET_OK;
    }

    func execute() -> Int {
        let retVal = getExecutionResult(iResult: iResult);
        if(retVal == ExecutionResult._OK) {
            // If amount is present in XML add to TLV node
            AddAmountFromXmlinTlV();
            // if currency code present in XML, set the value in EMV Module
            SetCurrencyCodeInEMVModule();
        }
        reset();
        return retVal;
    }

    public  override func prepareTimer(time :Int) {
        
    }
    public override func startTimer() {
        
    }
    
    
    public override func cancelTimer() {
        
    }
    
    
    public override func onExecuted() {
        
    }
}
