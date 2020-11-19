//
//  LOGIN_ACCOUNTS.swift
//  ePOS
//
//  Created by Vishal Rathore on 13/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class LOGINACCOUNTS: Codable
{
    var m_strUserID: String = ""
    var m_strPIN: String = ""
    var m_strCreatedBy: String = ""
    var m_sAccountType: Int16 = 0
    var m_strCreatedOn: String = ""
    var m_strUpdatedOn: String = ""     //refactor to UpdatedOn
    var m_strLastLoginOn: String = ""
    var m_strUUID: String = ""
    var m_sFlagChangeType: Int16 = 0 //0 Nothing 1 New 2 Modify 3 Delete
}
