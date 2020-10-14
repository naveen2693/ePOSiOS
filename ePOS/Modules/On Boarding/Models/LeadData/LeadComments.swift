//
//  LeadComments.swift
//  ePOS
//
//  Created by Abhishek on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
// MARK:-Lead comments 
public struct LeadComments:Codable{
    var sortOrder:Int?
    var comment:String?
    var commentedBy:String?
    private enum CodingKeys: String, CodingKey {
        case sortOrder = "sortOrder"
        case comment = "comment"
        case commentedBy = "commentedBy"
    }
}
