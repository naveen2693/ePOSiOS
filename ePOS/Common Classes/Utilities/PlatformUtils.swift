//
//  PlatformUtils.swift
//  ePOS
//
//  Created by Vishal Rathore on 12/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public class PlatformUtils{

  static func GetHardWareSerialNumber() -> [Byte]? {
     do {
        let m_sParamData: TerminalParamData = GlobalData.sharedInstance.ReadParamFile()!
         
        debugPrint("HardWareSerialNumber \(m_sParamData.m_strHardwareSerialNumber)")
        //CLogger.TraceLog(TRACE_INFO, "HardWareSerialNumber[%s]", m_sParamData.m_strHardwareSerialNumber);
        let byteArrHarwareSerialNumber = [Byte](m_sParamData.m_strHardwareSerialNumber.utf8)
        
        return byteArrHarwareSerialNumber;
     
        } catch {
            debugPrint("Exception Occurred: \(error)")
            return nil
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(ex));
        }
    }
    
    static func getFullSerialNumber() -> [Byte]?{
        
        if let serialNumber = GlobalData.sharedInstance.getFullSerialNumber(){
         let bSerialNumber = [Byte](serialNumber.utf8)
        return bSerialNumber
        }
        return nil
    }

}
