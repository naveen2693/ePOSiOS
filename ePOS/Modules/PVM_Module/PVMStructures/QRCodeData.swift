//
//  QRCodeData.swift
//  ePOS
//
//  Created by Abhishek on 04/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct QRCodeData{
    
    var index = 0;
    var qc = ""
    
    public func getQc() -> String{
         return qc
     }

    public mutating func setIndex(_ index: Int) {
         self.index = index
     }
    
    public func getIndex() -> Int{
         return index
     }

    public mutating func setQc(_ qc: String) {
         self.qc = qc
     }
    
    
}
