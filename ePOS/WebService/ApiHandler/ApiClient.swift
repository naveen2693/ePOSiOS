//
//  Endpoint.swift
//  SimpleApiClient

import Foundation
import Moya
enum ApiService
{
// MARK:- Login Apis
    case getCheckUserWith(mobileNumber:String)
    
    case getForgotPasswordWith(mobileNumber:String)
    
    case getVerifyOtpWith(mobileNumber:String,otp:String)
    
    case getSendOtpWith(mobileNumber:String)
    
    case resetPasswordWith(mobileNumber:String,otp:String,newPassword:String)
    
    case getLoginWith(mobileNumber:String,password:String)
    
// MARK:- SignUp Apis
    case getSignUpWith(signUpData:SignUpData)
    
    case getManageAccount
    
    case createRequestMasterDataWith(mode:String)
    
    case getCityListWith(strLastModifiedDate:String)
    
    case getFetchUserWith(listSortParams:ListSortParams)
    
    case getLeadByIdWith(leadId:Int64)
    
// MARK:- Configuration
    case getConfigurationsWith(globalChangeNumber:Int)
}
extension ApiService : TargetType
{
    var baseURL: URL {
        return URL(string:"http://mobileserveruat.pinelabs.com:9001")!
    }
    
    var path: String {
        switch self  {
    // MARK:- Login Apis path
        case .getCheckUserWith:
            return ApiEndpointsUrl.UserDetailsApiEndpointUrl.checkUser.rawValue
            
        case .getForgotPasswordWith:
            return ApiEndpointsUrl.UserDetailsApiEndpointUrl.forgetPasswordUrl.rawValue
            
        case .getVerifyOtpWith:
            return ApiEndpointsUrl.UserDetailsApiEndpointUrl.verifyOtpUrl.rawValue
            
        case .getSendOtpWith:
            return ApiEndpointsUrl.UserDetailsApiEndpointUrl.sendOtpUrl.rawValue
            
        case .resetPasswordWith:
            return ApiEndpointsUrl.UserDetailsApiEndpointUrl.resetPasswordUrl.rawValue
        case .getLoginWith:
            return ApiEndpointsUrl.UserDetailsApiEndpointUrl.loginUrl.rawValue
            
    // MARK:- Sign Apis Path
        case .getSignUpWith:
            return ApiEndpointsUrl.UserDetailsApiEndpointUrl.signUpUrl.rawValue
            
   // MARK:-OnBoarding
        case .getManageAccount:
            return ApiEndpointsUrl.OnboardingApiEndpointUrl.getProfileUrl.rawValue
            
        case .createRequestMasterDataWith:
            return ApiEndpointsUrl.OnboardingApiEndpointUrl.masterDataUrl.rawValue
            
        case .getCityListWith:
            return ApiEndpointsUrl.OnboardingApiEndpointUrl.getCityList.rawValue
            
        case .getFetchUserWith:
            return ApiEndpointsUrl.OnboardingApiEndpointUrl.fetchUserList.rawValue
            
        case .getLeadByIdWith:
           return ApiEndpointsUrl.OnboardingApiEndpointUrl.getLeadId.rawValue
        
    // MARK:- Configuration path
        case .getConfigurationsWith:
            return ApiEndpointsUrl.ConfigurationApiEndPointsUrl.configurationUrl.rawValue
           
        }
    }

