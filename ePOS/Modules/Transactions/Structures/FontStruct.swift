//
//  FontStruct.swift
//  ePOS
//
//  Created by Abhishek on 13/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public struct Fontstruct:Codable {
    var id:Int64 = 0;
    var FontFileName:[UInt8] = [0];
}
