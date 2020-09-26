//
//  CityData.swift
//  ePOS
//
//  Created by Matra Sharma on 26/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

struct City: Codable {
    var name: String
    var cityCode: String
    var xCoordinate: Float
    var yCoordinate: Float
    
    private enum CodingKeys: String, CodingKey {
        case name
        case cityCode
        case xCoordinate
        case yCoordinate
    }
}

struct State: Codable {
    var stateCode: String
    var state: String
    var cities: [City]
    
    private enum CodingKeys: String, CodingKey {
        case stateCode
        case state
        case cities
    }
    
    func isMatching(with searchText: String) -> Bool {
        let searchString = searchText.lowercased()
        return  self.stateCode.lowercased().contains(searchString)
    }
}

struct StateData: Codable {
    var states: [State]
    var lastModifiedDate: Double
    
    private enum CodingKeys: String, CodingKey {
        case lastModifiedDate
        case states
    }
}
