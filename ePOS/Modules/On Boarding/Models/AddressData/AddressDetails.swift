//
//  AddressDetails.swift
//  ePOS
//
//  Created by Abhishek on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
// MARK:- Lead Address Request Keys
public struct AddressDetails:Codable{
    var ownershipType:String?
    var city : String?
    var pincode:String?
    var address:String?
    var addressType:String?
    var entityName:String?
    var description:String?
    var landMark:String?
    var state:String?
    var optlock:Int?
    private enum CodingKeys: String, CodingKey {
        case ownershipType = "ownershipType"
        case pincode = "pincode"
        case address = "address"
        case addressType = "addressType"
        case entityName = "entityName"
        case description = "description"
        case landMark = "landMark"
        case state = "state"
        case optlock = "optlock"
        case city = "city"
    }
}

enum AddressType:String
{
case store = "STORE";
case corparate = "CORPORATE";
case billing = "BILLING";
}

enum OwnerShipType:String
{
case owner = "OWNED";
}
