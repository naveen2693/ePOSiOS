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
    var m_bDisconnectFlag: Bool = true
    var m_bReward: Int = AppConstant.FALSE
    
    func DoHUBActivation() -> Bool {

        debugPrint("Inside DoHubActivation")

        let globalData = GlobalData.singleton

        globalData.mFinalMsgActivation = "Activation Failed!";
        globalData.mFinalMsgDisplayField58 = "";

        do {
            
            if(!TCPIPCommunicator.singleton.Connect())
            {
                return false
            }
            //CGlobalData.updateCustomProgressDialog("Activating");

            let isohandler = ISOHandler();
            let iso440 = ISO440Activation();
            iso440.ISO440C();
            debugPrint("Sending ISO 440 packet.")
            iso440.SetActivationRequestData();

            if (!isohandler.sendISOPacket(iso440))
            {
                debugPrint("Sending ISO 440 packet Failed")
                globalData.mFinalMsgActivation = "Activation Failed!";
                iso440.CISOMsgD();
                _ = TCPIPCommunicator.singleton.disconnect()
                return false
            }
            if ((isohandler.getNextMessage(iso440) != 450) || iso440.IsOK() != true)
            {
                debugPrint("Receiving ISO 440 packet. Failed")
                globalData.mFinalMsgActivation = globalData.mFinalMsgDisplayField58
                if (globalData.mFinalMsgActivation.isEmpty) {
                    globalData.mFinalMsgActivation = "Activation Failed";
                }
                iso440.CISOMsgD();
                _ = TCPIPCommunicator.singleton.disconnect()
                return false;
            }
            _ = iso440.bFnGetTokenDataForHUB();
            globalData.mFinalMsgActivation = "Activation Successful. Client ID: " + iso440.m_sClientID;
            debugPrint(globalData.mFinalMsgActivation)
            iso440.CISOMsgD();
            _ = TCPIPCommunicator.singleton.disconnect()
            return true
        }
        catch
        {
            fatalError("Exception caught in DoHUBActivation()")
            _ = TCPIPCommunicator.singleton.disconnect()
            //conx.disconnect();
            return false
        }

    }
    
    //MARK:- DoHUBInitialization() -> Int
    func DoHUBInitialization() -> Int {

        GlobalData.m_csFinalMsgDoHubInitialization = StringConstant.initialization_fail
        GlobalData.m_bIsFiled58Absent = false
        GlobalData.m_csFinalMsgDisplay58 = "";

        //CConx conx = CConx.GetInstance();
        do {

            if(!TCPIPCommunicator.singleton.Connect())
            {
                return RetVal.RET_CONX_FAILED
            }
            
            //TODO: Conx yet to Add
            /*if (!conx.requestForDial(iHostID)) {
                CGlobalData.m_csFinalMsgDoHubInitialization = "Connection Failed! Please Check Data Connection";
                return RetVal.RET_CONX_FAILED;
            } else if (!conx.waitForConnect()) {
                CGlobalData.m_csFinalMsgDoHubInitialization = "Connection Failed";
                conx.disconnect();
                return RetVal.RET_NOT_OK;
            }*/
            //if (!CConx.isSerial()) {
                let t_contentServerParamData: ContentServerParamData? = GlobalData.ReadContentServerParamFile()
                if (t_contentServerParamData != nil) {
                    if (t_contentServerParamData!.m_bIsContentSyncEnabled) {
                        //  TODO: Yet to Add
                        //  ContentServer contentServer = ContentServer.GetInstance();
                        //  contentServer.DoContentSync();
                    }
                }
            //}

            GlobalData.updateCustomProgressDialog(msg: "Initializing!");
            let iso = ISOHandler()
                /************* ISO 320/330 for INITIALIZATION ************************/
            let ip320HostComm = ISO320Initialization()
            ip320HostComm.Start()
            ip320HostComm.CISO320C()

            let globalData = GlobalData.singleton
            var uchArrBitmap320HUB = [Byte](repeating: 0x00, count: AppConstant.LEN_INITIALIZATION_BITMAP)

            repeat {
                uchArrBitmap320HUB = Array(globalData.m_sMasterParamData!.m_uchArrBitmap320HUBChangeNumber[0 ..< AppConstant.LEN_INITIALIZATION_BITMAP])
                //System.arraycopy(GlobalData.m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber, 0, uchArrBitmap320HUB, 0, AppConst.LEN_INITIALIZATION_BITMAP);

                if (ip320HostComm.m_iChangeNumber == ISO320ChangeNumberConstants.HOST_CONTENT_DOWNLOAD) {
                    //This extra check has been added in order to check if content sync process is enabled for this client or not
                    //as we do in case of content syncing from web service .
                    let t_contentServerParamData: ContentServerParamData? = GlobalData.ReadContentServerParamFile()
                    
                    if (/*(!CConx.isSerial()) || TODO: Conx yet to add */
                        (t_contentServerParamData == nil) ||
                        (t_contentServerParamData!.m_bIsContentSyncEnabled == false)) {
                            ip320HostComm.m_iChangeNumber += 1
                    }
                }
                
                if (ip320HostComm.m_iChangeNumber == ISO320ChangeNumberConstants.HUB_PINEKEY_EXCHANGE) {
                    ip320HostComm.m_iChangeNumber += 2;//jump to next packet as key exchange not required in case of didPos
                }
                    
                //Code block changed to forward shift the change number logic.
                let bSecond = Byte(0x00000080 >> ((ip320HostComm.m_iChangeNumber - 1) % 8))
                let iTemp = Byte(uchArrBitmap320HUB[(ip320HostComm.m_iChangeNumber - 1) / 8] & bSecond);
                if (iTemp == 0) {
                    debugPrint("change num[\(ip320HostComm.m_iChangeNumber)] is not loaded")
                        ip320HostComm.m_iChangeNumber += 1
                        continue;
                }

                debugPrint("Sending ISO 320 packet.");
                if (!iso.sendISOPacket(ip320HostComm)) {
                    GlobalData.m_csFinalMsgDoHubInitialization = StringConstant.initialization_fail
                    ip320HostComm.CISOMsgD()
                    ip320HostComm.CISO320MsgD()
                    _ = TCPIPCommunicator.singleton.disconnect()
                    //TODO: Conx Yet to Add
                    //conx.disconnect()
                    debugPrint("ISO 320 send data failed.")
                    return RetVal.RET_NOT_OK
                }
                
                debugPrint("Recieving ISO 330 packet.");
                if (iso.getNextMessage(ip320HostComm) != 330) {
                    debugPrint("ISO 330 recv data failed. != 330")
                    GlobalData.m_csFinalMsgDoHubInitialization = GlobalData.m_csFinalMsgDisplay58.trimmingCharacters(in: .whitespacesAndNewlines)
                    if (GlobalData.m_csFinalMsgDoHubInitialization.isEmpty) {
                        GlobalData.m_csFinalMsgDoHubInitialization = StringConstant.initialization_fail
                    }
                    ip320HostComm.CISOMsgD()
                    ip320HostComm.CISO320MsgD()
                        
                    //conx.disconnect()
                    return RetVal.RET_NOT_OK
                }
                if (!ip320HostComm.ProcessData()) {
                    debugPrint("ProcessData Failed.")
                    GlobalData.m_csFinalMsgDoHubInitialization = GlobalData.m_csFinalMsgDisplay58;
                    if (GlobalData.m_csFinalMsgDoHubInitialization.isEmpty) {
                        GlobalData.m_csFinalMsgDoHubInitialization = StringConstant.initialization_fail
                    }
                    ip320HostComm.CISOMsgD()
                    ip320HostComm.CISO320MsgD()
                    //TODO: Conx yet to add
                    _ = TCPIPCommunicator.singleton.disconnect()
                    //conx.disconnect()
                    return RetVal.RET_NOT_OK
                } else {
                    ip320HostComm.CISOMsgD()
                }
                }
            while (ip320HostComm.m_iChangeNumber <= ISO320ChangeNumberConstants.HOST_COLORED_IMAGE_DOWNLOAD)//);EDC_LOG_SHIPPING_DETAILS_DOWNLOAD


            ip320HostComm.CISO320MsgD()
            if (m_bDisconnectFlag)
            {
                _ = TCPIPCommunicator.singleton.disconnect()
                //TODO: Conx Yet to Add
                //conx.disconnect()
            }
            
            return RetVal.RET_OK
        } catch {
                debugPrint("Exception Occurred : \(error)")
                GlobalData.m_csFinalMsgDoHubInitialization = StringConstant.initialization_fail
                _ = TCPIPCommunicator.singleton.disconnect()
                //TODO: Conx Yet to Add
                //conx.disconnect()
                return RetVal.RET_NOT_OK
        }
    }
    
}
