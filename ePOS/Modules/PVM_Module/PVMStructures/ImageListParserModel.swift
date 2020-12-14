//
//  ImageListParserModel.swift
//  ePOS
//
//  Created by Abhishek on 04/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct ImageListParserModel {
    var tagName = ""
    var tagValue = ""
    
    public func getTagName() -> String {
        return tagName;
    }

    public mutating func setTagName(_ tagName: String) {
        self.tagName = tagName
    }

    public func getTagValue() -> String {
        return tagValue
    }

    public mutating func setTagValue(_ tagValue: String) {
        self.tagValue = tagValue;
    }
}
