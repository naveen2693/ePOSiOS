//
//  TCPIPCommunicationHandler.swift
//  ePOS
//
//  Created by Naveen Goyal on 06/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
import SwiftSocket

class TCPIPCommunicationHandler
{
    var mHostIP: String
    var mHostPort: Int32
    var mClient: TCPClient
    var mbIsConnected: Bool = false
    var mbIsSSLOn:Bool
    var mConnectionTimeout:Int
    var mSendReceiveTimeout:Int
    
    
    init(hostIP: String,hostPort: Int32,connectionTimeout: Int,sendReceiveTimeout:Int ,bIsSSLOn:Bool)
    {
        mHostIP=hostIP
        mHostPort=hostPort
        mConnectionTimeout=connectionTimeout
        mSendReceiveTimeout=sendReceiveTimeout
        mbIsSSLOn=bIsSSLOn
        mClient = TCPClient(address: mHostIP, port: mHostPort)
    }
    
    func Connect() -> Bool
    {
        if(mbIsConnected){
        return true
        }
        
        if(mbIsSSLOn){
            //TODO Write code for SSL Communication
            return true
        }
        else{
        switch mClient.connect(timeout: mConnectionTimeout) {
        case .success:
          debugPrint("Connection Success");
          return true;
        case .failure(_):
          debugPrint("Connection Failed");
          return false;
            }
        }
        
    }
    
    func SendDataToHost(bArrSendBuffer: [Byte]) -> Bool
    {
        //guard let client = mClient else { return false}
        switch mClient.send(data:bArrSendBuffer)
        {
        case .success:
            debugPrint("Data Sent Successfully");
            return true;
        case .failure(_):
          return false;
        }
    }
    
    func ReceiveDataFromHost() -> [Byte]?
    {
        //guard let client = mClient else { return nil}
        guard let receivedBuffer = mClient.read(1024*10,timeout:mSendReceiveTimeout)
            else { return nil }
     
        //TODO comment later
        debugPrint(receivedBuffer)

        return receivedBuffer
    }
    
    func ReceiveCompletePacket() -> [Byte]?
    {
        //TODO check for complete packet
        return nil
    }
    
    func disconnect() -> Bool
    {
        //TODO test
         //guard let client = mClient else { return false}
         mClient.close()
         return true
    }
}
