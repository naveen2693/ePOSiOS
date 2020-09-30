//
//  CompleteUserData.swift
//  ePOS
//
//  Created by Matra Sharma on 29/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct CompleteUserData : Codable {
    let uniqueUserID : String
    let profile : UserProfile
    let accessToken : String

    enum CodingKeys: String, CodingKey {

        case uniqueUserID = "unqusrid"
        case profile = "profile"
        case accessToken = "acstkn"
    }

}
