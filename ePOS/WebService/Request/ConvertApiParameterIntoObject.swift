//
//  ConvertRequestParameterIntoObject.swift
//  ePOS
//
//  Created by Abhishek on 20/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
// MARK:-SignUpData
public struct SignUpData{
    public var contactName:String?;
    public var email:String?;
    public var establishmentName:String?;
    public var password:String?;
    public var referralCode:String?;
    public var contactNumber:String?;
}
// MARK:-ListSortParamsModel
public struct ListSortParams{
    public var direction:String?;
    public var page:Int?
    public var size:Int?;
    public var sort:String?
}
