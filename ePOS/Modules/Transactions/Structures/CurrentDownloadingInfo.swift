//
//  CurrentDownloadingInfo.swift
//  ePOS
//
//  Created by Vishal Rathore on 18/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct CurrentDownloadingInfo: Codable {
    var id: Int64 = 0
    var currentpacketCount: Int = 0
    var totalpacketCount: Int = 0
}
