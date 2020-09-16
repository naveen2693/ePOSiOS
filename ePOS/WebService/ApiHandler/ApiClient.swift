//
//  Endpoint.swift
//  SimpleApiClient

import Foundation
import Moya
enum LoginApiService
{
    case getCheckUserSubscription(mobileNumber:String)
    case getForgotPwdSubscription(mobileNumber:String)
    case getVerifyOtpSubscription(mobileNumber:String,otp:String)

    case getSendOtpSubscription(mobileNumber:String)
}
extension LoginApiService :TargetType
{
    var baseURL: URL {
        return URL(string:"https://torrentpay.pinepg.in/")!
    }
    
    var path: String {
        switch self  {
        case .getCheckUserSubscription:
            return Constants.CHECk_USER_URL
        case .getForgotPwdSubscription:
            return Constants.FORGOT_PASSWORD_URL
        case .getVerifyOtpSubscription:
            return Constants.VERIFY_OTP_URL
        case .getSendOtpSubscription:
            return Constants.SEND_OTP_URL
            
        }
    }
    
    var method:Moya.Method {
        switch self{
        case .getCheckUserSubscription:
            return .get
        case .getForgotPwdSubscription:
            return .post
        case .getVerifyOtpSubscription:
            return .post
        case .getSendOtpSubscription:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getCheckUserSubscription(let mobileNumber):
            return  .requestJSONEncodable(try! JSONEncoder().encode(RequestHandler
                .createCheckUserReq(mobileNum:mobileNumber)))
        case .getForgotPwdSubscription(let mobileNumber):
            return  .requestJSONEncodable(try! JSONEncoder().encode(RequestHandler
                .createForgotPwdReq(mobileNum:mobileNumber)))
        case .getVerifyOtpSubscription(let mobileNumber,let otp):
            return  .requestJSONEncodable(try! JSONEncoder().encode(RequestHandler
                .createOTPVerifyReq(mobileNum:mobileNumber,otp: otp)))
        case .getSendOtpSubscription(let mobileNumber):
            return  .requestJSONEncodable(try! JSONEncoder().encode(RequestHandler
                .createOTPSendReq(mobileNum:mobileNumber)))
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json"
        ]
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
