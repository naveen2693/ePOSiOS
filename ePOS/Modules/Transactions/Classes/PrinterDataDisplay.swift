//
//  PrinterDataDisplay.swift
//  ePOS
//
//  Created by Vishal Rathore on 03/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class PrinterDataDisplay: Codable {

    private var printData: String = ""
    private var imageData: [[Byte]] = []
    private var qrcodeData: [String] = []
    private var barcodeData: [String] = []

    public func getPrintData() -> String {
        return printData
    }

    public func setPrintData(_ printData: String) {
        self.printData = printData
    }

    public func getImageData() -> [[Byte]] {
        return imageData
    }

    public func setImageData(_ imageData: [[Byte]]) {
        self.imageData = imageData
    }

    public func getQrcodeData() -> [String] {
        return qrcodeData
    }

    public func setQrcodeData(_ qrcodeData: [String]) {
        self.qrcodeData = qrcodeData
    }

    public func getBarcodeData() -> [String] {
        return barcodeData
    }

    public func setBarcodeData(_ barcodeData: [String]) {
        self.barcodeData = barcodeData
    }
}
