//
//  EPOSUserDefaults.swift
//  ePOS
//
//  Created by Matra Sharma on 18/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//



import Foundation

protocol KeyNamespaceable { }

extension KeyNamespaceable {
    private static func namespace(_ key: String) -> String {
        return "\(Self.self).\(key)"
    }
    
    static func namespace<T: RawRepresentable>(_ key: T) -> String where T.RawValue == String {
        return namespace(key.rawValue)
    }
}

protocol UserDefaultable: KeyNamespaceable {
    associatedtype UserDefaultKey: RawRepresentable
}

extension UserDefaultable where UserDefaultKey.RawValue == String {
    // get/set string types
    static func set(_ string: String, forKey key: UserDefaultKey) {
        UserDefaults.standard.set(string, forKey: namespace(key))
    }
    
    static func string(forKey key: UserDefaultKey) -> String? {
        return UserDefaults.standard.string(forKey: namespace(key))
    }
    // get set integer types
    static func set(_ integer: Int, forKey key: UserDefaultKey) {
        UserDefaults.standard.set(integer, forKey: namespace(key))
    }
    
    static func integer(forKey key: UserDefaultKey) -> Int {
        return UserDefaults.standard.integer(forKey: namespace(key))
    }
    // get set urls
    static func set(_ url: URL, forKey key: UserDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(url, forKey: key)
    }
    
    static func url(forKey key: UserDefaultKey) -> URL? {
        let key = namespace(key)
        return UserDefaults.standard.url(forKey: key)
    }
    // get set double values
    static func set(_ double: Double, forKey key: UserDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(double, forKey: key)
    }

    static func double(forKey key: UserDefaultKey) -> Double {
        let key = namespace(key)
        return UserDefaults.standard.double(forKey: key)
    }
    // get set float values
    static func set(_ float: Float, forKey key: UserDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(float, forKey: key)
    }
    
    static func float(forKey key: UserDefaultKey) -> Float {
        let key = namespace(key)
        return UserDefaults.standard.float(forKey: key)
    }
    // get set Bool values
    static func set(_ bool: Bool, forKey key: UserDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(bool, forKey: key)
    }
    
    static func bool(forKey key: UserDefaultKey) -> Bool {
        let key = namespace(key)
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func set(_ object: AnyObject, forKey key: UserDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(object, forKey: key)
    }
    
    static func object(forKey key: UserDefaultKey) -> Any? {
        let key = namespace(key)
        return UserDefaults.standard.object(forKey: key)
    }
}

