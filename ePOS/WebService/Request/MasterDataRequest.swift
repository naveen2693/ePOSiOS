//
//  MasterDataRequest.swift
//  ePOS
//
//  Created by Abhishek on 17/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public struct MasterDataRequest : Codable{
    var mode:String?;
    
    private enum CodingKeys: String, CodingKey {
           case mode = "mode"
       }
    
}
