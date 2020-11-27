//
//  CUIHelper.swift
//  ePOS
//
//  Created by Abhishek on 13/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public class CUIHelper{
    
     static func generatePassword(password:String,uuid:String) -> String {
       let hash:String = password + "_" + uuid
       return CryptoHandler.vFnGetSHA256(key:hash)
   }
}
