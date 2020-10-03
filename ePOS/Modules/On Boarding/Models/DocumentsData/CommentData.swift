//
//  CommentData.swift
//  ePOS
//
//  Created by Abhishek on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public struct Comment:Codable{
    var sortOrder:Int?
    var comment:String?
    var commentedBy:String?
    var optlock:Int?
    private enum CodingKeys: String, CodingKey {
        case sortOrder = "sortOrder"
        case comment = "comment"
        case commentedBy = "commentedBy"
        case optlock = "optlock"
    }
}
