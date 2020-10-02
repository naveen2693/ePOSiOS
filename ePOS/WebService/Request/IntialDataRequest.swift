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
    var deviceInfo = DeviceInformationKeys();
    var userLoginInfo = UserInfoKeys();
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
    var deviceInfo = DeviceInformationKeys()
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
// MARK:-IntialDataRequest
public class IntialDataRequest:BaseRequest{
    static func callApiSignupRequest(signUpData:SignUpData,completion:@escaping CompletionHandler)
    {
        
        guard NetworkState().isInternetAvailable else {
        completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        };
        BaseRequest.objMoyaApi.request(.getSignUpWith(signUpData:signUpData)) { result in
            switch result
            {
            case .success(let response):
                if let checkStatus = checkApiResponseStatus(responseData: response.data)
                {
                    if checkStatus.status == true
                    {
                        do {
                            let userData = try BaseRequest.decoder.decode(CompleteUserData.self, from:response.data) as CompleteUserData
                            EPOSUserDefaults.setProfile(profile: userData.profile)
                            EPOSUserDefaults.setUserId(userID: userData.uniqueUserID)
                            EPOSUserDefaults.setAccessToken(accessToken: userData.accessToken)
                            if let uuid = userData.profile.appUuid {
                                EPOSUserDefaults.setUuid(udid: uuid)
                            }
                            completion(.success(response))
                        } catch DecodingError.dataCorrupted(let context) {
                            debugPrint(context)
                        } catch DecodingError.keyNotFound(let key, let context) {
                            debugPrint("Key '\(key)' not found:", context.debugDescription)
                            debugPrint("codingPath:", context.codingPath)
                        } catch DecodingError.valueNotFound(let value, let context) {
                            debugPrint("Value '\(value)' not found:", context.debugDescription)
                            debugPrint("codingPath:", context.codingPath)
                        } catch DecodingError.typeMismatch(let type, let context)  {
                            debugPrint("Type '\(type)' mismatch:", context.debugDescription)
                            debugPrint("codingPath:", context.codingPath)
                        } catch {
                            debugPrint("error: ", error)
                        }
                    } else
                    {
                        completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                        
                    }
                    
                }
                
            case .failure(let error):
                completion(.failure(BaseError.errorMessage(error)));
                print(error);
                
            }
            
        }
    }
    // MARK:-checkUserWith
    static func checkUserWith(mobileNumber:String,completion:@escaping CompletionHandler)
    {
        
        guard NetworkState().isInternetAvailable else {
        completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        };
        BaseRequest.objMoyaApi.request(.getCheckUserWith(mobileNumber: mobileNumber)) { result in
            switch result
            {
            case .success(let response):
                if let checkStatus = checkApiResponseStatus(responseData: response.data)
                {
                    if checkStatus.status == true
                    {
                        
                        if let CheckUserValues = try? BaseRequest.decoder.decode(CheckUserModel.self, from:response.data)
                        {
                            completion(.success(CheckUserValues as AnyObject));
                        } else {
                            fatalError("checkusermodel was not created")
                        }
                    }else
                    {
                        completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                        
                    }
                }
            case .failure(let error):
                print(error)
                completion(.failure(BaseError.errorMessage(error)));
                
            }
            
        }
    }
    // MARK:-getConfigurationDataWith
    static func getConfigurationDataWith(globalChangeNumber:Int,completion:@escaping CompletionHandler)
    {
       guard NetworkState().isInternetAvailable else {
        completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        };
        BaseRequest.objMoyaApi.request(.getConfigurationsWith(globalChangeNumber:globalChangeNumber)){ result in
            switch result
            {
            case .success(let response):
                if let checkStatus = checkApiResponseStatus(responseData: response.data)
                {
                    if checkStatus.status == true
                    {
                        if let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] {
                            if let configResult = json["rs"] as? [AnyObject]
                            {
                                if let configContent = configResult[0] as? [String:Any]
                                {
                                    if let configContentValue = configContent["cnt"] as? [AnyObject]
                                    {
                                        if let Dicvalue = configContentValue[0] as? [String:Any]
                                        {
                                            for (key,value) in Dicvalue{
                                                if key == "confid"
                                                {
                                                    if value as? Int ==  ConstantsInt.eposConfigurationId.rawValue
                                                    {
                                                        let configJson = Dicvalue["json"] as? [String:Any]
                                                        let subConfiglist = configJson?["subConfList"] as? [AnyObject]
                                                        EPOSUserDefaults.setConfigurationData(configData: subConfiglist as AnyObject)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                    }
                }
            case .failure(let error):
                print(error);
                completion(.failure(BaseError.errorMessage(error)));
                
            }
            
        }
    }
    // MARK:-forgotPasswordCallApiWith
    static func forgotPasswordCallApiWith(mobileNumber:String,completion:@escaping CompletionHandler)
    {
        
        guard NetworkState().isInternetAvailable else {
        completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        };
        BaseRequest.objMoyaApi.request(.getForgotPasswordWith(mobileNumber:mobileNumber)){ result in
            switch result
            {
            case .success(let response):
                if let checkStatus = checkApiResponseStatus(responseData: response.data)
                {
                    if checkStatus.status == true
                    {
                        completion(.success(response))
                    } else
                    {
                        completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                        
                    }
                }
                
                
            case .failure(let error):
                print(error)
                completion(.failure(BaseError.errorMessage(error)));
                
            }
            
        }
    }
    // MARK:-resetPasswordCallApiwith
    static func resetPasswordCallApiwith(mobileNumber:String,otp:String,newPassword:String,completion:@escaping CompletionHandler)
    {
        guard NetworkState().isInternetAvailable else {
        completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        };
        
        BaseRequest.objMoyaApi.request(.resetPasswordWith(mobileNumber: mobileNumber, otp: otp, newPassword: newPassword)){ result in
            switch result
            {
            case .success(let response):
                if let checkStatus = checkApiResponseStatus(responseData: response.data)
                {
                    if checkStatus.status == true
                    {
                        completion(.success(response))
                    } else
                    {
                        completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                        
                    }
                }
            case .failure(let error):
                print(error)
                completion(.failure(BaseError.errorMessage(error)));
            }
            
        }
    }
    // MARK:- resendOtpCallApiWith
    static func resendOtpCallApiWith(mobileNumber:String,completion:@escaping CompletionHandler)
    {
        guard NetworkState().isInternetAvailable else {
        completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        };
        
        BaseRequest.objMoyaApi.request(.getSendOtpWith(mobileNumber: mobileNumber)){ result in
            switch result
            {
            case .success(let response):
                if let checkStatus = checkApiResponseStatus(responseData: response.data)
                {
                    if checkStatus.status == true
                    {
                        completion(.success(response))
                    } else
                    {
                        completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                        
                    }
                }
            case .failure(let error):
                completion(.failure(BaseError.errorMessage(error)));
                print(error)
                
            }
            
        }
    }
    static func callApiVerifyOtpWith(mobileNumber:String,otp:String,completion:@escaping CompletionHandler)
    {
        guard NetworkState().isInternetAvailable else {
        completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        };
        
        BaseRequest.objMoyaApi.request(.getVerifyOtpWith(mobileNumber: mobileNumber, otp: otp)){ result in
            switch result
            {
            case .success(let response):
                if let checkStatus = checkApiResponseStatus(responseData: response.data)
                {
                    if checkStatus.status == true
                    {
                        completion(.success(response))
                    } else
                    {
                        completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                        
                    }
                }
                
            case .failure(let error):
                completion(.failure(BaseError.errorMessage(error)));
                print(error)
                
            }
            
        }
    }
    // MARK:-callLoginApiAfterNumberVerfication Abhi123@
    static func callLoginApiAfterNumberVerfication(mobileNumber:String,password:String,completion:@escaping CompletionHandler)
    {
        guard NetworkState().isInternetAvailable else {
        completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        };
        
        BaseRequest.objMoyaApi.request(.getLoginWith(mobileNumber: mobileNumber, password: password)){ result in
            switch result
            {
            case .success(let response):
                if let checkStatus = checkApiResponseStatus(responseData: response.data)
                {
                    if checkStatus.status == true
                    {
                        do {
                            let userData = try BaseRequest.decoder.decode(CompleteUserData.self, from:response.data) as CompleteUserData
                            EPOSUserDefaults.setProfile(profile: userData.profile)
                            EPOSUserDefaults.setUserId(userID: userData.uniqueUserID)
                            EPOSUserDefaults.setAccessToken(accessToken: userData.accessToken)
                            if let uuid = userData.profile.appUuid {
                                EPOSUserDefaults.setUuid(udid: uuid)
                            }
                            completion(.success(response))
                        } catch DecodingError.dataCorrupted(let context) {
                            debugPrint(context)
                        } catch DecodingError.keyNotFound(let key, let context) {
                            debugPrint("Key '\(key)' not found:", context.debugDescription)
                            debugPrint("codingPath:", context.codingPath)
                        } catch DecodingError.valueNotFound(let value, let context) {
                            debugPrint("Value '\(value)' not found:", context.debugDescription)
                            debugPrint("codingPath:", context.codingPath)
                        } catch DecodingError.typeMismatch(let type, let context)  {
                            debugPrint("Type '\(type)' mismatch:", context.debugDescription)
                            debugPrint("codingPath:", context.codingPath)
                        } catch {
                            debugPrint("error: ", error)
                        }
                    }  else {
                        completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                        
                    }
                }
                
            case .failure(let error):
                completion(.failure(BaseError.errorMessage(error)));
                print(error);
                
            }
            
        }
    }
    
    
    
    
    
    
    
    
}
