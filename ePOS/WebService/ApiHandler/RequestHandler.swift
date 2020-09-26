//
//  RequestHandler.swift
//  ePOS
//
//  Created by Abhishek on 12/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public class RequestHandler{
    // MARK:-createWebServiceHeaderWithoutAccessToken
    internal static func  createWebServiceHeaderWithoutAccessToken() -> [String:String] {
        var headermap = [String:String]();
        let deviceId:String = "0000000089ABCDEF0123456789ABCDEF";
        let imeiNum:String = "000000123456789"
        let advertisingId:String = "0000000089ABCDEF0123456789ABCDEF"
        //let appUuid:String = "2b6f0cc904d137be2e1730235f5664094b831186"
        headermap[ApiHeaderKeys.requestHeaderClientKey.rawValue] = ClientRequestValues.requestHeaderClientValue.rawValue
        headermap[ApiHeaderKeys.requestHeaderBuildVersionKey.rawValue] = "1.0"// set build-version
        headermap[ApiHeaderKeys.requestClientTypeKey.rawValue] = ApiHeaderKeys.requestHeaderClientTypeValue.rawValue;
        if(!(deviceId.isEmpty)) {
            headermap[ApiHeaderKeys.requestHeaderDeviceKey.rawValue] = deviceId;
        }
        if(!imeiNum.isEmpty) {
            headermap[ApiHeaderKeys.requestHeaderImeiKey.rawValue] = imeiNum;
        }
        if(!advertisingId.isEmpty) {
            headermap[ApiHeaderKeys.requestHeaderAdvertisingKey.rawValue] = advertisingId;
        }
//        if(!appUuid.isEmpty) {
//            headermap[ApiHeaderKeys.requestHeaderUUIDKey.rawValue] = appUuid;
//        }
        print(headermap);
        return headermap;
    }
    // MARK:-createWebServiceHeaderWithAccessToken
    internal static func  createWebServiceHeaderWithAccessToken() -> [String:String]{
        var headermap =  [String:String]();
        let deviceId:String = "0000000089ABCDEF0123456789ABCDEF";
        let imeiNum:String = "000000123456789"
        let advertisingId:String = "0000000089ABCDEF0123456789ABCDEF"
        let appUuid:String = "59607063c22a4470b778aab4e28733f3"
        headermap[ApiHeaderKeys.requestHeaderClientKey.rawValue] = ClientRequestValues.requestHeaderClientValue.rawValue
        headermap[ApiHeaderKeys.requestHeaderBuildVersionKey.rawValue] = "1.0"// set build-version
        headermap[ApiHeaderKeys.requestClientTypeKey.rawValue] = ApiHeaderKeys.requestHeaderClientTypeValue.rawValue;
        headermap[ApiHeaderKeys.requestHeaderAccessTokenKey.rawValue] = "nt8qB55C7B5TTe9hhAYQY1QyAg1LBbH4";
        if(!(deviceId.isEmpty)) {
            headermap[ApiHeaderKeys.requestHeaderDeviceKey.rawValue] = deviceId;
        }
        if(!imeiNum.isEmpty) {
            headermap[ApiHeaderKeys.requestHeaderImeiKey.rawValue] = imeiNum;
        }
        if(!advertisingId.isEmpty) {
            headermap[ApiHeaderKeys.requestHeaderAdvertisingKey.rawValue] = advertisingId;
        }
        if(!appUuid.isEmpty) {
            headermap[ApiHeaderKeys.requestHeaderUUIDKey.rawValue] = appUuid;
        }
        return headermap;
    }
    
    // MARK:-createCheckUserReq
    public static func createCheckUserRequest(mobileNum:String) -> [String:String] {
        var dic = [String:String]();
        let userKey = CheckUserKeys()
        dic[userKey.QUERY_KEY1] = mobileNum;
        return dic;
    }
    
    // MARK:-createCheckUserReq
    public static func createOTPVerifyRequest(mobileNum:String,otp:String) -> OTPVerifyKeys{
        var request = OTPVerifyKeys();
        request.mobileNum=mobileNum
        request.otp=otp;
        return request;
    }
    
    // MARK:-createOTPSendReq
    public static func createOTPSendRequest(mobileNum:String) -> [String:String]{
        var  dic = [String:String]();
        let userKey = CheckUserKeys()
        dic[userKey.QUERY_KEY1] = mobileNum;
        return dic;
    }
    
    // MARK:-createForgotPwdReq
    public static func createForgotPasswordRequest(mobileNum:String) -> [String:String] {
        var dic = [String:String]();
        let userKey = CheckUserKeys()
        dic[userKey.QUERY_KEY1] = mobileNum;
        return dic
    }
    
    // MARK:-createConfigurationRequest
    public static func  createConfigurationRequest(globalChangeNumber:Int) -> ConfigurationKeys {
        var request =  ConfigurationKeys();
        request.globalChngeNumber = globalChangeNumber;
        return request;
    }
    
    // MARK:- createGetLeadIDRequest
    public static func  createGetLeadIDRequest(leadID:Int64) -> GetLeadIDKeys{
        var request = GetLeadIDKeys();
        request.id = leadID;
        return request;
    }
    
    // MARK:- createSignUpReq
    public static func createSignUpRequest(signUpData : SignUpData) -> SignUpKeys {
        var request = SignUpKeys();
        request.contactName = signUpData.contactName;
        request.contactNumber = signUpData.contactNumber;
        request.email = signUpData.email
        request.establishmentName = signUpData.establishmentName;
        request.password = signUpData.password;
        request.tncFlag = "YES"
        request.referralCode = signUpData.referralCode;
        request.deviceInfo.displayDensity = "";
        request.deviceInfo.deviceOS = "";
        request.deviceInfo.pushNotificationToken = "";
        request.deviceInfo.deviceType = "";
        request.deviceInfo.horizontalRes = "";
        request.deviceInfo.verticalRes = "";
        request.deviceInfo.manufacturerName = "";
        request.deviceInfo.deviceModel = "";
        return request;
    }
