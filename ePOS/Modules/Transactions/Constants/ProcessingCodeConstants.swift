//
//  ProcessingCodeConstants.swift
//  ePOS
//
//  Created by Abhishek on 23/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
enum ProcessingCodeConstants{
      static let AC_SUCCESS = "0000";
      static let AC_DRDUMPREQ = "0095";
      static let AC_PARTIAL_SETTLEMENT = "5055";

       /******************************************************************************
        *            PROCESSING CODES
        *****************************************************************************/
       //This processing code is meant for ISO500
       static let PC_OVERALL_SUMMARY = "960006";
       /*************PROCESSING CODES*********************************************/


       /************ISO 320 Processing Codes *************************************/
       static let PC_BATCH_ID = "960100";
       static let PC_BATCH_ID_END = "960101";
       static let PC_PVM_DLD_START = "960110";
       static let PC_PVM_DLD_END   = "960111";
       static let PC_CHARGE_SLIP_ID_DLD_START = "960120";
       static let PC_CHARGE_SLIP_ID_DLD_END = "960121";
       static let PC_IMAGE_ID_DOWNLOAD_START = "960130";
       static let PC_IMAGE_ID_DOWNLOAD_END = "960131";
       static let PC_CLOCK_SYNC_START = "960140";
       static let PC_CLOCK_SYNC_END = "960141";
       static let PC_CHARGE_SLIP_DLD_START = "960150";
       static let PC_CHARGE_SLIP_DLD_END = "960151";
       static let PC_IMAGE_DOWNLOAD_START = "960160";
       static let PC_IMAGE_DOWNLOAD_END = "960161"
       static let PC_MESSAGE_ID_LIST_DLD_START = "960170";
       static let PC_MESSAGE_ID_LIST_DLD_END = "960171";
       static let PC_MESSAGE_DLD_START = "960180";
       static let PC_MESSAGE_DLD_END = "960181";
       static let PC_PARAMETER_START = "960190";
       static let PC_PARAMETER_END = "960191";
       static let PC_HOST_PARAMS_START = "960200";
       static let PC_HOST_PARAMS_END = "960201";


       /************ISO 320 Host Comm Processing Codes ***************************/
       static let PC_EMV_PARAM_START = "960300";
       static let PC_EMV_PARAM_END = "960301";
       static let PC_PARAMETER_UPLOAD_START = "960310";
       static let PC_PARAMETER_UPLOAD_END = "960311";
       static let PC_PARAMETER_DOWNLOAD_START = "960320";
       static let PC_PARAMETER_DOWNLOAD_END  =  "960321";
       static let PC_GETPSK_START   = "960330";
       static let PC_GETPSK_END = "960331";
       static let PC_GETBINRANGE_START = "960340";
       static let PC_GETBINRANGE_END = "960341";
       static let PC_PINEKEY_EXCHANGE_START = "960350";
       static let PC_PINEKEY_EXCHANGE_END = "960351";
       static let PC_GETCSVTXNMAP_START = "960360";
       static let PC_GETCSVTXNMAP_END = "960361";
       static let PC_GETCACRT_START = "960370";
       static let PC_GETCACRT_END = "960371";
       //Transaction BIN
      static let PC_GETTXNBIN_START = "960380";
      static let PC_GETTXNBIN_END = "960381";

      static let PC_IGNORE_AMOUNT_CSV_MAP_START = "960430";
      static let PC_IGNORE_AMOUNT_CSV_MAP_END = "960431";
      static let PC_EDC_APP_DOWNLOAD_START = "960440";
      static let PC_EDC_APP_DOWNLOAD_END = "960441";


       //EMV TAG Download=
       static let PC_EDC_REQUIRED_EMV_TAGS_DOWNLOAD_START = "960450";
       static let PC_EDC_REQUIRED_EMV_TAGS_DOWNLOAD_END    = "960451";

       //Dynamic charge slip
      static let PC_EDC_REQUIRED_FIXED_CHARGESLIP_ID_LIST_DOWNLOAD_START      = "960460";
      static let PC_EDC_REQUIRED_FIXED_CHARGESLIP_ID_LIST_DOWNLOAD_END          = "960461";

