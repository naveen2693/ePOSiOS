//
//  ISOProcessor.swift
//  ePOS
//
//  Created by Naveen Goyal on 06/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class ISOProcessor
{
    func DoHUBActivation() -> Bool {

        debugPrint("Inside DoHubActivation")
        //CConx conx = CConx.GetInstance();

        _ = GlobalData.singleton

        //globalData.csFinalMsg = "Activation Failed!";
        //globalData.m_csFinalMsgDisplay58 = "";

        do {
//            if !conx.requestForDial()
//            {
//                //globalData.csFinalMsg = "Connection Failed! Please Check your Internet Connectivity";
//                return false;
//            } else if (!conx.waitForConnect()) {
//                CGlobalData.csFinalMsg = "Connection Failed!";
//                conx.disconnect();
//                return AppConst.FALSE;
//            }

            if(!TCPIPCommunicator.singleton.Connect())
            {
                return false
            }
            
            //CGlobalData.updateCustomProgressDialog("Activating");

            _ = ISOHandler();
            let iso440 = ISO440Activation();
            iso440.ISO440C();
            debugPrint("Sending ISO 440 packet.")
            iso440.SetActivationRequestData();

            if (/*!isohandler.sendISOPacket(iso440)*/true)
            {
                debugPrint("Sending ISO 440 packet Failed")
                //CGlobalData.csFinalMsg = "Activation Failed";
                //iso440.CISOMsgD();
                _ = TCPIPCommunicator.singleton.disconnect()
                return false
            }
            if (/*(isohandler.getNextMessage(iso440) != 450) || !iso440.IsOK()*/ true)
             {
                debugPrint("Receiving ISO 440 packet. Failed")
                //CGlobalData.csFinalMsg = CGlobalData.m_csFinalMsgDisplay58.trim();
//                if (CGlobalData.csFinalMsg.isEmpty()) {
//                    CGlobalData.csFinalMsg = "Activation Failed";
//                }
                //iso440.ISOMsgD();
                _ = TCPIPCommunicator.singleton.disconnect()
                return false;
            }
            _ = iso440.bFnGetTokenDataForHUB();
            //CGlobalData.csFinalMsg = "Activation Successful. Client ID: " + ip440.m_sClientID;
            //ip440.CISOMsgD();
            _ = TCPIPCommunicator.singleton.disconnect()
            return true
        }
        catch
        {
            fatalError("Exception caught in DoHUBActivation()")
            //conx.disconnect();
            return false
        }

    }
}
