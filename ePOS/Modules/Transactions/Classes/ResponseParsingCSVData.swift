//
//  ResponseParsingCSVData.swift
//  ePOS
//
//  Created by Vishal Rathore on 24/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public class ResponseParsingCSVData: Codable {
/*
* sequence of parameter should be same when adding data from string csv as the response of csv is comma separated
* */

    private var billingReferenceId: String?
    private var authCode: String?
    private var transactionResponse: String?
    private var cardMaskedPan: String?
    private var expiryDate: String?
    private var cardholderName: String?
    private var hostType: String?
    private var edcROC: String?
    private var edcBatchId: String?
    private var terminalID: String?
    private var loyaltyPointsReward: String?
    private var remark: String?
    private var transactionAcquirerName: String?
    private var merchantID: String?
    private var retrievalReferenceNumber: String?
    private var cardEntryMode: String?
    private var printCardholderNameOnReceipt: String?
    private var merchantName: String?
    private var merchantAddress: String?
    private var merchantCity: String?
    private var plutusVersion: String?
    private var acquirerCode: String?
    private var emiTenure: String?
    private var emiProcessingFee: String?
    private var rewardBalanceAmount: String?
    private var emiInterestRate: String?
    private var chargeSlipPrintData: String?
    private var couponCode: String?
    private var transactionAmountProcessed: String?
    private var rfu3: String?
    private var settlementSummary: String?
    private var dateOfTransaction: String?
    private var timeOfTransaction: String?
    private var transactionId: String?
    private var transactionAmount: String?
    private var transactionType: String?
    private var reservedField: String?
    private var emiProductCategory: String?
    private var maskedMobileNumber: String?
    private var vpa: String?
    private var addonCsvResponse: String?
    private var emiProductName: String?
    private var emiOemName: String?
    private var emiProductDescription: String?
    private var imei: String?
    private var originalTransactionAmount: String?
    private var issuerName: String?
    private var emiPrincipleAmount: String?
    private var emiAmount: String?
    private var emiTotalAmount: String?
    private var customerEmail: String?
    private var originalBillingDetails: String?

    
    public func setBillingReferenceId(_ billingReferenceId: String) {
         self.billingReferenceId = billingReferenceId
     }

    public func setAuthCode(_ authCode: String) {
        self.authCode = authCode
    }
    
    public func setTransactionResponse(_ transactionResponse: String) {
        self.transactionResponse = transactionResponse
    }

    public func setCardMaskedPan(_ cardMaskedPan: String) {
        self.cardMaskedPan = cardMaskedPan
    }


    public func setExpiryDate(_ expiryDate: String) {
        self.expiryDate = expiryDate
    }
    
    public func setCardholderName(_ cardholderName: String) {
        self.cardholderName = cardholderName
    }
        
    public func setHostType(_ hostType: String) {
        self.hostType = hostType
    }

    public func setEdcROC(_ edcROC: String) {
        self.edcROC = edcROC
    }

    public func setEdcBatchId(_ edcBatchId: String) {
        self.edcBatchId = edcBatchId
    }

    public func setTerminalID(_ terminalID: String) {
        self.terminalID = terminalID
    }

    public func setLoyaltyPointsReward(_ loyaltyPointsReward: String) {
        self.loyaltyPointsReward = loyaltyPointsReward
    }

    public func setRemark(_ remark: String) {
        self.remark = remark
    }

    public func setTransactionAcquirerName(_ transactionAcquirerName: String) {
        self.transactionAcquirerName = transactionAcquirerName
    }


    public func setMerchantID(_ merchantID: String) {
        self.merchantID = merchantID
    }


    public func setRetrievalReferenceNumber(_ retrievalReferenceNumber: String) {
        self.retrievalReferenceNumber = retrievalReferenceNumber
    }


    public func setCardEntryMode(_ cardEntryMode: String) {
        self.cardEntryMode = cardEntryMode
    }


    public func setPrintCardholderNameOnReceipt(_ printCardholderNameOnReceipt: String) {
        self.printCardholderNameOnReceipt = printCardholderNameOnReceipt
    }


    public func setMerchantName(_ merchantName: String) {
        self.merchantName = merchantName
    }

    public func setMerchantAddress(_ merchantAddress: String) {
        self.merchantAddress = merchantAddress
    }


    public func setMerchantCity(_ merchantCity: String) {
        self.merchantCity = merchantCity
    }

    public func setPlutusVersion(_ plutusVersion: String) {
        self.plutusVersion = plutusVersion
    }


    public func setAcquirerCode(_ acquirerCode: String) {
        self.acquirerCode = acquirerCode
    }

    public func getAcquirerCode() -> String? {
           return acquirerCode!
       }

    public func setEmiTenure(_ emiTenure: String) {
        self.emiTenure = emiTenure
    }


    public func setEmiProcessingFee(_ emiProcessingFee: String) {
        self.emiProcessingFee = emiProcessingFee
    }


    public func setRewardBalanceAmount(_ rewardBalanceAmount: String) {
        self.rewardBalanceAmount = rewardBalanceAmount
    }


    public func setEmiInterestRate(_ emiInterestRate: String) {
        self.emiInterestRate = emiInterestRate
    }

    public func setChargeSlipPrintData(_ chargeSlipPrintData: String) {
        self.chargeSlipPrintData = chargeSlipPrintData
    }


    public func setCouponCode(_ couponCode: String) {
        self.couponCode = couponCode
    }

    public func setTransactionAmountProcessed(_ transactionAmountProcessed: String) {
        self.transactionAmountProcessed = transactionAmountProcessed
    }


    public func setRfu3(_ rfu3: String) {
        self.rfu3 = rfu3
    }


    public func setSettlementSummary(_ settlementSummary: String) {
        self.settlementSummary = settlementSummary
    }


    public func setDateOfTransaction(_ dateOfTransaction: String) {
        self.dateOfTransaction = dateOfTransaction
    }


    public func setTimeOfTransaction(_ timeOfTransaction: String) {
        self.timeOfTransaction = timeOfTransaction
    }

    public func setTransactionId(_ transactionId: String) {
        self.transactionId = transactionId
    }

    public func setTransactionAmount(_ transactionAmount: String) {
        self.transactionAmount = transactionAmount
    }
 
    public func getTransactionType() -> String? {
        return transactionType!
    }
    
    public func setTransactionType(_ transactionType: String) {
        self.transactionType = transactionType
    }

    public func setReservedField(_ reservedField: String) {
        self.reservedField = reservedField
    }

    public func setEmiProductCategory(_ emiProductCategory: String) {
        self.emiProductCategory = emiProductCategory
    }

    public func setMaskedMobileNumber(_ maskedMobileNumber: String) {
        self.maskedMobileNumber = maskedMobileNumber
    }
    
    public func setEmiProductName(_ emiProductName: String) {
         self.emiProductName = emiProductName
     }

    public func setEmiProductDescription(_ emiProductDescription: String) {
        self.emiProductDescription = emiProductDescription
    }

    public func getImei() -> String? {
        return imei!
    }

    public func setImei(_ imei: String) {
        self.imei = imei
    }
    
    public func setOriginalTransactionAmount(_ originalTransactionAmount: String) {
        self.originalTransactionAmount = originalTransactionAmount
    }
    
    public func setIssuerName(_ issuerName: String) {
        self.issuerName = issuerName
    }
    
    public func setEmiPrincipleAmount(_ emiPrincipleAmount: String) {
        self.emiPrincipleAmount = emiPrincipleAmount
    }

    public func setEmiAmount(_ emiAmount: String) {
        self.emiAmount = emiAmount
    }

    public func setEmiTotalAmount(_ emiTotalAmount: String) {
          self.emiTotalAmount = emiTotalAmount
    }
    
    public func setCustomerEmail(_ customerEmail: String) {
        self.customerEmail = customerEmail
    }
    
    public func setOriginalBillingDetails(_ originalBillingDetails: String) {
        self.originalBillingDetails = originalBillingDetails
    }
    
}
