//
//  DeviceInformationModel.swift
//  ePOS
//
//  Created by Abhishek on 17/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
class DeviceInformationModel:Codable{
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
