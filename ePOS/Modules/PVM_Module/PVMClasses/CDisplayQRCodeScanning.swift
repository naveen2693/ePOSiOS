//
//  CDisplayQRCodeScanning.swift
//  ePOS
//
//  Created by Naveen Goyal on 14/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CDisplayQRCodeScanning: CBaseNode
{
    override init() {
        super.init()
    }
    
    public override func execute() -> Int {
           debugPrint("Inside execute")
           var retVal = getExecutionResult(iResult: iResult)
           if(retVal == ExecutionResult._OK) {
            
           var buffer:[Byte]?
            
            guard let scannedItems:[String] = iBuffer != nil ? (iBuffer?.split(separator: ",").map{String($0)}): [String](repeating:"", count: qrcodescanningListParser.count) else {return ExecutionResult._CANCEL}
            
            for i in 0..<qrcodescanningListParser.count
            {
                InputMethod = qrcodescanningListParser[i].getInputMethod()
                HostTlvtag = qrcodescanningListParser[i].getHTL()
                
                if(scannedItems[i].count > 0)
                {
                    buffer = [Byte](scannedItems[i].utf8)
                }
                
            
                switch(InputMethod)
                {
                case .NUMERIC_ENTRY:
                      //TODO check for EPOS using PineKKeyInjection
                      break
                case .ALPHANUMERIC_ENTRY:
                      break
                case .none:
                      break
                }
                if (ExecutionResult._OK == retVal) {
                      // If amount is present in XML add to TLV node
                      AddAmountFromXmlinTlV()
                      //if currency code present in XML, set the value in EMV Module
                      SetCurrencyCodeInEMVModule()
                }
           }
        }
           return retVal;
    }
    
    public override func AddPrivateParameters(tagAttribute: XMLATTRIBUTE, nTotal: Int) -> Int {
                let retVal = RetVal.RET_OK
                return retVal
    }

}
