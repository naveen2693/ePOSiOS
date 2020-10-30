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
            //CConx conx = CConx.GetInstance();
            var bIssent:Bool = false;

            var bArrSendDataToHostTemp = [UInt8](repeating:0 , count:10000)
           
            //Pack ISO Packet
            let iReceivedPacketLength = iso.packIt(sendee: &bArrSendDataToHostTemp);
            if (iReceivedPacketLength <= 0) {
                debugPrint("Not received any data from server")
                return false;
            }
            
            
            // add TPDU and length of message according to connection type
//            switch (conx.m_iConnType) {
//                case AppConst.DIALUP_SERIAL:
//                    ip.m_TPDU[0] = (byte) TPDUConnectionType.TPDU_DIALUP_SERIAL;
//                    break;
//
//                case AppConst.DIALUP_WIFI:
//                    ip.m_TPDU[0] = (byte) TPDUConnectionType.TPDU_DIALUP_WIFI;
//                    break;
//
//                case AppConst.DIALUP_GPRS:
//                    ip.m_TPDU[0] = (byte) TPDUConnectionType.TPDU_DIALUP_GPRS;
//                    break;
//
//                case AppConst.DIALUP_ETHERNET:
//                    ip.m_TPDU[0] = (byte) TPDUConnectionType.TPDU_DIALUP_ETHERNET;
//                    break;
//                default:
//                    ip.m_TPDU[0] = (byte) TPDUConnectionType.TPDU_DIALUP_SERIAL;
//                    break;
//            }

            //Packet + 7 byte header
            var bArrSendDataToHost = [UInt8](repeating: 0, count: iReceivedPacketLength+7)
                      
            
            // add TPDU and length of message.
            var iOffset = 0x00;

            //Lets take connection type WIFI
            iso.m_TPDU[0] = 2
            
            bArrSendDataToHost[0...4] = iso.m_TPDU[0...4]
            
            //Length in 2 Bytes
            bArrSendDataToHost[0] = (UInt8) (iReceivedPacketLength >> 8)
            bArrSendDataToHost[1] = (UInt8) (iReceivedPacketLength)
            
            bArrSendDataToHost[7...iReceivedPacketLength-1] = bArrSendDataToHostTemp[0...iReceivedPacketLength-1]
            
            iOffset += iReceivedPacketLength;

            bIssent = TCPIPCommunicator.singleton.SendDataToHost(bArrSendBuffer:bArrSendDataToHost)
            return bIssent;
        } catch{
            //CGlobalData.csFinalMsg = "Error in Sending Data to Host";
            fatalError("Exception caught in sendISOPacket")
            return false
        }

    }
    
    func getNextMessage(_ iso:ISOMessage) -> Int{

           do {
               debugPrint("Inside getNextMessage")
               
            guard TCPIPCommunicator.singleton.ReceiveDataFromHost() != nil
              else {
                    debugPrint("getNextMessage Failed")
                    return 0
                }

                if (false/*!iso.unPackHostDirect(bArrReceivedData)*/) {
                   return 0;
               }

            let msgNumber:Int = 440/*Integer.parseInt(new String(ip.msgno))*/;
            return msgNumber;
           } catch  {
               //CGlobalData.csFinalMsg = "Unknown Error";
               //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(ex));
               fatalError("Exception caught in getNextMessage")
               return 0;
           }

       }

}