    var method:Moya.Method {
        switch self{
// MARK:- Login Apis method
        case .getCheckUserWith:
            return .get
            
        case .getForgotPasswordWith:
            return .post
            
        case .getVerifyOtpWith:
            return .post
            
        case .getSendOtpWith:
            return .get
        
        case .resetPasswordWith:
            return .post
        
        case .getLoginWith:
            return .post
            
// MARK:- SignUp Apis Method
        case .getSignUpWith:
            return .post
            
        case .getManageAccount:
            return .get
            
        case .createRequestMasterDataWith:
            return .post
            
        case .getCityListWith:
            return .post
            
        case .getFetchUserWith:
            return .get
            
        case .getLeadByIdWith:
            return .get
 // MARK:- Configuration Method
        case .getConfigurationsWith:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
// MARK:- Login Apis task
        case .getCheckUserWith(let mobileNumber):
            return  .requestParameters(parameters:RequestHandler.createCheckUserRequest(mobileNum:mobileNumber), encoding: URLEncoding.queryString)
            
        case .getForgotPasswordWith(let mobileNumber):
          return .requestParameters(parameters:RequestHandler.createForgotPasswordRequest(mobileNum:mobileNumber), encoding: URLEncoding.queryString)
            
        case .getVerifyOtpWith(let mobileNumber,let otp):
            return  .requestJSONEncodable((RequestHandler
                .createOTPVerifyRequest(mobileNum:mobileNumber,otp: otp)))
            
        case .getSendOtpWith(let mobileNumber):
            return  .requestParameters(parameters:RequestHandler.createOTPSendRequest(mobileNum:mobileNumber), encoding: URLEncoding.queryString)
            
        case .resetPasswordWith(let mobileNumber,let otp, let newPassword):
                  return  .requestJSONEncodable((RequestHandler
                    .createResetPasswordRequest(mobileNumber:mobileNumber,otp: otp,password: newPassword)))
            
        case .getLoginWith(let mobileNumber, let password):
            return  .requestJSONEncodable((RequestHandler
                                     .createLoginRequest(mobileNumber: mobileNumber, password: password)))
            
// MARK:- SignUp Apis task
        case .getSignUpWith(let signUpData):
            return  .requestJSONEncodable((RequestHandler
                .createSignUpRequest(signUpData: signUpData)))
            
        case .createRequestMasterDataWith(let mode):
             return  .requestJSONEncodable((RequestHandler
                .createMasterDataRequest(mode: mode)))
            
        case .getCityListWith(let strLastModifiedDate):
             return  .requestJSONEncodable((RequestHandler
                .createGetCityListRequest(strLastModifiedDate: strLastModifiedDate)))
            
        case .getFetchUserWith(let listSortParams):
            return .requestParameters(parameters:RequestHandler.createUserListRequest(params:listSortParams), encoding: URLEncoding.queryString)
            
        case .getLeadByIdWith(let leadId):
            return  .requestJSONEncodable((RequestHandler
                .createGetLeadIDRequest(leadID: leadId)))
            
        case .getManageAccount:
            return .requestPlain
        
// MARK:-Configuration task
        case .getConfigurationsWith(let globalChngNum):
            return  .requestJSONEncodable((RequestHandler
                .createConfigurationRequest(globalChangeNumber: globalChngNum)))
        

    }
    }
    var headers: [String : String]? {
          switch self {
             case .getCheckUserWith:
                return RequestHandler.createWebServiceHeaderWithoutAccessToken()
                        
                    case .getForgotPasswordWith:
                        return RequestHandler.createWebServiceHeaderWithoutAccessToken()
            
                    case .getVerifyOtpWith:
                       return RequestHandler.createWebServiceHeaderWithoutAccessToken()
                        
                    case .getSendOtpWith:
                       return RequestHandler.createWebServiceHeaderWithoutAccessToken()
            
                    case .getLoginWith:
                    return RequestHandler.createWebServiceHeaderWithoutAccessToken()
            
                    case .getSignUpWith:
                       return RequestHandler.createWebServiceHeaderWithoutAccessToken()
            
                    case .resetPasswordWith:
                        return RequestHandler.createWebServiceHeaderWithoutAccessToken()
                        
                    case .getManageAccount:
                         return RequestHandler.createWebServiceHeaderWithAccessToken()
                        
                    case .createRequestMasterDataWith:
                          return RequestHandler.createWebServiceHeaderWithAccessToken()
                        
                    case .getCityListWith:
                          return RequestHandler.createWebServiceHeaderWithAccessToken()
                        
                    case .getFetchUserWith:
                         return RequestHandler.createWebServiceHeaderWithAccessToken()
                        
                    case .getLeadByIdWith:
                         return RequestHandler.createWebServiceHeaderWithAccessToken()
            
                    case .getConfigurationsWith:
                         return RequestHandler.createWebServiceHeaderWithoutAccessToken()
            
                    }
            
    }
}
//private extension NSURL {
//    static func getBaseUrl() -> NSURL {
//        guard let info = Bundle.main.infoDictionary,
//            let urlString = info["Base url"] as? String,
//            let url = NSURL(string: urlString) else {
//            fatalError("Cannot get base url from info.plist")
//        }
//
//        return url
//    }
//}
