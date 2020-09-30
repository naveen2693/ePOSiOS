//
//  GSTDetails.swift
//  ePOS
//
//  Created by Matra Sharma on 30/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct GSTDetails : Codable {
    let id : String?
    let entityType : String?
    let firmType : String?
    let legalName : String?
    let tradeName : String?
    let centreJurisdiction : String?
    let stateJurisdiction : String?
    let registrationDate : Int?
    let taxPayerType : String?
    let gstStatus : String?
    let cancellationDate : String?
    let natureOfBusinessActivities : [String]?
    let principalPlaceState : String?
    let primaryAddress : String?
    let primaryBuildingNo : String?
    let primaryBuildingName : String?
    let primarySplitAddress : String?
    let primaryFloorNo : String?
    let primaryPincode : String?
    let primaryDistrict : String?
    let primaryState : String?
    let primaryCity : String?
    let primaryCountry : String?
    let secondaryAddress : String?
    let secondarySplitAddress : String?
    let secondaryBuildingNo : String?
    let secondaryBuildingName : String?
    let secondaryFloorNo : String?
    let secondaryPincode : String?
    let secondaryDistrict : String?
    let secondaryState : String?
    let secondaryCity : String?
    let secondaryCountry : String?
    let uin : String?
    let number : String?

    enum CodingKeys: String, CodingKey {

        case id
        case entityType
        case firmType
        case legalName
        case tradeName
        case centreJurisdiction
        case stateJurisdiction
        case registrationDate
        case taxPayerType
        case gstStatus
        case cancellationDate
        case natureOfBusinessActivities
        case principalPlaceState
        case primaryAddress
        case primaryBuildingNo
        case primaryBuildingName
        case primarySplitAddress
        case primaryFloorNo
        case primaryPincode
        case primaryDistrict
        case primaryState
        case primaryCity
        case primaryCountry
        case secondaryAddress
        case secondarySplitAddress
        case secondaryBuildingNo
        case secondaryBuildingName
        case secondaryFloorNo
        case secondaryPincode
        case secondaryDistrict
        case secondaryState
        case secondaryCity
        case secondaryCountry
        case uin
        case number
    }

}

struct GSTDetailWrapper: Codable {
    let result : GSTDetails?
    enum CodingKeys: String, CodingKey {
        case result
    }
}
