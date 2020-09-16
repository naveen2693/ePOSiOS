 //
 //  OrderResponse.swift
 //  RapidPayIntegrationFramework
 //
 //  Created by Abhishek on 19/08/20.
 //  Copyright © 2020 Abhishek. All rights reserved.
 //

 import Foundation
  public struct OrderResponse: Codable {
     public let TokenID: String?
    public enum CodingKeys: String, CodingKey {
         case TokenID = "url_data"
     }
 }

 public enum APIError:Error{
     case responseProblem
     case decodingproblem
     case responseError
 }
