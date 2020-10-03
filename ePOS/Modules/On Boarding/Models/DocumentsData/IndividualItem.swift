//
//  IndividualItem.swift
//  ePOS
//
//  Created by Abhishek on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public struct IndividualItem:Codable{
    var sectionName:String?
    var comments:[String]?
    var docs:[IndividualDocs]?
    var id:Int?
    private enum CodingKeys: String, CodingKey {
        case sectionName = "sectionName"
        case comments = "comments"
        case docs = "docs"
        case id = "id"
    }
}

public struct IndividualDocs:Codable{
    var comments:String?
    var docs:[DocumentItem]?
    var sectionName:String?
    var id:Int?
    private enum CodingKeys: String, CodingKey {
        case comments = "comments"
        case docs = "docs"
        case sectionName = "sectionName"
        case id = "id"
    }
}
