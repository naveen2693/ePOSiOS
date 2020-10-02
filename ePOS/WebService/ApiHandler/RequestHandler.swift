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
        let deviceId:String = Util.getUUID()
        let imeiNum:String = "000000123456712"
        let advertisingId:String = Util.getUUID()
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
        debugPrint("HEADER ====  Nooooo ==== AccessToken:: \(headermap)");
        return headermap;
    }
    // MARK:-createWebServiceHeaderWithAccessToken
    internal static func  createWebServiceHeaderWithAccessToken() -> [String:String]{
        var headermap =  [String:String]();
        let deviceId:String = Util.getUUID()
        let imeiNum:String = "000000123456712"
        let advertisingId:String = Util.getUUID()
        var appUuid:String = ""
        if let uuid = EPOSUserDefaults.getUuid() {
            appUuid = uuid
        }
        
        headermap[ApiHeaderKeys.requestHeaderClientKey.rawValue] = ClientRequestValues.requestHeaderClientValue.rawValue
        headermap[ApiHeaderKeys.requestHeaderBuildVersionKey.rawValue] = "1.0"// set build-version
        headermap[ApiHeaderKeys.requestClientTypeKey.rawValue] = ApiHeaderKeys.requestHeaderClientTypeValue.rawValue;
        headermap[ApiHeaderKeys.requestHeaderAccessTokenKey.rawValue] = EPOSUserDefaults.getAccessToken()
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
        debugPrint("HEADER  ====  AccessToken:: \(headermap)");
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
    public static func  createGetLeadIDRequest(leadID:Int) -> GetLeadIDKeys{
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
        request.deviceInfo.displayDensity = "";
        request.deviceInfo.deviceOS = "";
        request.deviceInfo.pushNotificationToken = "";
        request.deviceInfo.deviceType = "";
        request.deviceInfo.horizontalRes = "";
        request.deviceInfo.verticalRes = "";
        request.deviceInfo.manufacturerName = "";
        request.deviceInfo.deviceModel = "";
        request.userLoginInfo.mobileNumber = mobileNumber;
        request.userLoginInfo.password = password
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
    
    // MARK:- gst details
    public static func createGstDetailRequest(number:String) -> [String:String] {
        var dict = [String:String]();
        let keys = GstDetailKeys()
        dict[keys.QUERY_KEY1] = number;
        return dict;
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
    
    // MARK:- Merchant verification service request
    public static func createMerchantVerificationRequest(proofName:String,proofNumber:String,additionalInfo:[String:String]) -> MerchantVerficationKeys{
        var getMerchantVerficationKeys =  MerchantVerficationKeys();
        getMerchantVerficationKeys.proofId = proofNumber
        getMerchantVerficationKeys.additionalInfo = additionalInfo
        getMerchantVerficationKeys.proofName = proofName
        return getMerchantVerficationKeys;
    }
    
    
}
