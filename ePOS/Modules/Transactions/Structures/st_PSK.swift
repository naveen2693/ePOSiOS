//
//  st_PSK.swift
//  ePOS
//
//  Created by Abhishek on 14/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct StPSK: Codable {
    var iKeySlotID = 0 ;

    var uchArrPSKPin:[Byte] = [0] ;
    var uchArrKCVPSKPin:[Byte] = [0] ;

    var uchArrPSKTLE:[Byte] = [0] ;
    var uchArrKCVPSKTLE:[Byte] = [0] ;
}
