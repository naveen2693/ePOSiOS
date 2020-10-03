//
//  AdditionalItem.swift
//  ePOS
//
//  Created by Abhishek on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public struct AdditionalItem:Codable{
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
