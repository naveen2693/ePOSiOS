//
//  RESET_RESPONSE.swift
//  ePOS
//
//  Created by Abhishek on 09/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct RESET_RESPONSE {
    var iIsZMKCompUnderPMK = 0;
    var iNumKeySlots = 0;
    var sZMKKeys = [ZMK_KEY](repeating: ZMK_KEY(), count:AppConstant.NUM_KEYSLOTS);
}
