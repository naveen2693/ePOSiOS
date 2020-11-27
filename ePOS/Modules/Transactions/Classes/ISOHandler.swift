//
//  ISOHandler.swift
//  ePOS
//
//  Created by Naveen Goyal on 06/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class ISOHandler
{
    func sendISOPacket(_ iso: ISOMessage) -> Bool {
        do {
            debugPrint("Inside SendISO Packet")
            //CConx conx = CConx.GetInstance()
            var bIssent:Bool = false

            var bArrSendDataToHostTemp = [UInt8](repeating:0 , count:10000)
           
            //Pack ISO Packet
            let iReceivedPacketLength = iso.packIt(sendee: &bArrSendDataToHostTemp)
            if (iReceivedPacketLength <= 0) {
                debugPrint("Not received any data from server")
                return false
            }

            //Packet + 7 byte header
            var bArrSendDataToHost = [UInt8](repeating: 0, count: iReceivedPacketLength+7)
                      
            
            // add TPDU and length of message.
            var iOffset = 0x00

            //Lets take connection type WIFI
            iso.m_TPDU[0] = 0x66
            
            //5Bytes TPDU
            bArrSendDataToHost[0...4] = iso.m_TPDU[0...4]
            iOffset += AppConstant.MAX_LEN_TPDU
            
            //Length in 2 Bytes
            bArrSendDataToHost[iOffset] = (UInt8) (iReceivedPacketLength >> 8)
            iOffset += 1
            bArrSendDataToHost[iOffset] = (UInt8) (iReceivedPacketLength)
            iOffset += 1
            
            bArrSendDataToHost[iOffset..<iOffset+iReceivedPacketLength] = bArrSendDataToHostTemp[0..<iReceivedPacketLength]
            
            iOffset += iReceivedPacketLength

            bIssent = TCPIPCommunicator.singleton.SendDataToHost(bArrSendBuffer:bArrSendDataToHost)
            return bIssent
        } catch{
            //CGlobalData.csFinalMsg = "Error in Sending Data to Host"
            fatalError("Exception caught in sendISOPacket")
            return false
        }

    }
    
    func getNextMessage(_ iso:ISOMessage) -> Int{
         do {
              debugPrint("Inside getNextMessage")
              guard let bArrReceivedData = TCPIPCommunicator.singleton.ReceiveCompletePacket()
              else{
                    debugPrint("getNextMessage Failed")
                    return 0
                
               }
               if (!iso.unPackHostDirect(bArrSource:bArrReceivedData)) { return 0}
               guard let strMsgNumber = String(bytes: iso.msgno, encoding: .utf8) else {return 0}
               guard let iMsgNumber:Int = Int(strMsgNumber) else {return 0}
               return iMsgNumber
           }
         catch {
               fatalError("Exception caught in getNextMessage")
               return 0
           }
       }
}

