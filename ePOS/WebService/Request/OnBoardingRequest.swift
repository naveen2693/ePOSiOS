//
//  OnBoardingRequest.swift
//  ePOS
//
//  Created by Abhishek on 19/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

// MARK:- LeadCode Keys
public struct GetLeadIDKeys:Codable{
    var id:Int64?;
}

// MARK:-UserList Keys
public struct UserListKeys{
    let QUERY_KEY1:String = "page";
    let QUERY_KEY2:String = "size";
    let QUERY_KEY3:String = "dir";
    let QUERY_KEY4:String = "sort";
}

// MARK:-CityListKeys
public struct CityListKeys:Codable{
    var lastModifiedDate:String?;
    private enum CodingKeys: String, CodingKey {
        case lastModifiedDate = "mdafter"
    }
}

// MARK:- Master Data Keys
public struct MasterDataKeys:Codable{
    var mode:String?;
}
//MARK:-DeviceInformationKeys
struct DeviceInformationKeys:Codable{
    var displayDensity:String?;
    var deviceOS:String?
    var pushNotificationToken:String?;
    var deviceType:String?
    var horizontalRes:String?
    var verticalRes:String?
    var manufacturerName:String?
    var deviceModel:String?
    private enum CodingKeys: String, CodingKey {
        case displayDensity = "displayDensity"
        case deviceOS = "dos"
        case pushNotificationToken = "dtoken"
        case deviceType = "dtype"
        case horizontalRes = "hres"
        case verticalRes = "vres"
        case manufacturerName = "manfctrnm"
        case deviceModel = "model"
        
    }
}

public class OnBoardingRequest{
    
}
