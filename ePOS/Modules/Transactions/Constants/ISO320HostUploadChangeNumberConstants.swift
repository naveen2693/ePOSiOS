//
//  ISO320HostUploadChangeNumberConstants.swift
//  ePOS
//
//  Created by Naveen Goyal on 05/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

enum ISO320HostUploadChangeNum : Int
{
    case SERIAL_UPLOAD_PACKET           = 1;
    case GPRS_UPLOAD_PACKET             = 2;
    case ETHERNET_UPLOAD_PACKET         = 3;
    case TERMINAL_PARAM_UPLOAD_PACKET   = 4;
    case MASTER_PARAM_UPLOAD_PACKET     = 5;
    case AUTOSETTLE_UPLOAD_PACKET       = 6;
}
