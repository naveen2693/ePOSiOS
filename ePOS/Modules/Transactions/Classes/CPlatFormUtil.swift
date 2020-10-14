//
//  CPlatFormUtil.swift
//  ePOS
//
//  Created by Abhishek on 13/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public class CPlatFormUtils{
    
public static func getLast8DigitOfIMEINumber() -> String {
    var last8DigitIMEI = "";
    
    if let IMEI = GlobalData.sharedInstance.getFullSerialNumber()
    {
     last8DigitIMEI =  IMEI.substring(from: (IMEI.count - 8),to: IMEI.count)
    }
    
    return last8DigitIMEI;
}
}
