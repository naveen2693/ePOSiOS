//
//  SecureData.swift
//  ePOS
//
//  Created by Abhishek on 09/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct SecureData:Codable {
   var iSlotID = 0;
    var strMasterKey:String = "";
   var strChecksum = "";
}
