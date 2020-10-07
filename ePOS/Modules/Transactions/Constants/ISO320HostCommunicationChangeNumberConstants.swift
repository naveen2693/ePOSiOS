//
//  ISO320ChangeNumberConstants.swift
//  ePOS
//
//  Created by Naveen Goyal on 05/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

enum ISO320ChangeNumberConstants : Int
{
    case EDC_LIB_LIST_DOWNLOAD = 1; //ignore
    case EDC_LIB_DOWNLOAD = 2; //ignore
    case HUB_GET_EDC_APP_DOWNLOAD = 3; //ignore
    case HOST_PVM_DOWNLOAD = 4;
    case HOST_CHARGESLIP_ID_DOWNLOAD = 5;
    case HOST_CHARGESLIP_DOWNLOAD = 6;//not download
    case HOST_IMAGE_ID_DOWNLOAD = 7;
    case HOST_IMAGE_DOWNLOAD = 8;
    case HOST_BATCH_ID  = 9;
    case HOST_CLOCK_SYNC = 10;
    case HOST_MESSAGE_ID_LIST_DOWNLOAD = 11;
    case HOST_MESSAGE_DOWNLOAD = 12;//not download
    case HOST_PARAMETERS_DOWNLOAD = 13;
    case HUB_PARM_UPLOAD = 14;
    case HUB_PARM_DOWNLOAD = 15;
    case HUB_GET_IGNORE_AMT_CSV_TXN_LIST = 16;
    case EDC_FIXED_CHARGESLIP_ID_DOWNLOAD = 17;
    case EDC_FIXED_CHARGESLIP_DOWNLOAD = 18;//not download
    case EDC_PRINTING_LOCATION_DOWNLOAD = 19;
    case EDC_TXN_TYPE_FLAGS_MAPPING_DOWNLOAD = 20;
    case HOST_MINIPVM_ID_DOWNLOAD = 21;
    case HOST_MINIPVM_DOWNLOAD = 22;
    case CSV_TXN_TYPE_MINIPVM_MAPPING_DOWNLOAD = 23;
    case EDC_ISPASSWORD_TXN_MAPPING_DOWNLOAD = 24;
    case HOST_CONTENT_DOWNLOAD = 25;
    case EDC_LOG_SHIPPING_DETAILS_DOWNLOAD = 26;
    case AD_SERVER_HTL_SYNC = 27;
    case HOST_COLORED_IMAGE_ID_DOWNLOAD = 28;
    case HOST_COLORED_IMAGE_DOWNLOAD = 29;
    //Below changenumbers are ignored for Digipos
    case HUB_PINEKEY_EXCHANGE = 31; //ignore
    case HUB_GET_PINE_SESSION_KEY = 32; //ignore
    case HUB_GET_BIN_RANGE = 33; //ignore
    case HUB_GET_CSV_TXN_MAP = 34; //ignore
    case HUB_GET_TXN_BIN = 35; //ignore
    case CLESS_PARM_DWONLOAD = 36;//ignore
    case HUB_GET_CLESSPARAM = 37;//ignore
    case HUB_GET_CLESS_UPLOAD = 38;//ignore
    case EDC_AID_EMV_TXNTYPE_DOWNLOAD = 39; //ignore
    case USER_INFO_SYNC = 40;//ignore
    case HUB_GET_CACRT = 41;//ignore
    case HUB_GET_EMV_TAG_LIST = 42;//ignore
}
