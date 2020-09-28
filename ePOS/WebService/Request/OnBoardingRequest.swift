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

// MARK:-UserList Keys
public struct UserListKeys{
    let QUERY_KEY1:String = "page";
    let QUERY_KEY2:String = "size";
    let QUERY_KEY3:String = "dir";
    let QUERY_KEY4:String = "sort";
}

// MARK:-CityListKeys
public struct CityListKeys:Codable{
    var lastModifiedDate:String?;
    private enum CodingKeys: String, CodingKey {
        case lastModifiedDate = "mdafter"
    }
}

// MARK:- Master Data Keys
public struct MasterDataKeys:Codable{
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

public class OnBoardingRequest:BaseRequest{
    
    static func getUserProfileAndProceedToLaunch(showProgress:Bool, completion:@escaping CompletionHandler)
    {
        guard NetworkState().isInternetAvailable else {
            completion(.failure(APIError.noNetwork))
            return
        }
        BaseRequest.objMoyaApi.request(.getManageAccount) { result in
            switch result
            {
            case .success(let response):
                if let profileData = try? BaseRequest.decoder.decode(UserProfile.self, from:response.data) {
                    EPOSUserDefaults.setProfile(profile: profileData)
                    EPOSUserDefaults.setCurrentUserState(state: profileData.userType ?? UserState.applicant.rawValue)
                } else {
                    fatalError("UserProfile was not created")
                }
                
                loadMasterDataAndProceedToLaunch(mode: Constants.modeValueForMasterData.rawValue, completion: completion);
                completion(.success(response))
                
            case .failure(let error):
                completion(.failure(error));
                loadMasterDataAndProceedToLaunch(mode: Constants.modeValueForMasterData.rawValue, completion: completion);
                print(error);
                
            }
            
        }
    }
    
    private static func loadMasterDataAndProceedToLaunch(mode :String, completion:@escaping CompletionHandler)
    {
        guard NetworkState().isInternetAvailable else {
            completion(.failure(APIError.noNetwork))
            return
        }
        BaseRequest.objMoyaApi.request(.createRequestMasterDataWith(mode: mode)) { result in
            switch result
            {
            case .success(let response):
                do {
                    let masterData = try BaseRequest.decoder.decode(MasterDataWrapper.self, from:response.data)
                    try? MasterDataProvider().saveMasterDataPlistFile(with: masterData)
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

                getCityDetailsAndProceedToLaunch(completion: completion);
                
            case .failure(let error):
                getCityDetailsAndProceedToLaunch(completion: completion);
                error.errorDescription
                print(error);
                
            }
            
        }
    }
    
    private static func  getCityDetailsAndProceedToLaunch(completion:@escaping CompletionHandler)
    {
        guard NetworkState().isInternetAvailable else {
            completion(.failure(APIError.noNetwork))
            return
        }
        let strLastModifiedDate = CityDataProvider().getLastModifiedDate()
    BaseRequest.objMoyaApi.request(.getCityListWith(strLastModifiedDate:"\(strLastModifiedDate)")) { result in
        switch result
        {
        case .success(let response):
            do {
                let statesData = try BaseRequest.decoder.decode(StateData.self, from:response.data)
                try? CityDataProvider().saveSateDataPlistFile(with: statesData)
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
            fetchSubUserList(completion: completion)
            
        case .failure(let error):
            fetchSubUserList(completion: completion);
            print(error);
            
        }
                
    }
}
    
    private static func fetchSubUserList(completion:@escaping CompletionHandler)
    {
        guard NetworkState().isInternetAvailable else {
            completion(.failure(APIError.noNetwork))
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
            completion(.failure(APIError.noNetwork))
            return
        }
        BaseRequest.objMoyaApi.request(.getLeadByIdWith(leadId: leadId)) { result in
            switch result
            {
            case .success(let response):
                guard let jsonObject: Any = try? JSONSerialization.jsonObject(with: response.data, options: []) as Any,
                    let jsonData = jsonObject as? [String:Any],
                    let leadData = jsonData["lead"] as? [String:Any],
                    let workFlowState = jsonData["workFlowState"] as? String
                    else
                {
                    fatalError("Serialization Error")
                }
                EPOSUserDefaults.setCurrentStateWorkflow(currentState:workFlowState)
            case .failure(let error):
                print(error);
                
            }
            
        }
    }
    
    private static func checkWorkFlowStateToLaunch(completion:@escaping CompletionHandler) {
        var workflowState = WorkFlowState.leadNotCreated
        if let currentLead = EPOSUserDefaults.CurrentLead() {
            if currentLead.workFlowState != nil {
                workflowState = WorkFlowState(rawValue: currentLead.workFlowState) ?? workflowState
                if workflowState == WorkFlowState.saveBUDetails {
// TODO:                   if lead.getBusinessDetail() == nil {
//                        workFlowState = WorkFlowState.leadInitialized;
//                        completion(.success(workflowState as AnyObject))
//                    }
//                    else {
//                        completion(.success(workflowState as AnyObject))
//                    }
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
}





