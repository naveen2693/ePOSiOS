//
//  CDisplayWait.swift
//  ePOS
//
//  Created by Vishal Rathore on 10/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CDisplayWait: CBaseNode {
    private var EventOfNode: Byte
    //xml view
    //global variable
    private var m_EventMask: Byte
    // Added for extended event mask
    private var m_bIsExtendedEventMask: Bool
    private var m_ExtendedEventMask = [Byte](repeating: 0x00, count: 3)
    private var m_bIsUnicodeDisplayWait: Bool // Added abhishek for unicode
    private var m_iFontId: Int                      // Added abhishek for unicode
    private var m_EventReceived: Byte
    private var m_HardwareMaskReceived: Int
    private var m_sel_index: Int
    //static variable
    public static var iBuffer: String?
    public static var iResult: Int = -1
    public static var iPos: Int = -1
    public static var m_iRetVal: Int = ExecutionResult._EXIT;
    var timeOut: Int

    public override func onExecuted() {
        if(iResult == CStateMachine.GO)
        {
            CDisplayWait.m_iRetVal = ExecutionResult._OK;
        }
        else if(iResult == CStateMachine.CANCEL)
        {
            CDisplayWait.m_iRetVal = ExecutionResult._CANCEL;
        }
        else if(iResult == CStateMachine.TIME_OUT)
        {
            CDisplayWait.m_iRetVal = ExecutionResult._TIMEOUT;
        }
        else if(iResult == CStateMachine.BACK_PRESSED)
        {
            CDisplayWait.m_iRetVal = ExecutionResult._EXIT;
        }

        TransactionHUB.singleton.sendMessage(DisplayRequestType.RESPONSE_FOR_CDISPLAYWAIT_ACTIVITY,CStateMachine.GO,timeOut,iBuffer as NSObject?) //Here third arguments is for timeout of waitforevent
    }

    override init() {
        m_EventMask = 0x00
        m_bIsExtendedEventMask = false
        m_EventReceived = 0
        m_HardwareMaskReceived = 0
        m_bIsUnicodeDisplayWait = false
        m_iFontId = 0
        EventOfNode = m_EventMask
        m_sel_index = 0
        timeOut = 0
        
        super.init()
        DisplayMessage = ""
        DisplayMessageLine2 = ""
        DisplayMessageLine3 = ""
        DisplayMessageLine4 = ""
    }

    public override func AddPrivateParameters(tagAttribute: XMLATTRIBUTE, nTotal: Int) -> Int {
        let retVal = RetVal.RET_OK;
        EventOfNode = tagAttribute.EventMask;

        // Added for set Unicode flag and font id used in display unicode message
        if (tagAttribute.IsUTF8) {
            m_bIsUnicodeDisplayWait = true;
            m_iFontId = tagAttribute.fontId;
        }

        m_EventMask = tagAttribute.EventMask;
        if (tagAttribute.IsExtendedEventMask) {
            m_bIsExtendedEventMask = true;
            m_ExtendedEventMask = [Byte](tagAttribute.ExtendedEventMask[0 ..< 2])
            //System.arraycopy(tagAttribute.ExtendedEventMask, 0, m_ExtendedEventMask, 0, 2);
        } else {
            m_bIsExtendedEventMask = false;
        }

        // Added for copy on basis of unicode length
        if (m_bIsUnicodeDisplayWait) {
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
            DisplayMessage = tagAttribute.DisplayMessage
            DisplayMessageLine2 = tagAttribute.DisplayMessageLine2
            DisplayMessageLine3 = tagAttribute.DisplayMessageLine3
            DisplayMessageLine4 = tagAttribute.DisplayMessageLine4
        }

        return retVal
    }

    public override func execute() -> Int {

        let retVal = CDisplayWait.m_iRetVal
        CDisplayWait.m_iRetVal = ExecutionResult._EXIT
        if(retVal == ExecutionResult._OK) {
            m_sel_index = iPos + 1;
            AddAmountFromXmlinTlV();
            // if currency code present in XML, set the value in EMV Module
            SetCurrencyCodeInEMVModule();
        }
        return retVal
    }

    public override func GotoChild() -> CBaseNode? {
        return GotoChild(index: m_sel_index)
    }

    public override func GotoChild(index: Int) -> CBaseNode? {
        do {
            if (nil == Child) {
                return nil
            } else {
                return (Child?.gotoindexedChild(gIndex: index))
            }
        }catch {
            debugPrint("Exception Occurred : \(error)")
            return nil
        }
    }

    public override func GetEventMask() -> Byte
    {
        return EventOfNode
    }

    public override func prepareTimer(time: Int) {

    }

    public override func startTimer() {

    }

    public override func cancelTimer() {

    }
}
