//
//  GlobalData.swift
//  ePOS
//
//  Created by Naveen Goyal on 06/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

final class GlobalData {

    // MARK: - Properties
    static let singleton = GlobalData()
    static var m_sTerminalParamData_Cache: TerminalParamData? = nil
    
    var m_sMasterParamData: TerminalMasterParamData? = nil
    
    var m_objCurrentLoggedInAccount: LOGINACCOUNTS? = nil
    var m_strCurrentLoggedInUserPIN: String = ""
    var m_bIsLoggedIn: Bool = false
    var fullSerialNumber: String = ""
    var m_csFinalMsgDisplay58 = ""
    
    
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
    
    func GetMessage(id: Int64, messagebuffer: [Byte]) -> Bool {
        return true
    }
}
