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
    // MARK:-OnBoarding Apis
    case createRequestMasterDataWith(mode:String)
    
    case getCityListWith(strLastModifiedDate:String)
    
    case getFetchUserWith(listSortParams:ListSortParams)
    
    case createLeadWith(params: CreateLeadParams)
    
    case getLeadByIdWith(leadId:Int)
    
    case getGSTDetail(gstNumber: String)
    
    case getMerchantVerificationWith(proofName:String,proofNumber:String,additionalInfo:[String:String])
    case updateLeadWith(lead:Lead,documents:DocumentDetails)
    
    case searchIFSCWith(bankName:String,stateName:String,distName:String, branchName:String)
    
    case BankverificationWith(leadId:Int64,ArrayListAdditionalInfo:[AdditionalInfo])
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
            
        case .createLeadWith:
            return ApiEndpointsUrl.OnboardingApiEndpointUrl.createLead.rawValue
            
        case .getGSTDetail:
            return ApiEndpointsUrl.OnboardingApiEndpointUrl.gstDetail.rawValue
            
        case .getMerchantVerificationWith:
            return ApiEndpointsUrl.OnboardingApiEndpointUrl.getMerchantVerificationDetails.rawValue
            
        case .updateLeadWith:
            return ApiEndpointsUrl.OnboardingApiEndpointUrl.updateLead.rawValue
        // MARK:- Configuration path
        case .getConfigurationsWith:
            return ApiEndpointsUrl.ConfigurationApiEndPointsUrl.configurationUrl.rawValue
        case .searchIFSCWith:
            return ApiEndpointsUrl.OnboardingApiEndpointUrl.searchIFSC.rawValue
            
        case .BankverificationWith:
            return ApiEndpointsUrl.OnboardingApiEndpointUrl.verifyBankAccount.rawValue
            
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
            
        // MARK: - OnBoarding Apis Method
        case .createRequestMasterDataWith:
            return .post
            
        case .getCityListWith:
            return .post
            
        case .getFetchUserWith:
            return .get
            
        case .createLeadWith,.updateLeadWith,.searchIFSCWith,.BankverificationWith:
            return .post
            
        case .getLeadByIdWith, .getGSTDetail,.getMerchantVerificationWith:
            return .get
            
            
        // MARK:- Configuration Method
        case .getConfigurationsWith:
            return .post
            
            
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var validate:ValidationType {
        switch self {
        case .getCheckUserWith, .getForgotPasswordWith,.getVerifyOtpWith,.getSendOtpWith,.resetPasswordWith,.getLoginWith,.getSignUpWith,.getManageAccount,.createRequestMasterDataWith,.getCityListWith,.getFetchUserWith,.getLeadByIdWith,.getConfigurationsWith, .createLeadWith, .getGSTDetail,.getMerchantVerificationWith,.updateLeadWith,.searchIFSCWith,.BankverificationWith:
            return .customCodes([200])
        }
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
        case .getManageAccount:
            return .requestPlain
            
            
        //  MARK: - ONBoarding tasks
        case .createRequestMasterDataWith(let mode):
            return  .requestJSONEncodable((RequestHandler
                .createMasterDataRequest(mode: mode)))
            
        case .getCityListWith(let strLastModifiedDate):
            return  .requestJSONEncodable((RequestHandler
                .createGetCityListRequest(strLastModifiedDate: strLastModifiedDate)))
            
        case .getFetchUserWith(let listSortParams):
            return .requestParameters(parameters:RequestHandler.createUserListRequest(params:listSortParams), encoding: URLEncoding.queryString)
            
        case .createLeadWith(let params):
            return .requestJSONEncodable(params)
            
        case .getLeadByIdWith(let leadId):
            return  .requestJSONEncodable((RequestHandler
                .createGetLeadIDRequest(leadID: leadId)))
            
        case .getGSTDetail(let gstNumber):
            return .requestParameters(parameters:RequestHandler.createGstDetailRequest(number: gstNumber), encoding: URLEncoding.queryString)
            
        case .getMerchantVerificationWith(let proofName,let proofNumber,let additionalInfo):
            return  .requestJSONEncodable((RequestHandler
                .createMerchantVerificationRequest(proofName: proofName, proofNumber: proofNumber, additionalInfo: additionalInfo)))
        case .updateLeadWith(let lead,let documents):
            return .requestJSONEncodable((RequestHandler
                .updateLeadRequest(lead: lead, documents: documents)))
            
        case .searchIFSCWith(let bankName,let stateName,let distName ,let branchName):
            return .requestJSONEncodable((RequestHandler
                .searchIFSCRequest(bankName: bankName, stateName: stateName, distName: distName, branchName: branchName)))
            
        case .BankverificationWith(let leadId,let additionalInfo):
            return .requestJSONEncodable((RequestHandler
                .createBankVerificationRequest(leadId: leadId, additionalInfos:additionalInfo)))
            
        // MARK:-Configuration task
        case .getConfigurationsWith(let globalChngNum):
            return  .requestJSONEncodable((RequestHandler
                .createConfigurationRequest(globalChangeNumber: globalChngNum)))
            
            
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getCheckUserWith,.getForgotPasswordWith,.getVerifyOtpWith,.getSendOtpWith,.getLoginWith,.getSignUpWith,.resetPasswordWith,.getConfigurationsWith:
            return RequestHandler.createWebServiceHeaderWithoutAccessToken()
            
        case .getManageAccount, .createRequestMasterDataWith, .getCityListWith, .getFetchUserWith, .createLeadWith, .getLeadByIdWith, .getGSTDetail,.getMerchantVerificationWith,.updateLeadWith,.searchIFSCWith,.BankverificationWith:
            return RequestHandler.createWebServiceHeaderWithAccessToken()
            
        }
        
    }
}
