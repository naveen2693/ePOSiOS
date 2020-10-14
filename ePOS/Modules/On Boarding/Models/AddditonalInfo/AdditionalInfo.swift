//
//  AdditionalInfo.swift
//  ePOS
//
//  Created by Abhishek on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
// MARK:-Additional Info Keys
public struct AdditionalInfo:Codable{
    var value:String?
    var key:String?
    private enum CodingKeys: String, CodingKey {
        case value = "value"
        case key = "key"
    }
}
