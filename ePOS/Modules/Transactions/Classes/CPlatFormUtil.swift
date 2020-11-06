//
//  CPlatFormUtil.swift
//  ePOS
//
//  Created by Abhishek on 13/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public class PlatFormUtils{
    
    //MARK:- getLast8DigitOfFullSerialNumber() -> String
    static func getLast8DigitOfFullSerialNumber() -> String {
        var last8digitFullSerialNumber = "";
    
        if let fullSerialNumber = GlobalData.singleton.getFullSerialNumber()
        {
            last8digitFullSerialNumber =  fullSerialNumber.substring(from: (fullSerialNumber.count - 8),to: fullSerialNumber.count)
        }
        return last8digitFullSerialNumber;
    }

    //MARK:- getIMEI() -> String?
    static func getIMEI() -> String? {
        let IMEI = "";
        //        TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        //        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
        //            ActivityCompat.requestPermissions((Activity) context,
        //                    new String[]{Manifest.permission.READ_PHONE_STATE},
        //                    0);
        //            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "READ_PHONE_STATE Permission Not Granted ");
        //            return "";
        //        }/*else{*/
        //
        //        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        //            IMEI = telephonyManager.getImei();
        //        } else {
        //            IMEI = telephonyManager.getDeviceId();
        ////            }
        //        }
        return IMEI;
    }
    
    //MARK:- installApk(fileName: String) -> Bool
    static func installApk(fileName: String) -> Bool
    {
        return true
    }
    
    //MARK:- GetHardWareSerialNumber() -> [Byte]?
    static func GetHardWareSerialNumber() -> [Byte]? {
        do {
           let m_sParamData: TerminalParamData = GlobalData.singleton.ReadParamFile()!
            
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
       
    //MARK:- getFullSerialNumber() -> [Byte]?
    static func getFullSerialNumber() -> [Byte]?{

        if let serialNumber = GlobalData.singleton.getFullSerialNumber(){
        let bSerialNumber = [Byte](serialNumber.utf8)
        return bSerialNumber
        }
        return nil
    }
    
    //MARK:- upgradeDll(fileNameList: [String]) -> Bool
    static func upgradeDll(fileNameList: [String]) -> Bool {
        return true;
    }
    
}
