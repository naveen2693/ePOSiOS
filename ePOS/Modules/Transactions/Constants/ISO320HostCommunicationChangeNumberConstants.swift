//
//  ISO320ChangeNumberConstants.swift
//  ePOS
//
//  Created by Naveen Goyal on 05/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

enum ISO320ChangeNumberConstants
{
     static let EDC_LIB_LIST_DOWNLOAD = 1; //ignore
     static let EDC_LIB_DOWNLOAD = 2; //ignore
     static let HUB_GET_EDC_APP_DOWNLOAD = 3; //ignore
     static let HOST_PVM_DOWNLOAD = 4;
     static let HOST_CHARGESLIP_ID_DOWNLOAD = 5;
     static let HOST_CHARGESLIP_DOWNLOAD = 6;//not download
     static let HOST_IMAGE_ID_DOWNLOAD = 7;
     static let HOST_IMAGE_DOWNLOAD = 8;
     static let HOST_BATCH_ID  = 9;
     static let HOST_CLOCK_SYNC = 10;
     static let HOST_MESSAGE_ID_LIST_DOWNLOAD = 11;
     static let HOST_MESSAGE_DOWNLOAD = 12;//not download
     static let HOST_PARAMETERS_DOWNLOAD = 13;
     static let HUB_PARM_UPLOAD = 14;
     static let HUB_PARM_DOWNLOAD = 15;
     static let HUB_GET_IGNORE_AMT_CSV_TXN_LIST = 16;
     static let EDC_FIXED_CHARGESLIP_ID_DOWNLOAD = 17;
     static let EDC_FIXED_CHARGESLIP_DOWNLOAD = 18;//not download
     static let EDC_PRINTING_LOCATION_DOWNLOAD = 19;
     static let EDC_TXN_TYPE_FLAGS_MAPPING_DOWNLOAD = 20;
     static let HOST_MINIPVM_ID_DOWNLOAD = 21;
     static let HOST_MINIPVM_DOWNLOAD = 22;
     static let CSV_TXN_TYPE_MINIPVM_MAPPING_DOWNLOAD = 23;
     static let EDC_ISPASSWORD_TXN_MAPPING_DOWNLOAD = 24;
     static let HOST_CONTENT_DOWNLOAD = 25;
     static let EDC_LOG_SHIPPING_DETAILS_DOWNLOAD = 26;
     static let AD_SERVER_HTL_SYNC = 27;
     static let HOST_COLORED_IMAGE_ID_DOWNLOAD = 28;
     static let HOST_COLORED_IMAGE_DOWNLOAD = 29;
    //Below changenumbers are ignored for Digipos
     static let HUB_PINEKEY_EXCHANGE = 31; //ignore
     static let HUB_GET_PINE_SESSION_KEY = 32; //ignore
     static let HUB_GET_BIN_RANGE = 33; //ignore
     static let HUB_GET_CSV_TXN_MAP = 34; //ignore
     static let HUB_GET_TXN_BIN = 35; //ignore
     static let CLESS_PARM_DWONLOAD = 36;//ignore
     static let HUB_GET_CLESSPARAM = 37;//ignore
     static let HUB_GET_CLESS_UPLOAD = 38;//ignore
     static let EDC_AID_EMV_TXNTYPE_DOWNLOAD = 39; //ignore
     static let USER_INFO_SYNC = 40;//ignore
     static let HUB_GET_CACRT = 41;//ignore
     static let HUB_GET_EMV_TAG_LIST = 42;//ignore
}
