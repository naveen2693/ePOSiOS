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
}
