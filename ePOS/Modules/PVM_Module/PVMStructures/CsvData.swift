//
//  CsvData.swift
//  ePOS
//
//  Created by Abhishek on 05/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct CsvData {
    var bPrintingFlag = false;
    var bsendData = false;
    var bCSVreceived = false;
    var m_chBillingCSVData = [Byte](repeating: 0x00, count: AppConstant.MAX_CSV_LEN)
    var m_HostTxnType: Int = 0
    var bStatus: Byte = 0x00

    mutating func reset()
    {
        bPrintingFlag = false;
        bsendData = false;
        bCSVreceived = false;
        
        m_chBillingCSVData = [Byte](repeating: 0x00, count: AppConstant.MAX_CSV_LEN)
        m_HostTxnType = 0
        bStatus = Byte(0x00)
    }
    
    //var TlvData =  TxnTLVData();
}
