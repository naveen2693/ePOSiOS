//
//  CDisplayConfirmationNewDialog.swift
//  ePOS
//
//  Created by Vishal Rathore on 14/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CDisplayConfirmationNewDialog: CBaseNode {

    private var m_bIsUnicodeDisplayConfirmation: Bool // Added abhishek for unicode
    private var m_iFontId: Int                              // Added abhishek for unicode
    private var m_sel_index: Int
    private var numMenuItems: Int

    override init() {
        m_bIsUnicodeDisplayConfirmation = false
        m_iFontId = 0
        numMenuItems = 0
        m_sel_index = 0
    }
    
    public override func GotoChild() -> CBaseNode? {
        return GotoChild(index: m_sel_index)!
    }

    public override func prepareTimer(time: Int) {

    }

    public override func startTimer() {

    }

    public override func cancelTimer() {

    }

    public override func onExecuted() {

    }

    public override func GotoChild(index: Int) -> CBaseNode? {
        if (nil == Child) {
            return nil
        } else {
            return (Child!.gotoindexedChild(gIndex: index))
        }
    }

    public override func AddPrivateParameters(tagAttribute: XMLATTRIBUTE, nTotal: Int) -> Int {
        let retVal = RetVal.RET_OK
        DisplayMessage = tagAttribute.DisplayMessage;
        if (tagAttribute.IsUTF8) {
            m_bIsUnicodeDisplayConfirmation = true;
            m_iFontId = tagAttribute.fontId;
        }

        return retVal
    }

    public override func execute() -> Int {
        debugPrint("Inside execute");
        let retVal = getExecutionResult(iResult: iResult)
        m_sel_index = iPos + 1;
        if(retVal == ExecutionResult._OK) {
            // if Item is selected correctly set the Host tag in TLV structure
            let bSelIndex: [Byte] = [Byte](String(m_sel_index).trimmingCharacters(in: .whitespacesAndNewlines).utf8)
            AddTLVData(Data: bSelIndex, length: bSelIndex.count);
            // If amount is present in XML add to TLV node
            AddAmountFromXmlinTlV()
            // if currency code present in XML, set the value in EMV Module
            SetCurrencyCodeInEMVModule()
        }
        reset()
        return retVal
    }
}
