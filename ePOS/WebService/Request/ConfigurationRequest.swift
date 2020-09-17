//
//  ConfigurationRequest.swift
//  ePOS
//
//  Created by Abhishek on 17/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public struct ConfigurationRequest : Codable{
    var glochngno:Int?;
    
    private enum CodingKeys: String, CodingKey {
           case glochngno = "glochngno"
       }
    
}
