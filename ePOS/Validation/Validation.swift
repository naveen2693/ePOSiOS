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

enum ValidationMode {
    case email
    case contactNameValidation
    case businessNameValidation
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
    case password = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{6,20}$"
    // Password length 6-15
    case alphabeticStringWithoutSpace = "^[a-zA-Z]*$" // e.g. hello sandeep
    case alphabeticStringFirstLetterCaps = "^[A-Z]+[a-zA-Z]*$" // SandsHell
    case phoneNo = "(?:(?:\\+|0{0,2})91(\\s*[\\- ]\\s*)?|[0 ]?)?[789]\\d{9}|(\\d[ -]?){10}\\d" // PhoneNo 10-14 Digits
    // MARK:- signUp fields validation regex
    case contactNameValidation = "[A-Za-z0-9]{1,50}([_\\-\\s][A-Za-z0-9]{1,50})*"
    case businessNameValidation = "[0-9A-Za-z]+([\\s]{0,1}[&\\-_|'/@.]{0,1}[\\s]{0,1}[0-9A-Za-z]\\.?)*"
    case otp = "\\d{6}"
    
    //Change RegEx according to your Requirement
}

enum AlertMessages: String {
    case inValidEmail = "Invalid Email"
    case invalidFirstLetterCaps = "First letter should be capital"
    case inValidPhone = "Invalid phone number"
    case invalidAlphabeticString = "Please enter correct name"
    case inValidPSW = "Please enter strong password"
    case emptyPhone = "Please enter Phone"
    case emptyEmail = "Please enter Email"
    case emptyFirstLetterCaps = "Please enter Name"
    case emptyAlphabeticString = "Please enter String"
    case emptyPSW = "Please enter Password"
    case confirmPassword = "Please enter Confirm Password"
    case passwordMatch = "Confirm password is not same as password"
    case checkBox = "Please confirm the term and condition"
    case otpErrorMessage = "Please enter valid OTP"
    case emptyotp = "Please enter OTP"
    // MARK:- sign field validation Message
    case emptyContactNameMessage = "Please enter the contact name"
    case emptyBusinessNameMessage = "Please enter the establishment name"
    case contactNameValidationErrorMessage = "Please enter valid contact name "
    case businessNameValidationErrorMessage = "Please enter valid establishment name"
    
    
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
class Validation: NSObject {
    var password:String="";
    static let shared = Validation()
    func validate(values: (type: ValidationMode, inputValue: Any)...) -> Valid {
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
                if let tempValue = PasswordMatch(confirmPassword: (valueToBeChecked.inputValue as? String)!, emptyAlert: .confirmPassword, invalidAlert: .passwordMatch) {
                    return tempValue
                }
            case .checkBoxChecked:
                if let tempValue = isCheckboxChecked(checkbox: (valueToBeChecked.inputValue as? Bool)!, emptyAlert: .emptyPSW, invalidAlert: .checkBox) {
                    return tempValue
                }
            case .otp:
               if let tempValue = isValidString(text: (valueToBeChecked.inputValue as? String)!, regex: .otp, emptyAlert: .emptyotp, invalidAlert: .otpErrorMessage) {
                    return tempValue
                }
                
            case .businessNameValidation:
                if let tempValue = isValidString(text: (valueToBeChecked.inputValue as? String)!, regex: .businessNameValidation, emptyAlert: .emptyBusinessNameMessage, invalidAlert: .businessNameValidationErrorMessage) {
                    return tempValue
                }
            case .contactNameValidation:
                if let tempValue = isValidString(text: (valueToBeChecked.inputValue as? String)!, regex: .contactNameValidation, emptyAlert: .emptyContactNameMessage, invalidAlert: .contactNameValidationErrorMessage) {
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
        if confirmPassword.isEmpty {
            return  .failure(.error, emptyAlert)
        }
        else if((confirmPassword.elementsEqual(password))==false){
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
