//
//  TerminalTransactionData.swift
//  ePOS
//
//  Created by Abhishek on 05/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct TerminalTransactionData: Codable {
    var ulBatchId:Int64 = 0         //indicates current batch id
    var ulROC:Int64 = 0              //indicates ROC
    var uiTransactionType:Int = 0 //indicates the tag id of the last menu in the flow after which there was no menu to choose.
    var bIsOnline = false //did transaction go online or was executed offline
    var bIsReversalPending = false // on going first time online, until answer has come this flag will be set to true, after having got the answer set this to false
    var bIsTransactionReversed = false  //to indicate that this transaction was actually reversed.
    var chArrTxDateTime = "" //the time which indicates as to when transaction got saved in this file before going online.
    var iDrOffset = 0        //starting offset of DR data for this transaction in DRFile
    var iDRLength = 0        //length of data in DR file starting from DROffset. The length is same as the offset
    var bIsSignatureCapturedForTransaction = false
    var bIsSignUploaded = false//Amitesh :: to mark if signature uploaded or not
    var uiCSVTransactionType = 0
    var uiAmount = ""
    var status = 0

}
