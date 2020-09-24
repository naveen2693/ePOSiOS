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
    case checkBoxChecked
    case confirmPassword
    case otp
}

enum RegEx: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
    case password = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}" // Password length 6-15
    case alphabeticStringWithoutSpace = "^[a-zA-Z]*$" // e.g. hello sandeep
    case alphabeticStringFirstLetterCaps = "^[A-Z]+[a-zA-Z]*$" // SandsHell
    case phoneNo = "(?:(?:\\+|0{0,2})91(\\s*[\\- ]\\s*)?|[0 ]?)?[789]\\d{9}|(\\d[ -]?){10}\\d" // PhoneNo 10-14 Digits
    
    //Change RegEx according to your Requirement
}

enum AlertMessages: String {
    case inValidEmail = "InvalidEmail"
    case invalidFirstLetterCaps = "First Letter should be capital"
    case inValidPhone = "Invalid Phone Number"
    case invalidAlphabeticString = "Please Enter Correct Name"
    case inValidPSW = "Your password should have at least one special charachter,uppercase and lowercase character"
    case emptyPhone = "Please Enter Phone"
    case emptyEmail = "Please Enter Email"
    case emptyFirstLetterCaps = "Please Enter Name"
    case emptyAlphabeticString = "Please Enter String"
    case emptyPSW = "Please Enter Password"
    case passwordMatch = "Passwords do not match"
    case checkBox = "Please confirm the term and condition"
    case otp = "Please enter valid otp"
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
class Validation: NSObject {
    var password:String="";
    static let shared = Validation()
    func validate(values: (type: ValidationType, inputValue: Any)...) -> Valid {
        for valueToBeChecked in values {
            switch valueToBeChecked.type {
            case .email:
                if let tempValue = isValidString(text: (valueToBeChecked.inputValue as? String)!, regex: .email, emptyAlert: .emptyEmail, invalidAlert: .inValidEmail) {
                    return tempValue
                }
            case .stringWithFirstLetterCaps:
                if let tempValue = isValidString(text: (valueToBeChecked.inputValue as? String)!, regex: .alphabeticStringFirstLetterCaps, emptyAlert: .emptyFirstLetterCaps, invalidAlert: .invalidFirstLetterCaps) {
                    return tempValue
                }
            case .phoneNo:
                if let tempValue = isValidString(text: (valueToBeChecked.inputValue as? String)!, regex: .phoneNo, emptyAlert: .emptyPhone, invalidAlert: .inValidPhone) {
                    return tempValue
                }
            case .alphabeticString:
                if let tempValue = isValidString(text: (valueToBeChecked.inputValue as? String)!, regex: .alphabeticStringWithoutSpace, emptyAlert: .emptyAlphabeticString, invalidAlert: .invalidAlphabeticString) {
                    return tempValue
                }
            case .password:
                if let tempValue = isValidString(text: (valueToBeChecked.inputValue as? String)!, regex: .password, emptyAlert: .emptyPSW, invalidAlert: .inValidPSW) {
                    password = (valueToBeChecked.inputValue as? String)!
                    return tempValue
                }
                else
                {
                    password = (valueToBeChecked.inputValue as? String)!
                }
            case .confirmPassword:
                if let tempValue = PasswordMatch(confirmPassword: (valueToBeChecked.inputValue as? String)!, emptyAlert: .emptyPSW, invalidAlert: .passwordMatch) {
                    return tempValue
                }
            case .checkBoxChecked:
                if let tempValue = isCheckboxChecked(checkbox: (valueToBeChecked.inputValue as? Bool)!, emptyAlert: .emptyPSW, invalidAlert: .checkBox) {
                    return tempValue
                }
            case .otp:
                if let tempValue = isOtpChecked(otp: (valueToBeChecked.inputValue as? String)!, emptyAlert: .emptyPSW, invalidAlert: .otp) {
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
    
    func PasswordMatch(confirmPassword: String, emptyAlert: AlertMessages, invalidAlert: AlertMessages) -> Valid? {
        if((confirmPassword.elementsEqual(password))==false){
            return .failure(.error, invalidAlert)
        }
        return nil
    }
    
    func isCheckboxChecked(checkbox: Bool, emptyAlert: AlertMessages, invalidAlert: AlertMessages) -> Valid? {
        if !checkbox{
            return .failure(.error, invalidAlert)
        }
        return nil
    }
    
    func isOtpChecked(otp: String, emptyAlert: AlertMessages, invalidAlert: AlertMessages) -> Valid? {
        if otp.count != 6 {
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
