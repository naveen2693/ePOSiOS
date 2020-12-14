//
//  CDisplayEventReceived.swift
//  ePOS
//
//  Created by Vishal Rathore on 11/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CDisplayEventReceived: CBaseNode {
    
    private var EventOfNode: Byte
    private var HardwareMaskReceived: Int
    private var KeyReceived: Byte

    private var m_bIsUnicodeDisplayEventReceived: Bool               //Added abhishek for unicode
    private var m_iFontId: Int                                        //Added abhishek for unicode

    private var multipleCardGrpId: Int

    var Statemachine = CStateMachine.stateMachine

    public override init() {
        EventOfNode = 0
        HardwareMaskReceived = 0
        KeyReceived = 0
        m_bIsUnicodeDisplayEventReceived = false
        m_iFontId = 0
        multipleCardGrpId = 1
        super.init()
        DisplayMessage = ""
    }

    public override func AddPrivateParameters(tagAttribute: XMLATTRIBUTE, nTotal: Int) -> Int {
        let retVal = RetVal.RET_OK;

        if (tagAttribute.IsUTF8) {
            m_bIsUnicodeDisplayEventReceived = true;
            m_iFontId = tagAttribute.fontId;
        }

        onOk = PvmNodeActions.gotoChild;
        onCancel = PvmNodeActions.gotoRoot;
        onExit = PvmNodeActions.gotoRoot;
        EventOfNode = tagAttribute.EventMask;

        // Added for copy on basis of unicode length
        if (m_bIsUnicodeDisplayEventReceived) {
            if (tagAttribute.DisplayMessagelen > 0) {
                DisplayMessage = tagAttribute.DisplayMessage;
            }
        } else {
            DisplayMessage = tagAttribute.DisplayMessage;
        }

        if (tagAttribute.multipleCardPinGrpId != 0) {
            multipleCardGrpId = tagAttribute.multipleCardPinGrpId;
        } else {
            multipleCardGrpId = 1;
        }

        return retVal;
    }

    public override func execute() -> Int {
        debugPrint("Inside execute")
        let retVal = getExecutionResult(iResult: iResult)
        if(retVal == ExecutionResult._OK) {
            let m_CardBundle = m_bundle
            if (m_CardBundle != nil) {
                /*var objTrackParser = CTrackParser()
                var iRet: Int = objTrackParser.handleSwipeEvent(m_CardBundle, m_chPadChar, m_iPadStyle, HostTlvtag, m_iTleEnabled)
                if (iRet != AppConstant.TRUE) {
                    retVal = ExecutionResult._EXIT
                }*/
            }
            m_bundle = nil
            // If amount is present in XML add to TLV node
            AddAmountFromXmlinTlV()
            // if currency code present in XML, set the value in EMV Module
            SetCurrencyCodeInEMVModule()
        }
        reset()
        return retVal
    }

    public override func GetEventMask() -> Byte
    {
        return EventOfNode
    }

    public override func SetHardwareMask(HardWareMask: Int) -> Bool {
        HardwareMaskReceived = HardWareMask
        return true
    }

    public override func prepareTimer(time: Int) {

    }

    public override func startTimer() {

    }

    public override func cancelTimer() {

    }

    public override func onExecuted() {

    }
    
}
