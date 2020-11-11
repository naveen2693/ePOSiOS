//
//  PvmNodeActions.swift
//  ePOS
//
//  Created by Abhishek on 04/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
enum PvmNodeActions {
   static let invalid     = 0;
   static let gotoChild   = 1;
   static let goBack      = 2;
   static let gotoRoot    = 3;
   static let goOnline    = 4;
   static let exitPvm     = 5;
}
