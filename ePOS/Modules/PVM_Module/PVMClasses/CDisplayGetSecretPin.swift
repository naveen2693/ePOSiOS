//
//  CDisplayGetSecretPin.swift
//  ePOS
//
//  Created by Vishal Rathore on 14/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CDisplayGetSecretPin: CBaseNode {

    var m_iKeySlot: Int
    var m_bIsUnicodeDisplayGetSecretPin: Bool               //Added abhishek for unicode
    var m_iFontId: Int                                //Added abhishek for unicode
    var SessionKey = [Byte](repeating: 0x00, count: 50)
    var useHtlForTag: Bool
    public var multiplePinGrpId: Int
    var AscPinBlock: [Byte]?
    var AscPinBlock_temp: [Byte]?

    override init(){
        multiplePinGrpId = 0
        m_bIsUnicodeDisplayGetSecretPin = false
        m_iKeySlot = 0
        m_iFontId = 0
        useHtlForTag = false
    }
    
    internal override func AddPrivateParameters(tagAttribute: XMLATTRIBUTE, nTotal: Int) -> Int
    {
        let retVal = RetVal.RET_OK
        //System.arraycopy(tagAttribute.SessionKey, 0, SessionKey, 0, tagAttribute.SessionKey.length);
        //memcpy(SessionKey,tagAttribute->SessionKey,strlen((char *)tagAttribute->SessionKey));
        if(SessionKey.count == 16){}
        //m_bAlgoType = TLV_TYPE_KDES;
        if(SessionKey.count == 32){}
        //m_bAlgoType = TLV_TYPE_KTDES;

        m_iKeySlot = tagAttribute.iKeySlot
        onCancel = PvmNodeActions.exitPvm

        //Added for set Unicode flag and font id used in display unicode message
        if(tagAttribute.IsUTF8)
        {
            m_bIsUnicodeDisplayGetSecretPin = true
            m_iFontId                  = tagAttribute.fontId
        }

        //Added for copy on basis of unicode length
        if(m_bIsUnicodeDisplayGetSecretPin)
        {
            if (tagAttribute.DisplayMessagelen > 0)
            {
                //System.arraycopy(tagAttribute.DisplayMessage, 0, DisplayMessage, 0, tagAttribute.DisplayMessagelen);
                //memcpy(DisplayMessage,tagAttribute->DisplayMessage,tagAttribute->DisplayMessagelen);
            }
        }
        else
        {
            //System.arraycopy(tagAttribute.DisplayMessage, 0, DisplayMessage, 0, tagAttribute.DisplayMessage.length());
            //memcpy(DisplayMessage,tagAttribute->DisplayMessage,strlen(tagAttribute->DisplayMessage));
        }
        useHtlForTag = tagAttribute.useHtlForTag;
        if(tagAttribute.multipleCardPinGrpId != 0)
        {
            multiplePinGrpId = tagAttribute.multipleCardPinGrpId;
        }
        else
        {
            multiplePinGrpId = 1
        }
        return retVal
    }

    internal override func execute() -> Int
    {
        debugPrint("Inside execute");
        let ret = getExecutionResult(iResult: iResult)
        if(ret == ExecutionResult._OK) {
            
            if let val = AscPinBlock_temp{
                AscPinBlock = val
                AscPinBlock_temp = nil
            }
            
            let strDefaultKeyslotID: String = TransactionUtils.ByteArrayToHexString([Byte]("\(AppConstant.DEFAULT_BIN_KEYSLOTID)".utf8))!
            let strPinBlockHSM: String = strDefaultKeyslotID + "\(String(describing: AscPinBlock))"

            if (!useHtlForTag) {
                AddTLVDataWithTag(uiTag: FixedHostTags.TAG_TYPE_PINE_KEY_ENCRYPTED_PIN_BLOCK, Data: [Byte](strPinBlockHSM.utf8), length: strPinBlockHSM.count)
            } else {
                AddTLVDataWithTag(uiTag: HostTlvtag, Data: AscPinBlock!, length: AscPinBlock!.count)
            }
            //If amount is present in XML add to TLV node
            AddAmountFromXmlinTlV()
            //if currency code present in XML, set the value in EMV Module
            SetCurrencyCodeInEMVModule()
        }
        reset()
        return ret
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
