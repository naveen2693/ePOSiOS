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
    var mHostPort: Int
    var mClient: TCPClient?
    var mbIsConnected: Bool
    var mbIsSSLOn:Bool
    var mConnectionTimeout:Int
    var mSendReceiveTimeout:Int
    
    
    init(hostIP: String,hostPort: Int,connectionTimeout: Int,sendReceiveTimeout:Int ,bIsSSLOn:Bool)
    {
        mHostIP=hostIP
        mHostPort=hostPort
        mConnectionTimeout=connectionTimeout
        mSendReceiveTimeout=sendReceiveTimeout
        mbIsSSLOn=bIsSSLOn
    }
    
    func Connect()->Bool
    {
        if(mbIsConnected){
        return true
        }
        
        guard let client = mClient else { return false}
            
        if(mbIsSSLOn){
            //TODO Write code for SSL Communication
        }
        else{
        switch client.connect(timeout: mConnectionTimeout) {
        case .success:
          debugPrint("Connection Success");
          return true;
        case .failure(let error):
          appendToTextField(string: String(describing: error))
          debugPrint("Connection Failed");
          return false;
            }
        }
        
    }
    
    func SendDataToHost(bArrSendBuffer: [Byte])->Bool
    {
        guard let client = mClient else { return false}
        switch client.send(data:bArrSendBuffer)
        {
        case .success:
            debugPrint("Data Sent Successfully");
            return true;
        case .failure(let error):
          appendToTextField(string: String(describing: error))
          return false;
        }
    }
    
    func ReceiveDataFromHost()->[Byte]
    {
        guard let client = client else { return ""}
        guard let receivedBuffer = client.read(1024*10,timeout:mSendReceiveTimeout)
            else { return nil }
     
        //TODO comment later
        debugPrint(receivedBuffer)

        return receivedBuffer
    }
    
    func ReceiveCompletePacket()->[Byte]
    {
        //TODO check for complete packet
    }
    
    func disconnect()->Bool
    {
        //TODO test
         guard let client = mClient else { return false}
         client.close()
         return true
    }
}
