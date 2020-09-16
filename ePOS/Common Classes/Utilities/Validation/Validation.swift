//
//  Validation.swift
//  ePOS
//
//  Created by Abhishek on 15/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//
import Foundation

enum Alert {
    case success
    case failure
    case error
}

enum Valid {
    case success
    case failure(Alert, AlertMessages)
}

enum ValidationType {
    case email
    case stringWithFirstLetterCaps
    case phoneNo
    case alphabeticString
    case password
}

enum RegEx: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
    case password = "^.{6,15}$" // Password length 6-15
    case alphabeticStringWithSpace = "^[a-zA-Z ]*$" // e.g. hello sandeep
    case alphabeticStringFirstLetterCaps = "^[A-Z]+[a-zA-Z]*$" // SandsHell
    case phoneNo = "[0-9]{10,14}" // PhoneNo 10-14 Digits
    
    //Change RegEx according to your Requirement
}

enum AlertMessages: String {
    case inValidEmail = "InvalidEmail"
    case invalidFirstLetterCaps = "First Letter should be capital"
    case inValidPhone = "Invalid Phone"
    case invalidAlphabeticString = "Invalid String"
    case inValidPSW = "Invalid Password"
    
    case emptyPhone = "Empty Phone"
    case emptyEmail = "Empty Email"
    case emptyFirstLetterCaps = "Empty Name"
    case emptyAlphabeticString = "Empty String"
    case emptyPSW = "Empty Password"
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

class Validation: NSObject {
    
    public static let shared = Validation()
    
    func validate(values: (type: ValidationType, inputValue: String)...) -> Valid {
        for valueToBeChecked in values {
            switch valueToBeChecked.type {
            case .email:
                if let tempValue = isValidString(text: valueToBeChecked.inputValue, regex: .email, emptyAlert: .emptyEmail, invalidAlert: .inValidEmail) {
                    return tempValue
                }
            case .stringWithFirstLetterCaps:
                if let tempValue = isValidString(text: valueToBeChecked.inputValue, regex: .alphabeticStringFirstLetterCaps, emptyAlert: .emptyFirstLetterCaps, invalidAlert: .invalidFirstLetterCaps) {
                    return tempValue
                }
            case .phoneNo:
                if let tempValue = isValidString(text: valueToBeChecked.inputValue, regex: .phoneNo, emptyAlert: .emptyPhone, invalidAlert: .inValidPhone) {
                    return tempValue
                }
            case .alphabeticString:
                if let tempValue = isValidString(text: valueToBeChecked.inputValue, regex: .alphabeticStringWithSpace, emptyAlert: .emptyAlphabeticString, invalidAlert: .invalidAlphabeticString) {
                    return tempValue
                }
            case .password:
                if let tempValue = isValidString(text: valueToBeChecked.inputValue, regex: .password, emptyAlert: .emptyPSW, invalidAlert: .inValidPSW) {
                    return tempValue
                }
            }
        }
        return .success
    }
    
    func isValidString(text: String, regex: RegEx, emptyAlert: AlertMessages, invalidAlert: AlertMessages) -> Valid? {
        if text.isEmpty {
            return .failure(.error, emptyAlert)
        } else if isValidRegEx(text, regex) != true {
            return .failure(.error, invalidAlert)
        }
        return nil
    }
    
    func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex.rawValue)
        let result = stringTest.evaluate(with: testStr)
        return result
    }
}
