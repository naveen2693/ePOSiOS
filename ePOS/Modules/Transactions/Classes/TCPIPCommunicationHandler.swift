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
        guard let receivedBuffer = mClient.read(1024*10,timeout:mSendReceiveTimeout)
            else { return nil }
     
        //TODO comment later
        debugPrint(receivedBuffer)

        return receivedBuffer
    }
    
    func ReceiveCompletePacket() -> [Byte]?
    {
        guard var bArrReceivedDataTemp = ReceiveDataFromHost() else  {return nil}
        
        var iLength:Int = 0
        var iOffset:Int = 0
        let iHeaderLength:Int = 7
        
        if(bArrReceivedDataTemp.count < iHeaderLength){
        return nil
        }else {
            iLength = Int(bArrReceivedDataTemp[5] & 0x000000FF)
            iLength <<= 8
            iLength |= Int(bArrReceivedDataTemp[6] & 0x000000FF)
        }
        if (iLength == 0){
            return nil
        }
        if(iLength+iHeaderLength == bArrReceivedDataTemp.count){
            return bArrReceivedDataTemp
        }
        
        var bArrCompletePacket = [Byte](repeating: 0, count: 0)
        bArrCompletePacket.append(contentsOf: Array(bArrReceivedDataTemp[0..<bArrReceivedDataTemp.count]))
        
        iOffset += bArrReceivedDataTemp.count
        
        var iRetryCount:Int = 0
        while((iOffset-iHeaderLength) < iLength){
            bArrReceivedDataTemp = ReceiveDataFromHost()!
            bArrCompletePacket.append(contentsOf: Array(bArrReceivedDataTemp[0..<bArrReceivedDataTemp.count]))
            iOffset = iOffset+bArrReceivedDataTemp.count
            iRetryCount += 1
            
            if(iRetryCount>100){
                break
            }
        }
        
        if((iOffset-iHeaderLength)==iLength){
            let strReceivedData = TransactionUtils.bcd2a(bArrCompletePacket)
            debugPrint("Received Data [\(strReceivedData)]") //TODO Uncomment Later Added for testing
            return bArrCompletePacket
        }
        
        return nil
    }
    
    func disconnect() -> Bool
    {
         mClient.close()
         return true
    }
}
