//
//  UserDetailsRequest.swift
//  ePOS
//
//  Created by Abhishek on 19/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
import Moya
// MARK:-Login Keys
public struct CheckUserKeys{
public var  QUERY_KEY1:String = "mobileNumber";
}

// MARK:- OTP Verify Keys
public struct OTPVerifyKeys:Codable{
var mobileNum:String?;
var otp:String?;
private enum CodingKeys: String, CodingKey {
    case mobileNum = "mobileNumber"
    case otp = "otp"
}
}

// MARK:- SignUp keys
public struct SignUpKeys:Codable{
var contactName:String?;
var contactNumber:String?
var email:String?;
var establishmentName:String?
var password:String?
var deviceInfo:DeviceInformationKeys?
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

public class IntialDataRequest:BaseRequest{
static func SignupRequest(signUpData:SignUpData,completion:@escaping CompletionHandler)
{
    BaseRequest.objMoyaApi.request(.getSignUpWith(signUpData:signUpData)) { result in
        switch result
        {
        case .success(let Response):
            break;
        case .failure(let failure):
            break;
        }
        
    }
}
static func CheckUserWith(mobileNumber:String,completion:@escaping CompletionHandler)
    {
        BaseRequest.objMoyaApi.request(.getCheckUserWith(mobileNumber: mobileNumber)) { result in
            switch result
            {
            case .success(let response):
                let CheckUserValues = try? BaseRequest.decoder.decode(CheckUserModel.self, from:response.data)
                print(response)
                completion(.success(CheckUserValues as Any));
                break;
            case .failure(let failure):
                completion(.failure(.failure));
                break;
            }
            
        }
    }
}