       static let PC_EDC_REQUIRED_FIXED_CHARGESLIP_ID_DOWNLOAD_START      = "960470";
       static let PC_EDC_REQUIRED_FIXED_CHARGESLIP_ID_DOWNLOAD_END      = "960471";

       //UNICODE FONT DOWNLOAD
       static let PC_EDC_REQUIRED_FONT_FILE_ID_LIST_DOWNLOAD_START = "960480";
       static let PC_EDC_REQUIRED_FONT_FILE_ID_LIST_DOWNLOAD_END = "960481";

       static let PC_EDC_REQUIRED_FONT_FILE_ID_DOWNLOAD_START = "960490";
       static let PC_EDC_REQUIRED_FONT_FILE_ID_DOWNLOAD_END = "960491";

       static let PC_EDC_FONT_FILE_ID_UPDATE_START = "960500";
       static let PC_EDC_FONT_FILE_ID_UPADTE_END = "960501";

       //For CLess Param Update to CLESSPARAM.PAR
       static let PC_EDC_CLESSPARAM_UPDATE_START = "960510";
       static let PC_EDC_CLESSPARAM_UPADTE_END = "960511";

       //For CLess XML to CLESSPARAM.PAR
       static let PC_EDC_CLESSXML_UPDATE_START = "960520";
       static let PC_EDC_CLESSXML_UPADTE_END = "960521";

       //For update cless param download
       static let PC_EDC_CLESSPARAM_UPLOAD_START = "960530";
       static let PC_EDC_CLESSPARAM_UPLOAD_END = "960531";

       static let PC_EDC_PRINTING_LOCATION_DOWNLOAD_START = "960540";
       static let PC_EDC_PRINTING_LOCATION_DOWNLOAD_END = "960541";

       //amitesh::For Update AID mapping with HAT txn type and CSV txn type
       static let PC_EDC_AID_EMV_TXNTYPE_DOWNLOAD_START = "960550";
       static let PC_EDC_AID_EMV_TXNTYPE_DOWNLOAD_END = "960551";

       //Abhishek::HAT CSV TXN TYPE FLAGS MAPPING DOWNLOAD PARAMS
       static let PC_EDC_TXN_TYPE_FLAGS_DOWNLOAD_START    = "960560";
       static let PC_EDC_TXN_TYPE_FLAGS_DOWNLOAD_END = "960561";

       //Amitesh::For Library download
       static let   PC_EDC_LIB_LIST_DOWNLOAD_START = "960570";
       static let PC_EDC_LIB_LIST_DOWNLOAD_END = "960571";

       static let  PC_EDC_LIB_DOWNLOAD_START = "960580";
       static let PC_EDC_LIB_DOWNLOAD_END = "960581";

       //Ghulam::For isPasswordRequired for Specific transaction
       static let PC_EDC_TXN_TYPE_PASSWORD_MAPPING_DOWNLOAD_START = "960640";
       static let PC_EDC_TXN_TYPE_PASSWORD_MAPPING_DOWNLOAD_END = "960641";

       //Amitesh::CIMB Mini PVM ID download
       static let PC_CIMB_MINIPVM_ID_DOWNLOAD_START = "960600";
       static let PC_CIMB_MINIPVM_ID_DOWNLOAD_END = "960601";

       //Amitesh::CIMB Mini PVM  download
      static let PC_CIMB_MINIPVM_DOWNLOAD_START = "960610";
      static let PC_CIMB_MINIPVM_DOWNLOAD_END = "960611";

       //Rahul Agarwal::CUSTOMER FEEDBACK CSV TXN TYPE MAPPING DOWNLOAD
       static let PC_EDC_CSV_TXN_TYPE_MINIPVM_MAPPING_DOWNLOAD_START = "960620";
       static let PC_EDC_CSV_TXN_TYPE_MINIPVM_DOWNLOAD_END   = "960621";

       static let PC_EDC_LOG_SHIPPING_DETAILS_DOWNLOAD_START =     "960680";
       static let PC_EDC_LOG_SHIPPING_DETAILS_DOWNLOAD_END   =     "960681";

    static let PC_OEM_ALL_CONTENT_DOWNLOAD_START = "960690";
    static let PC_OEM_ALL_CONTENT_DOWNLOAD_END = "960691";
    static let PC_OEM_CONTENT_DOWNLOAD_ACK = "960700";
    static let PC_OEM_CONTENT_DOWNLOAD_NO_IMAGE = "960701";
    
