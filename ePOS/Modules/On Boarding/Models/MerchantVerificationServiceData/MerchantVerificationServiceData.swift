//
//  MerchantVerificationServiceData.swift
//  ePOS
//
//  Created by Abhishek on 01/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct MerchantverificationResponse:Codable {
    var baseResponse:MerchantVeficationServiceBaseResponse?;
    enum CodingKeys: String, CodingKey {
        case baseResponse = "result"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        baseResponse = try values.decodeIfPresent(MerchantVeficationServiceBaseResponse.self, forKey: .baseResponse)
    }
}

struct MerchantVeficationServiceBaseResponse : Codable {
    let id : String?
    let status : String?
    let primaryDistrict : String?
    let primaryState : String?
    let primaryCity : String?
    let primaryCountry : String?
    let primarySplitAddress : String?
    let completeAddress : [MerchantverificationAddress]?
    let address : String?
    let district : String?
    let state : String?
    let pincode : String?
    let dicName : String?
    let cstNumber : String?
    let vatNumber : String?
    let tinNumber : String?
    let dlNumber : String?
    let uamNumber : String?
    let sneNumber : String?
    let dealer : String?
    let ownerName : String?
    let cstStatus : String?
    let pan : String?
    let regDate : Int64?
    let cancelDate : Int64?
    let lpgId : String?
    let name : String?
    let consumerName : String?
    let nameOfEnterprise : String?
    let nameOfTheShop : String?
    let epicNumber : String?
    let electricityProvider : String?
    let dateOfCommencement : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case status = "status"
        case primaryDistrict = "primaryDistrict"
        case primaryState = "primaryState"
        case primaryCity =  "primaryCity"
        case primaryCountry = "primaryCountry"
        case primarySplitAddress = "primarySplitAddress"
        case completeAddress = "completeAddress"
        case address = "address"
        case district = "district"
        case pincode = "pincode"
        case dicName = "dicName"
        case cstNumber = "cstNumber"
        case vatNumber = "vatNumber"
        case tinNumber = "tinNumber"
        case dlNumber = "dlNumber"
        case uamNumber = "uamNumber"
        case sneNumber = "sneNumber"
        case dealer = "dealer"
        case ownerName = "ownerName"
        case cstStatus = "cstStatus"
        case state = "state"
        case pan = "pan"
        case regDate = "regDate"
        case cancelDate = "cancelDate"
        case lpgId = "lpgId"
        case name = "name"
        case consumerName = "consumerName"
        case nameOfEnterprise = "nameOfEnterprise"
        case nameOfTheShop = "nameOfTheShop"
        case epicNumber = "epicNumber"
        case electricityProvider = "electricityProvider"
        case dateOfCommencement = "dateOfCommencement"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        primaryDistrict = try values.decodeIfPresent(String.self, forKey: .primaryDistrict)
        primaryState = try values.decodeIfPresent(String.self, forKey: .primaryState)
        primaryCity = try values.decodeIfPresent(String.self, forKey: .primaryCity)
        primaryCountry = try values.decodeIfPresent(String.self, forKey: .primaryCountry)
        primarySplitAddress = try values.decodeIfPresent(String.self, forKey: .primarySplitAddress)
        completeAddress = try values.decodeIfPresent([MerchantverificationAddress].self, forKey: .completeAddress)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        district = try values.decodeIfPresent(String.self, forKey: .district)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        pincode = try values.decodeIfPresent(String.self, forKey: .pincode)
        dicName = try values.decodeIfPresent(String.self, forKey: .dicName)
        cstNumber = try values.decodeIfPresent(String.self, forKey: .cstNumber)
        vatNumber = try values.decodeIfPresent(String.self, forKey: .vatNumber)
        tinNumber = try values.decodeIfPresent(String.self, forKey: .tinNumber)
        dlNumber = try values.decodeIfPresent(String.self, forKey: .dlNumber)
        uamNumber = try values.decodeIfPresent(String.self, forKey: .uamNumber)
        sneNumber = try values.decodeIfPresent(String.self, forKey: .sneNumber)
        dealer = try values.decodeIfPresent(String.self, forKey: .dealer)
        ownerName = try values.decodeIfPresent(String.self, forKey: .ownerName)
        cstStatus = try values.decodeIfPresent(String.self, forKey: .cstStatus)
        pan = try values.decodeIfPresent(String.self, forKey: .pan)
        regDate = try values.decodeIfPresent(Int64.self, forKey: .regDate)
        cancelDate = try values.decodeIfPresent(Int64.self, forKey: .cancelDate)
        lpgId = try values.decodeIfPresent(String.self, forKey: .lpgId)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        consumerName = try values.decodeIfPresent(String.self, forKey: .consumerName)
        nameOfEnterprise = try values.decodeIfPresent(String.self, forKey: .nameOfEnterprise)
        nameOfTheShop = try values.decodeIfPresent(String.self, forKey: .nameOfTheShop)
        epicNumber = try values.decodeIfPresent(String.self, forKey: .epicNumber)
        electricityProvider = try values.decodeIfPresent(String.self, forKey: .electricityProvider)
        dateOfCommencement = try values.decodeIfPresent(String.self, forKey: .dateOfCommencement)
        
}
}
