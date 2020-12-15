//
//  CDisplayGifVideo.swift
//  ePOS
//
//  Created by Vishal Rathore on 14/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CDisplayGifVideo: CBaseNode {

    internal override func execute() -> Int {
        let retVal = getExecutionResult(iResult: iResult)
        if(retVal == ExecutionResult._OK || retVal == ExecutionResult._TIMEOUT) {
            // If amount is present in XML add to TLV node
            AddAmountFromXmlinTlV()
            // if currency code present in XML, set the value in EMV Module
            SetCurrencyCodeInEMVModule()
        }
        reset()
        return retVal
    }

    internal override func AddPrivateParameters(tagAttribute: XMLATTRIBUTE, nTotal: Int) -> Int {
        return RetVal.RET_OK
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
