//
//  SignUpRequest.swift
//  ePOS
//
//  Created by Abhishek on 17/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public struct SignUpRequest:Codable{
    var contactName:String?;
    var contactNumber:String?
    var email:String?;
    var establishmentName:String?
    var password:String?
    var deviceInfo:DeviceInformationModel?
    var tncFlag:String?
    var referralCode:String?
    
    private enum CodingKeys: String, CodingKey {
           case contactName = "contactName"
           case contactNumber = "contactNumber"
           case email = "email"
           case establishmentName = "establishmentName"
           case password = "password"
           case deviceInfo = "di"
           case tncFlag = "tncFlag"
           case referralCode = "referralCode"
       }
    
}
