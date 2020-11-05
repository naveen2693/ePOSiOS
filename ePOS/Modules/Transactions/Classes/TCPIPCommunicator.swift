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
    static let singleton = TCPIPCommunicationHandler(hostIP: "192.168.1.202",hostPort: 8997,connectionTimeout: 60000,sendReceiveTimeout:120000 ,bIsSSLOn:false)
    
//    func connect()->Bool
//    {
//        if TCPIPCommunicator.singleton.mbIsConnected == true
//        {
//            return true
//        }
//        else
//        {
//            //extract IP Port from file and connect
//            return TCPIPCommunicator.singleton.Connect()
//        }
//    }
}
