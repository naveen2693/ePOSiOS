//
//  CDisplayQRcode.swift
//  ePOS
//
//  Created by Naveen Goyal on 14/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CDisplayQRCode:CBaseNode
{
    var isOfflineQrCode = false
    var isRunTimeQR = false
    var iHostCatID = -1
    
    public override func AddPrivateParameters(tagAttribute: XMLATTRIBUTE, nTotal: Int) -> Int {
        KEY_F1 = tagAttribute.KEY_F1
        isOfflineQrCode = tagAttribute.bIsOfflineQrCode
        isRunTimeQR = tagAttribute.bIsRunTimeQR
        iHostCatID = tagAttribute.iHostCatID
        return 0
    }
    
    
    public override func execute()->Int {
        debugPrint("Inside execute")

        var retVal = getExecutionResult(iResult:iResult)

        onOk = KEY_F1;
        var keySelected:Byte = 1
        var keySelectedTemp = [Byte](repeating: 0, count:2)
        keySelectedTemp[0] = keySelected;
        AddTLVData(Data: keySelectedTemp, length: 1)
        if(retVal == ExecutionResult._OK || retVal == ExecutionResult._TIMEOUT) {
            // If amount is present in XML add to TLV node
            AddAmountFromXmlinTlV()
            // if currency code present in XML, set the value in EMV Module
            SetCurrencyCodeInEMVModule()
        }
        reset()
        return retVal
    }
}
