//
//  EMVTxnType.swift
//  ePOS
//
//  Created by Abhishek on 06/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
enum  EMVTxnType {
   static let NOT_EMV:Int =  0x00;     //Not an EMV TXn
   static let ONLINE_AUTH :Int =  0x01;     //ONLINE AUTH
   static let OFFLINE_UPLOAD :Int =  0x02;     //OFFLINE FINAL RESPONSE
   static let ONLINE_UPLOAD:Int =  0x03;     //FINAL RESPONSE AFTER ONLINE AUTH
   static let FALLBACK:Int =  0x04;     //FALLBACK
   static let ADDITONAL_DATA :Int = 0x05;     //Request to get Additional info
}
