//
//  Lead.swift
//  ePOS
//
//  Created by Matra Sharma on 28/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct LeadWrapper : Codable {
    let lead : Lead
}
// MARK:-Lead Requests
public struct Lead:Codable{
    var nextWorkFlowState:String?
    var comments :[LeadComments]?
    var userReponse : [UserReponse]?
    var pcStoreId:String?
    var typeOfLead:String?
    var individualDetails : [IndividualDetail]?
    var businessDetail : [BusinessDetails]?
    var pcMerchantId:Int?
    var workFlowState:String?
    var bankAccounts : [BankAccountDetails]?
    var leadState : [LeadState]
    var lmsLeadId:Int?
    var packageExternalId:Int?
    var paymentRecieved:String?
    var uniqueUserId:String?
    var leadSchedule : [LeadScheduleDetails]?
    var leadProfile : LeadProfileDetails
    var additionalInfo : [AdditionalInfo]?
    var id:Int?
    var applicationId:String?
    var packageInfo : [PackageInfo]?
    var packageFee:Double?
    var status:String?
    var optlock:Int?
    var tncAccepted:String?
    var leadAgreement : [LeadAgreement]?
    var blockedMessage:String?
    var heading:String?
    private enum CodingKeys: String, CodingKey {
        case nextWorkFlowState = "nextWorkFlowState"
        case comments = "comments"
        case userReponse = "userReponse"
        case pcStoreId = "pcStoreId"
        case typeOfLead = "typeOfLead"
        case individualDetails = "individualDetails"
        case businessDetail = "businessDetail"
        case pcMerchantId = "pcMerchantId"
        case workFlowState = "workFlowState"
        case bankAccounts = "bankAccounts"
        case leadState = "leadState"
        case lmsLeadId = "lmsLeadId"
        case packageExternalId = "packageExternalId"
        case paymentRecieved = "paymentRecieved"
        case uniqueUserId = "uniqueUserId"
        case leadSchedule = "leadSchedule"
        case leadProfile = "leadProfile"
        case additionalInfo = "additionalInfo"
        case id = "id"
        case applicationId = "applicationId"
        case packageInfo = "packageInfo"
        case packageFee = "packageFee"
        case status = "status"
        case optlock = "optlock"
        case tncAccepted = "tncAccepted"
        case leadAgreement = "leadAgreement"
        case blockedMessage = "blockedMessage"
        case heading = "heading"
    }
}

// MARK:-Lead UsersResponse Request Keys
public struct UserReponse:Codable{
    var response:Int?
    var tncLogs:String?
    var workFlowState:String?
    var comment:String?
    var optlock:Int?
    private enum CodingKeys: String, CodingKey {
        case response = "response"
        case tncLogs = "tncLogs"
        case workFlowState = "workFlowState"
        case comment = "comment"
        case optlock = "optlock"
    }
}
// MARK:-Lead IndividualDetail Request Keys
public struct IndividualDetail:Codable{
    var lastName:String?
    var address: [AddressDetails]?
    var gender:String?
    var externalId:String?
    var title:String?
    var buRelationshipType:String?
    var firstName:String?
    var individualRelationshipType:String?
    var kyc: [KYCDetails]
    var dob:String?
    var buSharePercent:String?
    var maritalStatus:String?
    var contacts : [ContactDetails]?
    var id:Int64?
    var optlock:Int?
    private enum CodingKeys: String, CodingKey {
        case lastName = "lastName"
        case address = "address"
        case gender = "gender"
        case externalId = "externalId"
        case title = "title"
        case buRelationshipType = "buRelationshipType"
        case firstName = "firstName"
        case individualRelationshipType = "individualRelationshipType"
        case kyc = "kyc"
        case dob = "dob"
        case buSharePercent = "buSharePercent"
        case maritalStatus = "maritalStatus"
        case contacts = "contacts"
        case id = "id"
        case optlock = "optlock"
    }
}
// MARK:-Package Info  Keys
public struct PackageInfo:Codable{
    var packageExternalId:String?
    var description:String?
    var packageFee:String?
    var optlock:Int?
    private enum CodingKeys: String, CodingKey {
        case packageExternalId = "packageExternalId"
        case description = "description"
        case packageFee = "packageFee"
        case optlock = "optlock"
    }
}






