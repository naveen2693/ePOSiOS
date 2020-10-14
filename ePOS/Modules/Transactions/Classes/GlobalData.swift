//
//  GlobalData.swift
//  ePOS
//
//  Created by Naveen Goyal on 06/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public class GlobalData
{
    var  m_sConxData = StructConxData();
    static var m_sTerminalParamData_Cache:TerminalParamData? = nil;
    
    public func  createConnectionFile() -> Int
    {
        let iConnType:Int = 0;
        let iConxPriority:Int = 0;
        let maxCommunication:Int = AppConstant.MAX_COMMUNICATION_CHANNEL
        for _ in  0...maxCommunication
        {
            var conxData = TerminalConxData();
            conxData.iConnType += iConnType;
            conxData.iConxPriority += iConxPriority;
            conxData.bIsConnectionActive = false;
            conxData.bIsDataChanged = true;
            conxData.iConnTimeout = AppConstant.iConnectionTimeout;
            conxData.iSendRecTimeout = AppConstant.iSendReceiveTimeout;
            conxData.iInterCharTimeout = AppConstant.iInterCharTimeout;
            conxData.iComPort = AppConstant.iComPort;
            conxData.strLoginID = AppConstant.strConxLoginID;
            conxData.strPassword = AppConstant.strConxPassword;
            conxData.iTransactionSSLPort = AppConstant.HOST_PORT;
            conxData.iSecondaryTransactionSSLPort = AppConstant.HOST_PORT;
            conxData.strTransactionSSLServerIP = AppConstant.PRIMARY_IP;
            conxData.strSecondaryTransactionSSLServerIP = AppConstant.SECONDARY_IP;
            conxData.bTransactionSSLIPRetryCounter = 0;
            conxData.strGPRSServiceProvider = AppConstant.strGPRSServiceProvider;
            conxData.strAPN = AppConstant.strAPN;
            //Write this Info into file
            do{
                _ = try FileSystem.AppendFile(strFileName: AppConstant.CONNECTIONDATAFILENAME, with: [conxData])}
            catch
            {
                fatalError("File Write Error")
            }
            
        }
        //Load connection Index
        var tData:TerminalConxData?;
        m_sConxData.m_bArrConnIndex =  StructConnIndex();
        
        if let listParams:[TerminalConxData] = FileSystem.ReadFile(strFileName: AppConstant.CONNECTIONDATAFILENAME)
        {
            if (listParams.count > 0) {
                let numberOfRow:Int = listParams.count;
                for i in 0...numberOfRow {
                    tData = listParams[i];
                    if (ConnectionTypes.DIALUP_SERIAL == tData?.iConnType) {
                        m_sConxData.m_bArrConnIndex.CON_SerialIp.index = i;
                    } else if (ConnectionTypes.DIALUP_GPRS == tData?.iConnType) {
                        m_sConxData.m_bArrConnIndex.CON_GPRS.index = i;
                    } else if (ConnectionTypes.DIALUP_ETHERNET == tData?.iConnType) {
                        m_sConxData.m_bArrConnIndex.CON_ETHERNET.index = i;
                    } else if (ConnectionTypes.DIALUP_WIFI == tData?.iConnType) {
                        m_sConxData.m_bArrConnIndex.CON_WIFI.index = i;
                    }
                }
            }
        }
        return AppConstant.TRUE;
    }
    
    public class func CreateSignatureParamFile() -> Int
    {
        var Objsignaturedata =  SignatureParams();
        //FileSystem.Delete(m_context, chArrSignatureParamFile);
        let bArrSignatureComPort:[UInt8] = Array("0".utf8);
        let bArrSignatureDeviceType:[UInt8] = Array("NONE".utf8);
        Objsignaturedata.bArrSignatureComPort.insert(contentsOf: bArrSignatureComPort, at: 0)
        Objsignaturedata.SignatureDeviceType.insert(contentsOf: bArrSignatureDeviceType, at: 0)
        Objsignaturedata.IsSignDeviceConnected = false;
        //        int iCurrentNumOfRecords = CFileSystem.NumberOfRows(m_context, SignatureParams[].class, chArrSignatureParamFile);
        return AppConstant.TRUE;
    }
    
    public class func createDeviceStateFile() {
        let deviceState = DeviceState.S_INITIAL;
        do{
            _ = try FileSystem.AppendFile(strFileName: AppConstant.DEVICE_STATE, with:[String](from: deviceState  as! Decoder))
            
        }
        catch {
            fatalError("File Write Error")
        }
    }
    
    static func readParamFile() -> [TerminalParamData]? {
        var m_terminalParamData:[TerminalParamData]?
        if (m_sTerminalParamData_Cache == nil) {
            if let m_sTerminalParamData_Cache:[TerminalParamData] = FileSystem.ReadFile(strFileName: AppConstant.TERMINALPARAMFILENAME)
            {
                m_terminalParamData = m_sTerminalParamData_Cache
            }
        }
        return m_terminalParamData;
    }
    
    static func WriteParamFile(listParamData:TerminalParamData?) ->Int {
        var objTerminalParamData = [TerminalParamData]();
        if (listParamData == nil) {
            return 0;
        }
        if let unwrappedParamData = listParamData
        {
            do {
                objTerminalParamData.append(unwrappedParamData)
                m_sTerminalParamData_Cache = unwrappedParamData; //Assigning to cache for future use
                _  = try FileSystem.ReWriteFile(strFileName: AppConstant.TERMINALPARAMFILENAME, with:  objTerminalParamData);
            }catch
            {
                fatalError("File Rewrite Error")
            }
        }
        return AppConstant.TRUE;
}

final class GlobalData {

    // MARK: - Properties
    static let singleton = GlobalData()
    static var m_sTerminalParamData_Cache: TerminalParamData? = nil
    var m_sMasterParamData: TerminalMasterParamData? = nil
    
    var m_objCurrentLoggedInAccount: LOGINACCOUNTS? = nil
    var m_strCurrentLoggedInUserPIN: String = ""
    var m_bIsLoggedIn: Bool = false
    var fullSerialNumber: String = ""
    
    func ReadParamFile() -> TerminalParamData? {
        if (GlobalData.m_sTerminalParamData_Cache == nil) {

            if let m_sTerminalParamData:TerminalParamData = FileSystem.SeekRead(strFileName: AppConst.TERMINALPARAMFILENAME, iOffset: 0)
            {
                    GlobalData.m_sTerminalParamData_Cache = m_sTerminalParamData
            }
        }
        
        return GlobalData.m_sTerminalParamData_Cache
    }

    func WriteParamFile(listParamData: TerminalParamData?) ->Int {
        var objTerminalParamData: TerminalParamData
           
        if (listParamData == nil) {
               return 0;
           }

        if listParamData != nil
           {
               do {
                  GlobalData.m_sTerminalParamData_Cache = listParamData; //Assigning to cache for future use
                 objTerminalParamData = listParamData!
                
                   _  = try FileSystem.SeekWrite(strFileName: AppConst.TERMINALPARAMFILENAME, with:
                    objTerminalParamData, iOffset: 0)
                
               }catch
               {
                   fatalError("File Rewrite Error")
               }
           }
           return AppConst.TRUE;
    }
    
    func WriteMasterParamFile() -> Int {
        return AppConst.TRUE;
      }

     func ReadMasterParamFile() -> Int {
        return AppConst.TRUE;
      }

    
    func setFullSerialNumber(fullSerialNumber: String) {
        //setting full serial number from remote to be used in activation to generate Short Serial number
        //no need to store in file as it will be set everytime app call Plutus API
        debugPrint("Inside setFullSerialNumber : \(fullSerialNumber)")
        //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Inside setFullSerialNumber : " + fullSerialNumber);
        self.fullSerialNumber = fullSerialNumber;
    }
    
    func getFullSerialNumber() -> String {
        return fullSerialNumber
    }
    
}
