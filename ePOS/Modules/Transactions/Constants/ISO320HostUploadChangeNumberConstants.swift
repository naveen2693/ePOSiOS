//
//  ISO320HostUploadChangeNumberConstants.swift
//  ePOS
//
//  Created by Naveen Goyal on 05/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

enum ISO320HostUploadChangeNum
{
     static let SERIAL_UPLOAD_PACKET = 1;
     static let GPRS_UPLOAD_PACKET = 2;
     static let ETHERNET_UPLOAD_PACKET = 3;
     static let TERMINAL_PARAM_UPLOAD_PACKET = 4;
     static let MASTER_PARAM_UPLOAD_PACKET = 5;
     static let AUTOSETTLE_UPLOAD_PACKET = 6;
}
