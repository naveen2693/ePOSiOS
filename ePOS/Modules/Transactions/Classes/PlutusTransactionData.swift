//
//  PlutusTransactionData.swift
//  ePOS
//
//  Created by Vishal Rathore on 23/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class PlutusTransactionData: Codable {
    
    private var billingReferenceId: String?
    private var authCode: String?
    private var transactionResponse: String?
    private var cardMaskedPan: String?
    private var expiryDate: String?
    private var name: String?
    private var hostType: String?
    private var edcROC: Int64?
    private var edcBatchId: Int64?
    private var terminalId: String?
    private var acquirer: String?
    private var merchantId: String?
    private var rrn: String?
    private var date: String?
    private var transactionId: Int64?
    private var amount: Double?
    private var transactionType: String?
    private var mobileNumber: String?
    private var customerVPA: String?
    private var emiTenure: Int?
    private var emiProcessingFee: Double?
    private var emiInterestRate: Double?
    private var productCategory: String?
    private var oemName: String?
    private var productDesc: String?
    private var productSerial: String?
    private var emiTxnAmount: Double?
    private var cardIssuer: String?
    private var emiLoanAmount: Double?
    private var emiAmount: Double?
    private var emiTotalAmount: Double?
    private var emailId: String?
    private var clientId: Int64?
    private var originalEdcBatchId: Int64?
    private var originalEdcROC: Int64?
    private var firstROC: Int64?
    private var originalBillingReferenceNumber: String?
    private var referenceNumber: String?
    private var status: Int?
    private var isReversed: Int?
    private var IsLocal: Bool = true
    private var IsPaperPos: Bool = false
    private var paperPosIdentifier: String?

    init() {
    }

    init(_ edcBatchId: Int64, _ roc: Int64, _ originalEdcROC: Int64, _ isPaperPos: Bool, _ paperPosIdentifier: String, _ clientId: Int64) {
        self.edcBatchId = edcBatchId
        self.originalEdcBatchId = edcBatchId
        self.edcROC = roc
        self.originalEdcROC = originalEdcROC
        self.firstROC = roc
        self.IsPaperPos = isPaperPos
        self.paperPosIdentifier = paperPosIdentifier
        self.clientId = clientId
    }

    public func getBillingReferenceId() -> String? {
        return billingReferenceId
    }

    public func setBillingReferenceId(_ billingReferenceId: String) {
        self.billingReferenceId = billingReferenceId
    }

    public func getAuthCode() -> String? {
        return authCode
    }

    public func setAuthCode(_ authCode: String) {
        self.authCode = authCode
    }

    public func getTransactionResponse() -> String? {
        return transactionResponse
    }

    public func setTransactionResponse(_ transactionResponse: String) {
        self.transactionResponse = transactionResponse
    }

    public func getCardMaskedPan() -> String? {
        return cardMaskedPan
    }

    public func setCardMaskedPan(_ cardMaskedPan: String) {
        self.cardMaskedPan = cardMaskedPan
    }

    public func getExpiryDate() -> String? {
        return expiryDate
    }

    public func setExpiryDate(_ expiryDate: String) {
        self.expiryDate = expiryDate
    }

    public func getName() -> String? {
        return name
    }

    public func setName(_ name: String) {
        self.name = name
    }

    public func getHostType() -> String? {
        return hostType
    }

    public func setHostType(_ hostType: String) {
        self.hostType = hostType
    }

    public func getEdcROC() -> Int64? {
        return edcROC
    }

    public func setEdcROC(_ edcROC: Int64) {
        self.edcROC = edcROC
    }

    public func getEdcBatchId() -> Int64? {
        return edcBatchId
    }

    public func setEdcBatchId(_ edcBatchId: Int64) {
        self.edcBatchId = edcBatchId
    }

    public func getTerminalId() -> String? {
        return terminalId
    }

    public func setTerminalId(_ terminalId: String) {
        self.terminalId = terminalId
    }

    public func getAcquirer() -> String? {
        return acquirer
    }

    public func setAcquirer(_ acquirer: String) {
        self.acquirer = acquirer
    }

    public func getMerchantId() -> String? {
        return merchantId
    }

    public func setMerchantId(_ merchantId: String) {
        self.merchantId = merchantId
    }

    public func getRrn() -> String? {
        return rrn
    }

    public func setRrn(_ rrn: String) {
        self.rrn = rrn
    }

    public func getDate() -> String? {
        return date
    }

    public func setDate(_ date: String) {
        self.date = date
    }

    public func getTransactionId() -> Int64? {
        return transactionId
    }

    public func setTransactionId(_ transactionId: Int64) {
        self.transactionId = transactionId
    }

    public func getAmount() -> Double? {
        return amount
    }

    public func setAmount(_ amount: Double) {
        self.amount = amount
    }

    public func getTransactionType() -> String? {
        return transactionType
    }

    public func setTransactionType(_ transactionType: String) {
        self.transactionType = transactionType
    }

    public func getMobileNumber() -> String? {
        return mobileNumber
    }

    public func setMobileNumber(_ mobileNumber: String) {
        self.mobileNumber = mobileNumber
    }

    public func getCustomerVPA() -> String? {
        return customerVPA
    }

    public func setCustomerVPA(_ customerVPA: String) {
        self.customerVPA = customerVPA
    }

    public func getEmiTenure() -> Int? {
        return emiTenure
    }

    public func setEmiTenure(_ emiTenure: Int) {
        self.emiTenure = emiTenure
    }

    public func getEmiProcessingFee() -> Double? {
        return emiProcessingFee
    }

    public func setEmiProcessingFee(_ emiProcessingFee: Double) {
        self.emiProcessingFee = emiProcessingFee
    }

    public func getEmiInterestRate() -> Double? {
        return emiInterestRate
    }

    public func setEmiInterestRate(_ emiInterestRate: Double) {
        self.emiInterestRate = emiInterestRate
    }

    public func getProductCategory() -> String? {
        return productCategory
    }

    public func setProductCategory(_ productCategory: String) {
        self.productCategory = productCategory
    }

    public func getOemName() -> String? {
        return oemName
    }

    public func setOemName(_ oemName: String) {
        self.oemName = oemName
    }

    public func getProductDesc() -> String? {
        return productDesc
    }

    public func setProductDesc(_ productDesc: String) {
        self.productDesc = productDesc
    }

    public func getProductSerial() -> String? {
        return productSerial
    }

    public func setProductSerial(_ productSerial: String) {
        self.productSerial = productSerial
    }

    public func getEmiTxnAmount() -> Double? {
        return emiTxnAmount
    }

    public func setEmiTxnAmount(_ emiTxnAmount: Double) {
        self.emiTxnAmount = emiTxnAmount
    }

    public func getCardIssuer() -> String? {
        return cardIssuer
    }

    public func setCardIssuer(_ cardIssuer: String) {
        self.cardIssuer = cardIssuer
    }

    public func getEmiLoanAmount() -> Double? {
        return emiLoanAmount
    }

    public func setEmiLoanAmount(_ emiLoanAmount: Double) {
        self.emiLoanAmount = emiLoanAmount
    }

    public func getEmiAmount() -> Double? {
        return emiAmount
    }

    public func setEmiAmount(_ emiAmount: Double) {
        self.emiAmount = emiAmount
    }

    public func getEmiTotalAmount() -> Double? {
        return emiTotalAmount
    }

    public func setEmiTotalAmount(_ emiTotalAmount: Double) {
        self.emiTotalAmount = emiTotalAmount
    }

    public func getEmailId() -> String? {
        return emailId
    }

    public func setEmailId(_ emailID: String) {
        self.emailId = emailID
    }

    public func getClientId() -> Int64? {
        return clientId
    }

    public func setClientId(_ clientId: Int64) {
        self.clientId = clientId
    }

    public func getOriginalEdcBatchId() -> Int64? {
        return originalEdcBatchId
    }

    public func setOriginalEdcBatchId(_ originalEdcBatchId: Int64) {
        self.originalEdcBatchId = originalEdcBatchId
    }

    public func getOriginalEdcROC() -> Int64? {
        return originalEdcROC
    }

    public func setOriginalEdcROC(_ originalEdcROC: Int64) {
        self.originalEdcROC = originalEdcROC
    }

    public func getFirstROC() -> Int64? {
        return firstROC
    }

    public func setFirstROC(_ firstROC: Int64) {
        self.firstROC = firstROC
    }

    public func getOriginalBillingReferenceNumber() -> String? {
        return originalBillingReferenceNumber
    }

    public func setOriginalBillingReferenceNumber(_ originalBillingReferenceNumber: String) {
        self.originalBillingReferenceNumber = originalBillingReferenceNumber
    }

    public func getReferenceNumber() -> String? {
        return referenceNumber
    }

    public func setReferenceNumber(_ referenceNumber: String) {
        self.referenceNumber = referenceNumber
    }

    public func getStatus() -> Int? {
        return status
    }

    public func setStatus(_ status: Int) {
        self.status = status
    }

    public func getIsReversed() -> Int? {
        return isReversed
    }

    public func setIsReversed(_ isReversed: Int) {
        self.isReversed = isReversed
    }

    public func isLocal() -> Bool {
        return IsLocal
    }

    public func setLocal(_ local: Bool) {
        self.IsLocal = local
    }

    public func isPaperPos() -> Bool?{
        return IsPaperPos
    }

    public func setPaperPos(_ paperPos: Bool) {
        self.IsPaperPos = paperPos
    }

    public func getPaperPosIdentifier() -> String? {
        return paperPosIdentifier
    }

    public func setPaperPosIdentifier(_ paperPosIdentifier: String) {
        self.paperPosIdentifier = paperPosIdentifier
    }
    
    public func equals(_ obj: AnyObject) -> Bool {
        if (obj is PlutusTransactionData) {
            let otherTxn: PlutusTransactionData =  (obj as? PlutusTransactionData)!
            if (IsPaperPos) {
                return otherTxn.IsPaperPos && (self.clientId != nil && self.clientId == (otherTxn.clientId) &&
                        self.edcBatchId == (otherTxn.edcBatchId) &&
                        self.edcROC == (otherTxn.edcROC))
            } else {
                return  !otherTxn.IsPaperPos && (self.originalEdcBatchId == (otherTxn.originalEdcBatchId) &&
                        ((self.originalEdcROC != nil && (self.originalEdcROC == (otherTxn.originalEdcROC) || self.originalEdcROC == (otherTxn.edcROC))) ||
                                (self.edcROC != nil && (self.edcROC == (otherTxn.originalEdcROC) || self.edcROC == (otherTxn.edcROC))) ||
                                self.firstROC != nil && (self.firstROC == (otherTxn.firstROC) || self.firstROC == (otherTxn.edcROC) || self.firstROC == (otherTxn.originalEdcROC))))
            }
        }else {
            return false
        }
    }
    
    
    
    
}
