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
    var id:Int64?;
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
    
    static func getUserProfileAndProceedToLaunch(showProgress:Bool,completion:@escaping CompletionHandler)
    {
        BaseRequest.objMoyaApi.request(.getManageAccount) { result in
            switch result
            {
            case .success(let response):
                guard let jsonObject: Any = try? JSONSerialization.jsonObject(with: response.data, options: []) as Any,
                    let jsonData = jsonObject as? [String:Any],
                    let profile = jsonData["profile"] as? String
                    else
                {
                    fatalError("Serialization Error")
                }
                EPOSUserDefaults.setProfile(profile: profile as AnyObject)
                loadMasterDataAndProceedToLaunch(mode: Constants.modeValueForMasterData.rawValue);
                completion(.success(response))
                
            case .failure(let error):
                completion(.failure(error));
                loadMasterDataAndProceedToLaunch(mode: Constants.modeValueForMasterData.rawValue);
                print(error);
                
            }
            
        }
    }
    
    private static func loadMasterDataAndProceedToLaunch(mode :String)
    {
        BaseRequest.objMoyaApi.request(.createRequestMasterDataWith(mode: mode)) { result in
            switch result
            {
            case .success(let response):
                guard let jsonObject: Any = try? JSONSerialization.jsonObject(with: response.data, options: []) as Any,
                    let jsonData = jsonObject as? [String:Any],
                    let masterData = jsonData["masterData"] as? [AnyObject]
                    else
                {
                    fatalError("Serialization Error")
                }
                EPOSUserDefaults.setMasterData(masterData: masterData as AnyObject)
                getCityDetailsAndProceedToLaunch();
                
            case .failure(let error):
                getCityDetailsAndProceedToLaunch();
                print(error);
                
            }
            
        }
    }
    
    private static func  getCityDetailsAndProceedToLaunch()
    {
        let strLastModifiedDate = EPOSUserDefaults.getStateModifiedDate();
        if let unwrappedModifiedDate = strLastModifiedDate{
            BaseRequest.objMoyaApi.request(.getCityListWith(strLastModifiedDate:unwrappedModifiedDate)) { result in
                switch result
                {
                case .success(let response):
                    guard let jsonObject: Any = try? JSONSerialization.jsonObject(with: response.data, options: []) as Any,
                        let jsonData = jsonObject as? [String:Any],
                        let modifiedDate = jsonData["lastModifiedDate"] as? String,
                        let state = jsonData["states"] as? [String:Any]
                        else
                    {
                        fatalError("Serialization Error")
                    }
                    EPOSUserDefaults.setStateModifiedDate(modifiedDate: modifiedDate)
                    EPOSUserDefaults.setStateData(stateData: state as AnyObject)
                    fetchSubUserList();
                case .failure(let error):
                    fetchSubUserList();
                    print(error);
                    
                }
                
            }
        }else
        {
            fatalError("Error: unwrappedModifiedDate")
        }
    }
    
    private static func fetchSubUserList()
    {
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
                let leadId:Int64 = 1;//call lead function
                if leadId>0
                {
                    getLeadByIdAndProceedToLaunch(leadId: leadId);
                }
            case .failure(let error):
                fetchSubUserList();
                print(error);
                
            }
            
        }
    }
    private static func  getLeadByIdAndProceedToLaunch(leadId:Int64)
    {
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
}





