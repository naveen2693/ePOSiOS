//
//  Lead.swift
//  ePOS
//
//  Created by Matra Sharma on 28/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct Lead : Codable {
    let id : Int?
    let optlock : Int?
    let applicationId : String?
    let status : String?
    let pcStoreId : String?
    let pcMerchantId : String?
    let typeOfLead : String?
    let lmsLeadId : String?
    let uniqueUserId : String?
    let workFlowState : String?
    let nextWorkFlowState : String?
    let leadState : [LeadState]?
    let leadProfile : LeadProfile?
    let individualDetails : String?
    let comments : String?
    let bankAccounts : String?
    let leadSchedule : String?
    let userReponse : String?
    let additionalInfo : String?
    let blockedMessage : String?
    let packageInfo : String?
    let tncAccepted : Bool?
    let isEposUserLoggedIn : String?
    let paymentreceived : Bool?
    let businessDetail : String?
    let leadAgreement : String?
    let poUpdateStatus : String?
    let fileName : String?
    let uploadedBy : String?
    let lastPoUpdatedDate : String?
    let uploadedDate : String?
    let isQrRequest : String?
    let reqSource : String?
    let digiLeadId : String?
    let isSmartphoneUser : String?

    enum CodingKeys: String, CodingKey {

        case id 
        case optlock
        case applicationId
        case status
        case pcStoreId
        case pcMerchantId
        case typeOfLead
        case lmsLeadId
        case uniqueUserId
        case workFlowState
        case nextWorkFlowState
        case leadState
        case leadProfile
        case individualDetails
        case comments
        case bankAccounts
        case leadSchedule
        case userReponse
        case additionalInfo
        case blockedMessage
        case packageInfo
        case tncAccepted
        case isEposUserLoggedIn
        case paymentreceived
        case businessDetail
        case leadAgreement
        case poUpdateStatus
        case fileName
        case uploadedBy
        case lastPoUpdatedDate
        case uploadedDate
        case isQrRequest
        case reqSource
        case digiLeadId
        case isSmartphoneUser
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        optlock = try values.decodeIfPresent(Int.self, forKey: .optlock)
        applicationId = try values.decodeIfPresent(String.self, forKey: .applicationId)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        pcStoreId = try values.decodeIfPresent(String.self, forKey: .pcStoreId)
        pcMerchantId = try values.decodeIfPresent(String.self, forKey: .pcMerchantId)
        typeOfLead = try values.decodeIfPresent(String.self, forKey: .typeOfLead)
        lmsLeadId = try values.decodeIfPresent(String.self, forKey: .lmsLeadId)
        uniqueUserId = try values.decodeIfPresent(String.self, forKey: .uniqueUserId)
        workFlowState = try values.decodeIfPresent(String.self, forKey: .workFlowState)
        nextWorkFlowState = try values.decodeIfPresent(String.self, forKey: .nextWorkFlowState)
        leadState = try values.decodeIfPresent([LeadState].self, forKey: .leadState)
        leadProfile = try values.decodeIfPresent(LeadProfile.self, forKey: .leadProfile)
        individualDetails = try values.decodeIfPresent(String.self, forKey: .individualDetails)
        comments = try values.decodeIfPresent(String.self, forKey: .comments)
        bankAccounts = try values.decodeIfPresent(String.self, forKey: .bankAccounts)
        leadSchedule = try values.decodeIfPresent(String.self, forKey: .leadSchedule)
        userReponse = try values.decodeIfPresent(String.self, forKey: .userReponse)
        additionalInfo = try values.decodeIfPresent(String.self, forKey: .additionalInfo)
        blockedMessage = try values.decodeIfPresent(String.self, forKey: .blockedMessage)
        packageInfo = try values.decodeIfPresent(String.self, forKey: .packageInfo)
        tncAccepted = try values.decodeIfPresent(Bool.self, forKey: .tncAccepted)
        isEposUserLoggedIn = try values.decodeIfPresent(String.self, forKey: .isEposUserLoggedIn)
        paymentreceived = try values.decodeIfPresent(Bool.self, forKey: .paymentreceived)
        businessDetail = try values.decodeIfPresent(String.self, forKey: .businessDetail)
        leadAgreement = try values.decodeIfPresent(String.self, forKey: .leadAgreement)
        poUpdateStatus = try values.decodeIfPresent(String.self, forKey: .poUpdateStatus)
        fileName = try values.decodeIfPresent(String.self, forKey: .fileName)
        uploadedBy = try values.decodeIfPresent(String.self, forKey: .uploadedBy)
        lastPoUpdatedDate = try values.decodeIfPresent(String.self, forKey: .lastPoUpdatedDate)
        uploadedDate = try values.decodeIfPresent(String.self, forKey: .uploadedDate)
        isQrRequest = try values.decodeIfPresent(String.self, forKey: .isQrRequest)
        reqSource = try values.decodeIfPresent(String.self, forKey: .reqSource)
        digiLeadId = try values.decodeIfPresent(String.self, forKey: .digiLeadId)
        isSmartphoneUser = try values.decodeIfPresent(String.self, forKey: .isSmartphoneUser)
    }

}
