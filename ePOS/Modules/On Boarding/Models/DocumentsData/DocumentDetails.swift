//
//  DocumentDetails.swift
//  ePOS
//
//  Created by Abhishek on 03/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public struct DocumentDetails:Codable{
    var additional:AdditionalItem?
    var business:BusinessItem?
    var individual:IndividualItem?
    private enum CodingKeys: String, CodingKey {
        case additional = "additional"
        case business = "business"
        case individual = "individual"
    }
}
