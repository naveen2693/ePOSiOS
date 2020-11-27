//
//  DailyTxnAmount.swift
//  ePOS
//
//  Created by Vishal Rathore on 24/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation


class DailyTxnAmount: Codable {
    private var date: String = ""
    private var amount: Double = 0

    public func getDate() -> String {
        return date
    }

    public func setDate(_ date: String) {
        self.date = date
    }

    public func getAmount() -> Double {
        return amount
    }

    public func setAmount(_ amount: Double) {
        self.amount = amount
    }
}
