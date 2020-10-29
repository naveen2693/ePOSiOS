//
//  CurrentEDCAppDownloadingInfo.swift
//  ePOS
//
//  Created by Vishal Rathore on 20/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct CurrentEDCAppDownloadingInfo: Codable {

    var chVersion = [Byte](repeating: 0, count: AppConstant.MAX_APP_VERSION_LEN)
    var currentpacketCount: Int = 0
    var totalpacketCount: Int = 0
    
}
