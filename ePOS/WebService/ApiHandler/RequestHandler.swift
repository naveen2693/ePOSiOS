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
private static func  createWebServiceHeaderWithoutAccessToken()->Dictionary<String,String> {
    var headermap = Dictionary<String, String>();
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
private static func  createWebServiceHeaderWithAccessToken()->Dictionary<String,String>{
    var headermap = Dictionary<String, String>();
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
public static func createCheckUserReq(mobileNum:String)->CheckUserRequest {
    let checkUserRequest = CheckUserRequest();
    checkUserRequest.headerMap = createWebServiceHeaderWithoutAccessToken();
    var dic = Dictionary<String, String>();
    dic[Constants.QUERY_KEY1] = mobileNum;
    checkUserRequest.queryMap = dic;
    return checkUserRequest;
}
    
// MARK:-createCheckUserReq
public static func createOTPVerifyReq(mobileNum:String,otp:String)-> OTPVerifyRequest{
    let request = OTPVerifyRequest();
    request.headerMap = createWebServiceHeaderWithoutAccessToken();
    request.mobileNum=mobileNum
    request.otp=otp;
    return request;
}
    
// MARK:-createOTPSendReq
public static func createOTPSendReq(mobileNum:String)->BaseRequest{
    let sendOtpRequest = BaseRequest();
    sendOtpRequest.headerMap = createWebServiceHeaderWithoutAccessToken();
    var  dic = Dictionary<String,String>();
    dic[Constants.QUERY_KEY1] = mobileNum;
    sendOtpRequest.queryMap = dic;
    return sendOtpRequest;
}
    
// MARK:-createForgotPwdReq
public static func createForgotPwdReq(mobileNum:String)->BaseRequest {
    let sendOtpRequest = BaseRequest();
    sendOtpRequest.headerMap = createWebServiceHeaderWithoutAccessToken();
    var dic = Dictionary<String,String>();
    dic[Constants.QUERY_KEY1] = mobileNum;
    sendOtpRequest.queryMap = dic;
    return sendOtpRequest;
}

}
