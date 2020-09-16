//
//  BaseRequest.swift
//  ePOS
//
//  Created by Abhishek on 13/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public class BaseRequest:Codable {
      var headerMap:Dictionary<String,String>?=nil;
      var queryMap:Dictionary<String,String>?=nil;
}
