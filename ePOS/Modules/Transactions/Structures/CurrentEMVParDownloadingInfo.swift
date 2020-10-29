//
//  CurrentEMVParDownloadingInfo.swift
//  ePOS
//
//  Created by Vishal Rathore on 25/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct CurrentEMVParDownloadingInfo: Codable {
    
    var chVersion = [Byte](repeating: 0x00, count: 13)
    var currentpacketCount: Int
    var totalpacketCount: Int
    
}
