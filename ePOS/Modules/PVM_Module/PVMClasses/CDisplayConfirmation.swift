//
//  CDisplayConfirmation.swift
//  ePOS
//
//  Created by Vishal Rathore on 10/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CDisplayConfirmation: CBaseNode{
    private var m_bIsUnicodeDisplayConfirmation: Bool // Added abhishek for unicode
    private var m_iFontId: Int                              // Added abhishek for unicode
    static var key: Byte = 0x00

    override init() {
        m_bIsUnicodeDisplayConfirmation = false
        m_iFontId = 0
        super.init()
        KEY_F1 = PvmNodeActions.gotoRoot
        KEY_F2 = PvmNodeActions.gotoRoot
        KEY_F3 = PvmNodeActions.gotoRoot
        KEY_F4 = PvmNodeActions.gotoRoot
        KEY_ENTER = PvmNodeActions.gotoRoot
        KEY_CANCEL = PvmNodeActions.gotoRoot
        
        
        KeyF1 = ""
        KeyF2 = ""
        KeyF3 = ""
        KeyF4 = ""
        DisplayMessage = ""
        DisplayMessageLine2 = ""
        DisplayMessageLine3 = ""
        DisplayMessageLine4 = ""
    }

    public override func AddPrivateParameters(tagAttribute: XMLATTRIBUTE, nTotal: Int) -> Int {
        let retVal: Int = RetVal.RET_OK
        if (tagAttribute.IsUTF8) {
            m_bIsUnicodeDisplayConfirmation = true
            m_iFontId = tagAttribute.fontId
        }

        KEY_F1 = tagAttribute.KEY_F1
        KEY_F2 = tagAttribute.KEY_F2
        KEY_F3 = tagAttribute.KEY_F3
        KEY_F4 = tagAttribute.KEY_F4
        KEY_ENTER = KEY_F1             // tagAttribute.KEY_ENTER;
        KEY_CANCEL = PvmNodeActions.exitPvm     // tagAttribute.KEY_CANCEL;

        KeyF1 = tagAttribute.KeyF1
        KeyF2 = tagAttribute.KeyF2
        KeyF3 = tagAttribute.KeyF3
        KeyF4 = tagAttribute.KeyF4
        onCancel = tagAttribute.onCancel
        //Added for copy on basis of unicode length
        if(m_bIsUnicodeDisplayConfirmation)
        {
            if (tagAttribute.DisplayMessagelen > 0) {
                DisplayMessage = tagAttribute.DisplayMessage
            }
            if (tagAttribute.DisplayMessageLine2len > 0) {
                DisplayMessageLine2 = tagAttribute.DisplayMessageLine2
            }
            if (tagAttribute.DisplayMessageLine3len > 0) {
                DisplayMessageLine3 = tagAttribute.DisplayMessageLine3
            }
            if (tagAttribute.DisplayMessageLine4len > 0) {
                DisplayMessageLine4 = tagAttribute.DisplayMessageLine4
            }
        }
        else {
            DisplayMessage = tagAttribute.DisplayMessage
            DisplayMessageLine2 = tagAttribute.DisplayMessageLine2
            DisplayMessageLine3 = tagAttribute.DisplayMessageLine3
            DisplayMessageLine4 = tagAttribute.DisplayMessageLine4
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
        debugPrint("Inside execute");
        var retVal: Int = ExecutionResult._OK
        var keySelected: Byte = "7".bytes[0]
        
        var key: Byte = 0x00
        if iBuffer != nil
        {
            key = iBuffer!.bytes[0]
        }
        
        switch (key) {
            case AppConstant.T_SK1:
                retVal = keyAction(KEY: KEY_F1)
                onOk = KEY_F1
                keySelected = "1".bytes[0]
            case AppConstant.T_SKHAUT:
                retVal = ExecutionResult._OK
                onOk = KEY_F3;
                keySelected = "3".bytes[0]
            case AppConstant.T_SKBAS:
                retVal = ExecutionResult._OK
                onOk = KEY_F2;
                keySelected = "2".bytes[0]
            case AppConstant.T_SK4:
                retVal = keyAction(KEY: KEY_F4)
//                retVal = ExecutionResult._OK
                onOk = KEY_F4
                keySelected = "4".bytes[0]
            case AppConstant.T_VAL:
                retVal = ExecutionResult._OK;
                onOk = KEY_ENTER;
                keySelected = "5".bytes[0]
            case "T".bytes[0]:
                retVal = ExecutionResult._TIMEOUT
                keySelected = "7".bytes[0]
            case "B".bytes[0]:
                retVal = backPressAction()
                keySelected = "6".bytes[0]//back press
            case AppConstant.T_ANN:
                break
            default:
                retVal = ExecutionResult._OK
                onOk = KEY_CANCEL
                keySelected = "6".bytes[0]
        }

        var keySelectedTemp = [Byte](repeating: 0x00, count: 2)
        keySelectedTemp[0] = keySelected
        AddTLVData(Data: keySelectedTemp, length: 1)

        if (ExecutionResult._OK == retVal) {
            // If amount is present in XML add to TLV node
            AddAmountFromXmlinTlV()
            // if currency code present in XML, set the value in EMV Module
            SetCurrencyCodeInEMVModule()
        }
        
        reset()
        return retVal
    }

    private func keyAction(KEY: Int) -> Int {
        if (KEY == PvmNodeActions.gotoChild){
            return ExecutionResult._OK;
        } else if (KEY == PvmNodeActions.goBack){
            return ExecutionResult._CANCEL;
        } else if (KEY == PvmNodeActions.gotoRoot){
            return ExecutionResult._EXIT;
        } else if (KEY == PvmNodeActions.goOnline){
            return ExecutionResult._OK;
        }else{
            return ExecutionResult._EXIT;
        }
    }

    private func backPressAction() -> Int {
        if (onCancel == PvmNodeActions.gotoChild) {
            return ExecutionResult._OK;
        } else if (onCancel == PvmNodeActions.goBack) {
            return ExecutionResult._CANCEL;
        } else if (onCancel == PvmNodeActions.gotoRoot) {
            return ExecutionResult._EXIT;
        } else if (onCancel == PvmNodeActions.goOnline) {
            return ExecutionResult._OK;
        } else {
            return ExecutionResult._EXIT;
        }
    }
}