       static let PC_AD_SERVER_HTL_SYNC_START =     "960730";
       static let PC_AD_SERVER_HTL_SYNC_END   =     "960731";
       static let PC_USER_INFO_SYNC_START =     "960740";
       static let PC_USER_INFO_SYNC_END   =     "960741";

       /************ISO 220 Processing Codes *************************************/
      static let PC_ONLINE_TRANSACTION_REQ     = "900001";
      static let PC_OFFLINE_TRANSACTION_REQ     = "900002";
      static let PC_ONLINE_REQ_MULTI_PCAKET   = "900003";
      static let PC_ONLINE_REVERSAL_REQ_PCAKET = "900004";
      static let PC_ONLINE_REVERSAL_RES_PCAKET = "900004";

      static let PC_ONLINE_KEY_EXCHANGE_REQ_PCAKET = "900005";

      static let PC_SETTLEMENT_START =  "910100";
      static let PC_SETTLEMENT_END =  "910101";
      static let PC_ONLINE_RESPONSE_GET_ADDTIONAL_INFO_START = "910010";
      static let PC_ONLINE_RESPONSE_GET_ADDTIONAL_INFO_END = "910011";
      static let PC_ONLINE_RESPONSE_MULTI_PACKET_DATA_START = "910020";
      static let PC_ONLINE_RESPONSE_MULTI_PACKET_DATA_END = "910021";

       static let PC_GET800DATA_REQ = "910000";
       static let PC_DR_DATA_UPLOAD_START =    "900060";
       static let PC_DR_DATA_UPLOAD_END     =    "900061";

       //FOR ONLINE SIGNATURE UPLOAD-amitesh
       static let    PC_ONLINE_SIGNATURE_UPLOAD_START = "910040";
      static let   PC_ONLINE_SIGNATURE_UPLOAD_END = "910041";
       //FOR COLORED IMAGE - Ghulam
       static let PC_COLORED_IMAGE_ID_DOWNLOAD_START = "960750";
       static let PC_COLORED_IMAGE_ID_DOWNLOAD_END = "960751";
       static let PC_COLORED_IMAGE_DOWNLOAD_START = "960760";
       static let PC_COLORED_IMAGE_DOWNLOAD_END = "960761";

       /*    ***********MTIs *************************************/
      static let UPDATAREQ = "0220";
      static let UPDATARES = "0230"
      static let DOWNDATAREQ = "0320";
      static let DOWNDATARES = "0330";
      static let ACTIVATIONREQ = "0440";
      static let ACTIVATIONRES = "0450";
      static let BATCHCOMPLREQ = "0500";
      static let BATCHCOMPLRES = "0510";
      static let NETWORKRECOVERYREQ = "0800";
      static let NETWORKRECOVERYRES  = "0810";
      static let ISO_LEN = 64;

    static let msgno = [Byte](repeating: 0, count: AppConstant.ISO_LEN_MTI);
    static let bitmap = [Bool](repeating: false, count: AppConstant.ISO_LEN);
    static let encryptedFieldBitmap = [Bool](repeating: false, count: AppConstant.ISO_LEN);
    static let len = [Int](repeating: 0, count: AppConstant.ISO_LEN);
    static let data = [Byte](repeating: 0, count: AppConstant.ISO_LEN);
    static let m_chFirstKey = [Byte](repeating: 0, count: 9);
    static let m_chSecondKey = [Byte](repeating: 0, count: 9);
    static let m_chArrISOPacketDate = [Byte](repeating: 0, count: AppConstant.MAX_LEN_DATE_TIME);
    static let m_TPDU = [Byte](repeating: 0, count: AppConstant.MAX_LEN_TPDU);
    static let m_iHostID = AppConstant.DEFAULT_HOSTID
    static let m_bField7PrintPAD = false;
    static let  m_nBatchID = 0;
    static let m_chArrHardwareSerialNumber = [Byte](repeating: 0, count: AppConstant.MAX_LEN_HARDWARE_SERIAL_NUMBER);
    static let m_bIsTerminalActivationPacket = false;
}
