//
//  TCPIPCommunicationHandlerSSL.swift
//  ePOS
//
//  Created by Naveen Goyal on 02/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
import SwiftSocket

class TCPIPCommunicationHandlerSSL : NSObject, StreamDelegate
{
    var mHostIP: String
    var mHostPort: Int32
    var mbIsConnected: Bool = false
    var mbIsSSLOn:Bool
    var mConnectionTimeout:Int
    var mSendReceiveTimeout:Int
    
    // Input and output streams for socket
    var inputStream: InputStream?
    var outputStream: OutputStream?

    // Secondary delegate reference to prevent ARC deallocating the NSStreamDelegate
     var inputDelegate: StreamDelegate?
     var outputDelegate: StreamDelegate?
    
    
    init(hostIP: String,hostPort: Int32,connectionTimeout: Int,sendReceiveTimeout:Int ,bIsSSLOn:Bool)
    {
        mHostIP=hostIP
        mHostPort=hostPort
        mConnectionTimeout=connectionTimeout
        mSendReceiveTimeout=sendReceiveTimeout
        mbIsSSLOn=bIsSSLOn
    }
    
    func Connect() -> Bool
    {
        if(mbIsConnected){
        return true
        }
        
        // Specify host and port number. Get reference to newly created socket streams both in and out
        Stream.getStreamsToHost(withName:mHostIP, port: Int(mHostPort), inputStream: &inputStream, outputStream: &outputStream)

        // Create strong delegate reference to stop ARC deallocating the object
        inputDelegate = self
        outputDelegate = self

        // Now that we have a strong reference, assign the object to the stream delegates
        inputStream!.delegate = inputDelegate
        outputStream!.delegate = outputDelegate

        // This doesn't work because of arc memory management. Thats why another strong reference above is needed.
        //inputStream!.delegate = self
        //outputStream!.delegate = self

        // Schedule our run loops. This is needed so that we can receive StreamEvents
        inputStream!.schedule(in:RunLoop.main, forMode: RunLoop.Mode.default)
        outputStream!.schedule(in:RunLoop.main, forMode: RunLoop.Mode.default)

        // Enable SSL/TLS on the streams
        inputStream!.setProperty(kCFStreamSocketSecurityLevelNegotiatedSSL, forKey:  Stream.PropertyKey.socketSecurityLevelKey)
        outputStream!.setProperty(kCFStreamSocketSecurityLevelNegotiatedSSL, forKey: Stream.PropertyKey.socketSecurityLevelKey)

        // Defin custom SSL/TLS settings
        let sslSettings : [NSString: Any] = [
            // NSStream automatically sets up the socket, the streams and creates a trust object and evaulates it before you even get a chance to check the trust yourself. Only proper SSL certificates will work with this method. If you have a self signed certificate like I do, you need to disable the trust check here and evaulate the trust against your custom root CA yourself.
            NSString(format: kCFStreamSSLValidatesCertificateChain): kCFBooleanFalse,
            //
            NSString(format: kCFStreamSSLPeerName): kCFNull,
            // We are an SSL/TLS client, not a server
            NSString(format: kCFStreamSSLIsServer): kCFBooleanFalse
        ]

        // Set the SSL/TLS settingson the streams
        inputStream!.setProperty(sslSettings, forKey:  kCFStreamPropertySSLSettings as Stream.PropertyKey)
        outputStream!.setProperty(sslSettings, forKey: kCFStreamPropertySSLSettings as Stream.PropertyKey)

        // Open the streams
        inputStream!.open()
        outputStream!.open()
        mbIsConnected = true
        return true
    }
    
    func SendDataToHost(bArrSendBuffer: [Byte]) -> Bool
    {
       var writtenBytes = outputStream?.write(bArrSendBuffer, maxLength: bArrSendBuffer.count)
       if(writtenBytes == bArrSendBuffer.count)
       {
         debugPrint("Data Written Successfully")
         return true
       }
       else
       {
         debugPrint("Data Not Written")
         return false
       }
    }
    
    func ReceiveDataFromHost() -> [Byte]?
    {
       var maxReadLength = 1024*10
       var receivedBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
       var readBytes = inputStream?.read(receivedBuffer, maxLength: maxReadLength)
        
       if(readBytes!>0)
       {
            // Mutable buffer pointer from data:
           let tempBuffer = UnsafeMutableBufferPointer(start: receivedBuffer, count: readBytes!)
           // Array from mutable buffer pointer
           let bytes = Array(tempBuffer)
           return bytes
       }
       else
       {
            return nil
       }
        
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
            debugPrint("Received Data [\(String(describing: strReceivedData))]") //TODO Uncomment Later Added for testing
            return bArrCompletePacket
        }
        
        return nil
    }
    
    func disconnect() -> Bool
    {
        inputStream?.close()
        outputStream?.close()
        mbIsConnected = false
        return true
        
    }
}

