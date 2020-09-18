//
//  Endpoint.swift
//  SimpleApiClient

import Foundation
import Moya
enum ApiService
{
// MARK:- Login Apis
    case getCheckUserSubscription(mobileNumber:String)
    
    case getForgotPwdSubscription(mobileNumber:String)
    
    case getVerifyOtpSubscription(mobileNumber:String,otp:String)
    
    case getSendOtpSubscription(mobileNumber:String)
    
// MARK:- SignUp Apis
    case getSignUpSubscription(registrationData:UserRegistrationDataModel)
    
    case getManageAccountSubscription
    
    case createRequestMasterData(mode:String)
    
    case getCityListSubscription(strLastModifiedDate:String)
    
    case getFetchUserSubscription(listSortParams:ListSortParamsModel)
    
    case getLeadByIdSubscription(leadId:Int64)
    
// MARK:- Configuration
    case getConfigurationsSubscription(globalChngNum:Int)

}
extension ApiService : TargetType
{
    var baseURL: URL {
        return URL(string:"https://torrentpay.pinepg.in/")!
    }
    
    var path: String {
        switch self  {
    // MARK:- Login Apis path
        case .getCheckUserSubscription:
            return Constants.CHECk_USER_URL
            
        case .getForgotPwdSubscription:
            return Constants.FORGOT_PASSWORD_URL
            
        case .getVerifyOtpSubscription:
            return Constants.VERIFY_OTP_URL
            
        case .getSendOtpSubscription:
            return Constants.SEND_OTP_URL
            
    // MARK:- Sign Apis Path
        case .getSignUpSubscription:
            return Constants.SIGNUP_URL
            
        case .getManageAccountSubscription:
            return Constants.GET_PROFILE_URL
            
        case .createRequestMasterData:
            return Constants.MASTER_DATA_URL
            
        case .getCityListSubscription:
            return Constants.GET_CITY_LIST
            
        case .getFetchUserSubscription:
            return Constants.FETCH_USERS_URL
            
        case .getLeadByIdSubscription:
           return Constants.GET_LEAD_ID_URL
        
    // MARK:- Configuration path
        case .getConfigurationsSubscription:
            return Constants.CONFIGURATION_URL
           
        }
    }
    
    var method:Moya.Method {
        switch self{
// MARK:- Login Apis method
        case .getCheckUserSubscription:
            return .get
            
        case .getForgotPwdSubscription:
            return .post
            
        case .getVerifyOtpSubscription:
            return .post
            
        case .getSendOtpSubscription:
            return .post
        
// MARK:- SignUp Apis Method
        case .getSignUpSubscription:
            return .post
            
        case .getManageAccountSubscription:
            return .get
            
        case .createRequestMasterData:
            return .post
            
        case .getCityListSubscription:
            return .post
            
        case .getFetchUserSubscription:
            return .get
            
        case .getLeadByIdSubscription:
            return .get
 // MARK:- Configuration Method
        case .getConfigurationsSubscription:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
// MARK:- Login Apis task
        case .getCheckUserSubscription(let mobileNumber):
            return  .requestParameters(parameters:RequestHandler.createCheckUserRequest(mobileNum:mobileNumber), encoding: URLEncoding.queryString)
            
        case .getForgotPwdSubscription(let mobileNumber):
          return .requestParameters(parameters:RequestHandler.createForgotPasswordRequest(mobileNum:mobileNumber), encoding: URLEncoding.queryString)
            
        case .getVerifyOtpSubscription(let mobileNumber,let otp):
            return  .requestJSONEncodable(try? JSONEncoder().encode(RequestHandler
                .createOTPVerifyRequest(mobileNum:mobileNumber,otp: otp)))
            
        case .getSendOtpSubscription(let mobileNumber):
            return  .requestParameters(parameters:RequestHandler.createOTPSendRequest(mobileNum:mobileNumber), encoding: URLEncoding.queryString)
            
// MARK:- SignUp Apis task
        case .getSignUpSubscription(let registrationData):
            return  .requestJSONEncodable(try? JSONEncoder().encode(RequestHandler
                .createSignUpRequest(registrationData: registrationData)))
            
        case .createRequestMasterData(let mode):
             return  .requestJSONEncodable(try? JSONEncoder().encode(RequestHandler
                .createMasterDataRequest(mode: mode)))
            
        case .getCityListSubscription(let strLastModifiedDate):
             return  .requestJSONEncodable(try? JSONEncoder().encode(RequestHandler
                .createGetCityListRequest(strLastModifiedDate: strLastModifiedDate)))
            
        case .getFetchUserSubscription(let listSortParams):
            return .requestParameters(parameters:RequestHandler.createUserListRequest(params:listSortParams), encoding: URLEncoding.queryString)
            
        case .getLeadByIdSubscription(let leadId):
            return  .requestJSONEncodable(try? JSONEncoder().encode(RequestHandler
                .createGetLeadIDRequest(leadID: leadId)))
        case .getManageAccountSubscription:
            return .requestPlain
        
// MARK:-Configuration task
        case .getConfigurationsSubscription(let globalChngNum):
            return  .requestJSONEncodable(try? JSONEncoder().encode(RequestHandler
                .createConfigurationRequest(globalChngNum: globalChngNum)))
        }

    }
    
    var headers: [String : String]? {
          switch self {
             case .getCheckUserSubscription:
                return RequestHandler.createWebServiceHeaderWithoutAccessToken()
                        
                    case .getForgotPwdSubscription:
                        return RequestHandler.createWebServiceHeaderWithoutAccessToken()
            
                    case .getVerifyOtpSubscription:
                       return RequestHandler.createWebServiceHeaderWithoutAccessToken()
                        
                    case .getSendOtpSubscription:
                       return RequestHandler.createWebServiceHeaderWithoutAccessToken()
            
                    case .getSignUpSubscription:
                       return RequestHandler.createWebServiceHeaderWithoutAccessToken()
                        
                    case .getManageAccountSubscription:
                         return RequestHandler.createWebServiceHeaderWithAccessToken()
                        
                    case .createRequestMasterData:
                          return RequestHandler.createWebServiceHeaderWithAccessToken()
                        
                    case .getCityListSubscription:
                          return RequestHandler.createWebServiceHeaderWithAccessToken()
                        
                    case .getFetchUserSubscription:
                         return RequestHandler.createWebServiceHeaderWithAccessToken()
                        
                    case .getLeadByIdSubscription:
                         return RequestHandler.createWebServiceHeaderWithAccessToken()
            
                    case .getConfigurationsSubscription:
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
