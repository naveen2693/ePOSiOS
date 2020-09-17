//
//  OTPVerifyRequest.swift
//  ePOS
//
//  Created by Abhishek on 13/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public struct OTPVerifyRequest:Codable{
    var mobileNum:String = "";
    var otp:String="";
    
    private enum CodingKeys: String, CodingKey {
           case mobileNum = "mobileNumber"
           case otp = "otp"
       }
    
}
