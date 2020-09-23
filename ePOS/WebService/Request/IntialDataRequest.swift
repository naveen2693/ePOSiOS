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
// MARK:- ResetPassword Keys
public struct ResetPasswordKeys:Codable{
    var mobileNum:String?;
    var otp:String?;
    var newPassword:String?;
    private enum CodingKeys: String, CodingKey {
        case mobileNum = "mobileNumber"
        case otp = "otp"
        case newPassword = "newPassword"
    }
}
// MARK:- Login Keys
public struct LoginKeys:Codable{
    var deviceInfo:DeviceInformationKeys?;
    var userLoginInfo:UserInfoKeys?;
    private enum CodingKeys: String, CodingKey {
        case deviceInfo = "di"
        case userLoginInfo = "si"
        
    }
}

public struct UserInfoKeys:Codable{
    var mobileNumber:String?;
    var password:String?;
    private enum CodingKeys: String, CodingKey {
        case mobileNumber = "mobileNumber"
        case password = "pwd"
        
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
// MARK:-Configuration Field
public struct ConfigurationKeys : Codable{
    var globalChngeNumber:Int?;
    private enum CodingKeys: String, CodingKey {
        case globalChngeNumber = "glochngno"
    }
    
}

public class IntialDataRequest:BaseRequest{
    static func callApiSignupRequest(signUpData:SignUpData,completion:@escaping CompletionHandler)
    {
        BaseRequest.objMoyaApi.request(.getSignUpWith(signUpData:signUpData)) { result in
            switch result
            {
            case .success(let response):
                completion(.success(response))
                
            case .failure(let error):
                completion(.failure(.failure));
                print(error);
                
            }
            
        }
    }
    static func checkUserWith(mobileNumber:String,completion:@escaping CompletionHandler)
    {
        let logController = LoginController()
        BaseRequest.objMoyaApi.request(.getCheckUserWith(mobileNumber: mobileNumber)) { result in
            switch result
            {
            case .success(let response):
                let CheckUserValues = try? BaseRequest.decoder.decode(CheckUserModel.self, from:response.data)
                let response = CheckUserValues
                let UserExist:String = (response?.userExists)!
                if UserExist.elementsEqual(Boolean.yes.rawValue)
                {
                    if response?.UserData != nil
                    {
                        if let unwrappedAppUdid = response?.UserData?.appUuid {
                            EPOSUserDefaults.setUdid(udid:unwrappedAppUdid)
                        } else {
                            fatalError("Api failed.")
                        }
                    }
                    if ((response?.udfFields) != nil) && UdfFields.valUdfPositiveValue.rawValue.elementsEqual( (response?.udfFields![UdfFields.keyISFirstTimeLoginUser.rawValue])!)
                    {
                        logController.callApiOtpToCreateNewPasswordWith(mobileNumber: mobileNumber);
                    }
                    else {
                        logController.gotoPasswordVerificationController(mobileNumber: mobileNumber);
                    }
                }
                else {
                    if let unwrappedMobileVerified = response?.UserData?.mobileVerified {
                        if response?.UserData != nil && Boolean.yes.rawValue.elementsEqual(unwrappedMobileVerified) {
                            if let unwrappedAppUdid = response?.UserData?.appUuid {
                                EPOSUserDefaults.setUdid(udid:unwrappedAppUdid)
                            } else {
                                fatalError("Api failed.")
                            }
                            //if mobile verified go to sign up page
                            if let unwrappedUserData = response?.UserData {
                                logController.gotoSignUpController(mobileNumber: mobileNumber, userData: unwrappedUserData)
                            } else {
                                fatalError("Api failed.")
                            }
                            
                        } else {
                            //New user, ask for OTP
                            if let unwrappedUserData = response?.UserData {
                                logController.gotoOtpVerificationController(mobileNumber: mobileNumber, userData: unwrappedUserData)
                            } else {
                                fatalError("Api failed.")
                            }
                        }
                    } else {
                        fatalError("Api failed.")
                    }
                }
                completion(.success(CheckUserValues as AnyObject));
                
            case .failure(let error):
                print(error)
                completion(.failure(.failure));
                
            }
            
        }
    }
    
    static func getConfigurationDataWith(globalChangeNumber:Int,completion:@escaping CompletionHandler)
    {
        BaseRequest.objMoyaApi.request(.getConfigurationsWith(globalChangeNumber:globalChangeNumber)){ result in
            switch result
            {
            case .success(let response):
                print(response);
                completion(.success(response))
                
            case .failure(let error):
                print(error);
                completion(.failure(.failure));
                
            }
            
        }
    }
    static func forgotPasswordCallApiWith(mobileNumber:String,completion:@escaping CompletionHandler)
    {
        BaseRequest.objMoyaApi.request(.getForgotPasswordWith(mobileNumber:mobileNumber)){ result in
            switch result
            {
            case .success(let response):
                print(response);
                completion(.success(response))
                
            case .failure(let error):
                print(error)
                completion(.failure(.failure));
                
            }
            
        }
    }
    
    static func resetPasswordCallApiwith(mobileNumber:String,otp:String,newPassword:String,completion:@escaping CompletionHandler)
    {
        BaseRequest.objMoyaApi.request(.resetPasswordWith(mobileNumber: mobileNumber, otp: otp, newPassword: newPassword)){ result in
            switch result
            {
            case .success(let response):
                print(response);
                completion(.success(response))
            case .failure(let error):
                print(error)
                completion(.failure(.failure));
            }
            
        }
    }
    
    static func resendOtpCallApiWith(mobileNumber:String,completion:@escaping CompletionHandler)
    {
        BaseRequest.objMoyaApi.request(.getSendOtpWith(mobileNumber: mobileNumber)){ result in
            switch result
            {
            case .success(let response):
                print(response);
                completion(.success(response))
                
            case .failure(let error):
                completion(.failure(.failure));
                print(error)
                
            }
            
        }
    }
    
    static func callLoginApiAfterNumberVerfication(mobileNumber:String,password:String,completion:@escaping CompletionHandler)
    {
        BaseRequest.objMoyaApi.request(.getLoginWith(mobileNumber: mobileNumber, password: password)){ result in
            switch result
            {
            case .success(let response):
              
                guard let jsonObject: Any = try? JSONSerialization.jsonObject(with: response.data, options: []) as Any,
                    let jsonData = jsonObject as? [String:Any],
                    let accessToken = jsonData["acstkn"] as? String,
                    let profile  = jsonData["acstkn"] as? String,
                    let userProfileData = jsonData["profile"] as? [String: Any],
                    let appUdid =  userProfileData["acstkn"] as? String,
                    let userId = jsonData["acstkn"] as? String
                    else
                {
                    fatalError("Serialization Error")
                }
                EPOSUserDefaults.setProfile(profile: profile)
                EPOSUserDefaults.setUserId(userID: userId)
                EPOSUserDefaults.setUdid(udid: appUdid)
                EPOSUserDefaults.setAccessToken(accessToken: accessToken)
                completion(.success(response))
                
            case .failure(let error):
                completion(.failure(.failure));
                print(error);
                
            }
            
        }
    }
}
