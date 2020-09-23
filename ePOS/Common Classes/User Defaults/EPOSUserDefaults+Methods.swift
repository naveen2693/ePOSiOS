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
    static func setProfile(profile:String)
    {
        UserDefaults.Configuration.set(profile, forKey: .profile)
    }
    static func getProfile() -> String?
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
    
}
