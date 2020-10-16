//
//  CPlatFormUtil.swift
//  ePOS
//
//  Created by Abhishek on 13/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public class CPlatFormUtils{
    
public static func getLast8DigitOfIMEINumber() -> String {
    var last8DigitIMEI = "";
    
    if let IMEI = GlobalData.sharedInstance.getFullSerialNumber()
    {
     last8DigitIMEI =  IMEI.substring(from: (IMEI.count - 8),to: IMEI.count)
    }
    return last8DigitIMEI;
}

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
}
