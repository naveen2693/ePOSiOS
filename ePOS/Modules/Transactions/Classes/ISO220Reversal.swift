//
//  ISO220Reversal.swift
//  ePOS
//
//  Created by Vishal Rathore on 25/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CISO220Reversal: CISO220
{
    
    override func SetTransactionRequestData()
    {
        do {
            debugPrint("SetOnlineTransactionReversalRequestData")

            self.vFnSetTerminalActivationFlag(bTerminalActivationFlag: false)
            /*    ***************************************************************************
                   FEILD 3 ::Processing Code
             ***************************************************************************/
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_ONLINE_REVERSAL_REQ_PCAKET.utf8), bcd: true)

            /*    ***************************************************************************
                  FEILD 11 ::ROC
             ***************************************************************************/

            let strROC = "\(String(describing: m_ulCurrentRoc!))"
            let strROCTemp = TransactionUtils.StrLeftPad(data: strROC, length: 4, padChar: "0")
            debugPrint("SetOnlineTransactionRequestData::ROC#: \(strROCTemp)")
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_11, data1: [Byte](strROCTemp.utf8), bcd: true)

            /*    ***************************************************************************
                  FEILD 26 ::BatchId
             ***************************************************************************/

            let strBatchID = "\(String(describing: m_ulBatchId!))"
            let strBatchIDTemp = TransactionUtils.StrLeftPad(data: strBatchID, length: 6, padChar: "0")
            debugPrint("SetOnlineTransactionRequestData::BatchId#: \(strBatchIDTemp)")
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_26, data1: [Byte](strBatchIDTemp.utf8), bcd: true)
        }
        catch
        {
            debugPrint("Exception Occurred : \(error)")
        }
    }
    
    public override func GetTransactionResponse() -> Bool
    {
        do {
            debugPrint("GetOnlineTransactionReversalResponse")
            if (false == IsOK()) {
                debugPrint("REVERSAL FAILED")
                return false
            }
            debugPrint("REVERSAL DONE")
            return true
        }
        catch
        {
            debugPrint("Exception Occurred : \(error)")
            return false
        }
    }
    
    public override func AfterDataExchange() -> Int
    {
        debugPrint("CISO220Reversal::Inside method AfterDataExchange")
        let iRetVal: Int = CISO220.ClearReversal()
        if(iRetVal == AppConstant.TRUE) {
            return AppConstant.TRUE
        }
        else {
            return AppConstant.FALSE
        }
    }
    
}
