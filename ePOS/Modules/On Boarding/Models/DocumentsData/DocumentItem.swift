//
//  DocumentItem.swift
//  ePOS
//
//  Created by Abhishek on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public struct DocumentItem:Codable{
    var comments :[Comment]?
    var codeType:String?
    var entityType:String?
    var description:String?
    var entityId:Int?
    var label:String?
    var parentId :Int?
    var noOfFiles:Int?
    var codeKey:String?
    var uiElement:Int?
    var sortOrder:Int?
    var tag:Int?
    var captureLocation:String?
    var id:Int?
    var docResources:[DocResource]?
    var isMandatory:String?
    var status:String?
    var isHiddenOnFullKyc:String?
    var optlock:Int?
    private enum CodingKeys: String, CodingKey {
        case comments = "comments"
        case codeType = "codeType"
        case entityType = "entityType"
        case description = "description"
        case entityId = "entityId"
        case label = "label"
        case parentId = "parentId"
        case noOfFiles = "noOfFiles"
        case uiElement = "uiElement"
        case sortOrder = "sortOrder"
        case tag = "tag"
        case captureLocation = "captureLocation"
        case id = "id"
        case docResources = "docResources"
        case isMandatory = "isMandatory"
        case optlock = "optlock"
        case status = "status"
        case isHiddenOnFullKyc = "isHiddenOnFullKyc"
    }
}
