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
    typealias CompletionHandler = (Result<AnyObject,BaseError>) -> Void
    class func checkApiResponseStatus(responseData:Data) -> (message: String?, status: Bool?)?
    {
        if let baseResponse = try? BaseRequest.decoder.decode(BaseResponse.self, from:responseData)
        {
            return (baseResponse.message,baseResponse.status)
        }
        return nil;
    }
    
    
}

enum BaseError: Error {
    case errorMessage(Any)
}


// MARK:- Base Response
public struct BaseResponse:Codable{
    var message:String?;
    var status:Bool?
    var messageId:String?;
    var errorMessageCode:String?
    private enum CodingKeys: String, CodingKey {
        case message = "msg"
        case status = "st"
        case messageId = "msgid"
        case errorMessageCode = "devErrorMessage"
        
    }
}

public enum APIError:Error{
   case responseProblem
   case decodingproblem
   case responseError
   case noNetwork
   
}
