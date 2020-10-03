//
//  DocResources.swift
//  ePOS
//
//  Created by Abhishek on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public struct DocResource:Codable{
    var resourceId:String?
    var comment:String?
    var filename:String?
    var id:Int?
    var status:String?
    private enum CodingKeys: String, CodingKey {
        case resourceId = "resourceId"
        case comment = "comment"
        case filename = "filename"
        case status = "status"
        case id = "id"
    }
}
