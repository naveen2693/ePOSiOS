//
//  ISO320PineKeyExchangeChangeNumberConstants.swift
//  ePOS
//
//  Created by Naveen Goyal on 05/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
enum ISO320PineKeyExchangeChangeNum :Int
{
    case START_SESSION = 1
    case RESETKEY_REQ = 2
    case RENEWKEY_REQ = 3
    case END_SESSION = 4
}
