//
//  EPOSUserDefaults+Methods.swift
//  ePOS
//
//  Created by Matra Sharma on 18/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//
// Use this class to save values in UserDefaults
// Create getter/setter here only to get/set values in UserDefaults
// Do not write values directly into UserDefaults in any other class.

import Foundation

extension UserDefaults {
    struct Configuration: UserDefaultable {
    enum UserDefaultKey: String {
            case termsUrl
            case accessToken
            case udid
            case userId
            case profile
            case masterData
            case modifiedDate
            case stateData
            case mobileNumberList
            case currentWorkFlowState
            case configurationData
        }
        private init() {}
        
    }
}

class EPOSUserDefaults: NSObject {
    
    static func setTermsUrl(_ url: URL) {
        UserDefaults.Configuration.set(url, forKey: .termsUrl)
    }
    
    static func getTermsUrl() -> URL? {
        return UserDefaults.Configuration.url(forKey: .termsUrl)
    }
    
    static func setUdid(udid:String)
    {
        UserDefaults.Configuration.set(udid, forKey: .udid)
    }
    static func getUdid() -> String?
    {
        return UserDefaults.Configuration.string(forKey: .udid)
    }
    static func setAccessToken(accessToken:String)
    {
        UserDefaults.Configuration.set(accessToken, forKey: .accessToken)
    }
    static func getAccessToken() -> String?
    {
        return UserDefaults.Configuration.string(forKey: .accessToken)
    }
    static func setProfile(profile:AnyObject)
    {
        UserDefaults.Configuration.set(profile, forKey: .profile)
    }
    static func getProfile() -> Any?
    {
        return UserDefaults.Configuration.string(forKey: .profile)
    }
    static func setUserId(userID:String)
    {
        UserDefaults.Configuration.set(userID, forKey: .userId)
    }
    static func getUserId() -> String?
    {
        return UserDefaults.Configuration.string(forKey: .userId)
    }
    static func setMasterData(masterData:AnyObject)
    {
        UserDefaults.Configuration.set(masterData, forKey: .masterData)
    }
    static func getMasterData() -> Any?
    {
        return UserDefaults.Configuration.string(forKey: .masterData)
    }
    static func setStateModifiedDate(modifiedDate:String)
    {
        UserDefaults.Configuration.set(modifiedDate, forKey: .modifiedDate)
    }
    static func getStateModifiedDate() -> String?
    {
        return UserDefaults.Configuration.string(forKey: .modifiedDate)
    }
    static func setStateData(stateData:AnyObject)
    {
        UserDefaults.Configuration.set(stateData, forKey: .stateData)
    }
    static func getStateData() -> Any?
    {
        return UserDefaults.Configuration.string(forKey: .stateData)
    }
    static func setMobileNumberList(stateData:AnyObject)
    {
           UserDefaults.Configuration.set(stateData, forKey: .mobileNumberList)
    }
    static func getMobileNumberList() -> Any?
    {
           return UserDefaults.Configuration.string(forKey: .mobileNumberList)
    }
    static func setCurrentStateWorkflow(currentState:String)
    {
           UserDefaults.Configuration.set(currentState, forKey: .currentWorkFlowState)
    }
    static func getCurrentStateWorkflow() -> String?
    {
           return UserDefaults.Configuration.string(forKey: .currentWorkFlowState)
    }
    static func setConfigurationData(configData:AnyObject)
    {
           UserDefaults.Configuration.set(configData, forKey: .configurationData)
    }
    static func gettConfigurationData() -> Any?
    {
           return UserDefaults.Configuration.string(forKey: .configurationData)
    }
    
    
}
