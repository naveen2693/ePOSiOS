//
//  OnBoardingRequest.swift
//  ePOS
//
//  Created by Abhishek on 19/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

// MARK:- LeadCode Keys
public struct GetLeadIDKeys:Codable{
    var id:Int?;
}

struct GstDetailKeys{
    public var  QUERY_KEY1:String = "gst";
}

struct GetPackagesKeys{
    public var  QUERY_KEY1:String = "leadId";
}

// MARK:-UserList Keys
public struct UserListKeys{
    let QUERY_KEY1:String = "page";
    let QUERY_KEY2:String = "size";
    let QUERY_KEY3:String = "dir";
    let QUERY_KEY4:String = "sort";
}

// MARK:-CityListKeys
public struct CityListRequest:Codable{
    var lastModifiedDate:String?;
    private enum CodingKeys: String, CodingKey {
        case lastModifiedDate = "mdafter"
    }
}

// MARK:-Merchant verification service keys
public struct MerchantVerficationRequest:Codable{
    var proofName:String?
    var proofId:String?
    var additionalInfo:[String:String]?
    private enum CodingKeys: String, CodingKey {
        case proofName = "proofName"
        case proofId = "proofId"
        case additionalInfo = "additionalInfo"
    }
}
// MARK:- Master Data Keys
public struct MasterDataRequest:Codable{
    var mode:String?;
}
//MARK:-DeviceInformationKeys
struct DeviceInformationKeys : Codable{
    var displayDensity:String?;
    var deviceOS:String?
    var pushNotificationToken:String?;
    var deviceType:String?
    var horizontalRes:String?
    var verticalRes:String?
    var manufacturerName:String?
    var deviceModel:String?
    private enum CodingKeys: String, CodingKey {
        case displayDensity = "displayDensity"
        case deviceOS = "dos"
        case pushNotificationToken = "dtoken"
        case deviceType = "dtype"
        case horizontalRes = "hres"
        case verticalRes = "vres"
        case manufacturerName = "manfctrnm"
        case deviceModel = "model"
        
    }
}

public struct UpdateLeadRequests:Codable
{
    var lead:Lead?;
    var documents:DocumentDetails?
    private enum CodingKeys: String, CodingKey {
    case lead = "lead"
    case documents = "documents"
}
}

public struct SearchIFSCRequest:Codable
{
    var bankName:String?
    var state:String?
    var district:String?
    var branch:String?
    private enum CodingKeys: String, CodingKey {
    case bankName = "bankName"
    case state = "state"
    case district = "district"
    case branch = "branch"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let name = bankName {
            try container.encode(name, forKey: .bankName)
        }
        if let name = state {
            try container.encode(name, forKey: .state)
        }
        if let name = district {
            try container.encode(name, forKey: .district)
        }
        if let name = branch {
            try container.encode(name, forKey: .branch)
        }
    }
}

public struct BankVerificationRequest:Codable
{
    var leadId:Int64?;
    var task:String?
    var additionalInfo = [AdditionalInfo]()
    private enum CodingKeys: String, CodingKey {
    case leadId = "leadId"
    case task = "task"
    case additionalInfo = "additionalInfo"
    }
}



public class OnBoardingRequest:BaseRequest{
    
    static func getUserProfileAndProceedToLaunch(showProgress:Bool, completion:@escaping CompletionHandler)
    {
        guard NetworkState().isInternetAvailable else {
        completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        }
        BaseRequest.objMoyaApi.request(.getManageAccount) { result in
            switch result
            {
                
            case .success(let response):
                if let checkStatus = checkApiResponseStatus(responseData: response.data)
                {
                    if checkStatus.status == true
                    {
                        if let profileData = try? BaseRequest.decoder.decode(UserProfile.self, from:response.data) {
                            EPOSUserDefaults.setProfile(profile: profileData)
                            EPOSUserDefaults.setCurrentUserState(state: profileData.userType ?? UserState.applicant.rawValue)
                            loadMasterDataAndProceedToLaunch(mode: Constants.modeValueForMasterData.rawValue, completion: completion);
                        } else {
                            fatalError("UserProfile was not created")
                        }
                        
                    } else
                    {
                        completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                        
                    }
                }
            case .failure(let error):
                completion(.failure(BaseError.errorMessage(error)))
                //                loadMasterDataAndProceedToLaunch(mode: Constants.modeValueForMasterData.rawValue, completion: completion);
                
            }
            
        }
    }
    
