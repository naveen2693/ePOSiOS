//
//  TCPIPCommunicator.swift
//  ePOS
//
//  Created by Naveen Goyal on 06/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class TCPIPCommunicator
{
    
    static let singleton = TCPIPCommunicationHandler(hostIP: "192.168.43.111",hostPort: 8997,connectionTimeout: 20000,sendReceiveTimeout:120000 ,bIsSSLOn:false)
    
    //Comment above and Uncomment below to run SSL
//    static let singleton = TCPIPCommunicationHandlerSSL(hostIP: "192.168.43.111",hostPort: 8997,connectionTimeout: 60000,sendReceiveTimeout:120000 ,bIsSSLOn:true)

}
