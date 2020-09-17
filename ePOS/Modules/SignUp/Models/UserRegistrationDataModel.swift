//
//  UserRegistrationData.swift
//  ePOS
//
//  Created by Abhishek on 17/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public class UserRegistrationDataModel {
private var contactName:String?;
private var contactNumber:String?;
private var email:String?;
private var establishmentName:String?;
private var password:String?;
private var referralCode:String?;

public func getReferralCode() -> String {
    if let unwrappedReferralCode = referralCode {
        return unwrappedReferralCode;
    } else {
        fatalError("Error: UserRegistrationDataModel:getReferralCode  failed.")
    }
}

public func setReferralCode(referralCode:String) -> UserRegistrationDataModel {
    self.referralCode = referralCode;
    return self
}

public func getContactName() -> String{
    if let unwrappedContactName = contactName {
        return unwrappedContactName;
    } else {
        fatalError("Error: UserRegistrationDataModel:getContactName  failed.")
    }
}

public func setContactName(contactName:String) -> UserRegistrationDataModel{
    self.contactName = contactName;
    return self
}

public func getContactNumber() -> String {
    if let unwrappedContactNumber = contactNumber {
        return unwrappedContactNumber;
    } else {
        fatalError("Error: UserRegistrationDataModel:getContactNumber  failed.")
    }
}

public func setContactNumber(contactNumber:String) -> UserRegistrationDataModel{
    self.contactNumber = contactNumber;
    return self
}

public func getEmail() -> String{
    if let unwrappedEmail = email {
        return unwrappedEmail;
    } else {
        fatalError("Error: UserRegistrationDataModel:getEmail  failed.")
    }
}

public func setEmail(email:String) -> UserRegistrationDataModel{
    self.email = email;
    return self
}

public func getEstablishmentName() -> String {
    if let unwrappedEstablishmentName = establishmentName {
        return unwrappedEstablishmentName;
    } else {
        
        fatalError("Error: UserRegistrationDataModel:getEstablishmentName  failed.")
    };
}

public func setEstablishmentName(establishmentName:String) -> UserRegistrationDataModel{
    self.establishmentName = establishmentName;
    return self
}

public func getPassword() -> String {
    if let unwrappedPassword = password {
        return unwrappedPassword;
    } else {
        fatalError("Error: UserRegistrationDataModel:getPassword  failed.")
    };
}

public func setPassword(password : String) -> UserRegistrationDataModel {
    self.password = password;
    return self
}
}