    private static func loadMasterDataAndProceedToLaunch(mode :String, completion:@escaping CompletionHandler)
    {
        guard NetworkState().isInternetAvailable else {
        completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        }
        BaseRequest.objMoyaApi.request(.createRequestMasterDataWith(mode: mode)) { result in
            switch result
            {
            case .success(let response):
                do {
                    if let checkStatus = checkApiResponseStatus(responseData: response.data)
                    {
                        if checkStatus.status == true
                        {
                            let masterData = try BaseRequest.decoder.decode(MasterDataWrapper.self, from:response.data)
                            try? MasterDataProvider().saveMasterDataPlistFile(with: masterData)
                            getCityDetailsAndProceedToLaunch(completion: completion);
                        }
                        else{
                           completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                        }
                    }
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
                
                
            case .failure(let error):
                completion(.failure(BaseError.errorMessage(error)))
                //                getCityDetailsAndProceedToLaunch(completion: completion);
                error.errorDescription
                print(error);
                
            }
            
        }
    }
    
    private static func  getCityDetailsAndProceedToLaunch(completion:@escaping CompletionHandler)
    {
        guard NetworkState().isInternetAvailable else {
        completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        }
        let strLastModifiedDate = CityDataProvider().getLastModifiedDate()
        BaseRequest.objMoyaApi.request(.getCityListWith(strLastModifiedDate:"\(strLastModifiedDate)")) { result in
            switch result
            {
            case .success(let response):
                do {
                    if let checkStatus = checkApiResponseStatus(responseData: response.data)
                    {
                        if checkStatus.status == true
                        {
                            let statesData = try BaseRequest.decoder.decode(StateData.self, from:response.data)
                            try? CityDataProvider().saveSateDataPlistFile(with: statesData)
                            fetchSubUserList(completion: completion)
                        }
                        else{
                           completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                        }
                    }
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
                
                
            case .failure(let error):
                completion(.failure(BaseError.errorMessage(error)))
                //            fetchSubUserList(completion: completion);
                print(error);
                
            }
            
        }
    }
    
    private static func fetchSubUserList(completion:@escaping CompletionHandler)
    {
        guard NetworkState().isInternetAvailable else {
        completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        }
        
        
        if let state = EPOSUserDefaults.currentUserState(), state == UserState.merchant.rawValue {
            let userProfileData = EPOSUserDefaults.getProfile();
            var listmobileNumber = [String]();
            guard let profiledataJson = userProfileData as? [String:Any],
                let mobileNumber = profiledataJson["mobileNumber"] as? String
                else
            {
                fatalError("Error: unwrappedModifiedDate")
            }
            listmobileNumber.append(mobileNumber)
            let params = ListSortParams(direction: "ASC", page: 0, size: 100, sort:"id");
            BaseRequest.objMoyaApi.request(.getFetchUserWith(listSortParams: params)) { result in
                switch result
                {
                case .success(let response):
                    if let checkStatus = checkApiResponseStatus(responseData: response.data)
                    {
                        if checkStatus.status == true
                        {
                            guard let jsonObject: Any = try? JSONSerialization.jsonObject(with: response.data, options: []) as Any,
                                let jsonData = jsonObject as? [String:Any],
                                let listSubUsers = jsonData["subUsers"] as? [String:Any]
                                else
                            {
                                fatalError("Serialization Error")
                            }
                            for (key,value) in listSubUsers
                            {
                                if key == "mobileNumber"{
                                    let mobileNumber  = value as? String
                                    if let unwrappedMobileNumber = mobileNumber{
                                        listmobileNumber.append(unwrappedMobileNumber)
                                    }
                                    else
                                    {
                                        fatalError("Error:Unwrapped error subuser dictionary")
                                    }
                                }
                            }
                            EPOSUserDefaults.setMobileNumberList(stateData: listmobileNumber as AnyObject)
                            let leadId:Int = 1;//call lead function
                            if leadId>0
                            {
                                getLeadByIdAndProceedToLaunch(leadId: leadId, completion: completion);
                            }
                        }
                        else{
                           completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                        }
                    }
                case .failure(let error):
                    fetchSubUserList(completion: completion);
                    print(error);
                    
                }
                
            }
        }
        else {
            let leadID = EPOSUserDefaults.currentLeadID()
            if leadID > 0 {
                getLeadByIdAndProceedToLaunch(leadId: leadID, completion: completion);
            } else {
                //hide loading
                checkWorkFlowStateToLaunch(completion: completion)
            }
        }
    }
    private static func  getLeadByIdAndProceedToLaunch(leadId:Int, completion:@escaping CompletionHandler)
    {
        guard NetworkState().isInternetAvailable else {
        completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        }
        BaseRequest.objMoyaApi.request(.getLeadByIdWith(leadId: leadId)) { result in
            switch result
            {
            case .success(let response):
                if let checkStatus = checkApiResponseStatus(responseData: response.data)
                {
                    if checkStatus.status == true
                    {
                        guard let jsonObject: Any = try? JSONSerialization.jsonObject(with: response.data, options: []) as Any,
                            let jsonData = jsonObject as? [String:Any],
                            let leadData = jsonData["lead"] as? [String:Any],
                            let workFlowState = jsonData["workFlowState"] as? String
                            else
                        {
                            fatalError("Serialization Error")
                        }
                        EPOSUserDefaults.setCurrentStateWorkflow(currentState:workFlowState)
                    }
                    else{
                       completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                    }
                }
            case .failure(let error):
                print(error);
                
            }
            
        }
    }
    
    private static func checkWorkFlowStateToLaunch(completion:@escaping CompletionHandler) {
        //        completion(.success(WorkFlowState.leadNotCreated as AnyObject))
        var workflowState = WorkFlowState.leadNotCreated
        if let currentLead = EPOSUserDefaults.CurrentLead() {
            if currentLead.workFlowState != nil {
                workflowState = WorkFlowState(rawValue: currentLead.workFlowState!) ?? workflowState
                if workflowState == WorkFlowState.saveBUDetails {
                    if currentLead.businessDetail == nil {
                        workflowState = WorkFlowState.leadInitialized;
                        completion(.success(workflowState as AnyObject))
                    }
                    else {
                        completion(.success(workflowState as AnyObject))
                    }
                } else {
                    completion(.success(workflowState as AnyObject))
                }
            }
            else {
                completion(.success(workflowState as AnyObject))
            }
        } else {
            completion(.success(workflowState as AnyObject))
        }
    }
    
    static func createLeadWith(params: CreateLeadParams, completion:@escaping CompletionHandler) {
        guard NetworkState().isInternetAvailable else {
        completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        }
        BaseRequest.objMoyaApi.request(.createLeadWith(params: params)) { result in
            switch result
            {
            case .success(let response):
                do {
                    if let checkStatus = checkApiResponseStatus(responseData: response.data)
                    {
                        if checkStatus.status == true
                        {
                            let leadInfo = try BaseRequest.decoder.decode(LeadWrapper.self, from:response.data)
                            EPOSUserDefaults.setLead(lead: leadInfo.lead)
                            completion(.success(leadInfo.lead as AnyObject))
                        }
                        else{
                           completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                        }
                    }
                    
                }catch DecodingError.dataCorrupted(let context) {
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
            case .failure(let error):
                completion(.failure(BaseError.errorMessage(error)))
                
            }
        }
    }
    
    static func getGSTDetails(gstNumber: String, completion:@escaping CompletionHandler) {
        guard NetworkState().isInternetAvailable else {
        completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        }
        
        BaseRequest.objMoyaApi.request(.getGSTDetail(gstNumber: gstNumber)) { result in
            switch result
            {
            case .success(let response):
                do {
                    if let checkStatus = checkApiResponseStatus(responseData: response.data)
                    {
                        if checkStatus.status == true
                        {
                            let gstWrapper = try BaseRequest.decoder.decode(GSTDetailWrapper.self, from:response.data)
                            completion(.success((gstWrapper.result as AnyObject)))
                        }
                        else{
                           completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                        }
                    }
                    
                }catch DecodingError.dataCorrupted(let context) {
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
            case .failure(let error):
                completion(.failure(BaseError.errorMessage(error)))
                
            }
        }
    }
    
    
      static func varifyDocumentWith(proofName:String,
                                       proofNumber:String,
                                       kycType:String?,
                                       additionalInfo:[String:String],
                                       completion:@escaping CompletionHandler) {
        
        guard NetworkState().isInternetAvailable else {
        completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        }
        
        BaseRequest.objMoyaApi.request(.getMerchantVerificationWith(proofName: proofNumber, proofNumber: proofNumber, additionalInfo:additionalInfo)) { result in
            switch result
            {
            case .success(let response):
                do {
                    if let checkStatus = checkApiResponseStatus(responseData: response.data)
                    {
                        if checkStatus.status == true
                        {
                            let merchantVerificationDetailsWrapper = try BaseRequest.decoder.decode(MerchantverificationResponse.self, from:response.data)
                            completion(.success((merchantVerificationDetailsWrapper.baseResponse as AnyObject)))
                        }
                        else{
                           completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                        }
                    }
                    
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
            case .failure(let error):
                completion(.failure(BaseError.errorMessage(error)))
                
            }
        }
    }
    
    static func getPackages(leadId: Int, completion:@escaping CompletionHandler) {
        guard NetworkState().isInternetAvailable else {
            completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        }
        
        BaseRequest.objMoyaApi.request(.getPackagesWith(leadId: leadId)) { result in
            switch result
            {
            case .success(let response):
                do {
                    if let checkStatus = checkApiResponseStatus(responseData: response.data)
                    {
                        if checkStatus.status == true
                        {
                            let gstWrapper = try BaseRequest.decoder.decode(GSTDetailWrapper.self, from:response.data)
                            completion(.success((gstWrapper.result as AnyObject)))
                        }
                        else{
                           completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                        }
                    }
                    
                }catch DecodingError.dataCorrupted(let context) {
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
            case .failure(let error):
                completion(.failure(BaseError.errorMessage(error)))
                
            }
        }
    }
    
    static func searchIFSCCodeWith(_ data: SearchIFSCRequest, for type: SearchIFSCType, completion:@escaping CompletionHandler) {
        guard NetworkState().isInternetAvailable else {
            completion(.failure(BaseError.errorMessage(Constants.noNetworkMsg.rawValue)))
            return
        }
        
        BaseRequest.objMoyaApi.request(.searchIFSCWith(params: data)) { result in
            switch result
            {
            case .success(let response):
                do {
                    if let checkStatus = checkApiResponseStatus(responseData: response.data)
                    {
                        if checkStatus.status == true
                        {
                            switch type {
                            case .bankName:
                                let ifscData = try BaseRequest.decoder.decode(Banks.self, from:response.data)
                                completion(.success((ifscData as AnyObject)))
                                
                            case .state:
                                let ifscData = try BaseRequest.decoder.decode(States.self, from:response.data)
                                completion(.success((ifscData as AnyObject)))
                                
                            case .district:
                                let ifscData = try BaseRequest.decoder.decode(Districts.self, from:response.data)
                                completion(.success((ifscData as AnyObject)))
                                
                            case .branch:
                                let ifscData = try BaseRequest.decoder.decode(Branch.self, from:response.data)
                                completion(.success((ifscData as AnyObject)))
                                
                            case .ifscCode:
                                let ifscData = try BaseRequest.decoder.decode(IFSCDetail.self, from:response.data)
                                completion(.success((ifscData as AnyObject)))
                            }
                        }
                        else{
                           completion(.failure(BaseError.errorMessage(checkStatus.message as Any)))
                        }
                    }
                    
                }catch DecodingError.dataCorrupted(let context) {
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
            case .failure(let error):
                completion(.failure(BaseError.errorMessage(error)))
                
            }
        }
    }
}





