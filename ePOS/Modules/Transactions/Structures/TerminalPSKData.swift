//
//  TerminalPSKData.swift
//  ePOS
//
//  Created by Abhishek on 14/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct TerminalPSKData:Codable {
 var iNumKeySlots = 0;

}
struct TerminalPSKDataValues{
 var stPSK = [StPSK?](repeatElement(nil,
 count: 8))
mutating func TerminalPSKData()
{
    for i in 0...8
    {
        stPSK[i] = StPSK();
    }
}
}