// MARK:- createLoginRequest
    static func createLoginRequest(mobileNumber:String,password:String) -> LoginKeys{
        var request =  LoginKeys();
           request.deviceInfo = nil;
            request.userLoginInfo?.mobileNumber = mobileNumber;
            request.userLoginInfo?.password = password
           return request;
       }
    
    // MARK:- ResetPasswordRequest
    static func createResetPasswordRequest(mobileNumber:String, otp:String,password:String) -> ResetPasswordKeys {
        var objResetPasswordKeys =  ResetPasswordKeys();
          objResetPasswordKeys.mobileNum = mobileNumber
          objResetPasswordKeys.otp = otp
          objResetPasswordKeys.newPassword = password
          return objResetPasswordKeys;
      }
    
    // MARK:- createMasterDataReq
    public static func createMasterDataRequest(mode:String) -> MasterDataKeys {
        var request = MasterDataKeys();
        request.mode = mode;
        return request;
    }
    
    // MARK:- createGetCityListRequest
    public static func createGetCityListRequest(strLastModifiedDate:String) -> CityListKeys{
        var getCityListRequest =  CityListKeys();
        getCityListRequest.lastModifiedDate = strLastModifiedDate;
        return getCityListRequest;
    }
    
    // MARK:- createUserListReq
    public static func createUserListRequest(params:ListSortParams) -> [String:Any] {
        var param = [String:Any]();
        let UserListRequest = UserListKeys()
        param[UserListRequest.QUERY_KEY1] = params.page;
        param[UserListRequest.QUERY_KEY2] = params.size;
        param[UserListRequest.QUERY_KEY3] = params.direction;
        param[UserListRequest.QUERY_KEY4] = params.sort;
        return param;
    }
    
}
