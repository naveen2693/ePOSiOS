//
//  Constants.swift
//  ePOS
//
//  Created by Abhishek on 11/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//
import Foundation
// MARK:-API URL EndPoints
enum ApiEndpointsUrl{
    
    enum ConfigurationApiEndPointsUrl:String
    {
        case configurationUrl = "/rest/configuration/list";
    }
    
    enum UserDetailsApiEndpointUrl:String{
        case checkUser = "/rest/authentication/epos/checkUser";
        case verifyOtpUrl = "/rest/authentication/epos/verify";
        case loginUrl = "/rest/authentication/epos/login";
        case signUpUrl = "/rest/authentication/epos/register";
        case sendOtpUrl = "/rest/authentication/epos/sendOTP";
        case forgetPasswordUrl = "/rest/authentication/epos/forgotPassword";
        case resetPasswordUrl = "/rest/authentication/epos/resetPassword";
    }
    enum OnboardingApiEndpointUrl: String
    {
        case getProfileUrl = "/rest/data/epos/getProfile";
        case masterDataUrl = "/rest/data/epos/masterData/getMasterDataV1";
        case getCityList = "/rest/data/epos/city/getCityListV5"
        case fetchUserList = "/rest/data/epos/merchant/fetchUser";
        case getLeadId = "/rest/data/epos/lead/{lead_id}";
        
    }
}
    enum ApiHeaderKeys:String{
    case requestHeaderClientKey = "X-app-clnt-id";
        case requestHeaderDeviceKey = "X-dev-id";
        case requestHeaderAccessTokenKey = "X-acs-tkn";
        case requestHeaderBuildVersionKey = "X-bld-ver";
        case requestHeaderImeiKey = "X-imei-num";
        case requestClientTypeKey = "X-dev-clnt";
        case requestHeaderAdvertisingKey = "X-dev-adv-id";
        case requestHeaderUUIDKey = "X-app-uuid";
        case requestHeaderContentTypeKey = "Content-Type";
        case requestDeviceTypeKey = "MOBILE";
        case requuestOsKey = "android_";
        case requestHeaderClientTypeValue = "APP";
        case requestHeaderContentTypeValue = "multipart/form-data";
    }

enum ClientRequestValues :String
{
    case requestHeaderClientValue = "oaFxIR0VEh8yFTP9wSGSh8wBjmO9sKwU";
}
enum Constants:String {
    case termAndConditionPolicyString="I Agree Terms of Use & Privacy Policy"
    case privacyPolicyString="Privacy Policy"
    case termsOfUserString="Terms of Use"
    case urlTermOfUser = "http://www.example.com/terms";
    case UrlPrivacyPolicy = "http://www.example.com/privacy";

}
enum Boolean:String{
   case yes = "YES";
   case no = "NO";
}

enum UdfFields:String{
    case keyISFirstTimeLoginUser = "isFirstTimeLoginUser";
    case valUdfPositiveValue = "1"
}

