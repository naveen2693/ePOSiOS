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
    
    var objISO220SwipeTxn: CISO220SwipeTxn?
    
    func DoHUBActivation() -> Bool {

        debugPrint("Inside DoHubActivation")

        let globalData = GlobalData.singleton

        globalData.mFinalMsgActivation = "Activation Failed!"
        globalData.mFinalMsgDisplayField58 = ""

        do {
            
            if(!TCPIPCommunicator.singleton.Connect())
            {
                globalData.mFinalMsgActivation = "Connection Failed";
                return false
            }
            //CGlobalData.updateCustomProgressDialog("Activating")

            let isohandler = ISOHandler()
            let iso440 = ISO440Activation()
            iso440.ISO440C()
            debugPrint("Sending ISO 440 packet.")
            iso440.SetActivationRequestData()

            if (!isohandler.sendISOPacket(iso440))
            {
                debugPrint("Sending ISO 440 packet Failed")
                globalData.mFinalMsgActivation = "Activation Failed!"
                iso440.CISOMsgD()
                _ = TCPIPCommunicator.singleton.disconnect()
                return false
            }
            if ((isohandler.getNextMessage(iso440) != 450) || iso440.IsOK() != true)
            {
                debugPrint("Receiving ISO 440 packet. Failed")
                globalData.mFinalMsgActivation = globalData.mFinalMsgDisplayField58
                if (globalData.mFinalMsgActivation.isEmpty) {
                    globalData.mFinalMsgActivation = "Activation Failed"
                }
                iso440.CISOMsgD()
                _ = TCPIPCommunicator.singleton.disconnect()
                return false
            }
            _ = iso440.bFnGetTokenDataForHUB()
            globalData.mFinalMsgActivation = "Activation Successful. Client ID: " + iso440.m_sClientID
            debugPrint(globalData.mFinalMsgActivation)
            iso440.CISOMsgD()
            _ = TCPIPCommunicator.singleton.disconnect()
            return true
        }
        catch
        {
            fatalError("Exception caught in DoHUBActivation()")
            _ = TCPIPCommunicator.singleton.disconnect()
            //conx.disconnect()
            return false
        }

    }
    
    //MARK:- DoHUBInitialization() -> Int
    func DoHUBInitialization() -> Int {

        GlobalData.m_csFinalMsgDoHubInitialization = StringConstant.initialization_fail
        GlobalData.m_bIsFiled58Absent = false
        GlobalData.m_csFinalMsgDisplay58 = ""

        //CConx conx = CConx.GetInstance()
        do {

            if(!TCPIPCommunicator.singleton.Connect())
            {
                return RetVal.RET_CONX_FAILED
            }
            
            //TODO: Conx yet to Add
            /*if (!conx.requestForDial(iHostID)) {
                CGlobalData.m_csFinalMsgDoHubInitialization = "Connection Failed! Please Check Data Connection"
                return RetVal.RET_CONX_FAILED
            } else if (!conx.waitForConnect()) {
                CGlobalData.m_csFinalMsgDoHubInitialization = "Connection Failed"
                conx.disconnect()
                return RetVal.RET_NOT_OK
            }*/
            //if (!CConx.isSerial()) {
            let t_contentServerParamData: ContentServerParamData? = GlobalData.ReadContentServerParamFile()
            if (t_contentServerParamData != nil) {
                if (t_contentServerParamData!.m_bIsContentSyncEnabled) {
                    //  TODO: Yet to Add
                    //  ContentServer contentServer = ContentServer.GetInstance()
                    //  contentServer.DoContentSync()
                }
            }
            //}

            GlobalData.updateCustomProgressDialog(msg: "Initializing!")
            let iso = ISOHandler()
                /************* ISO 320/330 for INITIALIZATION ************************/
            let ip320HostComm = ISO320Initialization()
            ip320HostComm.Start()
            ip320HostComm.CISO320C()

            let globalData = GlobalData.singleton
            var uchArrBitmap320HUB = [Byte](repeating: 0x00, count: AppConstant.LEN_INITIALIZATION_BITMAP)

            repeat {
                uchArrBitmap320HUB = Array(globalData.m_sMasterParamData!.m_uchArrBitmap320HUBChangeNumber[0 ..< AppConstant.LEN_INITIALIZATION_BITMAP])
                //System.arraycopy(GlobalData.m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber, 0, uchArrBitmap320HUB, 0, AppConst.LEN_INITIALIZATION_BITMAP)

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
                    ip320HostComm.m_iChangeNumber += 2//jump to next packet as key exchange not required in case of didPos
                }
                    
                //Code block changed to forward shift the change number logic.
                let bSecond = Byte(0x00000080 >> ((ip320HostComm.m_iChangeNumber - 1) % 8))
                let iTemp = Byte(uchArrBitmap320HUB[(ip320HostComm.m_iChangeNumber - 1) / 8] & bSecond)
                if (iTemp == 0) {
                    debugPrint("change num[\(ip320HostComm.m_iChangeNumber)] is not loaded")
                        ip320HostComm.m_iChangeNumber += 1
                        continue
                }

                debugPrint("Sending ISO 320 packet.")
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
                
                debugPrint("Recieving ISO 330 packet.")
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
                    GlobalData.m_csFinalMsgDoHubInitialization = GlobalData.m_csFinalMsgDisplay58
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
                while (ip320HostComm.m_iChangeNumber <= ISO320ChangeNumberConstants.HOST_COLORED_IMAGE_DOWNLOAD)//)EDC_LOG_SHIPPING_DETAILS_DOWNLOAD


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
    
    //MARK:- DoHubSettlement() -> Int
    func DoHubSettlement() -> Int {
        
        //TODO: Conx yet to Add
        //let conx = CConx.singleton
        do {
            
            if(!TCPIPCommunicator.singleton.Connect())
            {
                return RetVal.RET_CONX_FAILED
            }
            
            GlobalData.m_csFinalMsgBatchSettlement = "Settlement Failed!"
            GlobalData.m_bIsTxnDeclined = false
            GlobalData.m_bIsFiled58Absent = false
            GlobalData.m_csFinalMsgDisplay58 = ""

            //TODO: Conx yet to Add
            /*
            if (!conx.requestForDial()) {
                GlobalData.m_csFinalMsgBatchSettlement = "Connection Failed! Please Check Data Connection"
                return RetVal.RET_CONX_FAILED
            } else if (!conx.waitForConnect()) {
                GlobalData.m_csFinalMsgBatchSettlement = "Connection Failed"
                
                //TODO: Conx Yet to Add
                //_ = conx.disconnect()
                return AppConstant.FALSE
            }*/


            if (AppConstant.TRUE == IsReversalPending()) {
                if (AppConstant.FALSE == DoReversal()) {
                    GlobalData.m_csFinalMsgBatchSettlement = GlobalData.m_csFinalMsgDoReversal
                    return AppConstant.FALSE
                }
            } else {
                //Check for Pending SignUpload to be sent first
                if (AppConstant.TRUE == IsSignUploadPending()) {
                    if (AppConstant.FALSE == DoSignUploadTxn()) {
                        GlobalData.m_csFinalMsgBatchSettlement = GlobalData.m_csFinalMsgDoSignUpload
                        return AppConstant.FALSE
                    }
                }
            }

            GlobalData.updateCustomProgressDialog(msg: "Settling Batch!!")
            let iso = ISOHandler()

            let ip500 = ISO500Settlement()
            ip500.Start()
            repeat {
                debugPrint("Sending ISO 500 packet.")
                if (!iso.sendISOPacket(ip500)) {
                    GlobalData.m_csFinalMsgBatchSettlement = "Settlement Failed!"
                    ip500.CISOMsgD()
                    
                    _ = TCPIPCommunicator.singleton.disconnect()
                    //TODO: Conx Yet to Add
                    //conx.disconnect()
                    debugPrint("ISO 500 send data failed.")
                    return AppConstant.FALSE
                }
                debugPrint("Recieving ISO 510 packet.")
                if (iso.getNextMessage(ip500) != 510) {
                    debugPrint("ISO 510 recv data failed.")
                    GlobalData.m_csFinalMsgBatchSettlement = GlobalData.m_csFinalMsgDisplay58.trimmingCharacters(in: .whitespacesAndNewlines)
                    if (GlobalData.m_csFinalMsgBatchSettlement.isEmpty) {
                        GlobalData.m_csFinalMsgBatchSettlement = "Settlement Failed!"
                    }
                    ip500.CISOMsgD()
                    
                    _ = TCPIPCommunicator.singleton.disconnect()
                    //TODO: Conx Yet to Add
                    //_ = conx.disconnect()
                    return AppConstant.FALSE
                }
                if (!ip500.ProcessData()) {
                    if (GlobalData.m_bIsTxnDeclined && GlobalData.m_bIsFiled58Absent) {
                        GlobalData.m_csFinalMsgBatchSettlement = "Settlement declined"
                    } else if (!GlobalData.m_bIsTxnDeclined) {
                        GlobalData.m_csFinalMsgBatchSettlement = "Settlement Failed"
                    }

                    ip500.CISOMsgD()
                    
                    _ = TCPIPCommunicator.singleton.disconnect()
                    //TODO: Conx Yet to Add
                    //_ = conx.disconnect()
                    debugPrint("ISO 510 recv data failed")
                    return 0
                }

                ip500.CISOMsgD()

            } while (ip500.m_iChangeNumber != 2) //define exit condition

            //if Printing via PAD Controller disconnect online session
            //The disconnect is done to print chargeslip on PADController
            if (ip500.m_bField7PrintPAD) {
                _ = TCPIPCommunicator.singleton.disconnect()
                //TODO: Conx Yet to Add
                //conx.disconnect()
            }

            //check for DR Flag to be true
            let globalData = GlobalData.singleton
            let sParamData: TerminalParamData = globalData.ReadParamFile()!

            // IF DR UPLOAD is Requested by HOST
            if (true == sParamData.m_bIsDRPending) {
                //send 800 packet To Get ROC for DR Upload to start from
                var iRetVal: Int = DoDRTxn()

                //if 800 succesful, check for DR Upload Required or not
                //If there are more ROCs left to be uploaded then upload
                //otherwise return from here.
                if (AppConstant.TRUE == iRetVal) {
                    //if last roc in out txn table is greater than Hosts last roc,
                    // then upload last txns one by one.
                    if (CheckDRUploadRequired() > 0) {
                        iRetVal = DoDRUploadTxn()
                    }
                }

                //SET DR Upload Flag False in Txn File
                var tParamData: TerminalParamData = globalData.ReadParamFile()!
                tParamData.m_bIsDRPending = false
                _ = globalData.WriteParamFile(listParamData: tParamData)

                //clear the connection and return AppConst.FALSE as
                //batch is locked and no sync possible
                _ = TCPIPCommunicator.singleton.disconnect()
                
                //TODO: Conx Yet to Add
                //_ = conx.disconnect()
                return AppConstant.FALSE
            }

            if (m_bDisconnectFlag)
            {
                _ = TCPIPCommunicator.singleton.disconnect()
                //TODO: Conx Yet to Add
                //_  = conx.disconnect()
            }
            
            if (!ip500.AfterDataExchange()) {
                GlobalData.m_csFinalMsgBatchSettlement = "AfterDataExchange failed"
                debugPrint("AfterDataExchange failed")
                _ = TCPIPCommunicator.singleton.disconnect()
                //TODO: Conx Yet to Add
                //_  = conx.disconnect()
                
                return AppConstant.FALSE
            }
        } catch {
            debugPrint("Exception Occurred : \(error)")
            GlobalData.m_csFinalMsgBatchSettlement = "Settlement Failed"
            
            _ = TCPIPCommunicator.singleton.disconnect()
           
            //TODO: Conx Yet to Add
            //_ = conx.disconnect()
            return AppConstant.FALSE
        }

        return AppConstant.TRUE

    }

    //MARK:- IsReversalPending() -> Int
    func IsReversalPending() -> Int {
        debugPrint("Inside method IsReversalPending")
        let globalData = GlobalData.singleton

        let strTxnFileName: String = String(format: "%@", FileNameConstants.TRANSACTIONFILENAME)
        if (!FileSystem.IsFileExist(strFileName: strTxnFileName)) {
            debugPrint("File NOT EXIST[\(strTxnFileName)]")
            return AppConstant.FALSE
        }
        //Read the last Txn Entry
        let sLastTxnData: TerminalTransactionData = globalData.ReadLastTxnEntry()!
        if (sLastTxnData == nil) {
            debugPrint("Got Last Transaction data null")
            return AppConstant.FALSE
        }
        //If REVERSAL is pending return true
        if (sLastTxnData.bIsReversalPending) {
            debugPrint("REVERSAL PENDING FOR LAST TXN")
            return AppConstant.TRUE
        }
        debugPrint("No reversal pending")
        return AppConstant.FALSE
    }

    //MARK:- SetCommunicationParam(_ disconnectFlag: Bool) -> Int
    func SetCommunicationParam(_ disconnectFlag: Bool) -> Int {
        //disconnectFlag true-- disconnect the session after sending one packet
        //false -- multiple packets had to be sent so disconnected later
        m_bDisconnectFlag = disconnectFlag
        return AppConstant.API_RESULT_SUCCEEDED
    }
    
    //MARK:- IsSignUploadPending() -> Int
    func IsSignUploadPending() -> Int {

        debugPrint("Inside IsSignUploadPending")

        let globalData = GlobalData.singleton
        let strTxnFileName = String(format: "%@", FileNameConstants.TRANSACTIONFILENAME)

        if (!FileSystem.IsFileExist(strFileName: strTxnFileName)) {
            debugPrint("Sign File NOT EXIST[\(strTxnFileName)]")
            return AppConstant.FALSE
        }

        //Read the last Txn Entry
        let sLastTxnData: TerminalTransactionData = globalData.ReadLastTxnEntry()!
        if (sLastTxnData == nil) {
            return AppConstant.FALSE
        }

        debugPrint("sLastTxnData.bIsSignUploaded[\(sLastTxnData.bIsSignUploaded)]")

        debugPrint("sLastTxnData.bIsSignatureCapturedForTransaction[\(sLastTxnData.bIsSignatureCapturedForTransaction)]")

        if (!sLastTxnData.bIsSignatureCapturedForTransaction) {
            return AppConstant.FALSE
        }

        if (!sLastTxnData.bIsSignUploaded) {
            debugPrint("Signature upload PENDING FOR LAST TXN")
            return AppConstant.TRUE
        }
        return AppConstant.FALSE
    }
    
    //MARK:- CheckDRUploadRequired() -> Int
    func CheckDRUploadRequired() -> Int {

        debugPrint("CheckDRUploadRequired")
        let globalData = GlobalData.singleton

        let sParamData: TerminalParamData = globalData.ReadParamFile()!
        debugPrint("sParamData.m_ulDRLastDownloadedROC[\(sParamData.m_ulDRLastDownloadedROC)]")
        debugPrint("sParamData.m_ulDRLastUploadedROC[\(sParamData.m_ulDRLastUploadedROC)]")

        if (sParamData.m_ulDRLastDownloadedROC > sParamData.m_ulDRLastUploadedROC) {
            return AppConstant.TRUE
        } else {
            return AppConstant.FALSE
        }
    }
    
    
    func DoHubOnlineTxn() -> Int {
        
        //TODO: Conx yet to Add
        //let conx = CConx.singleton
        do {
            
            if(!TCPIPCommunicator.singleton.Connect())
            {
                return RetVal.RET_CONX_FAILED
            }
            
            debugPrint("OnlineTxn")
            GlobalData.m_csFinalMsgDoHubOnlineTxn = "Transaction Failed"
            GlobalData.m_bIsTxnDeclined = false
            GlobalData.m_bIsFiled58Absent = false

            GlobalData.m_csFinalMsgDisplay58 = ""

            
            //TODO: Conx yet to Add
            /*
            if (!conx.requestForDial()) {
                GlobalData.m_csFinalMsgDoHubOnlineTxn = "Connection Failed! Please Check Data Connection"
                return RetVal.RET_CONX_FAILED
            } else if (!conx.waitForConnect()) {
                GlobalData.m_csFinalMsgDoHubOnlineTxn = "Connection Failed"
                
                //TODO: Conx Yet to Add
                //_ = conx.disconnect()
                return AppConstant.FALSE
            }*/
            
            if (GlobalData.IsMiniPVMPresent == false) {
                if (AppConstant.TRUE == IsReversalPending()) {
                    if (AppConstant.FALSE == DoReversal()) {
                        GlobalData.m_csFinalMsgDoHubOnlineTxn = GlobalData.m_csFinalMsgDoReversal
                        return AppConstant.FALSE
                    }
                } else {
                    //Check for Pending SignUpload to be sent first
                    if (AppConstant.TRUE == IsSignUploadPending()) {
                        if (AppConstant.FALSE == DoSignUploadTxn()) {
                            GlobalData.m_csFinalMsgDoHubOnlineTxn = GlobalData.m_csFinalMsgDoSignUpload
                            return AppConstant.FALSE
                        }
                    }
                }
            }
            GlobalData.IsMiniPVMPresent = false
            if (!GlobalData.singleton.isPayByMobileEnabled) {
                GlobalData.updateCustomProgressDialog(msg: "Doing Hub Online Txn")
            }

            let iso = ISOHandler()
            var ip220 = CISO220SwipeTxn()
            if (objISO220SwipeTxn != nil) {
                ip220 = objISO220SwipeTxn!
            } else {
                ip220 = CISO220SwipeTxn()
                objISO220SwipeTxn = ip220
                ip220.CISO220C(ISO220RequestState.ONLINE_REQUEST_DEFAULT_TXN_REQUEST)
            }
            repeat {
                if (!iso.sendISOPacket(ip220)) {
                    debugPrint("ISO 220 Send Data Failed")
                    GlobalData.m_csFinalMsgDoHubOnlineTxn = "Transaction Failed"
                    ip220.CISOMsgD()
                    
                    _ = TCPIPCommunicator.singleton.disconnect()
                    //TODO: Conx Yet to Add
                    //conx.disconnect()
                    return AppConstant.FALSE
                }

                if (iso.getNextMessage(ip220) != 230) {
                    //This is a reversal condition.
                    //Reversal will go for anything next time going online.
                    ip220.CISOMsgD()
                    debugPrint("ISO 230 recv data failed.")

                    if (!GlobalData.m_csFinalMsgDisplay58.isEmpty) {
                        GlobalData.m_csFinalMsgDoHubOnlineTxn = GlobalData.m_csFinalMsgDisplay58
                    } else {
                        GlobalData.m_csFinalMsgDoHubOnlineTxn = "Transaction Failed"
                    }
                    
                    _ = TCPIPCommunicator.singleton.disconnect()
                    //TODO: Conx Yet to Add
                    //conx.disconnect()
                    
                    return AppConstant.FALSE
                }

                if (AppConstant.FALSE == ip220.ProcessData()) {
                    debugPrint("ProcessData Failed.")
                    if (GlobalData.m_bIsTxnDeclined && GlobalData.m_bIsFiled58Absent) {
                        GlobalData.m_csFinalMsgDoHubOnlineTxn = "Transaction declined"
                    } else if (!GlobalData.m_bIsTxnDeclined) {
                        GlobalData.m_csFinalMsgDoHubOnlineTxn = "Transaction Failed"
                    }

                    ip220.CISOMsgD()
                    
                    _ = TCPIPCommunicator.singleton.disconnect()
                    //TODO: Conx Yet to Add
                    //conx.disconnect()
                    return AppConstant.FALSE
                } else {
                    ip220.CISOMsgD()
                }

            }
                while ((ip220.m_iReqState != ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED) && (ip220.m_iReqState != ISO220RequestState.ONLINE_REQUEST_TXN_ERR_TERMINATED) && (!GlobalData.IsMiniPVMPresent))


            if (GlobalData.IsMiniPVMPresent == false) {
                //Disconnect Now
                _ = TCPIPCommunicator.singleton.disconnect()
                //TODO: Conx Yet to Add
                //conx.disconnect()
                
                //Check for printing
                if (ip220.m_iReqState == ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED) {
                    _ = ip220.AfterDataExchange()
                }

                if (ip220.m_iReqState == ISO220RequestState.ONLINE_REQUEST_TXN_ERR_TERMINATED) {
                    return AppConstant.FALSE
                }
            }
        } catch {
            GlobalData.m_csFinalMsgDoHubOnlineTxn = "Transaction Failed"
            debugPrint("Exception Occurred : \(error)")
            
            _ = TCPIPCommunicator.singleton.disconnect()
            //TODO: Conx Yet to Add
            //conx.disconnect()
            
            return AppConstant.FALSE
        }

        return AppConstant.TRUE
    }

    
    
    public func DoSignUploadTxn() -> Int {

        debugPrint("DoSignUploadTxn")
        let iso = ISOHandler()
        let ip220 = CISO220SIGNUpload()
        //TODO: yet to add CXonx
        //CConx conx = CConx.GetInstance()
        ip220.CISO220C(ISO220RequestState.ONLINE_SIGN_UPLOAD_TXN_START)

        GlobalData.m_csFinalMsgDoSignUpload = "Signature Uploading Failed"
        GlobalData.m_bIsTxnDeclined = false
        GlobalData.m_bIsFiled58Absent = false
        
        if(!TCPIPCommunicator.singleton.Connect())
        {
            return RetVal.RET_CONX_FAILED
        }
        
        GlobalData.updateCustomProgressDialog(msg: "Signature Uploading")
        var count: Int = 0
        repeat {
            if (!iso.sendISOPacket(ip220)) {
                GlobalData.m_csFinalMsgDoSignUpload = "Signature Uploading Failed"
                debugPrint("Signature uploading failed in sending data to host")
                ip220.CISOMsgD()
                _ = TCPIPCommunicator.singleton.disconnect()
                //TODO: Conx Yet to Add
                //conx.disconnect()
                return AppConstant.FALSE
            }

            if (iso.getNextMessage(ip220) != 230) {
                GlobalData.m_csFinalMsgDoSignUpload = "Signature Uploading Failed"
                debugPrint("Signature uploading failed in receving data from host")
                //This is a reversal condition.
                //Reversal will go for anything next time going online.
                ip220.CISOMsgD()
                
                _ = TCPIPCommunicator.singleton.disconnect()
                //TODO: Conx Yet to Add
                //conx.disconnect()
                return AppConstant.FALSE
            }

            if (AppConstant.FALSE == ip220.ProcessData()) {

                if (GlobalData.m_bIsTxnDeclined && GlobalData.m_bIsFiled58Absent) {
                    GlobalData.m_csFinalMsgDoSignUpload = "Signature Upload declined!"
                } else if (!GlobalData.m_bIsTxnDeclined) {
                    GlobalData.m_csFinalMsgDoSignUpload = "Signature Upload Failed!"
                } else {
                    GlobalData.m_csFinalMsgDoSignUpload = "Signature Upload Failed!"
                }
                debugPrint("SignUpload ProcessData Failed.")
                ip220.CISOMsgD()
                
                _ = TCPIPCommunicator.singleton.disconnect()
                //TODO: Conx Yet to Add
                //conx.disconnect()
                return AppConstant.FALSE
            } else {
                ip220.CISOMsgD()

            }
            debugPrint("DoSignUploadTxn Count \(count)")
            count += 1
        }
        while ((ip220.m_iReqState != ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED) && (ip220.m_iReqState != ISO220RequestState.ONLINE_REQUEST_TXN_ERR_TERMINATED))

        ip220.CISOMsgD()

        //Check for printing
        if (ip220.m_iReqState == ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED) {
            _ = ip220.AfterDataExchange()
        }

        if (ip220.m_iReqState == ISO220RequestState.ONLINE_REQUEST_TXN_ERR_TERMINATED) {
            return AppConstant.FALSE
        }

        debugPrint("Sign Upload Success")
        return AppConstant.TRUE
    }

    
    public func DoReversal() -> Int {
    //CConx conx = CConx.GetInstance() TODO: yet to Add CConx Class
        do {
            let iso = ISOHandler()

            GlobalData.m_csFinalMsgDoReversal = "Reversal Failed"
            GlobalData.m_csFinalMsgDisplay58 = ""
            GlobalData.m_bIsTxnDeclined = false
            GlobalData.m_bIsFiled58Absent = false

            
            //Connection should already be made
            if(!TCPIPCommunicator.singleton.Connect())
            {
                GlobalData.m_csFinalMsgDoReversal = "Connection Failed"
                _ = TCPIPCommunicator.singleton.disconnect()
                //TODO: Conx Yet to Add
                //conx.disconnect()
                return RetVal.RET_CONX_FAILED
            }
            
            //TODO: yet to add CConx
            /*if (!conx.waitForConnect()) {
                GlobalData.m_csFinalMsgDoReversal = "Connection Failed"
                conx.disconnect()
                return AppConstant.FALSE
            }*/

                //If Do Reversal is called during miniPVM execution & its not on thread donot perform reversal
    //            if (sttmch.bRunMiniPVm && CStateMachine.m_bIsInterruptedByBackgroundThread != true) {
    //                return AppConst.TRUE
    //            }

            if (GlobalData.IsMiniPVMPresent /*&& CStateMachine.m_bIsInterruptedByBackgroundThread != true TODO: Yet to add CStateMachine*/) {
                return AppConstant.TRUE
            }

            debugPrint("REVERSAL")
            GlobalData.updateCustomProgressDialog(msg: "DOING REVERSAL")
            let ip220 = CISO220Reversal()
            ip220.CISO220C(ISO220RequestState.ONLINE_REQUEST_PENDING_TXN)
            ip220.m_iReqState = ISO220RequestState.ONLINE_REQUEST_PENDING_TXN
            ip220.m_ReversalFlag = true


            repeat {
                if (!iso.sendISOPacket(ip220)) {
                    GlobalData.m_csFinalMsgDoReversal = "Reversal Failed"
                    debugPrint("Reversal Failed in sending data to host")
                    ip220.CISOMsgD()
                    
                    _ = TCPIPCommunicator.singleton.disconnect()
                    //TODO: Conx Yet to Add
                    //conx.disconnect()
                    return AppConstant.FALSE
                }
                
                if (iso.getNextMessage(ip220) != 230) {
                    if (!GlobalData.m_csFinalMsgDisplay58.isEmpty) {
                        GlobalData.m_csFinalMsgDoReversal = GlobalData.m_csFinalMsgDisplay58
                    } else {
                        GlobalData.m_csFinalMsgDoReversal = "Reversal Failed"
                    }
                    ip220.CISOMsgD()
                    debugPrint("Reversal Failed in receiving data to host")
                    _ = TCPIPCommunicator.singleton.disconnect()
                    //TODO: Conx Yet to Add
                    //conx.disconnect()
                    return AppConstant.FALSE
                }

                if (AppConstant.FALSE == ip220.ProcessData()) {
                    if (!GlobalData.m_csFinalMsgDisplay58.isEmpty) {
                        GlobalData.m_csFinalMsgDoReversal = GlobalData.m_csFinalMsgDisplay58
                    } else if (GlobalData.m_bIsTxnDeclined) {
                        GlobalData.m_csFinalMsgDoReversal = "Reversal Transaction declined"
                    } else {
                        GlobalData.m_csFinalMsgDoReversal = "Reversal Failed"
                    }
                        
                    debugPrint("Reversal ProcessData Failed.")
                    ip220.CISOMsgD()
                    _ = TCPIPCommunicator.singleton.disconnect()
                    //TODO: Conx Yet to Add
                    //conx.disconnect()
                    return AppConstant.FALSE
                } else {
                    ip220.CISOMsgD()
                }
            }
            while (ip220.m_iReqState != ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED)
            
            ip220.CISOMsgD()
            //REVERSAL RESPONSE IS OK SET REVERSAL FLAG AS AppConst.FALSE
            _ = ip220.AfterDataExchange()
            
        } catch {
            debugPrint("Exception Occurred : \(error)")
            GlobalData.m_csFinalMsgDoReversal = "Reversal Failed"
                
            _ = TCPIPCommunicator.singleton.disconnect()
            //TODO: Conx Yet to Add
            //conx.disconnect()
            return AppConstant.FALSE
        }
        return AppConstant.TRUE
    }
    
    public func DoDRTxn()  -> Int {

        let ip800 = CISO800()
        let iso = ISOHandler()
        //CConx conx = CConx.GetInstance() yet to implement CConx
        ip800.CISO800C()
        debugPrint("Sending ISO 800 packet.")

        GlobalData.updateCustomProgressDialog(msg: "Upload Request")
        
        if (!iso.sendISOPacket(ip800)) {
            ip800.CISOMsgD()
            
            _ = TCPIPCommunicator.singleton.disconnect()
            //TODO: Conx Yet to Add
            //conx.disconnect()
            debugPrint("ISO 800 send data failed.")
            return AppConstant.FALSE
        }
        debugPrint("Recieving ISO 810 packet.")
        if (iso.getNextMessage(ip800) != 810 || !ip800.ProcessData()) {
            ip800.CISOMsgD()
            
            _ = TCPIPCommunicator.singleton.disconnect()
            //TODO: Conx Yet to Add
            //conx.disconnect()
            debugPrint("ISO 810 recv data failed.")
            return AppConstant.FALSE
        }

        ip800.CISOMsgD()
        return AppConstant.TRUE

    }

    public func DoDRUploadTxn() -> Int {

        debugPrint("DoDROnlineTxn")
        let iso = ISOHandler()
        let ip220 = CISO220DRUpload()
        
        //CConx conx = CConx.GetInstance() Yet to Add CConx Class
        ip220.CISO220C(ISO220RequestState.ONLINE_DR_UPLOAD_TXN_START)


        GlobalData.updateCustomProgressDialog(msg: "DR Upload")
        repeat {

            if (!iso.sendISOPacket(ip220)) {
                ip220.CISOMsgD()
                
                _ = TCPIPCommunicator.singleton.disconnect()
                //TODO: Conx Yet to Add
                //conx.disconnect()
                return AppConstant.FALSE
            }

               if (iso.getNextMessage(ip220) != 230) {

                   //This is a reversal condition.
                   //Reversal will go for anything next time going online.
                   ip220.CISOMsgD()
                   debugPrint("ISO 230 recv data failed.")
                    _ = TCPIPCommunicator.singleton.disconnect()
                   //TODO: Conx Yet to Add
                   //conx.disconnect()
                
                   return AppConstant.FALSE
               }

            if (AppConstant.FALSE == ip220.ProcessData()) {
                debugPrint("ProcessData Failed.")
                ip220.CISOMsgD()
                
                _ = TCPIPCommunicator.singleton.disconnect()
                //TODO: Conx Yet to Add
                //conx.disconnect()
                return AppConstant.FALSE
            } else {
                ip220.CISOMsgD()
            }
        }
        while ((ip220.m_iReqState != ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED) && (ip220.m_iReqState != ISO220RequestState.ONLINE_REQUEST_TXN_ERR_TERMINATED))

        //Disconnect Now
        _ = TCPIPCommunicator.singleton.disconnect()
        //TODO: Conx Yet to Add
        //conx.disconnect()

           //Check for printing
        if (ip220.m_iReqState == ISO220RequestState.ONLINE_REQUEST_TXN_COMPLETED) {
            _ = ip220.AfterDataExchange()
        }

        if (ip220.m_iReqState == ISO220RequestState.ONLINE_REQUEST_TXN_ERR_TERMINATED) {
            return AppConstant.FALSE
        }

        return AppConstant.TRUE
    }
    
}
