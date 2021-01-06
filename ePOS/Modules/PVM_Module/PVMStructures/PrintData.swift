//
//  PrintData.swift
//  ePOS
//
//  Created by Abhishek on 05/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct PrintData {
    var prd:String = ""
    
    public func getPrd() -> String {
        return prd
    }
    
    public mutating func setPrd(_ prd: String) {
        self.prd = prd
    }
}
