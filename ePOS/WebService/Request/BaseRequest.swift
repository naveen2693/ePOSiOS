//
//  BaseRequest.swift
//  ePOS
//
//  Created by Abhishek on 19/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
import Moya
public class BaseRequest{
    static var objMoyaApi = MoyaProvider<ApiService>()
    static let decoder = JSONDecoder()
    typealias CompletionHandler = (Result<AnyObject,Error>) -> Void
    
}
