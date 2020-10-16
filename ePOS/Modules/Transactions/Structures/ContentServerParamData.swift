//
//  ContentServerParamData.swift
//  ePOS
//
//  Created by Abhishek on 15/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
struct ContentServerParamData:Codable{
    //public boolean m_bIsContentSyncEnabled = false;
    var m_bIsContentSyncEnabled = false;
    var m_strDownloadUrl = "https://PLUTUSCONTENTSERVICE.IN/api/sync";
    var m_strUploadUrl = "https://PLUTUSCONTENTSERVICE.IN/api/upload";
    var m_strDownloadApkUrl = "https://PLUTUSCONTENTSERVICE.IN/api/sync/ApkDownload";
    var m_strDownloadDllUrl = "https://PLUTUSCONTENTSERVICE.IN/api/sync/LibDownload";
    var m_iConnectionTimeOut = 5000;
    var m_iSocketTimeOut = 5000;
}
