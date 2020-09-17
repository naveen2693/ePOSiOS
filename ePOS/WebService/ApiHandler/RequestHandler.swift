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
    let deviceId:String = "";
    let imeiNum:String = ""
    let advertisingId:String = ""
    let appUuid:String = ""
    headermap[Constants.REQUEST_HEADER_CLIENT_ID_KEY] = Constants.REQUEST_HEADER_CLIENT_ID
    headermap[Constants.REQUEST_HEADER_BUILD_VERSION_KEY] = "1.0"// set build-version
    headermap[Constants.REQUEST_HEADER_CLIENT_TYPE_KEY] = Constants.REQUEST_HEADER_CLIENT_TYPE_VALUE;
    if(!(deviceId.isEmpty)) {
        headermap[Constants.REQUEST_HEADER_DEVICE_ID_KEY] = deviceId;
    }
    if(!imeiNum.isEmpty) {
        headermap[Constants.REQUEST_HEADER_IMEI_KEY] = imeiNum;
    }
    if(!advertisingId.isEmpty) {
        headermap[Constants.REQUEST_HEADER_ADVERTISING_ID_KEY] = advertisingId;
    }
    if(!appUuid.isEmpty) {
        headermap[Constants.REQUEST_HEADER_UUID_KEY] = appUuid;
    }
    return headermap;
}
    
// MARK:-createWebServiceHeaderWithAccessToken
internal static func  createWebServiceHeaderWithAccessToken() -> [String:String]{
    var headermap =  [String:String]();
    let deviceId:String = "";
    let imeiNum:String = ""
    let advertisingId:String = ""
    let appUuid:String = ""
    headermap[Constants.REQUEST_HEADER_CLIENT_ID_KEY] = Constants.REQUEST_HEADER_CLIENT_ID
    headermap[Constants.REQUEST_HEADER_BUILD_VERSION_KEY] = "1.0"// set build-version
    headermap[Constants.REQUEST_HEADER_CLIENT_TYPE_KEY] = Constants.REQUEST_HEADER_CLIENT_TYPE_VALUE;
    headermap[Constants.REQUEST_HEADER_ACCESS_TOKEN_ID_KEY] = Constants.KEY_SP_ACCESS_TOKEN;
    if(!(deviceId.isEmpty)) {
        headermap[Constants.REQUEST_HEADER_DEVICE_ID_KEY] = deviceId;
    }
    if(!imeiNum.isEmpty) {
        headermap[Constants.REQUEST_HEADER_IMEI_KEY] = imeiNum;
    }
    if(!advertisingId.isEmpty) {
        headermap[Constants.REQUEST_HEADER_ADVERTISING_ID_KEY] = advertisingId;
    }
    if(!appUuid.isEmpty) {
        headermap[Constants.REQUEST_HEADER_UUID_KEY] = appUuid;
    }
    return headermap;
}

// MARK:-createCheckUserReq
    public static func createCheckUserRequest(mobileNum:String) -> [String:String] {
    var dic = [String:String]();
    dic[Constants.QUERY_KEY1] = mobileNum;
    return dic;
}

// MARK:-createCheckUserReq
public static func createOTPVerifyRequest(mobileNum:String,otp:String) -> OTPVerifyRequest{
    var request = OTPVerifyRequest();
    request.mobileNum=mobileNum
    request.otp=otp;
    return request;
}

// MARK:-createOTPSendReq
  public static func createOTPSendRequest(mobileNum:String) -> [String:String]{
    var  dic = [String:String]();
    dic[Constants.QUERY_KEY1] = mobileNum;
    return dic;
}

// MARK:-createForgotPwdReq
    public static func createForgotPasswordRequest(mobileNum:String) -> [String:String] {
    var dic = [String:String]();
    dic[Constants.QUERY_KEY1] = mobileNum;
    return dic
}
    
// MARK:-createConfigurationRequest
public static func  createConfigurationRequest(globalChngNum:Int) -> ConfigurationRequest {
    var request =  ConfigurationRequest();
    request.glochngno = globalChngNum;
    return request;
}
    
// MARK:- createGetLeadIDRequest
public static func  createGetLeadIDRequest(leadID:Int64) -> GetLeadIDRequest{
    var request = GetLeadIDRequest();
    request.id = leadID;
    return request;
}
    
// MARK:- createSignUpReq
public static func createSignUpRequest(registrationData : UserRegistrationDataModel) -> SignUpRequest {
    var request = SignUpRequest();
    request.contactName = registrationData.getContactName();
    request.contactNumber = registrationData.getContactNumber();
    request.email = registrationData.getEmail();
    request.establishmentName = registrationData.getEstablishmentName();
    request.password = registrationData.getPassword();
    request.tncFlag = Constants.YES;
    request.referralCode = registrationData.getReferralCode();
    // request.deviceInfo = deviceInfo;
    return request;
}
    
// MARK:- createMasterDataReq
public static func createMasterDataRequest(mode:String) -> MasterDataRequest {
    var request = MasterDataRequest();
    request.mode = mode;
    return request;
}
    
// MARK:- createGetCityListRequest
public static func createGetCityListRequest(strLastModifiedDate:String) -> CityListRequest{
    var getCityListRequest =  CityListRequest();
    getCityListRequest.lastModifiedDate = strLastModifiedDate;
    return getCityListRequest;
}
    
// MARK:- createUserListReq
    public static func createUserListRequest(params:ListSortParamsModel) -> [String:String] {
    var param = [String:String]();
    param[UserListRequest.QUERY_KEY1] = String(params.getPage());
    param[UserListRequest.QUERY_KEY2] = String(params.getSize());
    param[UserListRequest.QUERY_KEY3] = String(params.getDirection());
    param[UserListRequest.QUERY_KEY4] = params.getSort();
    return param;
}

}
