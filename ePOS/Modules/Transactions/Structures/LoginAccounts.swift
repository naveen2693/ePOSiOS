//
//  LOGIN_ACCOUNTS.swift
//  ePOS
//
//  Created by Abhishek on 12/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public struct LoginAccounts :Codable
{
    var userID = ""
    var pin = ""
    var createdBy = ""
    var accountType = 0
    var createdOn = ""
    var updatedOn = ""      //refactor to UpdatedOn
    var lastLoginOn = ""
    var UUID = ""
    var flagChangeType = 0 //0 Nothing 1 New 2 Modify 3 Delete
}
