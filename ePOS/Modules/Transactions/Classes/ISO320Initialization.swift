//
//  ISO320Initialization.swift
//  ePOS
//
//  Created by Naveen Goyal on 05/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class ISO320Initialization: ISOMessage
{
    var m_chDownloadingEMVparVersion = [Byte](repeating: 0x00, count: 13)
    var m_chDownloadingPSKVersion = [Byte](repeating: 0x00, count: 13)
    var m_uchMessage = [Byte](repeating: 0x00, count: AppConstant.MAX_MESSAGE_LEN + 1)
    var m_chTempImagefileName: String = ""
    var m_chTempImageDwnFile: String = ""
    var m_chTempImageChunkFile: String = ""
    var m_chTempClrdImagefileName: String = ""
    var m_chTempClrdImageDwnFile: String = ""
    var m_chTempClrdImageChunkFile: String = ""
    
    // for Dynamic chargeslip
    var m_chTempFixedChargeSlipfileName: String = ""
    var m_chTempFixedChargeSlipDwnFile: String = ""
    var m_chTempFixedChargeSlipChunkFile: String = ""
    
    // for Library file download
    var m_chTemplibfileName: String  = ""
    var m_chTemplibDwnFile: String = ""
    var m_chTemplibChunkFile: String = ""
    var m_chTempMINIPVMfileName: String = ""
    var m_chTempMINIPVMDwnFile: String = ""
    var m_chTempMINIPVMChunkFile: String = ""
    var m_chArrBuffer = [Byte](repeating: 0x00, count: 2000)
    var m_chDownloadingEDCAppVersion = [Byte](repeating: 0x00, count: AppConstant.MAX_APP_VERSION_LEN + 1)// Parameter to store current
    // downloading EDC App Version.
    var m_chDownloadingCLESSEMVparVersion = [Byte](repeating: 0x00, count: 13) // For ContactLess

    var m_iChangeNumber: Int = 0
    var m_imessageOffset: Int = 0
    var m_iOffsetBuffer: Int = 0
    var m_iHostUploadPacketNumber: Int  = 0
    var m_iPKExchangePacketNumber: Int = 0
    var m_iResPKExchangePacket: Int = 0

    //Content Server Changes for PC Starts
    var m_str_previous_ContentName: String = ""
    var m_str_current_ContentName: String = ""
    var m_str_temp_ContentName : String = ""
    var m_bis_last_content: Bool = false;
    var m_ulDownloadingContentId: Int64 = 0
    
    //Content Server Changes for PC Ends
    var m_ulDownloadingPvmVersion: Int64 = 0
    var m_ulDownloadingCACRTVersion: Int64 = 0

    var m_bCurrentPacketCount: Int64 = 0
    var m_bTotalPacketCount: Int64 = 0
    var m_temp_content_chunk: Int64 = 0
    var m_ulCountOfChargeSlipIdAdd: Int64 = 0
    var m_ulCountOfChargeSlipIdDelete: Int64 = 0
    var m_ulTotalChargeSlipTemplateAdded: Int64 = 0
    var m_ulCountOfImageIdAdd: Int = 0
    var m_ulCountOfImageIdDelete: Int = 0
    var m_ulTotalImagesAdded: Int = 0
    var m_ulCountOfColoredImageIdAdd: Int = 0
    var m_ulCountOfColoredImageIdDelete: Int = 0
    var m_ulTotalColoredImagesAdded: Int = 0
    var m_ulCountOfFixedChargeSlipIdAdd: Int = 0
    var m_ulCountOfFixedChargeSlipIdDelete: Int = 0
    var m_ulTotalFixedChargeSlipAdded: Int = 0
    var m_ulCountOfMessageIdAdd: Int = 0
    var m_ulCountOfMessageIdDelete: Int = 0
    var m_ulTotalMessagesAdded: Int = 0
    var m_ulLastParameterId: Int64 = 0
    var m_ulParameterIterator: Int = 0
    var m_ulBinRangeIterator: Int64 = 0
    var m_ulCSVTxnMapIterator: Int64 = 0
    var m_ulTxnBinIterator: Int64 = 0// Transaction Bin
    var m_ulTotalCSVTxnIgnAmtListIterator: Int64 = 0
    // EMV Tag download
    var m_ulTotalEMVTagListIterator: Int64 = 0
    // Txnwise Printing Location download
    var m_ulTotalTxnwisePrintingLocationIterator: Int64 = 0
    var m_ulCountOflibIdAdd: Int = 0
    var m_ulCountOflibIdDelete: Int = 0
    var m_ulTotallibAdded: Int = 0
    var m_ulCountOfMINIPVMIdAdd: Int = 0
    var m_ulCountOfMINIPVMIdDelete: Int = 0
    var m_ulTotalMINIPVMAdded: Int = 0

    //ghulam::Txnwise Is Password download
    var m_ulTotalTxnwiseIsPasswordIterator: Int64 = 0

    var m_ulArrChargeSlipIdAdd = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
    var m_ulArrChargeSlipIdDelete = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
    var m_ulArrImageIdAdd = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
    var m_ulArrImageIdDelete = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
    var m_ulArrColoredImageIdAdd = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
    var m_ulArrColoredImageIdDelete = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
    
    // Dynamic chargeslip
    var m_ulArrFixedChargeSlipIdAdd = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
    var m_ulArrFixedChargeSlipIdDelete = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
    var m_ulArrMessageIdAdd = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_MESSAGES + 1) // MAX_COUNT_MESSAGES
    var m_ulArrMessageIdDelete = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_MESSAGES + 1) // MAX_COUNT_MESSAGES
    // unsigned long m_ulTotalMessagesReceived;

    // for CIMB mini pvm download::amitesh
    var m_ulArrMINIPVMIdAdd = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_MINIPVM + 1) // MAX_COUNT_MINIPVM
    var m_ulArrMINIPVMIdDelete = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_MINIPVM + 1) // MAX_COUNT_MINIPVM
    var m_ObjArrParameterData: [ParameterData?] = []

    // for Lib file download-amitesh
    var m_ulArrlibIdAdd = [LIBStruct?](repeating: nil, count: AppConstant.MAX_LIB_FILE)
    var m_ulArrlibIdDelete = [LIBStruct?](repeating: nil, count: AppConstant.MAX_LIB_FILE)

    var loginAccountsMap = [String : LOGINACCOUNTS]()

    //MARK:- CISO320C()
    func CISO320C()
    {
        super.CISOMsgC()
        self.vFnSetTerminalActivationFlag(bTerminalActivationFlag: false)
    }

    //MARK:- vFnSetTerminalActivationFlag(bTerminalActivationFlag: Bool)
    override func vFnSetTerminalActivationFlag(bTerminalActivationFlag: Bool) {
          m_bIsTerminalActivationPacket = bTerminalActivationFlag
    }
    
    //MARK:- setField7PrintPAD()
    func setField7PrintPAD() {
        do {
            debugPrint("Inside setField7PrintPAD")
            let length: Int = len[ISOFieldConstants.ISO_FIELD_7 - 1]

            if (length > 0) {
                debugPrint("ISO_FILED_7 data[\(String(bytes: self.data[ISOFieldConstants.ISO_FIELD_7 - 1], encoding: String.Encoding.utf8)!)]")
                
                let strISOField7: String = String(bytes: self.data[ISOFieldConstants.ISO_FIELD_7 - 1], encoding: String.Encoding.utf8)!
                //String strISOField7 = new String(this.data[IsoFieldConstant.ISO_FIELD_7 - 1])
                if (strISOField7 == AppConstant.AC_PRINT_PAD) {
                    m_bField7PrintPAD = true;
                } else {
                    m_bField7PrintPAD = false;
                }
            }
        } catch {
            debugPrint("Exception Occurred \(error)")
        }
    }
    
    //MARK: - insertTLV(iParamID: Int, chArrParamData: [Byte], dataLen: Int) -> Int
    func insertTLV(iParamID: Int, chArrParamData: [Byte], dataLen: Int) -> Int
    {
        if(dataLen > 0){
            //m_chArrBuffer[m_iOffsetBuffer] = (Byte)(iHostID & 0xFF)
            //m_iOffsetBuffer += 1
            m_chArrBuffer[m_iOffsetBuffer] = (Byte)((iParamID >> 8) & 0xFF)
            m_iOffsetBuffer += 1
            m_chArrBuffer[m_iOffsetBuffer] = (Byte)(iParamID & 0xFF)
            m_iOffsetBuffer += 1
            m_chArrBuffer[m_iOffsetBuffer] = (Byte)((dataLen >> 8) & 0xFF)
            m_iOffsetBuffer += 1
            m_chArrBuffer[m_iOffsetBuffer] = (Byte)(dataLen & 0xFF)
            m_iOffsetBuffer += 1
            
            m_chArrBuffer[m_iOffsetBuffer ..< m_iOffsetBuffer + dataLen] = chArrParamData[0 ..< dataLen]
            //System.arraycopy(chArrParamData,0,m_chArrBuffer,m_iOffsetBuffer,dataLen)
            m_iOffsetBuffer += dataLen;
            debugPrint("iParamID[\(iParamID)], chArrParamData[\(String(describing: TransactionUtils.ByteArrayToHexString(chArrParamData)))]")
            //CLogger.TraceLog(TRACE_DEBUG, "iParamID[%d], chArrParamData[%s]",iParamID, BytesUtil.bytes2HexString(chArrParamData));
        }
        return 1;
    }
    
    //MARK:- memcmp
    func memcmp(str1: String, str2: String, iLen: Int) -> Int
    {
        if ((str1.count > 0) && (str2.count > 0) && (str1.count >= iLen) && ( str2.count >= iLen))
         {
            let sSource: String = str1.substring(from: 0, to: iLen)
            let sDest: String = str2.substring(from: 0, to: iLen)
            if (sSource == sDest)
            {
                return 0
            }
         }
         return 1
    }
    
    //MARK:- packIt(sendee: [Byte]) -> Int
    override func packIt(sendee: inout [Byte]) -> Int
    {
        let globalData = GlobalData.singleton
        debugPrint("m_iChangeNumber[\(m_iChangeNumber)]");
        vFnSetTerminalActivationFlag(bTerminalActivationFlag: false);
        /*    ***************************************************************************
                FEILD 0 ::Message Type
        ***************************************************************************/
        
        let copyData: [Byte] = [Byte](AppConstant.DOWNDATAREQ.utf8)
        msgno = Array(copyData[0 ..< copyData.count])
        //System.arraycopy(AppConst.DOWNDATAREQ.getBytes(), 0, msgno, 0, AppConst.DOWNDATAREQ.length());

        /****************************************************************************
                FEILD 3 ::Processing Code
         ***************************************************************************/
        //AppConst._enISO320_HOSTCOM_CHANGENUMBER enumReqType = AppConst._enISO320_HOSTCOM_CHANGENUMBER.values()[m_iChangeNumber-1];
        let enumReqType: Int = m_iChangeNumber
        
        switch (enumReqType) {
            case ISO320ChangeNumberConstants.HOST_PVM_DOWNLOAD:
                if(m_bCurrentPacketCount == 0) {
                    updateProgressDialog(msg: "PVM");
                }
                else {
                    let str = "PVM [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                    updateProgressDialog(msg: str)
                }
                _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_PVM_DLD_START.utf8), bcd: true);
                break;
            case ISO320ChangeNumberConstants.HOST_CHARGESLIP_ID_DOWNLOAD:
                    updateProgressDialog(msg: "CHARGESLIP ID")
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_CHARGE_SLIP_ID_DLD_START.utf8), bcd: true)
                    break
                case ISO320ChangeNumberConstants.HOST_CHARGESLIP_DOWNLOAD:
                    let str = "CHARGESLIP [\(m_ulTotalChargeSlipTemplateAdded + 1)/\(m_ulCountOfChargeSlipIdAdd)]"
                    updateProgressDialog(msg: str)
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_CHARGE_SLIP_DLD_START.utf8), bcd: true)
                    break
                case ISO320ChangeNumberConstants.HOST_IMAGE_ID_DOWNLOAD:
                    updateProgressDialog(msg: "IMAGE ID")
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_IMAGE_ID_DOWNLOAD_START.utf8), bcd: true)
                    break
                case ISO320ChangeNumberConstants.HOST_IMAGE_DOWNLOAD:
                    let str = "IMAGE [\(m_ulTotalImagesAdded + 1)/\(m_ulCountOfImageIdAdd)]"
                    updateProgressDialog(msg: str)
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_IMAGE_DOWNLOAD_START.utf8), bcd: true)
                    break
                case ISO320ChangeNumberConstants.HOST_COLORED_IMAGE_ID_DOWNLOAD:
                    updateProgressDialog(msg: "COLORED_IMAGE ID")
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_COLORED_IMAGE_ID_DOWNLOAD_START.utf8), bcd: true)
                    break
                case ISO320ChangeNumberConstants.HOST_COLORED_IMAGE_DOWNLOAD:
                    let str = "COLORED IMAGE [\(m_ulTotalColoredImagesAdded + 1)/\(m_ulCountOfColoredImageIdAdd)]"
                    updateProgressDialog(msg: str)
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_COLORED_IMAGE_DOWNLOAD_START.utf8), bcd: true)
                    break
                case ISO320ChangeNumberConstants.HOST_BATCH_ID:
                    updateProgressDialog(msg: "BATCH ID")
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_BATCH_ID.utf8), bcd: true);
                    break;
                case ISO320ChangeNumberConstants.HOST_CLOCK_SYNC:
                    updateProgressDialog(msg: "CLOCK SYNC");
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_CLOCK_SYNC_START.utf8), bcd: true);
                    break;
                case ISO320ChangeNumberConstants.HOST_MESSAGE_ID_LIST_DOWNLOAD:
                    updateProgressDialog(msg: "MESSAGE IDS");
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_MESSAGE_ID_LIST_DLD_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.HOST_MESSAGE_DOWNLOAD:
                    let str = "MESSAGE [\(m_ulTotalMessagesAdded + 1)/\(m_ulCountOfMessageIdAdd)]"
                    updateProgressDialog(msg: str);
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_MESSAGE_DLD_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.HOST_PARAMETERS_DOWNLOAD:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "PARAMETERS")
                    }
                    else {
                        let str = "PARAMETERS [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_PARAMETER_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.EMV_PARM_DWONLOAD:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "EMV PARAM")
                    }
                    else {
                        let str = "EMV PARAM [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_EMV_PARAM_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.HUB_PARM_UPLOAD:
                    updateProgressDialog(msg: "PARAM UPLOAD")
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_PARAMETER_UPLOAD_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.HUB_PARM_DOWNLOAD:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "PARAM DOWNLOAD")
                    }
                    else {
                        let str = "PARAM DOWNLOAD [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_PARAMETER_DOWNLOAD_START.utf8), bcd: true)
                    break

                case ISO320ChangeNumberConstants.HUB_PINEKEY_EXCHANGE:
                    let iTotalCount: Int = ISO320PineKeyExchangeChangeNum.END_SESSION
                    let str = "PINE KEY EXCHANGE [\(m_iPKExchangePacketNumber)/\(iTotalCount)]"
                    updateProgressDialog(msg: str)
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_PINEKEY_EXCHANGE_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.HUB_GET_PINE_SESSION_KEY:
                    updateProgressDialog(msg: "SESSION KEY");
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_GETPSK_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.HUB_GET_BIN_RANGE:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "BIN RANGE");
                    }
                    else {
                        let str = "BIN RANGE [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3,data1: [Byte](ProcessingCodeConstants.PC_GETBINRANGE_START.utf8), bcd: true);
                    break;
                case ISO320ChangeNumberConstants.HUB_GET_CSV_TXN_MAP:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "CSV TXN MAP");
                    }
                    else {
                        let str = "CSV TXN MAP [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_GETCSVTXNMAP_START.utf8), bcd: true);
                    break;
                case ISO320ChangeNumberConstants.HUB_GET_CACRT:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "CA CRT");
                    }
                    else {
                        let str = "CA CRT [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_GETCACRT_START.utf8), bcd: true)
                    break
                case ISO320ChangeNumberConstants.HUB_GET_TXN_BIN:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "TXN BIN");
                    }
                    else {
                        let str = "TXN BIN [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_GETTXNBIN_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.HUB_GET_IGNORE_AMT_CSV_TXN_LIST:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "IGNORE AMT CSV");
                    }
                    else {
                        let str = "IGNORE AMT CSV [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_IGNORE_AMOUNT_CSV_MAP_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.HUB_GET_EDC_APP_DOWNLOAD:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "EDC APP DOWNLOAD");
                    }
                    else {
                        let str = "EDC APP DOWNLOAD [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_EDC_APP_DOWNLOAD_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.EDC_FIXED_CHARGESLIP_ID_DOWNLOAD:
                    updateProgressDialog(msg: "FIXED CHARGESLIP ID");
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3,data1: [Byte](ProcessingCodeConstants.PC_EDC_REQUIRED_FIXED_CHARGESLIP_ID_LIST_DOWNLOAD_START.utf8), bcd: true);
                    break;
                case ISO320ChangeNumberConstants.EDC_FIXED_CHARGESLIP_DOWNLOAD:
                    let str = "FIXED CHARGESLIP DWND [\(m_ulTotalFixedChargeSlipAdded + 1)/\(m_ulCountOfFixedChargeSlipIdAdd)]"
                    updateProgressDialog(msg: str)
                    
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_EDC_REQUIRED_FIXED_CHARGESLIP_ID_DOWNLOAD_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.HUB_GET_EMV_TAG_LIST:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "EMV TAG LIST")
                    }
                    else {
                        let str = "EMV TAG LIST [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_EDC_REQUIRED_EMV_TAGS_DOWNLOAD_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.HUB_GET_CLESSPARAM:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "CLESS PARAM")
                    }
                    else {
                        let str = "CLESS PARAM [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_EDC_CLESSPARAM_UPDATE_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.HUB_GET_CLESS_UPLOAD:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "CLESS UPLOAD")
                    }
                    else {
                        let str = "CLESS UPLOAD [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_EDC_CLESSPARAM_UPLOAD_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.CLESS_PARM_DWONLOAD:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "CLESS XML")
                    }
                    else {
                        let str = "CLESS XML [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_EDC_CLESSXML_UPDATE_START.utf8), bcd: true);
                    break;
                case ISO320ChangeNumberConstants.EDC_PRINTING_LOCATION_DOWNLOAD:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "EDC PRINTING LOCATION");
                    }
                    else {
                        let str = "EDC PRINTING LOCATION [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_EDC_PRINTING_LOCATION_DOWNLOAD_START.utf8), bcd: true);
                    break;
                case ISO320ChangeNumberConstants.EDC_AID_EMV_TXNTYPE_DOWNLOAD:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "AID EMV TXN TYPE");
                    }
                    else {
                        let str = "AID EMV TXN TYPE [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ =  addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_EDC_AID_EMV_TXNTYPE_DOWNLOAD_START.utf8), bcd: true);
                    break;
                case ISO320ChangeNumberConstants.EDC_TXN_TYPE_FLAGS_MAPPING_DOWNLOAD:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "TXN TYPE FLAGS DOWNLOAD");
                    }
                    else {
                        let str = "TXN TYPE FLAGS DOWNLOAD [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_EDC_TXN_TYPE_FLAGS_DOWNLOAD_START.utf8), bcd: true);
                    break;
                case ISO320ChangeNumberConstants.EDC_LIB_LIST_DOWNLOAD:
                    updateProgressDialog(msg: "EDC LIB LIST");
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_EDC_LIB_LIST_DOWNLOAD_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.EDC_LIB_DOWNLOAD:
                    let str = "EDC LIB [\(m_ulTotallibAdded + 1)/\(m_ulCountOflibIdAdd)]"
                    updateProgressDialog(msg: str)
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_EDC_LIB_DOWNLOAD_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.HOST_MINIPVM_ID_DOWNLOAD:
                    updateProgressDialog(msg: "MINIPVM ID");
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_CIMB_MINIPVM_ID_DOWNLOAD_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.HOST_MINIPVM_DOWNLOAD:
                    let str = "MINIPVM [\(m_ulTotalMINIPVMAdded + 1)/\(m_ulCountOfMINIPVMIdAdd)]"
                    updateProgressDialog(msg: str)
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_CIMB_MINIPVM_DOWNLOAD_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.CSV_TXN_TYPE_MINIPVM_MAPPING_DOWNLOAD:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "TXN TYPE MINIPVM MAPPING");
                    }
                    else {
                        let str = "TXN TYPE MINIPVM MAPPING [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_EDC_CSV_TXN_TYPE_MINIPVM_MAPPING_DOWNLOAD_START.utf8), bcd: true);
                    break;
                case ISO320ChangeNumberConstants.EDC_ISPASSWORD_TXN_MAPPING_DOWNLOAD:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "TXN TYPE PASSWORD MAPPING");
                    }
                    else {
                        let str = "TXN TYPE PASSWORD MAPPING [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_EDC_TXN_TYPE_PASSWORD_MAPPING_DOWNLOAD_START.utf8), bcd: true);
                    break;
                case ISO320ChangeNumberConstants.EDC_LOG_SHIPPING_DETAILS_DOWNLOAD:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "LOG SHIPPING DETAILS");
                    }
                    else {
                        let str = "LOG SHIPPING DETAILS [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_EDC_LOG_SHIPPING_DETAILS_DOWNLOAD_START.utf8), bcd: true);
                    break;
                case ISO320ChangeNumberConstants.AD_SERVER_HTL_SYNC:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "AD SERVER HTL SYNC");
                    }
                    else {
                        let str = "AD SERVER HTL SYNC [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_AD_SERVER_HTL_SYNC_START.utf8), bcd: true)
                    break;
                case ISO320ChangeNumberConstants.USER_INFO_SYNC:
                    if(m_bCurrentPacketCount == 0) {
                        updateProgressDialog(msg: "USER INFO SYNC");
                    }
                    else {
                        let str = "USER INFO SYNC [\(m_bCurrentPacketCount)/\(m_bTotalPacketCount)]"
                        updateProgressDialog(msg: str)
                    }
                    _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_USER_INFO_SYNC_START.utf8), bcd: true)
                    break;
                //Content Server Changes for PC Starts
                case ISO320ChangeNumberConstants.HOST_CONTENT_DOWNLOAD:
                    updateProgressDialog(msg: "CONTENT SYNC FROM PC");
                    //Content Server Changes for PC Starts
                    if(CConx.isSerial())
                    {
                        if(m_temp_content_chunk != 0)
                        {
                            var chArrTempChunkSize: String = String(m_temp_content_chunk)
                            chArrTempChunkSize = TransactionUtils.StrLeftPad(data: chArrTempChunkSize, length: 6 , padChar: "0")
                            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_45, data1: [Byte](chArrTempChunkSize.utf8), bcd: true);
                        }
                        if(m_bCurrentPacketCount != 0 && m_bTotalPacketCount != 0)
                        {
                            var buffer = [Byte](repeating:0x00, count: 4)
                            var iLocalOffset: Int = 0x00;
                            var b: Int = Int(m_bCurrentPacketCount)

                            //Current Packet count 2 bytes
                            buffer[iLocalOffset] = Byte((b >> 8) & 0x000000FF)
                            iLocalOffset += 1
                            buffer[iLocalOffset] = Byte(b & 0x000000FF)
                            iLocalOffset += 1
                            
                            b = Int(m_bTotalPacketCount)

                            //Total Packet count 2 bytes
                            buffer[iLocalOffset] = Byte((b >> 8) & 0x000000FF);
                            iLocalOffset += 1
                            buffer[iLocalOffset] = Byte(b & 0x000000FF);
                            iLocalOffset += 1
                            debugPrint("AppConstant.IsoFieldConstant.ISO_FIELD_53[\(String(describing: String(bytes: buffer, encoding: .utf8)))]")

                            _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_53, data1: buffer, length: iLocalOffset)
                            debugPrint("Req->Setting field 53")
                        }
                        if (m_bis_last_content)
                        {
                            _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_OEM_CONTENT_DOWNLOAD_ACK.utf8), bcd: true)
                            m_bis_last_content = false
                        }
                        else
                        {
                            _ = addField(bitno: ISOFieldConstants.ISO_FIELD_3, data1: [Byte](ProcessingCodeConstants.PC_OEM_ALL_CONTENT_DOWNLOAD_START.utf8), bcd: true)
                        }
                    }
                    else
                    {
                        //Will add logging
                    }
                    break;
                //Content Server Changes for PC Ends
                default:
                    break;
            }

            if (m_iChangeNumber == ISO320ChangeNumberConstants.HOST_PVM_DOWNLOAD)
            {
                SetPVMDownLoadVersion();
            }

            if ((m_iChangeNumber == ISO320ChangeNumberConstants.HOST_CHARGESLIP_DOWNLOAD) ||
                (m_iChangeNumber == ISO320ChangeNumberConstants.HOST_IMAGE_DOWNLOAD) ||
                (m_iChangeNumber == ISO320ChangeNumberConstants.HOST_COLORED_IMAGE_DOWNLOAD) ||
                (m_iChangeNumber == ISO320ChangeNumberConstants.HOST_MESSAGE_DOWNLOAD) ||
                (m_iChangeNumber == ISO320ChangeNumberConstants.EDC_FIXED_CHARGESLIP_DOWNLOAD) ||
                (m_iChangeNumber == ISO320ChangeNumberConstants.HOST_MINIPVM_DOWNLOAD))
            {
                var bArrImageOrChargeSlipRequestBuffer: String
                var ulVal: DataLong = 0x00;

                if(m_iChangeNumber == ISO320ChangeNumberConstants.HOST_CHARGESLIP_DOWNLOAD)
                {
                    ulVal = m_ulArrChargeSlipIdAdd[Int(m_ulTotalChargeSlipTemplateAdded)]
                }
                else if(m_iChangeNumber == ISO320ChangeNumberConstants.HOST_IMAGE_DOWNLOAD)
                {
                    ulVal = m_ulArrImageIdAdd[m_ulTotalImagesAdded];
                    SetImageDownLoadData(imageId: ulVal);
                }
                else if(m_iChangeNumber == ISO320ChangeNumberConstants.HOST_COLORED_IMAGE_DOWNLOAD)
                {
                    ulVal = m_ulArrColoredImageIdAdd[m_ulTotalColoredImagesAdded];
                    SetColoredImageDownLoadData(imageId: ulVal);
                }
                else if(m_iChangeNumber == ISO320ChangeNumberConstants.HOST_MESSAGE_DOWNLOAD)
                {
                    ulVal = m_ulArrMessageIdAdd[ m_ulTotalMessagesAdded];
                }
                else if(m_iChangeNumber == ISO320ChangeNumberConstants.EDC_FIXED_CHARGESLIP_DOWNLOAD)
                {
                    ulVal = m_ulArrFixedChargeSlipIdAdd[m_ulTotalFixedChargeSlipAdded];
                    SetFixedChargeSlipDownLoadData(chargeslipId: ulVal);
                }
                else if(m_iChangeNumber == ISO320ChangeNumberConstants.HOST_MINIPVM_DOWNLOAD)
                {
                    ulVal = m_ulArrMINIPVMIdAdd[m_ulTotalMINIPVMAdded];
                    SetMINIPVMDownLoadData(MinipvmId: ulVal);
                    debugPrint("HOST_MINIPVM_DOWNLOAD[\(ulVal)]")
                }

                if(ulVal > 0){
                    bArrImageOrChargeSlipRequestBuffer = "\(ulVal)"
                    bArrImageOrChargeSlipRequestBuffer = TransactionUtils.StrLeftPad(data: bArrImageOrChargeSlipRequestBuffer, length: 8, padChar: "0");
                    let bArrTemp: [Byte] = TransactionUtils.a2bcd([Byte](bArrImageOrChargeSlipRequestBuffer.utf8))!

                    _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61, data1: bArrTemp, length: 4)
                    debugPrint("Req->Setting field 61")
                }else{
                    debugPrint("No ChargeSlip/Image to Downlaod");
                }
            }

            //for Library download-EDC_LIB_DOWNLOAD
            if(m_iChangeNumber == ISO320ChangeNumberConstants.EDC_LIB_DOWNLOAD) //to support Library Download
            {
                debugPrint("EDC_LIB_DOWNLOAD");

                let ulLibId: DataLong = DataLong(m_ulArrlibIdAdd[m_ulTotallibAdded]!.id)
                SetLibDownLoadData(LibId: ulLibId);

                var bLocalBuffer = [Byte](repeating: 0x00, count: 4)
                
                bLocalBuffer[0] = Byte((ulLibId >> 24) & 0x000000FF)
                bLocalBuffer[1] = Byte((ulLibId >> 16) & 0x000000FF)
                bLocalBuffer[2] = Byte((ulLibId >> 8) &  0x000000FF)
                bLocalBuffer[3] = Byte(ulLibId & 0x000000FF)

                _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61, data1: bLocalBuffer, length: 4)
            }


            /************************************************************************
             * ChangeNumber = CHARGESLIP_DOWNLOAD
             *************************************************************************/
            if (m_iChangeNumber == ISO320ChangeNumberConstants.HOST_CHARGESLIP_ID_DOWNLOAD) {

                var bLocalBuffer = [Byte](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES * 4)
                var iLocalOffset: Int = 0x00
                var numberOfItems: Int = 0x00

                let ItemList: [Long] = FileSystem.ReadFile(strFileName: FileNameConstants.MASTERCGFILE)!
                if(!ItemList.isEmpty) {
                    numberOfItems = ItemList.count
                    debugPrint("numberOfItems[\(numberOfItems)]");
                    for i in 0 ..< numberOfItems {
                        let ulcharegSlipId: DataLong = ItemList[i].value;
                        if (ulcharegSlipId != 0x0000) {
                            let PadedChargeSlipId: String = String(format: "%08d", ulcharegSlipId);
                            let tempArr: [Byte] = TransactionUtils.a2bcd([Byte](PadedChargeSlipId.utf8))!
                            bLocalBuffer[iLocalOffset ..< iLocalOffset + 4] = ArraySlice<Byte>(tempArr[0 ..< 4])
                            
                            //System.arraycopy(tempArr,0,bLocalBuffer,iLocalOffset,4);
                            iLocalOffset += 4;
                        }
                    }
                }

                if(iLocalOffset > 0)
                {
                    _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61, data1: bLocalBuffer, length: iLocalOffset)
                    debugPrint("Req->Setting field 61");
                }
            }

            //For dynamic fixed chargeslip format
            /************************************************************************
             * ChangeNumber = EDC_FIXED_CHARGESLIP_ID_DOWNLOAD
             *************************************************************************/
            if (m_iChangeNumber == ISO320ChangeNumberConstants.EDC_FIXED_CHARGESLIP_ID_DOWNLOAD) {
                
                var bLocalBuffer = [Byte](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES * 4)
                var iLocalOffset: Int = 0x00
                var numberOfItems: Int = 0x00
                
                let ItemList: [Long] = FileSystem.ReadFile(strFileName: FileNameConstants.MASTERFCGFILE)!
                if(!ItemList.isEmpty) {
                    numberOfItems = ItemList.count
                    debugPrint("numberOfItems[\(numberOfItems)]")

                    for i in 0 ..< numberOfItems {
                        let ulcharegSlipId: DataLong = ItemList[i].value
                        if (ulcharegSlipId != 0x0000) {
                            let res: String = String(format: "%08d", ulcharegSlipId)
                            let PadedChargeSlipId: [Byte] = TransactionUtils.a2bcd([Byte](res.utf8))!
                            bLocalBuffer[iLocalOffset ..< iLocalOffset + PadedChargeSlipId.count] = ArraySlice<Byte>(PadedChargeSlipId[0 ..< PadedChargeSlipId.count])
                            
                            //System.arraycopy(PadedChargeSlipId, 0, bLocalBuffer, iLocalOffset, PadedChargeSlipId.length);
                            iLocalOffset += 4;
                        }
                    }
                }

                if(iLocalOffset > 0)
                {
                    _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61, data1: bLocalBuffer, length: iLocalOffset)
                    debugPrint("Req->Setting field 61")
                }
            }

            //For LIB FILE DOWNLOAD and UPLOAD ::amitesh
            /************************************************************************
             * ChangeNumber = EDC_LIB_LIST_DOWNLOAD
             *************************************************************************/
            if (m_iChangeNumber == ISO320ChangeNumberConstants.EDC_LIB_LIST_DOWNLOAD) {

                debugPrint("m_iChangeNumber = EDC_LIB_LIST_DOWNLOAD");
                var bLocalBuffer = [Byte](repeating: 0x00, count: AppConstant.MAX_COUNT_LIBRARY * 4)
                var iLocalOffset: Int = 0x00
                var numberOfItems: Int = 0x00

                let ItemList: [LIBStruct] = FileSystem.ReadFile(strFileName: FileNameConstants.MASTERLIBFILE)!
                if(!ItemList.isEmpty){
                    numberOfItems = ItemList.count
                    for i in 0 ..< numberOfItems {
                        let ulLibId: DataLong = DataLong(ItemList[i].id)
                        if(ulLibId > 0){
                            bLocalBuffer[iLocalOffset] = Byte((ulLibId >> 24) & 0x000000FF)
                            iLocalOffset += 1
                            bLocalBuffer[iLocalOffset] = Byte((ulLibId >> 16) & 0x000000FF)
                            iLocalOffset += 1
                            bLocalBuffer[iLocalOffset] = Byte((ulLibId >> 8) &  0x000000FF)
                            iLocalOffset += 1
                            bLocalBuffer[iLocalOffset] = Byte(ulLibId & 0x000000FF)
                            iLocalOffset += 1
                            debugPrint("LibId[%d]", ulLibId)
                        }
                    }
                }

                if(iLocalOffset > 0)
                {
                    _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61, data1: bLocalBuffer, length: iLocalOffset)
                    debugPrint("Req->Setting field 61")
                }
            }

            /************************************************************************
             * ChangeNumber = IMAGE_ID_DOWNLOAD
             *************************************************************************/
            if (m_iChangeNumber == ISO320ChangeNumberConstants.HOST_IMAGE_ID_DOWNLOAD) {
                /**************************************************************************
                 *when ch== 4 means request for image ID to be downloaded.
                 *prepare list of images already with us.
                 *whenever we will have added a image we will store its id
                 *in a image id master.
                 *on deletion of a image we will synchronize the list by deleting
                 *from the master then purging.
                 **************************************************************************/

                var bLocalBuffer = [Byte](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES * 4)
                var iLocalOffset: Int = 0x00
                var numberOfItems: Int = 0x00

                let ItemList: [Long] = FileSystem.ReadFile(strFileName: FileNameConstants.MASTERIMFILE)!
                if(!ItemList.isEmpty) {
                    numberOfItems = ItemList.count
                    for i in 0 ..< numberOfItems {
                        let ulImageId: DataLong = ItemList[i].value;
                        if (ulImageId != 0x0000) {
                            let PadedImageId: String = String(format: "%08d", ulImageId);
                            let tempArr: [Byte] = TransactionUtils.a2bcd([Byte](PadedImageId.utf8))!;
                            
                            bLocalBuffer = Array(tempArr[0 ..< 4])
                            //System.arraycopy(tempArr,0,bLocalBuffer,iLocalOffset,4);
                            debugPrint("ImageId[\(PadedImageId)]")
                            iLocalOffset += 4;
                        }
                    }
                }

                if(iLocalOffset > 0)
                {
                    _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61, data1: bLocalBuffer, length: iLocalOffset)
                    debugPrint("Req->Setting field 61");
                }
            }

            /************************************************************************
             * ChangeNumber = COLORED_IMAGE_ID_DOWNLOAD
             *************************************************************************/
            if (m_iChangeNumber == ISO320ChangeNumberConstants.HOST_COLORED_IMAGE_ID_DOWNLOAD) {
                /**************************************************************************
                 *when ch== 4 means request for colored image ID to be downloaded.
                 *prepare list of images already with us.
                 *whenever we will have added a image we will store its id
                 *in a image id master.
                 *on deletion of a image we will synchronize the list by deleting
                 *from the master then purging.
                 **************************************************************************/

                var bLocalBuffer = [Byte](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES * 4)
                var iLocalOffset: Int = 0x00
                var numberOfItems: Int = 0x00

                let ItemList: [Long] = FileSystem.ReadFile(strFileName: FileNameConstants.MASTERCLRDIMFILE)!
                if(!ItemList.isEmpty) {
                    numberOfItems = ItemList.count
                    for i in 0 ..< numberOfItems {
                        let ulImageId: DataLong = ItemList[i].value
                        if (ulImageId != 0x0000) {
                            let PadedImageId: String = String(format: "%08d", ulImageId);
                            let tempArr: [Byte] = TransactionUtils.a2bcd([Byte](PadedImageId.utf8))!;
                            bLocalBuffer = Array(tempArr[0 ..< 4])
                            //System.arraycopy(tempArr,0,bLocalBuffer,iLocalOffset,4);
                            debugPrint("ImageId[\(PadedImageId)]");
                            iLocalOffset += 4;
                        }
                    }
                }

                if(iLocalOffset > 0)
                {
                    _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61, data1: bLocalBuffer, length: iLocalOffset);
                    debugPrint("Req->Setting field 61")
                }
            }

            /************************************************************************
             * ChangeNumber = MESSAGE_ID_LIST_DOWNLOAD
             *************************************************************************/
            if (m_iChangeNumber == ISO320ChangeNumberConstants.HOST_MESSAGE_ID_LIST_DOWNLOAD) {

                var iLocalOffset: Int = 0x00
                var bLocalBuffer = [Byte](repeating: 0x00, count: AppConstant.MAX_COUNT_MESSAGES * 4)
                var ulMessId: DataLong = 0

                let NumberOFRows: Int = FileSystem.NumberOfRows(strFileName: FileNameConstants.MASTERMESFILE, obj: StructMESSAGEID.self)
                for i in 0 ..< NumberOFRows
                {
                    let temp: StructMESSAGEID = FileSystem.SeekRead(strFileName: FileNameConstants.MASTERMESFILE, iOffset: i)!
                    ulMessId = temp.lmessageId;
                    if(ulMessId != 0x0000)
                    {
                        let PadedMessageId: String = String(format: "%08d",ulMessId)
                        let temp1: [Byte] = TransactionUtils.a2bcd([Byte](PadedMessageId.utf8))!
                        
                        bLocalBuffer[iLocalOffset ..< iLocalOffset + 4] = ArraySlice<Byte>(temp1[0 ..< 4])
                        //System.arraycopy(temp1,0,bLocalBuffer,iLocalOffset,4);
                        debugPrint("Message Id[\(PadedMessageId)]");
                        iLocalOffset += 4;      // sizeof(unsigned long);
                    }
                }

                if(iLocalOffset > 0)
                {
                    _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61, data1: bLocalBuffer, length: iLocalOffset)
                    debugPrint("Req->Setting field 61")
                }
            }

            if(m_iChangeNumber == ISO320ChangeNumberConstants.HOST_PARAMETERS_DOWNLOAD){

                debugPrint("m_iChangeNumber = PARAMETERS_DOWNLOAD");
                let chFileName: String = String(format: "%s.plist", FileNameConstants.TERMINALPARAMFILENAME)
                debugPrint("param file name[\(chFileName)]");

                let ItemList: [TerminalParamData] = FileSystem.ReadFile(strFileName: chFileName)!
                debugPrint("m_sParamDownloadDate[\(ItemList[0].m_strParamDownloadDate)]");

                // Left pad with '0'
                var tmmBuf: [Byte] = [Byte](repeating: 0x00, count: 12)
                let tempData: [Byte] = [Byte](ItemList[0].m_strParamDownloadDate.utf8)
                tmmBuf = Array(tempData[0 ..< 12])
                
                //System.arraycopy(ItemList[0].m_strParamDownloadDate.utf8,0,tmmBuf,0,12);
                let chArrParamDownLoadDate: String = TransactionUtils.StrLeftPad(data: String(bytes: tmmBuf, encoding: .utf8)!, length: 12,padChar: "0");
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_43, data1: [Byte](chArrParamDownLoadDate.utf8), bcd: true);
                debugPrint("Req->Setting field 43");

                if(m_ulLastParameterId > 0 ){
                    var bLocalBuffer = [Byte](repeating: 0x00, count: 50)
                    var iLocalOffset: Int = 0x00

                    bLocalBuffer[iLocalOffset] = Byte((m_ulLastParameterId >> 8) & 0x000000FF)
                    iLocalOffset += 1
                    bLocalBuffer[iLocalOffset] = Byte(m_ulLastParameterId & 0x000000FF)
                    iLocalOffset += 1
                    
                    _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61, data1: bLocalBuffer, length: iLocalOffset);
                    debugPrint("Req->Setting field 61 for last parameter Id");
                }
            }

            /*    ***************************************************************************
                          FEILD 44 ::Partially Downloaded EMV_PAR_DWONLOAD (6 :ASCII )
                ***************************************************************************/
            if (m_iChangeNumber == ISO320ChangeNumberConstants.EMV_PARM_DWONLOAD)
            {
                SetEMVParDownLoadVersion();
                _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61, data1: [Byte](globalData.m_sMasterParamData!.m_strEMVParVersion.utf8), length: 12);
            }

            /************************************************************************
             * ChangeNumber = CLESS_PARM_DWONLOAD
             *************************************************************************/
            if (m_iChangeNumber == ISO320ChangeNumberConstants.CLESS_PARM_DWONLOAD)
            {
                SetCLESSEMVParDownLoadVersion();
                _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61,  data1: [Byte](globalData.m_sMasterParamData!.m_strCLESSEMVParVersion.utf8), length: 12);
            }

            if (m_iChangeNumber == ISO320ChangeNumberConstants.HUB_PARM_UPLOAD)
            {
                /*******************************************************************************
                 * Upload of parameters to Plutus HUB
                 * Pack Data in TLV format
                 * Parameter ID 2 Bytes
                 * Length       2 Bytes
                 * Data                   //Add In Field 61
                 ******************************************************************************/

                packHostUploadPacket();
            }

            if (m_iChangeNumber == ISO320ChangeNumberConstants.HUB_PARM_DOWNLOAD)
            {
                debugPrint("m_iChangeNumber = PARAMETERS_DOWNLOAD")
                /*add field 43 with the actual last parameter updation date time.
                 in case if no date time is available then set it to 1 jan 2011 11 59 59
                 this date time will be stored in the flash when parameter download has ended. */

                let chFileName: String = String(format: "%s.plist", FileNameConstants.TERMINALPARAMFILENAME);
                debugPrint("param file name[\(chFileName)]")

                //List<TerminalParamData>ItemList = CFileSystem.ReadFile(m_cntx, TerminalParamData[].class, chFileName);
                let tData: TerminalParamData = GlobalData.singleton.ReadParamFile()!
                if(tData != nil){
                    debugPrint("m_sParamDownloadDate[\(tData.m_strParamDownloadDate)]")

                    // Left pad with '0'
                    var tmmBuf = [Byte](repeating: 0x00, count: 12)
                    let tempData: [Byte] = [Byte](tData.m_strParamDownloadDate.utf8)
                    tmmBuf = Array(tempData[0 ..< 12])
                    //System.arraycopy(tData.m_strParamDownloadDate.utf8,0,tmmBuf,0,12);
                    
                    let chArrParamDownLoadDate: String = TransactionUtils.StrLeftPad(data: String(bytes: tmmBuf, encoding: .utf8)!, length: 12, padChar: "0");
                    _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_43, data1: [Byte](chArrParamDownLoadDate.utf8), bcd: true);
                }

                if (m_ulLastParameterId > 0) {
                    var bLocalBuffer = [Byte](repeating: 0x00, count: 2)
                    var iLocalOffset: Int = 0x00

                    bLocalBuffer[iLocalOffset] = Byte(((m_ulLastParameterId >> 8) & 0x000000FF))
                    iLocalOffset += 1
                    bLocalBuffer[iLocalOffset] = Byte((m_ulLastParameterId & 0x000000FF))
                    iLocalOffset += 1
                    _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61,  data1: bLocalBuffer, length: iLocalOffset)
                }
            }
            if (m_iChangeNumber == ISO320ChangeNumberConstants.HUB_PINEKEY_EXCHANGE)
            {
                SetPineKeyExchangeRequest();
            }

            if (m_iChangeNumber == ISO320ChangeNumberConstants.HUB_GET_PINE_SESSION_KEY)
            {
                /****************************************************************
                 * If file exist, pack the data as the given format
                 * Request
                 * SLOT COUNT 1 Byte (n)
                 * {
                 * KEY_SLOT_ID                1 byte
                 * EXISTING_PSK_PIN_LEN        1 byte (X)
                 * PSK_PIN                    X bytes
                 * EXISTING_PSK_TLE_LEN        1 byte (Y)
                 * PSK_TLE}                    Y bytes
                 * n
                 *
                 ****************************************************************/
                var chArrTxnBuffer = [Byte](repeating: 0x00, count: 1000)
                var iOffset: Int = 0;
                let isPSKFileExist: Bool = FileSystem.IsFileExist(strFileName: FileNameConstants.PSKSDWNLDFILE)
                debugPrint("PSKSDWNLDFILE[\(isPSKFileExist)]")
                if(isPSKFileExist){
                    //if file exist pack acutal file data
                    //TODO: No requirement for PSKFile
                    //globalData.ReadPSKFile()

                    var uchArrTempPSK: [Byte]?

                    //Use Default Key Slot Only
                    //Here these slot IDs are used instead of previous slot IDs,
                    //if Default KeySlot Only flag changes, then number increases from 1 to 8 but
                    //key slots present in This file would be only 1. Therefore for further txns
                    //only one PSK would have been received.
                    let iUseDefaultKeySlotOnly: Bool = globalData.m_sMasterParamData!.m_iUseDefaultKeySlotOnly;
                    var iNumKeySlot: Int
                    if(iUseDefaultKeySlotOnly){
                        iNumKeySlot = AppConstant.DEFAULT_NUM_KEYSLOT;
                    }else{
                        iNumKeySlot = AppConstant.NUM_KEYSLOTS;
                    }

                    chArrTxnBuffer[iOffset] = Byte(iNumKeySlot & 0x00FF);
                    iOffset += 1
                    
                    for it in 0 ..< iNumKeySlot {
                        //Keyslot ID
                        chArrTxnBuffer[iOffset] = Byte(AppConstant.keySlotMap[it][AppConstant.ID_KEYSLOTID] & 0x00FF)
                        iOffset += 1
                        
                        //PSK Pin in ASCII
                        chArrTxnBuffer[iOffset] = 0x20
                        iOffset += 1
                        uchArrTempPSK = TransactionUtils.bcd2a(globalData.m_sPSKData!.stPSK[it]!.uchArrPSKPin, 24)
                        chArrTxnBuffer[iOffset ..< iOffset + 32] = ArraySlice<Byte>(uchArrTempPSK![0 ..< 32])
                        
                        //System.arraycopy(uchArrTempPSK,0,chArrTxnBuffer,iOffset,32);
                        iOffset += 32;

                        //PSK TLE in ASCII
                        chArrTxnBuffer[iOffset] = 0x20;
                        iOffset += 1
                        uchArrTempPSK = TransactionUtils.bcd2a([Byte](globalData.m_sPSKData!.stPSK[it]!.uchArrPSKTLE), 24)
                        chArrTxnBuffer[iOffset ..< iOffset + 32] = ArraySlice<Byte>(uchArrTempPSK![0 ..< 32])
                        
                        //System.arraycopy(uchArrTempPSK,0,chArrTxnBuffer,iOffset,32);
                        iOffset += 32;
                    }
                }else{
                    //Use Default Key Slot Only
                    let iUseDefaultKeySlotOnly: Bool = globalData.m_sMasterParamData!.m_iUseDefaultKeySlotOnly;
                    var iNumKeySlot: Int
                    if(iUseDefaultKeySlotOnly){
                        iNumKeySlot = AppConstant.DEFAULT_NUM_KEYSLOT;
                    }else{
                        iNumKeySlot = AppConstant.NUM_KEYSLOTS;
                    }

                    debugPrint("iNumKeySlot[\(iNumKeySlot)]");

                    //if file doesnt exist, send len as 0 for both PIN and TLE
                    chArrTxnBuffer[iOffset] = Byte(iNumKeySlot & 0x000000FF);
                    iOffset += 1
                    for it in 0 ..< iNumKeySlot {
                        chArrTxnBuffer[iOffset] = Byte(AppConstant.keySlotMap[it][AppConstant.ID_KEYSLOTID] & 0x00FF)
                        iOffset += 1
                        chArrTxnBuffer[iOffset] = 0x00
                        iOffset += 1
                        chArrTxnBuffer[iOffset] = 0x00
                        iOffset += 1
                    }
                }
                debugPrint("chArrTxnBuffer len[\(iOffset)]");
                _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61,data1: chArrTxnBuffer,length: iOffset)
            }

            if(m_iChangeNumber == ISO320ChangeNumberConstants.HUB_GET_BIN_RANGE){
                var tmmBuf = [Byte](repeating: 0x00, count: 12)
                let tempData: [Byte] = [Byte](globalData.m_sMasterParamData!.m_strBinRangeDownloadDate.utf8)
                tmmBuf = Array(tempData[0 ..< 12])
                
                //System.arraycopy(globalData.m_sMasterParamData!.m_strBinRangeDownloadDate.utf8,0,tmmBuf,0,12);
                let chArrParamDownLoadDate: String = TransactionUtils.StrLeftPad(data: String(bytes: tmmBuf,encoding: .utf8)!, length: 12,padChar: "0");
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_43, data1: [Byte](chArrParamDownLoadDate.utf8), bcd: true);
            }

            if (m_iChangeNumber == ISO320ChangeNumberConstants.HUB_GET_CACRT)
            {
                SetCACRTDownLoadVersion()
            }

            if(m_iChangeNumber == ISO320ChangeNumberConstants.HUB_GET_CSV_TXN_MAP){
                var tmpBuff = [Byte](repeating: 0x00, count: 12)
                let tempData: [Byte] = [Byte](globalData.m_sMasterParamData!.m_strCSVTxnMapVersion.utf8)
                tmpBuff = Array(tempData[0 ..< 12])

                //System.arraycopy(GlobalData.m_sMasterParamData.m_strCSVTxnMapVersion.utf8,0,tmpBuff,0,12);
                let chArrParamDownLoadDate: String = TransactionUtils.StrLeftPad(data: String(bytes: tmpBuff, encoding: .utf8)!, length: 12, padChar: "0")
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_43, data1: [Byte](chArrParamDownLoadDate.utf8), bcd: true)
            }

            //Transaction Bin
            if(m_iChangeNumber == ISO320ChangeNumberConstants.HUB_GET_TXN_BIN){
                var tmpBuff = [Byte](repeating: 0x00, count: 12)
                let tempData: [Byte] = [Byte](globalData.m_sMasterParamData!.m_strTxnBinDownloadDate.utf8)
                tmpBuff = Array(tempData[0 ..< 12])

                
                //System.arraycopy(GlobalData.m_sMasterParamData.m_strTxnBinDownloadDate.utf8,0,tmpBuff,0,12);
                let chArrParamDownLoadDate: String = TransactionUtils.StrLeftPad(data: String(bytes: tmpBuff, encoding: .utf8)!, length: 12, padChar: "0")
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_43, data1: [Byte](chArrParamDownLoadDate.utf8), bcd: true)
            }

            if(m_iChangeNumber == ISO320ChangeNumberConstants.HUB_GET_IGNORE_AMT_CSV_TXN_LIST){
                var tmpBuff = [Byte](repeating: 0x00, count: 12)
                let tempData: [Byte] = [Byte](globalData.m_sMasterParamData!.m_strIgnoreAmtCSVTxnListDownloadDate.utf8)
                tmpBuff = Array(tempData[0 ..< 12])

                //System.arraycopy(GlobalData.m_sMasterParamData.m_strIgnoreAmtCSVTxnListDownloadDate.utf8,0,tmpBuff,0,12);
                let chArrParamDownLoadDate: String = TransactionUtils.StrLeftPad(data: String(bytes: tmpBuff, encoding: .utf8)!, length: 12, padChar: "0");
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_43, data1: [Byte](chArrParamDownLoadDate.utf8), bcd: true);
            }

            if(m_iChangeNumber == ISO320ChangeNumberConstants.HUB_GET_EMV_TAG_LIST){
                /****************************************
                 * Filed 43 set EMV Tag list version
                 ****************************************/
                var tmpBuff = [Byte](repeating: 0x00, count: 12)
                let tempData: [Byte] = [Byte](globalData.m_sMasterParamData!.m_strEMVTagListDownloadDate.utf8)
                tmpBuff = Array(tempData[0 ..< 12])
                
                //System.arraycopy(GlobalData.m_sMasterParamData.m_strEMVTagListDownloadDate.utf8,0,tmpBuff,0,12);
                let chArrParamDownLoadDate: String = TransactionUtils.StrLeftPad(data: String(bytes: tmpBuff, encoding: .utf8)!, length: 12, padChar: "0");
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_43, data1: [Byte](chArrParamDownLoadDate.utf8), bcd: true)
            }

            //For Cless Param version
            if(m_iChangeNumber == ISO320ChangeNumberConstants.HUB_GET_CLESSPARAM){
                var tmpBuff = [Byte](repeating: 0x00, count: 12)
                let tempData: [Byte] = [Byte](globalData.m_sMasterParamData!.m_strCLessParamDownloadDate.utf8)
                tmpBuff = Array(tempData[0 ..< 12])

                //System.arraycopy(GlobalData.m_sMasterParamData.m_strCLessParamDownloadDate.utf8,0,tmpBuff,0,12);
                let chArrParamDownLoadDate: String = TransactionUtils.StrLeftPad(data: String(bytes: tmpBuff, encoding: .utf8)!, length: 12, padChar: "0");
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_43,data1: [Byte](chArrParamDownLoadDate.utf8), bcd: true);
            }
                /*    ***************************************************************************
                              FEILD 44 ::Partially Downloaded EDC_APP_DWONLOAD (6 :ASCII )
                    ***************************************************************************/
            if (m_iChangeNumber == ISO320ChangeNumberConstants.HUB_GET_EDC_APP_DOWNLOAD)
            {

                /************************************************************************
                 * ChangeNumber = HUB_GET_EDC_APP_DOWNLOAD
                 *************************************************************************/
                SetEDCAppDownLoadVersion();
            }

            /*    ***************************************************************************
                          Abhishek added for downloading printing location details
                ***************************************************************************/
            if(m_iChangeNumber == ISO320ChangeNumberConstants.EDC_PRINTING_LOCATION_DOWNLOAD)
            {
                debugPrint("m_iChangeNumber = EDC_PRINTING_LOCATION_DOWNLOAD");
            }

            if(m_iChangeNumber == ISO320ChangeNumberConstants.EDC_AID_EMV_TXNTYPE_DOWNLOAD)
            {
                debugPrint("m_iChangeNumber = EDC_AID_EMV_TXNTYPE_DOWNLOAD");

                var tmpBuff = [Byte](repeating: 0x00, count: 12)
                let tempData: [Byte] = [Byte](globalData.m_sMasterParamData!.m_strAIDEMVTXNTYPEDownloadDate.utf8)
                tmpBuff = Array(tempData[0 ..< 12])
                
                //System.arraycopy(GlobalData.m_sMasterParamData.m_strAIDEMVTXNTYPEDownloadDate.utf8,0,tmpBuff,0,12);
                let chArrParamDownLoadDate: String = TransactionUtils.StrLeftPad(data: String(bytes: tmpBuff, encoding: .utf8)!, length: 12, padChar: "0")
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_43,data1: [Byte](chArrParamDownLoadDate.utf8), bcd: true)
            }

            if(m_iChangeNumber == ISO320ChangeNumberConstants.EDC_TXN_TYPE_FLAGS_MAPPING_DOWNLOAD)
            {
                debugPrint("m_iChangeNumber = EDC_TXN_TYPE_FLAGS_MAPPING_DOWNLOAD");

                var tmpBuff = [Byte](repeating: 0x00, count: 12)
                let tempData: [Byte] = [Byte](globalData.m_sMasterParamData!.m_strTxnTypeFlagsMappingDownloadDate.utf8)
                tmpBuff = Array(tempData[0 ..< 12])
                               
                //System.arraycopy(GlobalData.m_sMasterParamData.m_strTxnTypeFlagsMappingDownloadDate.utf8,0,tmpBuff,0,12);
                let chArrParamDownLoadDate: String = TransactionUtils.StrLeftPad(data: String(bytes: tmpBuff, encoding: .utf8)!, length: 12, padChar: "0");
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_43,data1: [Byte](chArrParamDownLoadDate.utf8), bcd: true)
            }
            /************************************************************************
             * ChangeNumber = HOST_MINIPVM_ID_DOWNLOAD
             *************************************************************************/
            if (m_iChangeNumber == ISO320ChangeNumberConstants.HOST_MINIPVM_ID_DOWNLOAD) {
                debugPrint("HOST_MINIPVM_ID_DOWNLOAD");

                var bLocalBuffer = [Byte](repeating: 0x00, count: AppConstant.MAX_COUNT_MINIPVM * 4)
                var iLocalOffset: Int = 0x00
                var numberOfItems: Int = 0

                let ItemList: [Long] = FileSystem.ReadFile(strFileName: FileNameConstants.MASTERMINIPVMFILE)!
                if(!ItemList.isEmpty) {
                    numberOfItems = ItemList.count
                    debugPrint("numberOfItems Mini pvm[\(numberOfItems)]")
                    
                    for i in 0 ..< numberOfItems {
                        let ulMiniPVMId: DataLong = ItemList[i].value;
                        if (ulMiniPVMId != 0x0000) {
                            let res: String = String(format: "%08d", ulMiniPVMId);
                            let PadedMiniPVMId: [Byte] =  TransactionUtils.a2bcd([Byte](res.utf8))!
                            bLocalBuffer[iLocalOffset ..< iLocalOffset + 4] = ArraySlice<Byte>(PadedMiniPVMId[0 ..< 4])
                            
                            //System.arraycopy(PadedMiniPVMId,0,bLocalBuffer,iLocalOffset,4);
                            iLocalOffset += 4;
                            debugPrint("PadedMiniPVMId[\(TransactionUtils.byteArray2HexString(arr: PadedMiniPVMId))]")
                        }
                    }
                }

                if(iLocalOffset > 0)
                {
                    _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61, data1: bLocalBuffer, length: iLocalOffset)
                    debugPrint("Req->Setting field 61");
                }
            }

            if(m_iChangeNumber == ISO320ChangeNumberConstants.CSV_TXN_TYPE_MINIPVM_MAPPING_DOWNLOAD)
            {
                debugPrint("m_iChangeNumber = CSV_TXN_TYPE_MINIPVM_MAPPING_DOWNLOAD");

                var tmpBuff = [Byte](repeating: 0x00, count: 12)
                let tempData: [Byte] = [Byte](globalData.m_sMasterParamData!.m_strCsvTxnTypeMiniPvmMappingDownloadDate.utf8)
                tmpBuff = Array(tempData[0 ..< 12])
                
                //System.arraycopy(GlobalData.m_sMasterParamData.m_strCsvTxnTypeMiniPvmMappingDownloadDate.utf8,0,tmpBuff,0,12);
                let chArrParamDownLoadDate: String = TransactionUtils.StrLeftPad(data: String(bytes: tmpBuff, encoding: .utf8)!, length: 12, padChar: "0");
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_43,data1: [Byte](chArrParamDownLoadDate.utf8), bcd: true)
            }

            //IS Password required for txn mapping table date
            if(m_iChangeNumber == ISO320ChangeNumberConstants.EDC_ISPASSWORD_TXN_MAPPING_DOWNLOAD)
            {
                debugPrint("m_iChangeNumber = EDC_ISPASSWORD_TXN_MAPPING_DOWNLOAD");

                var tmpBuff = [Byte](repeating: 0x00, count: 12)
                let tempData: [Byte] = [Byte](globalData.m_sMasterParamData!.m_strISPasswordDownloadDate.utf8)
                tmpBuff = Array(tempData[0 ..< 12])
                
                //System.arraycopy(GlobalData.m_sMasterParamData.m_strISPasswordDownloadDate.utf8,0,tempBuff,0,12);
                let chArrISPasswordDownloadDate: String = TransactionUtils.StrLeftPad(data: String(bytes: tmpBuff, encoding: .utf8)!, length: 12, padChar: "0")
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_43,data1: [Byte](chArrISPasswordDownloadDate.utf8), bcd: true);
            }

            if(m_iChangeNumber == ISO320ChangeNumberConstants.EDC_LOG_SHIPPING_DETAILS_DOWNLOAD)
            {
                debugPrint("m_iChangeNumber = EDC_LOG_SHIPPING_DETAILS_DOWNLOAD");

                var tmpBuff = [Byte](repeating: 0x00, count: 12)
                let tempData: [Byte] = [Byte](globalData.m_sMasterParamData!.m_strLogShippingDownloadDate.utf8)
                tmpBuff = Array(tempData[0 ..< 12])
                
                //System.arraycopy(GlobalData.m_sMasterParamData.m_strLogShippingDownloadDate.utf8,0,tempBuff,0,12);
                let chArrISPasswordDownloadDate: String = TransactionUtils.StrLeftPad(data: String(bytes: tmpBuff, encoding: .utf8)!, length: 12,padChar: "0")
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_43,data1: [Byte](chArrISPasswordDownloadDate.utf8) , bcd: true)
            }

            /************************************************************************
             * ChangeNumber = AD_SERVER_HTL_SYNC
             *************************************************************************/
            if (m_iChangeNumber == ISO320ChangeNumberConstants.AD_SERVER_HTL_SYNC) {
                debugPrint("AD_SERVER_HTL_SYNC")

                var bLocalBuffer = [Byte](repeating: 0x00, count: AppConstant.MAX_COUNT_HTL * 4)
                var iLocalOffset: Int = 0x00
                var numberOfItems: Int = 0

                let ItemList: [DataLong] = Array(GlobalData.m_setAdServerHTL!)
                if(!ItemList.isEmpty) {
                    numberOfItems = ItemList.count
                    debugPrint( "numberOfItems HTL[\(numberOfItems)]");
                    for i in 0 ..< numberOfItems {
                        let ulHTL: DataLong = ItemList[i]
                        if (ulHTL != 0x0000) {
                            let res: String = String(format: "%08d", ulHTL);
                            let PadedHTL: [Byte] =  TransactionUtils.a2bcd([Byte](res.utf8))!
                            bLocalBuffer[iLocalOffset ..< iLocalOffset + 4] = ArraySlice<Byte>(PadedHTL[0 ..< 4])
                            
                            //System.arraycopy(PadedHTL,0,bLocalBuffer,iLocalOffset,4);
                            iLocalOffset += 4;
                            debugPrint("PadedHTL[\(TransactionUtils.byteArray2HexString(arr: PadedHTL))]")
                        }
                    }
                }

                if(iLocalOffset > 0)
                {
                    _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61, data1: bLocalBuffer, length: iLocalOffset);
                    debugPrint("Req->Setting field 61")
                }
            }

            /************************************************************************
             * ChangeNumber = USER_INFO_SYNC
             *************************************************************************/
            if (m_iChangeNumber == ISO320ChangeNumberConstants.USER_INFO_SYNC) {
                debugPrint("USER_INFO_SYNC")

                PackUserInfoData()
            }

            //field 53 --> packet count should handle more than 255 for PVM download(Review comments) : Shirish.pandey
            if(self.m_bCurrentPacketCount > 0){
                var buffer = [Byte](repeating: 0x00, count: 4)
                var iLocalOffset: Int = 0x00
                var b = Int(m_bCurrentPacketCount)

                //Current Packet count 2 bytes
                buffer[iLocalOffset] = Byte((b >> 8) & 0x000000FF)
                iLocalOffset += 1
                buffer[iLocalOffset] = Byte(b & 0x000000FF)
                iLocalOffset += 1
                
                b = Int(m_bTotalPacketCount)

                //Total Packet count 2 bytes
                buffer[iLocalOffset] = Byte((b >> 8) & 0x000000FF)
                iLocalOffset += 1
                buffer[iLocalOffset] = Byte( b & 0x000000FF)
                iLocalOffset += 1
                
                debugPrint("AppConst.IsoFieldConstant.ISO_FIELD_53[\(String(describing: String(bytes: buffer, encoding: .utf8)))]")

                _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_53, data1: buffer, length: iLocalOffset);
                debugPrint("Req->Setting field 53")
            }

        return packItHost(sendee: &sendee);
    }

    
    //MARK:- ProcessData()
    func ProcessData() -> Bool
    {
        debugPrint("Inside ProcessData")
        var isLibOK: Bool = false                  //Amitesh: changed for QA issue

        if (!IsOK())
        {
            debugPrint("Field 39 Failed")
            return false
        }

        debugPrint("m_iChangeNumber[\(m_iChangeNumber)]");

            //check for field 7 in all packets
        if(bitmap[7 - 1] && (m_iChangeNumber >= ISO320ChangeNumberConstants.HOST_PVM_DOWNLOAD && m_iChangeNumber <= ISO320ChangeNumberConstants.HUB_GET_CACRT)){
            debugPrint("bitmap[7] present in change number[\(m_iChangeNumber)]")
            let p: [Byte] = data[7 - 1]
            debugPrint("bitmap[7][0x%x]", p[0])
            
            if(memcmp(str1: String(bytes: self.data[7-1], encoding: .utf8)!, str2: "01", iLen: 2) == 0){
                let globalData = GlobalData.singleton
                
                _ = globalData.ReadMasterParamFile()
                globalData.m_sMasterParamData!.m_bIsPKExchangePacket = true
                _ = globalData.WriteMasterParamFile()
            }
        }

        //AppConst._enISO320_HOSTCOM_CHANGENUMBER number = AppConst._enISO320_HOSTCOM_CHANGENUMBER.values()[m_iChangeNumber-1];
        //index start from 0
        let number: Int = m_iChangeNumber
        debugPrint("SUBHENDU", "CHANGENUMBER: " + String(number))
        switch (number)
        {
                case ISO320ChangeNumberConstants.HOST_PVM_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_PVM_DLD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_PVM_DLD_END, iLen: 6) == 0))
                    {
                        if (bitmap[61 - 1] && bitmap[53 - 1])
                        {
                            if(!ProcessPVMData()){
                                return false
                            }
                        }
                    }

                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_PVM_DLD_END, iLen: 6) == 0) {
                        //Delete the temp downloadfile
                        //this will handle the scenario when we have some xyz PVM version and
                        //downloading xya version which was not sucessful.
                        //On initializing again if host whant to retain earlier version then
                        //PC_PVM_DLD_END will be send and we will delete saved temp files
                        _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.TEMPVMFILE)
                        _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DWNLDPVMINFO)
                        _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DWNLDCHUNKINFO)

                        m_bCurrentPacketCount = 0
                        m_bTotalPacketCount = 0
                        m_iChangeNumber += 1
                    }
                    break;

                case ISO320ChangeNumberConstants.HOST_CHARGESLIP_ID_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_CHARGE_SLIP_ID_DLD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_CHARGE_SLIP_ID_DLD_END, iLen: 6) == 0)) {
                        if (bitmap[61 - 1] && bitmap[53 - 1]) {
                            debugPrint("Response->field 61 and 53 found charge slip Id download")
                            //check for multi packets
                            ProcessChargeSlipIdDownload()
                        }
                    }

                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_CHARGE_SLIP_ID_DLD_END, iLen: 6) == 0) {
                        m_bCurrentPacketCount = 0;
                        m_bTotalPacketCount = 0;
                        m_iChangeNumber += 1
                        if (m_ulCountOfChargeSlipIdAdd == 0x00) {
                            m_iChangeNumber += 1            //skip the download of charge slip templates.
                        }
                    }
                    break;

                case ISO320ChangeNumberConstants.HOST_CHARGESLIP_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_CHARGE_SLIP_DLD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_CHARGE_SLIP_DLD_END, iLen: 6) == 0)) {
                        if (bitmap[61 - 1] && bitmap[53 - 1]) {
                            debugPrint("Response->field 61 and 53 found charge slip download")

                            //check for multi packets
                            ProcessChargeSlipDownload()
                        }
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_CHARGE_SLIP_DLD_END, iLen: 6) == 0) {
                        //one charge slip download finished.
                        m_ulTotalChargeSlipTemplateAdded += 1

                        if (m_ulTotalChargeSlipTemplateAdded >= m_ulCountOfChargeSlipIdAdd) {
                            m_iChangeNumber += 1
                        }
                        m_bCurrentPacketCount = 0
                        m_bTotalPacketCount = 0
                        
                        _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.TEMPCGFILE)
                    }
                    break;

                case ISO320ChangeNumberConstants.HOST_IMAGE_ID_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_IMAGE_ID_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_IMAGE_ID_DOWNLOAD_END, iLen: 6) == 0)) {
                        if (bitmap[61 - 1] && bitmap[53 - 1]) {
                            debugPrint("Response->field 61 and 53 found Image Id download")
                            //check for multi packets
                            ProcessImageIdDownload();
                        }
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_IMAGE_ID_DOWNLOAD_END, iLen: 6) == 0) {
                        m_bCurrentPacketCount = 0;
                        m_bTotalPacketCount = 0;
                        m_iChangeNumber += 1
                        if (m_ulCountOfImageIdAdd == 0x00) {
                            m_iChangeNumber += 1 //skip the download of charge slip templates.
                        }
                    }
                    break;

                case ISO320ChangeNumberConstants.HOST_IMAGE_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_IMAGE_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_IMAGE_DOWNLOAD_END, iLen: 6) == 0)) {
                        if (bitmap[61 - 1] && bitmap[53 - 1]) {
                           debugPrint("Response->field 61 and 53 found Image download")
                            //check for multi packets
                            if(!ProcessImageDownload()) {
                                return false;
                            }
                        }
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_IMAGE_DOWNLOAD_END, iLen: 6) == 0) {
                        _ = FileSystem.DeleteFileComplete(strFileName: m_chTempImageDwnFile)
                        _ = FileSystem.DeleteFileComplete(strFileName: m_chTempImagefileName)
                        _ = FileSystem.DeleteFileComplete(strFileName: m_chTempImageChunkFile)

                        m_ulTotalImagesAdded += 1 //one image download finished.
                        //send the request for the next one for every image downloaded host will send the processing code ends here.
                        if (m_ulTotalImagesAdded >= m_ulCountOfImageIdAdd) {
                            m_iChangeNumber += 1
                        }
                        
                        m_bCurrentPacketCount = 0
                        m_bTotalPacketCount = 0
                    }
                    break;

                case ISO320ChangeNumberConstants.HOST_COLORED_IMAGE_ID_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_COLORED_IMAGE_ID_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_COLORED_IMAGE_ID_DOWNLOAD_END, iLen: 6) == 0)) {
                        if (bitmap[61 - 1] && bitmap[53 - 1]) {
                            debugPrint("Response->field 61 and 53 found Colored Image Id download")
                            //check for multi packets
                            ProcessColoredImageIdDownload()
                        }
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_COLORED_IMAGE_ID_DOWNLOAD_END, iLen: 6) == 0) {
                        m_bCurrentPacketCount = 0;
                        m_bTotalPacketCount = 0;
                        m_iChangeNumber += 1
                        if (m_ulCountOfColoredImageIdAdd == 0x00) {
                            m_iChangeNumber += 1 //skip the download of charge slip templates.
                        }
                    }
                    break;

                case ISO320ChangeNumberConstants.HOST_COLORED_IMAGE_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_COLORED_IMAGE_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_COLORED_IMAGE_DOWNLOAD_END, iLen: 6) == 0)) {
                        if (bitmap[61 - 1] && bitmap[53 - 1]) {
                            debugPrint("Response->field 61 and 53 found Colored Image download")
                            //check for multi packets
                            if(!ProcessColoredImageDownload()) {
                                return false;
                            }
                        }
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_COLORED_IMAGE_DOWNLOAD_END, iLen: 6) == 0) {
                        _ = FileSystem.DeleteFileComplete(strFileName: m_chTempClrdImageDwnFile)
                        _ = FileSystem.DeleteFileComplete(strFileName: m_chTempClrdImagefileName)
                        _ = FileSystem.DeleteFileComplete(strFileName: m_chTempClrdImageChunkFile)

                        m_ulTotalColoredImagesAdded += 1//one image download finished.
                        //send the request for the next one for every image downloaded host will send the processing code ends here.
                        if (m_ulTotalColoredImagesAdded >= m_ulCountOfColoredImageIdAdd) {
                            m_iChangeNumber += 1
                        }
                        m_bCurrentPacketCount = 0
                        m_bTotalPacketCount = 0
                    }
                    break;

                case ISO320ChangeNumberConstants.HOST_BATCH_ID:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_BATCH_ID, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_BATCH_ID_END, iLen: 6) == 0)) {
                        if(bitmap[26 - 1]){
                            ProcessBatchId()
                        }
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_BATCH_ID_END, iLen: 6) == 0) {
                        //Update Batch ID
                        m_iChangeNumber += 1
                    }
                    break;

                case ISO320ChangeNumberConstants.HOST_CLOCK_SYNC:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_CLOCK_SYNC_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_CLOCK_SYNC_END, iLen: 6) == 0)) {
                        if(bitmap[12 - 1]){
                            ProcessClockSynchronization()
                        }
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_CLOCK_SYNC_END, iLen: 6) == 0) {
                        m_iChangeNumber += 1
                    }
                    break;

                case ISO320ChangeNumberConstants.HOST_MESSAGE_ID_LIST_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_MESSAGE_ID_LIST_DLD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_MESSAGE_ID_LIST_DLD_END, iLen: 6) == 0)) {
                        if (bitmap[61 - 1] && bitmap[53 - 1]) {
                            debugPrint("Response->field 61 and 53 found Image Id download")
                            //check for multi packets process message Id download
                            ProcessMessageIdDownload()
                        }
                    }

                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_MESSAGE_ID_LIST_DLD_END, iLen: 6) == 0) {
                        m_bCurrentPacketCount = 0;
                        m_bTotalPacketCount = 0;
                        m_iChangeNumber += 1
                        if (m_ulCountOfMessageIdAdd == 0x00) {
                            m_iChangeNumber += 1 //skip the download messages
                        }
                    }
                    break;

                case ISO320ChangeNumberConstants.HOST_MESSAGE_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_MESSAGE_DLD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_MESSAGE_DLD_END, iLen: 6) == 0)) {
                        //check for multi packets
                        //process message download and store it
                        ProcessMessageDownload()
                    }

                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_MESSAGE_DLD_END, iLen: 6) == 0) {
                        m_imessageOffset = 0;
                        m_ulTotalMessagesAdded += 1

                        //send the request for the next one.for every image downloaded host will send the processing code ends here.
                        if (m_ulTotalMessagesAdded >= m_ulCountOfMessageIdAdd) {
                            let NumberOFRows: Int = FileSystem.NumberOfRows(strFileName: FileNameConstants.MASTERMESFILE, obj: StructMESSAGEID.self)
                            for  i in 0 ..< NumberOFRows
                            {
                                let temp: StructMESSAGEID = FileSystem.SeekRead(strFileName: FileNameConstants.MASTERMESFILE, iOffset: i)!;
                                if (temp != nil)
                                {
                                    debugPrint("Message id[%d], Message[%s]", temp.lmessageId, temp.strArrMessage)
                                }
                            }
                            m_iChangeNumber += 1
                        }
                        m_bCurrentPacketCount = 0;
                        m_bTotalPacketCount = 0;
                    }
                    break;

                case ISO320ChangeNumberConstants.HOST_PARAMETERS_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_PARAMETER_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_PARAMETER_END, iLen: 6) == 0)) {
                        ProcessParameterDownload();
                    }

                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_PARAMETER_END, iLen: 6) == 0) {
                        m_iChangeNumber += 1
                        //store parameter updation last date time for sending it next time parse field 43

                        _ = CheckForParameterUpdate()
                        ProcessParameterDownloadDateTime()
                    }
                    break;

                case ISO320ChangeNumberConstants.EMV_PARM_DWONLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EMV_PARAM_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EMV_PARAM_END, iLen: 6) == 0))
                    {
                        if (bitmap[61 - 1] && bitmap[53 - 1])
                        {
                            if(!ProcessEMVParDownload()) {
                                return false
                            }
                        }
                    }

                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EMV_PARAM_END, iLen: 6) == 0) {
                        //Delete the temp downloadfile
                        //this will handle the scenario when we have some xyz PVM version and
                        //downloading xya version which was not sucessful.
                        //On initializing again if host whant to retain earlier version then
                        //PC_PVM_DLD_END will be send and we will delete saved temp files

                        _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.TEMEMVPARFILE)
                        _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DWNLDEMVPARINFO)
                        _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DWNLDEMVPARCHUNKINFO)

                        /*if (bitmap[61 - 1] && bitmap[53 - 1]) {
                            //parsing downloaded EMVParam file
                            EmvAIDParameter.emvAIDParameterList = null;
                            EmvCAPKParameter.emvCAPKParameterList = null;
                            EmvICSParameter.emvICSParameterList = null;
                            EmvParameterParser emvParameterParser = new EmvParameterParser();
                            emvParameterParser.parseEmvParameter("EmvParameter.xml");
                        }*/

                        m_bCurrentPacketCount = 0
                        m_bTotalPacketCount = 0
                        m_iChangeNumber += 1
                    }
                    break;

                case ISO320ChangeNumberConstants.HUB_PARM_UPLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_PARAMETER_UPLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_PARAMETER_UPLOAD_END, iLen: 6) == 0))
                    {
                        if (bitmap[61 - 1] && bitmap[53 - 1]){
                            //Nothing TO DO
                        }

                        // Check for number of Packets upload.
                        if (m_iHostUploadPacketNumber < ISO320HostUploadChangeNum.MASTER_PARAM_UPLOAD_PACKET)
                        {
                            m_iHostUploadPacketNumber += 1
                        } else
                        {
                            _ = UpdateUploadDataChangedFlag()
                            m_iChangeNumber += 1
                        }
                    }
                    break;

                case ISO320ChangeNumberConstants.HUB_PARM_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_PARAMETER_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_PARAMETER_DOWNLOAD_END, iLen: 6) == 0))
                    {
                        ProcessHubParmDownload()
                    }else{
                        debugPrint("WRONG PROC CODE")
                    }

                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_PARAMETER_DOWNLOAD_END, iLen: 6) == 0) {
                        m_iChangeNumber += 1
                        ProcessHubParmDownloadDateTime()

                        let globalData = GlobalData.singleton
                        _ = globalData.ReadMasterParamFile()
                        debugPrint("m_iUsePineEncryptionKeys[\(globalData.m_sMasterParamData!.m_iUsePineEncryptionKeys)]")
                        debugPrint("m_bIsPKExchangePacket[\(globalData.m_sMasterParamData!.m_bIsPKExchangePacket)]")

                        //Use Pine Encryption Key
                        if(0 == globalData.m_sMasterParamData!.m_iUsePineEncryptionKeys)
                        {
                            //if the use bank key flag is set, then PINEKey Exchange and PSK proc codes (960350 and 960330 respectively) wont be sent.
                            m_iChangeNumber += 1
                            m_iChangeNumber += 1
                        }else if(!globalData.m_sMasterParamData!.m_bIsPKExchangePacket)
                        {
                            //if PINEKEY EXCHANGE flag is not set(if field 7 is not set anywhere), then HUB_PINEKEY_EXCHANGE (960350) proc code would be skipped.
                            m_iChangeNumber += 1
                        }
                    }
                    break;
                case ISO320ChangeNumberConstants.HUB_PINEKEY_EXCHANGE:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_PINEKEY_EXCHANGE_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_PINEKEY_EXCHANGE_END, iLen: 6) == 0))
                    {
                        _ = ProcessPineKeyExchangeResponse()
                    }else{
                        debugPrint("WRONG PROC CODE")
                    }
                    break

                case ISO320ChangeNumberConstants.HUB_GET_PINE_SESSION_KEY:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_GETPSK_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_GETPSK_END, iLen: 6) == 0))
                    {
                        _ = ProcessPSKDownload()
                    }else{
                        debugPrint("WRONG PROC CODE")

                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_GETPSK_END, iLen: 6) == 0) {
                        m_iChangeNumber += 1
                    }
                    break;

                case ISO320ChangeNumberConstants.HUB_GET_BIN_RANGE:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_GETBINRANGE_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_GETBINRANGE_END, iLen: 6) == 0))
                    {
                        _ = ProcessBinRangeDownload()
                    }else{
                        debugPrint("WRONG PROC CODE")
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_GETBINRANGE_END, iLen: 6) == 0) {
                        m_iChangeNumber += 1
                        ProcessBinRangeDateTime()
                    }
                    break;

                case ISO320ChangeNumberConstants.HUB_GET_CSV_TXN_MAP:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_GETCSVTXNMAP_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_GETCSVTXNMAP_END, iLen: 6) == 0))
                    {
                        _ = ProcessCSVTxnMapDownload()
                    }else{
                        debugPrint("WRONG PROC CODE");

                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_GETCSVTXNMAP_END, iLen: 6) == 0) {
                        m_iChangeNumber += 1
                        ProcessCSVTxnMapVersion()
                    }
                    break;

                case ISO320ChangeNumberConstants.HUB_GET_CACRT:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_GETCACRT_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_GETCACRT_END, iLen: 6) == 0))
                    {
                        if (bitmap[61 - 1] && bitmap[53 - 1])
                        {
                            if(!ProcessCACRTData()) {
                                return false
                            }
                        }
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_GETCACRT_END, iLen: 6) == 0) {
                        //Delete the temp downloadfile
                        //this will handle the scenario when we have some xyz PVM version and
                        //downloading xya version which was not sucessful.
                        //On initializing again if host whant to retain earlier version then
                        //PC_PVM_DLD_END will be send and we will delete saved temp files
                        _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.TEMCACRTFILE)
                        _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DWNLDCACRTINFO)
                        _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DWNLDCACRTCHUNKINFO)

                        m_bCurrentPacketCount = 0
                        m_bTotalPacketCount = 0
                        m_iChangeNumber += 1
                    }
                    break;

                case ISO320ChangeNumberConstants.HUB_GET_TXN_BIN:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_GETTXNBIN_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_GETTXNBIN_END, iLen: 6) == 0))
                    {
                        _ = ProcessTxnBinDownload();
                    }

                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_GETTXNBIN_END, iLen: 6) == 0) {
                        m_iChangeNumber += 1
                        ProcessTxnBinDateTime()
                    }
                    break;

                case ISO320ChangeNumberConstants.HUB_GET_IGNORE_AMT_CSV_TXN_LIST:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_IGNORE_AMOUNT_CSV_MAP_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_IGNORE_AMOUNT_CSV_MAP_END, iLen: 6) == 0))
                    {
                        _ = ProcessCSVTxnIgnoreAmtListDownload()
                    }

                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_IGNORE_AMOUNT_CSV_MAP_END, iLen: 6) == 0) {
                        m_iChangeNumber += 1
                        ProcessCSVTxnIgnoreAmtDateTime()
                    }
                    break;

                case ISO320ChangeNumberConstants.HUB_GET_EDC_APP_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_APP_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_APP_DOWNLOAD_END, iLen: 6) == 0))
                    {
                        if (bitmap[61 - 1] && bitmap[53 - 1])
                        {
                            if(!ProcessEDCAppDownload()){
                                _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.TEMEDCAPPFILE)
                                _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DWNLDEDCAPPINFO)
                                _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DWNLDEDCAPPCHUNKINFO)
                                return false
                            }
                        }
                    }

                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_APP_DOWNLOAD_END, iLen: 6) == 0) {
                        _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.TEMEDCAPPFILE)
                        _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DWNLDEDCAPPINFO)
                        _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DWNLDEDCAPPCHUNKINFO)

                        m_bCurrentPacketCount = 0
                        m_bTotalPacketCount = 0
                        m_iChangeNumber += 1
                    }
                    break;
                case ISO320ChangeNumberConstants.EDC_FIXED_CHARGESLIP_ID_DOWNLOAD://for dynamic chargeslip format
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_REQUIRED_FIXED_CHARGESLIP_ID_LIST_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_REQUIRED_FIXED_CHARGESLIP_ID_LIST_DOWNLOAD_END, iLen: 6) == 0)) {
                        if (bitmap[61 - 1] && bitmap[53 - 1]) {
                            debugPrint("Response->field 61 and 53 found charge chargeslip Id download")
                            //check for multi packets
                            ProcessFixedChargeSlipIdDownload()
                        }
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_REQUIRED_FIXED_CHARGESLIP_ID_LIST_DOWNLOAD_END, iLen: 6) == 0) {
                        m_bCurrentPacketCount = 0
                        m_bTotalPacketCount = 0
                        m_iChangeNumber += 1
                        if (m_ulCountOfFixedChargeSlipIdAdd == 0x00) {
                            m_iChangeNumber += 1 //skip the download of charge slip templates.
                        }
                    }
                    break;

                case ISO320ChangeNumberConstants.EDC_FIXED_CHARGESLIP_DOWNLOAD://for dynamic chargeslip format
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_REQUIRED_FIXED_CHARGESLIP_ID_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_REQUIRED_FIXED_CHARGESLIP_ID_DOWNLOAD_END, iLen: 6) == 0)) {
                        if (bitmap[61 - 1] && bitmap[53 - 1]) {
                            debugPrint("Response->field 61 and 53 found Chargeslip download")
                            //check for multi packets
                            if(!ProcessFixedChargeSlipDownload()){
                                return false
                            }
                        }
                    }

                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_REQUIRED_FIXED_CHARGESLIP_ID_DOWNLOAD_END, iLen: 6) == 0) {
                        _ = FileSystem.DeleteFileComplete(strFileName: m_chTempFixedChargeSlipDwnFile)
                        _ = FileSystem.DeleteFileComplete(strFileName: m_chTempFixedChargeSlipfileName)
                        _ = FileSystem.DeleteFileComplete(strFileName: m_chTempFixedChargeSlipChunkFile)

                        m_ulTotalFixedChargeSlipAdded += 1 //one chargeslip download finished.

                        //send the request for the next one. for every chargeslip downloaded host will send the processing code ends here.
                        if (m_ulTotalFixedChargeSlipAdded >= m_ulCountOfFixedChargeSlipIdAdd) {
                            m_iChangeNumber += 1
                        }
                        m_bCurrentPacketCount = 0
                        m_bTotalPacketCount = 0
                    }
                    break;
                case ISO320ChangeNumberConstants.HUB_GET_CLESSPARAM://amitesh::CLess Param download
                 /*   if ((memcmp(new String(data[3-1]), PC_EDC_CLESSPARAM_UPDATE_START, 6) == 0) || (memcmp(new String(data[3-1]), PC_EDC_CLESSPARAM_UPADTE_END, 6) == 0))
                    {
                        if (bitmap[61 - 1])
                        {
                            ProcessCLessParamDownload();
                        }

                        if (memcmp(new String(data[3 - 1]), PC_EDC_CLESSPARAM_UPADTE_END, 6) == 0) {
                            m_iChangeNumber++;
                            ProcessCLessParamDateTime();
                            ClessLimits cless_limits = new ClessLimits();
                            cless_limits.parseClessLimits(context);
                        }
                    }*/

                    break;

                case ISO320ChangeNumberConstants.HUB_GET_CLESS_UPLOAD://amitesh::for cless param  upload
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_CLESSPARAM_UPLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_CLESSPARAM_UPLOAD_END, iLen: 6) == 0))
                    {
                        if (bitmap[61 - 1] && bitmap[53 - 1]){
                            //Nothing TO DO
                        }

                        // Check for number of Packets upload.
                        if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_CLESSPARAM_UPLOAD_END, iLen: 6) == 0)
                        {
                            m_iChangeNumber += 1
                        }
                    }else{
                        debugPrint("WRONG PROC CODE")
                    }
                    break;

                case ISO320ChangeNumberConstants.CLESS_PARM_DWONLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_CLESSXML_UPDATE_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_CLESSXML_UPADTE_END, iLen: 6) == 0))
                    {
                        if (bitmap[61 - 1] && bitmap[53 - 1]) {
                            if (!ProcessCLESSEMVParDownload()) {
                                return false;
                            }
                        }
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_CLESSXML_UPADTE_END, iLen: 6) == 0) {
                        //Delete the temp downloadfile
                        //this will handle the scenario when we have some xyz PVM version and
                        //downloading xya version which was not sucessful.
                        //On initializing again if host whant to retain earlier version then
                        //PC_PVM_DLD_END will be send and we will delete saved temp files
                        _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.TEMCLESSPARFILE)
                        _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DWNLDCLESSPARINFO)
                        _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DWNLDCLESSPARCHUNKINFO)

                        /*if (bitmap[61 - 1] && bitmap[53 - 1]) {
                            ClessParameterParser clessParameterParser = new ClessParameterParser();
                            clessParameterParser.parseEmvParameter("ClessEmvParameter.xml");
                            ClessAIDParameter.GetAllMockParameters();
                        }*/

                        m_bCurrentPacketCount = 0;
                        m_bTotalPacketCount = 0;
                        m_iChangeNumber += 1
                    }
                    break;

                case ISO320ChangeNumberConstants.HUB_GET_EMV_TAG_LIST://amitesh::EMV TAG List download
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_REQUIRED_EMV_TAGS_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_REQUIRED_EMV_TAGS_DOWNLOAD_END, iLen: 6) == 0))
                    {
                        if (bitmap[61 - 1] && bitmap[53 - 1])
                        {
                            _ = ProcessEMVTagListDownload()
                        }
                        if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_REQUIRED_EMV_TAGS_DOWNLOAD_END, iLen: 6) == 0) {
                            m_iChangeNumber += 1
                            ProcessEMVTagListDateTime()
                        }
                    }
                    else{
                        debugPrint("WRONG PROC CODE");
                    }
                    break;

                case ISO320ChangeNumberConstants.EDC_PRINTING_LOCATION_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_PRINTING_LOCATION_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_PRINTING_LOCATION_DOWNLOAD_END, iLen: 6) == 0))
                    {
                        _ = ProcessPrintingLocationDetailsDownload()
                    }else
                    {
                        debugPrint("WRONG PROC CODE")
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_PRINTING_LOCATION_DOWNLOAD_END, iLen: 6) == 0)
                    {
                        m_iChangeNumber += 1
                    }
                    break;

                case ISO320ChangeNumberConstants.EDC_AID_EMV_TXNTYPE_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_AID_EMV_TXNTYPE_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_AID_EMV_TXNTYPE_DOWNLOAD_END, iLen: 6) == 0))
                    {
                        if (bitmap[61 - 1])
                        {
                            _ = ProcessAIDEMVTXNTYPEDownload();
                        }
                    }else
                    {
                        debugPrint("WRONG PROC CODE")
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_AID_EMV_TXNTYPE_DOWNLOAD_END, iLen: 6) == 0)
                    {
                        //manage download date
                        ProcessAIDEMVTXNTYPEDateTime()
                        m_iChangeNumber += 1
                    }
                    break;

                case ISO320ChangeNumberConstants.EDC_TXN_TYPE_FLAGS_MAPPING_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_TXN_TYPE_FLAGS_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_TXN_TYPE_FLAGS_DOWNLOAD_END, iLen: 6) == 0))
                    {
                        if (bitmap[61 - 1])
                        {
                            _ = ProcessTxnTypeFlagsMappingDownload();
                        }
                    }else
                    {
                        debugPrint("WRONG PROC CODE");
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_TXN_TYPE_FLAGS_DOWNLOAD_END, iLen: 6) == 0)
                    {
                        //manage download date
                        ProcessTxnTypeFlagsMappingDateTime()
                        m_iChangeNumber += 1
                    }
                    break;

                case ISO320ChangeNumberConstants.EDC_LIB_LIST_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_LIB_LIST_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_LIB_LIST_DOWNLOAD_END, iLen: 6) == 0)) {
                        if (bitmap[61 - 1] && bitmap[53 - 1]) {
                            debugPrint("Response->field 61 and 53 found Lib download")
                            ProcessLibIdDownload();
                        }
                    }

                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_LIB_LIST_DOWNLOAD_END, iLen: 6) == 0) {
                        m_bCurrentPacketCount = 0;
                        m_bTotalPacketCount = 0;
                        m_iChangeNumber += 1
                        if (m_ulCountOflibIdAdd == 0x00) {
                            m_iChangeNumber += 1 //skip the download of lib file.
                        }
                    }
                    break;

                case ISO320ChangeNumberConstants.EDC_LIB_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_LIB_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_LIB_DOWNLOAD_END, iLen: 6) == 0)) {
                        if (bitmap[61 - 1] && bitmap[53 - 1]) {
                            debugPrint("Response->field 61 and 53 found Lib");

                            isLibOK = ProcessLibDownload();
                        }else {
                            debugPrint("Response->field 61 and 53 Not found Lib")
                        }
                    }

                    if( memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_LIB_DOWNLOAD_END, iLen: 6) == 0){
                        debugPrint("PC_EDC_LIB_DOWNLOAD_END")
                        let globalData = GlobalData.singleton

                        _ = FileSystem.DeleteFileComplete(strFileName: m_chTemplibfileName)
                        _ = FileSystem.DeleteFileComplete(strFileName: m_chTemplibDwnFile)
                        _ = FileSystem.DeleteFileComplete(strFileName: m_chTemplibChunkFile)

                        if (!isLibOK)
                        {
                            return false
                        }
                        
                        m_ulTotallibAdded += 1 //one Library download finished.

                        //send the request for the next one. For every Library downloaded host will send the processing code ends here.
                        debugPrint("m_ulTotallibAdded[\(m_ulTotallibAdded)], m_ulCountOflibIdAdd[\(m_ulCountOflibIdAdd)]");

                        if (isLibOK && m_ulTotallibAdded == m_ulCountOflibIdAdd) {
                            debugPrint("m_ulTotallibAdded = m_ulCountOflibIdAdd");
                            m_iChangeNumber += 1

                            let bLibStatus: [Byte] = [1]
                            do{
                                _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.EDCLIBSTATUS, with: bLibStatus);
                            }
                            catch
                            {
                                fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.EDCLIBSTATUS)")
                            }
                            //Save the login info-Amitesh
                            if (globalData.m_bIsLoggedIn) {
                                //TODO: ByteUtils Function 
                                let currentLoginInfo: [Byte] = TransactionUtils.objectToByteArray(obj: globalData.m_objCurrentLoggedInAccount)
                                
                                _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.LOGININFO);
                               
                                do{
                                    _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.LOGININFO, with: currentLoginInfo)
                                }
                                catch
                                {
                                    fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.EDCLIBSTATUS)")
                                }
                                
                                _ = FileSystem.DeleteFileComplete(strFileName:FileNameConstants.CURRENT_PIN)
                                
                                do{
                                    _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.CURRENT_PIN,
                                                                   with: [Byte](globalData.m_strCurrentLoggedInUserPIN.utf8))
                                }
                                catch
                                {
                                    fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.EDCLIBSTATUS)")
                                }
                            }

                            //Disconnect existing connection
                            let conx = CConx.singleton
                            _ = conx.disconnect();

                            var i: Int = 0;
                            var Files = [String](repeating: "", count: m_ulCountOflibIdAdd)
                            
                            while (i < m_ulCountOflibIdAdd) {
                                Files[i] = m_ulArrlibIdAdd[i]!.LibFileName;
                                i += 1
                            }

                            if (!PlatFormUtils.upgradeDll(fileNameList: Files)) {
                                
                                //TODO: FileSystem Format Directory
                                //CFileSystem.FormatExternalDirectory();
                                return false;
                            }
                        }
                    }

                    m_bCurrentPacketCount = 0;
                    m_bTotalPacketCount = 0;
                    break;

                case ISO320ChangeNumberConstants.HOST_MINIPVM_ID_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_CIMB_MINIPVM_ID_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_CIMB_MINIPVM_ID_DOWNLOAD_END, iLen: 6) == 0)) {
                        if (bitmap[61 - 1] && bitmap[53 - 1]) {
                            debugPrint("Response->field 61 and 53 found MINI PVM Id download")
                            //check for multi packets
                            debugPrint("before ProcessMINIPVMIdDownload")
                            _ = ProcessMINIPVMIdDownload()
                        }
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_CIMB_MINIPVM_ID_DOWNLOAD_END, iLen: 6) == 0) {
                        m_bCurrentPacketCount = 0
                        m_bTotalPacketCount = 0
                        m_iChangeNumber += 1
                        if (m_ulCountOfMINIPVMIdAdd == 0x00) {
                            m_iChangeNumber += 1 //skip the download of charge slip templates.
                        }
                    }
                    break;

                case ISO320ChangeNumberConstants.HOST_MINIPVM_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_CIMB_MINIPVM_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_CIMB_MINIPVM_DOWNLOAD_END, iLen: 6) == 0)) {
                        if (bitmap[61 - 1] && bitmap[53 - 1]) {
                            debugPrint("Response->field 61 and 53 found MINIPVM download")

                            //check for multi packets
                            if(!ProcessMINIPVMDownload()) {
                                return false
                            }
                        }
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_CIMB_MINIPVM_DOWNLOAD_END, iLen: 6) == 0) {
                        _ = FileSystem.DeleteFileComplete(strFileName: m_chTempMINIPVMDwnFile)
                        _ = FileSystem.DeleteFileComplete(strFileName: m_chTempMINIPVMfileName)
                        _ = FileSystem.DeleteFileComplete(strFileName: m_chTempMINIPVMChunkFile)

                        m_ulTotalMINIPVMAdded += 1 //one MINIPVM download finished.
                        //send the request for the next one.
                        //for every MINIPVM downloaded host will send the processing code ends here.
                        if (m_ulTotalMINIPVMAdded >= m_ulCountOfMINIPVMIdAdd) {
                            m_iChangeNumber += 1
                        }
                        m_bCurrentPacketCount = 0
                        m_bTotalPacketCount = 0
                    }
                    break;

                case ISO320ChangeNumberConstants.CSV_TXN_TYPE_MINIPVM_MAPPING_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_CSV_TXN_TYPE_MINIPVM_MAPPING_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_CSV_TXN_TYPE_MINIPVM_DOWNLOAD_END, iLen: 6) == 0))
                    {
                        RemoveCsvTxnTypeMiniPvmMappingFile()
                        if (bitmap[61 - 1])
                        {
                            _ = ProcessCSVTxnTypeMiniPvmMappingDownload()
                        }
                    }

                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_EDC_CSV_TXN_TYPE_MINIPVM_DOWNLOAD_END, iLen: 6) == 0)
                    {
                        ProcessCSVTxnTypeMiniPvmMappingDateTime()
                        m_iChangeNumber += 1
                    }
                    break;

                case ISO320ChangeNumberConstants.EDC_ISPASSWORD_TXN_MAPPING_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines), str2: ProcessingCodeConstants.PC_EDC_TXN_TYPE_PASSWORD_MAPPING_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines), str2: ProcessingCodeConstants.PC_EDC_TXN_TYPE_PASSWORD_MAPPING_DOWNLOAD_END, iLen: 6) == 0))
                    {
                        if (bitmap[61 - 1])
                        {
                            _ = ProcessIsPasswordMappingDownload();
                        }
                    }

                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines), str2: ProcessingCodeConstants.PC_EDC_TXN_TYPE_PASSWORD_MAPPING_DOWNLOAD_END, iLen: 6) == 0)
                    {
                        ProcessISPasswordDateTime()
                        m_iChangeNumber += 1
                    }
                    break;

                case ISO320ChangeNumberConstants.EDC_LOG_SHIPPING_DETAILS_DOWNLOAD:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines), str2: ProcessingCodeConstants.PC_EDC_LOG_SHIPPING_DETAILS_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines), str2: ProcessingCodeConstants.PC_EDC_LOG_SHIPPING_DETAILS_DOWNLOAD_END, iLen: 6) == 0))
                    {
                        if (bitmap[61 - 1]) {
                            _ = ProcessLogShippingDetailsDownload()
                        }
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines), str2: ProcessingCodeConstants.PC_EDC_LOG_SHIPPING_DETAILS_DOWNLOAD_END, iLen: 6) == 0) {
                        _ = ProcessLogShipingDtTime()
                        m_iChangeNumber += 1
    //                    if(CConx.isSerial())
    //                    {
    //                        m_iChangeNumber++;
    //                    }
    //                    else
    //                    {
    //                        m_iChangeNumber += 2;
    //                    }
                    }
                    break;
                case ISO320ChangeNumberConstants.AD_SERVER_HTL_SYNC:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines), str2: ProcessingCodeConstants.PC_AD_SERVER_HTL_SYNC_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines), str2: ProcessingCodeConstants.PC_AD_SERVER_HTL_SYNC_END, iLen: 6) == 0))
                    {
                        if (bitmap[61 - 1]) {
                            ProcessAdServerHTLSync();
                        }
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines), str2: ProcessingCodeConstants.PC_AD_SERVER_HTL_SYNC_END, iLen: 6) == 0) {
                        SaveAdServerHTLSync();
                        m_iChangeNumber += 1
                    }
                    break;
                case ISO320ChangeNumberConstants.USER_INFO_SYNC:
                    if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines), str2: ProcessingCodeConstants.PC_USER_INFO_SYNC_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines), str2: ProcessingCodeConstants.PC_USER_INFO_SYNC_END, iLen: 6) == 0))
                    {
                        if (bitmap[61 - 1]) {
                            ProcessUserInfoSync();
                        }
                    }
                    if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines), str2: ProcessingCodeConstants.PC_USER_INFO_SYNC_END, iLen: 6) == 0) {
                        SaveUserInfoSync();
                        m_iChangeNumber += 1
                    }
                    break;
                //Content Server Changes for PC Starts
                case ISO320ChangeNumberConstants.HOST_CONTENT_DOWNLOAD:
                    if(CConx.isSerial())
                    {
                        m_bis_last_content = false;
                        if ((memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_OEM_ALL_CONTENT_DOWNLOAD_START, iLen: 6) == 0) || (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_OEM_ALL_CONTENT_DOWNLOAD_END, iLen: 6) == 0))
                        {
                            //Either field 61 or field 62 has to come in case of start and end otherwise its an error scenario
                            if(bitmap[61 - 1] == false && bitmap[62 - 1] == false)
                            {
                                debugPrint("Content Server Sync Failed!!!")
                                GlobalData.updateCustomProgressDialog(msg: "Content Server Sync Failed")
                                do
                                {
                                    try Thread.sleep(forTimeInterval: 5);
                                }
                                catch /*(InterruptedException e)*/
                                {
                                    debugPrint("Exception Occurred : \(error)")
                                }
                                m_iChangeNumber += 1
                                return true
                            }
                            //  Bug Fix : 64311 Starts
                            //  Exp : LANDI UI :- Application should get restart after theme/font is downloaded
                            //  After discussion it was decided it will be better if any of the content get updated, then restart the app.
                            
                            //TODO: statemachine class needed
                            //CStateMachine Statemachine = CStateMachine.GetInstance();
                            //Statemachine.m_ResetTerminal = true;
                            //  Bug Fix : 64311 Ends
                            if (bitmap[61 - 1])
                            {
                                if(bitmap[45-1])
                                {
                                    do {
                                        var chArrTempChunkSize = [Byte](repeating: 0x00, count: 13)
                                        chArrTempChunkSize = Array(data[45 - 1][0 ..< data[45 - 1].count])
                                        //System.arraycopy(data[45 - 1], 0, chArrTempChunkSize, 0, data[45 - 1].length);
                                        
                                        var ulChunkSize = Long()
                                        

                                        let sArrTempChunkSize = String(bytes: chArrTempChunkSize, encoding: String.Encoding.utf8)
                                        ulChunkSize.value = Int64(atol(sArrTempChunkSize))
                                        
                                        m_temp_content_chunk = ulChunkSize.value
                                        debugPrint("Response->field 61 and 45 found Image download")
                                    }
                                    catch /*(Exception e)*/
                                    {
                                        //e.printStackTrace();
                                        debugPrint("Exception Occurred : \(error)")
                                    }
                                }
                                //check for multi packets
                                if(!ProcessContentDownload())
                                {
                                    debugPrint("Content Server Sync Failed!!!")
                                    GlobalData.updateCustomProgressDialog(msg: "Content Server Sync Failed")
                                    do
                                    {
                                        try Thread.sleep(forTimeInterval: 5);
                                    }
                                    catch /*(InterruptedException e)*/
                                    {
                                        debugPrint("Exception Occurred : \(error)")
                                    }
                                    m_iChangeNumber += 1
                                    return true;
                                }
                            }
                        }
                        if(memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_OEM_ALL_CONTENT_DOWNLOAD_END, iLen: 6) == 0)
                        {
                            if (bitmap[61 - 1])
                            {
                                //RenameFileGeneric --Can be TO DO
                                if (true == FileSystem.RenameFile(strNewFileName: m_str_current_ContentName, strFileName: m_str_temp_ContentName))
                                {
                                    m_bCurrentPacketCount = 0
                                    m_bTotalPacketCount = 0
                                    m_bis_last_content = true;// Will add logging .
                                }
                            }
                            else
                            {
                                if (!ProcessContentDelete())
                                {
                                    debugPrint("Content Server Sync Failed!!!")
                                    GlobalData.updateCustomProgressDialog(msg: "Content Server Sync Failed")
                                    
                                    do
                                    {
                                        try Thread.sleep(forTimeInterval: 5)
                                    }
                                    catch /*(InterruptedException e)*/
                                    {
                                        debugPrint("Exception Occurred : \(error)")
                                    }
                                    m_iChangeNumber += 1
                                    return true
                                }
                            }
                        }
                        if (memcmp(str1: String(bytes: data[3-1], encoding: .utf8)!, str2: ProcessingCodeConstants.PC_OEM_CONTENT_DOWNLOAD_NO_IMAGE, iLen: 6) == 0)
                        {
                            m_iChangeNumber += 1
                            m_bCurrentPacketCount = 0  // may be this won't be required, will check later .
                            m_bTotalPacketCount = 0    // may be this won't be required, will check later .
                        }
                    }
                    else
                    {
                        debugPrint("NOT A SERIAL CONNECTION")
                    }
                    break
                //Content Server Changes for PC Ends
                default:
                    debugPrint("m_iChangeNumber WRONG")
                    break

            }//switch ends
        
        return true;
    }
    
    
    //MARK:- updateProgressDialog(msg: String)
    private func updateProgressDialog(msg: String)
    {
            // CStateMachine.m_context_activity.runOnUiThread(new Runnable() {
            //     @Override
            //     public void run() {
            //         /*if (MainActivity.progressDialog != null) {
            //             MainActivity.progressDialog.setMessage(msg);
            //         }*/
            //         UIutils.getInstance().upDateCustomProgress(MainActivity.customProgressDialog,msg);
            //     }
            // });
     }
    
     //MARK:- UpdateUploadDataChangedFlag() -> Bool
    func UpdateUploadDataChangedFlag() -> Bool
    {
        var uchArrBitmap320 = [Byte](repeating: 0x00, count: 4)
        
        let globalData = GlobalData.singleton
        
        uchArrBitmap320 = Array((globalData.m_sMasterParamData?.m_uchArrBitmap320ActiveHost[0 ..< AppConstant.LEN_BITMAP_PACKET])!)
        
        //System.arraycopy(globalData.m_sMasterParamData.m_uchArrBitmap320ActiveHost,0,uchArrBitmap320,0,AppConst.LEN_BITMAP_PACKET);
        
        for it in (0 ..< AppConstant.LEN_BITMAP_PACKET * 8 - 1).reversed()
        {
            let bResult: Byte = uchArrBitmap320[it/8] & Byte(0x80 >> (it % 8))
            if (bResult == 0) {
                _ = globalData.UpdateConnectionDataChangedFlag(bFlag: false)
                _ = globalData.UpdateParamDataChangedFlag(bFlag: false)
            }
        }
        
        _ = globalData.UpdateMasterParamDataChangedFlag(bFlag: false)
        _ = globalData.UpdateAutoSettlementDataChangedFlag(bFlag: false)

        return true;
    }
    
    //MARK:- ProcessPSKDownload() -> Bool
    func ProcessPSKDownload() -> Bool
    {
        debugPrint("ProcessPSKDownload");

        if(!bitmap[61 - 1]){
            debugPrint("ERROR No Field 61 !!")
            return false;
        }

        _ = [Byte](repeating: 0x00, count: len[61 - 1])
        let _: Int = 0
        let iLenField61 = len[61-1]
        debugPrint("Field 61 len[\(iLenField61)]")

        //Check for Field 61 present or not
        if(iLenField61 <= 0){
            debugPrint("Field 61 not present")
            return false
        }
        
        return true
    }
    
    //MARK:- ProcessBinRangeDownload() -> Bool
    func ProcessBinRangeDownload() -> Bool
    {
        debugPrint("Inside ProcessBinRangeDownload");

        if(!bitmap[61 - 1]){
            debugPrint("ERROR No Field 61 !!");
            return false;
        }

        let p: [Byte] = data[61-1];
        let length: Int = len[61-1];

        debugPrint("field 61 len[\(length)], data[\(TransactionUtils.byteArray2HexString(arr: p))]");
        if(length <= 0){
            return false;
        }
        
        var st_BINRangeList: [StBINRange] = []

        var iOffset: Int = 0;
        while(length > iOffset)
        {
            if(m_ulBinRangeIterator >= AppConstant.MAX_BIN_RANGE_PARAMETERES){
                debugPrint("MAX_BIN_RANGE_PARAMETERES reached");
                break;
            }

            var stBinRange = StBINRange()

            //1 byte KeySlotID
            stBinRange.iKeySlotID = Int((Byte)(p[iOffset] & 0x000000FF))
            iOffset += 1
            
            //4 Byte Bin Low
            stBinRange.ulBinLow  = Int64(p[iOffset] << 24) & Int64(0xFF000000)
            iOffset += 1
            stBinRange.ulBinLow |= Int64(p[iOffset] << 16) & Int64(0x00FF0000)
            iOffset += 1
            stBinRange.ulBinLow |= Int64(p[iOffset] << 8) & Int64(0x0000FF00)
            iOffset += 1
            stBinRange.ulBinLow |=  Int64(p[iOffset] & 0x000000FF)
            iOffset += 1
            
            //4 Byte Bin High
            stBinRange.ulBinHigh  = Int64(p[iOffset] << 24) & Int64(0xFF000000)
            iOffset += 1
            stBinRange.ulBinHigh |= Int64(p[iOffset] << 16) & Int64(0x00FF0000)
            iOffset += 1
            stBinRange.ulBinHigh |= Int64(p[iOffset] <<  8)  & Int64(0x0000FF00)
            iOffset += 1
            stBinRange.ulBinHigh |=  Int64(p[iOffset] & 0x000000FF)
            iOffset += 1
            m_ulBinRangeIterator += 1

            debugPrint("BIN Range File it[\(m_ulBinRangeIterator)]")
            debugPrint("iKeySlotID[\(stBinRange.iKeySlotID)]")
            debugPrint("ulBinLow[\(stBinRange.ulBinLow)]")
            debugPrint("ulBinHigh[\(stBinRange.ulBinHigh)]")

            st_BINRangeList.append(stBinRange)
        }

        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.TEMPBINRANGEFILE, with: st_BINRangeList);
        }
        catch{
            fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.TEMPBINRANGEFILE)")
        }
        
        return true;
    }

    //MARK:- ProcessBinRangeDateTime()
    func ProcessBinRangeDateTime()
    {
        debugPrint("Inside ProcessBinRangeDateTime")
        let  globalData = GlobalData.singleton

        if(!bitmap[43-1])
        {
            debugPrint("ERROR No Feild 43 !!");
            return;
        }

        _ = globalData.ReadMasterParamFile()

        //if previous version is same as current version then do nothing
        if(globalData.m_sMasterParamData!.m_strBinRangeDownloadDate == String(bytes: data[43 - 1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)){
            return;
        }

        //if temp bin range file exist, then replace BINRANGE file with temp.
        if(FileSystem.IsFileExist(strFileName: FileNameConstants.TEMPBINRANGEFILE))
        {
            debugPrint("TEMPBINRANGEFILE exists")
            let tempData: [StBINRange] = []
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.BINRANGEFILE, with: tempData)
            if(true == FileSystem.RenameFile(strNewFileName: FileNameConstants.BINRANGEFILE, strFileName: FileNameConstants.TEMPBINRANGEFILE))
            {
                debugPrint("BINRANGEFILE rename done")
                globalData.m_sMasterParamData!.ulTotalBinRange = m_ulBinRangeIterator
            }else{
                debugPrint("BINRANGEFILE rename failed")
            }
        }

        // if version is different(the file is downloaded) then set reset flag and bin range changed flag true.
        // the bin range changed flag will ensure in loading files to sort bin range file.

        globalData.m_sMasterParamData!.m_strBinRangeDownloadDate = String(bytes: data[43 - 1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
        debugPrint("m_strBinRangeDownloadDate[\(globalData.m_sMasterParamData!.m_strBinRangeDownloadDate)]")

        globalData.m_sMasterParamData!.m_bIsBinRangeChanged = true

        //TODO: statemachine class nedded
        //CStateMachine Statemachine = CStateMachine.GetInstance();
        //Statemachine.m_ResetTerminal = true;

        _ = globalData.WriteMasterParamFile()
    }

    //MARK:- ProcessCSVTxnMapDownload() -> Bool
    func ProcessCSVTxnMapDownload() -> Bool
    {
        debugPrint("Inside ProcessCSVTxnTypeDownload")

        if(!bitmap[61 - 1]){
            debugPrint("ERROR No Field 61 !!")
            return false
        }

        let p: [Byte] = data[61-1]
        let length: Int = len[61-1]

        debugPrint("field 61 len[\(length)]")
        if(length <= 0){
            return false
        }
        
        debugPrint(length, p);
        var st_CSVTxnMapList: [StCSVTxnMap] = []

        var iOffset: Int = 0
        
        while(length > iOffset)
        {
            if(m_ulCSVTxnMapIterator >= AppConstant.MAX_CSV_TXN_TYPE_PARAMETERES){
                debugPrint("MAX_CSV_TXN_TYPE_PARAMETERES reached");
                break;
            }

            var structCSVTxnMap = StCSVTxnMap()

            //4 Byte Txn Type
            structCSVTxnMap.ulTxnType  = DataLong(p[iOffset] << 24) & Int64(0xFF000000)
            iOffset += 1
            structCSVTxnMap.ulTxnType |= DataLong(p[iOffset] << 16) & Int64(0x00FF0000)
            iOffset += 1
            structCSVTxnMap.ulTxnType |= DataLong(p[iOffset] <<  8) & Int64(0x0000FF00)
            iOffset += 1
            structCSVTxnMap.ulTxnType |= DataLong(p[iOffset] & 0x000000FF)
            iOffset += 1
            
            //1 Byte Use Encryption Flag
            structCSVTxnMap.bUseEncryption     = (Byte)(p[iOffset] & 0x000000FF)
            iOffset += 1
            
            m_ulCSVTxnMapIterator += 1

            debugPrint("CSV Txn Type File it[\(m_ulCSVTxnMapIterator)]")
            debugPrint("ulTxnType[\(structCSVTxnMap.ulTxnType)]")
            debugPrint("bUseEncryption[0x%x]", structCSVTxnMap.bUseEncryption!)

            st_CSVTxnMapList.append(structCSVTxnMap);
        }
        
        do{
             _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.TEMPCSVTXNMAPFILE, with: st_CSVTxnMapList);
        }
        catch{
            fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.TEMPCSVTXNMAPFILE)")
        }
        return true;
    }

    //MARK:- ProcessCSVTxnMapVersion()
    func ProcessCSVTxnMapVersion()
    {
        debugPrint("Inside ProcessCSVTxnTypeVersion")
        let globalData = GlobalData.singleton

        if(!bitmap[43-1])
        {
            debugPrint("ERROR No Field 43 !!")
            return;
        }

        _ = globalData.ReadMasterParamFile()

        //if previous version is same as current version then do nothing
        if(globalData.m_sMasterParamData!.m_strCSVTxnMapVersion == String(bytes: data[43 - 1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)){
            return;
        }

        //if temp bin range file exist, then replace BINRANGE file with temp.
        if(FileSystem.IsFileExist(strFileName: FileNameConstants.TEMPCSVTXNMAPFILE))
        {
            let tempData: [StCSVTxnMap] = []
            debugPrint("TEMPCSVTXNTYPEFILE exists")
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.CSVTXNMAPFILE, with: tempData)
            if(true == FileSystem.RenameFile(strNewFileName: FileNameConstants.CSVTXNMAPFILE,strFileName: FileNameConstants.TEMPCSVTXNMAPFILE))
            {
                debugPrint("CSVTXNMAPFILE rename done");
                globalData.m_sMasterParamData!.ulTotalCSVTxnType = m_ulCSVTxnMapIterator;
            }else{
                debugPrint("CSVTXNMAPFILE rename failed");
            }
        }

        // if version is different(the file is downloaded) then set reset flag and bin range changed flag true.
        // the bin range changed flag will ensure in loading files to sort bin range file.
        globalData.m_sMasterParamData!.m_strCSVTxnMapVersion = String(bytes: data[43 - 1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
        debugPrint("m_strCSVTxnMapVersion[\(globalData.m_sMasterParamData!.m_strCSVTxnMapVersion)]")

        //TODO:- statemachine class needed
        //CStateMachine Statemachine = CStateMachine.GetInstance();
        //Statemachine.m_ResetTerminal = true;

        _ = globalData.WriteMasterParamFile()
    }
    
    //MARK:- ProcessTxnBinDownload() -> Bool
    func ProcessTxnBinDownload() -> Bool
    {
        debugPrint("Inside ProcessTxnBinDownload")

        if(!bitmap[61 - 1]){
            debugPrint("ERROR No Field 61 !!")
            return false
        }

        let p: [Byte] = data[61-1];
        let length : Int = len[61-1];

        debugPrint("field 61 len[\(length)]")
        if(length <= 0){
            return false;
        }
        
        debugPrint(length, p);
        var st_TxnBinList: [StTxnBin] = []
        
        var iOffset: Int = 0
        while(length > iOffset)
        {
            if(m_ulTxnBinIterator >= AppConstant.MAX_TXN_BIN_PARAMETERES){
                debugPrint("MAX_TXN_BIN_PARAMETERES reached")
                break
            }

            var structTxnBin = StTxnBin()

            var iLocalStructLen: Int = 0
            iLocalStructLen |= Int(p[iOffset] << 8) & Int(0x0000FF00)
            iOffset += 1
            iLocalStructLen |= Int(p[iOffset] & 0x000000FF)
            iOffset += 1
            
            var iLocalOffset: Int = iOffset

            //1 byte BinID
            structTxnBin.iBinID = Int((Byte)(p[iLocalOffset] & 0x000000FF))
            iLocalOffset += 1
            
            
            //4 Byte Bin Low
            structTxnBin.ulBinLow  = DataLong(p[iLocalOffset] << 24) & Int64(0xFF000000)
            iLocalOffset += 1
            structTxnBin.ulBinLow |= DataLong(p[iLocalOffset] << 16) & Int64(0x00FF0000)
            iLocalOffset += 1
            structTxnBin.ulBinLow |= DataLong(p[iLocalOffset] <<  8) & Int64(0x0000FF00)
            iLocalOffset += 1
            structTxnBin.ulBinLow |=  DataLong(p[iLocalOffset] & 0x000000FF)
            iLocalOffset += 1
            
            //4 Byte Bin High
            structTxnBin.ulBinHigh  = DataLong(p[iLocalOffset] << 24) & Int64(0xFF000000)
            iLocalOffset += 1
            structTxnBin.ulBinHigh |= DataLong(p[iLocalOffset] << 16) & Int64(0x00FF0000)
            iLocalOffset += 1
            structTxnBin.ulBinHigh |= DataLong(p[iLocalOffset] <<  8) & Int64(0x0000FF00)
            iLocalOffset += 1
            structTxnBin.ulBinHigh |= DataLong(p[iLocalOffset] & 0x000000FF)
            iLocalOffset += 1
            
            //1 Byte EMV AccountType
            structTxnBin.iEMVAccountSelection = (Byte)(p[iLocalOffset] & 0x000000FF)
            iLocalOffset += 1
            structTxnBin.iIsPinNeeded = (Byte)(p[iLocalOffset] & 0x000000FF)
            iLocalOffset += 1
            
            m_ulTxnBinIterator += 1

            debugPrint("Txn Bin File it[\(m_ulTxnBinIterator)]")
            debugPrint("iBinID[\(structTxnBin.iBinID)]")
            debugPrint("ulBinLow[\(structTxnBin.ulBinLow)]")
            debugPrint("ulBinHigh[\(structTxnBin.ulBinHigh)]")
            debugPrint("iEMVAccountSelection[0x%x]", structTxnBin.iEMVAccountSelection!)
            debugPrint("iIsPinNeeded[0x%x]", structTxnBin.iIsPinNeeded!)

            st_TxnBinList.append(structTxnBin)

            //Local length define the length of local structure
            iOffset += iLocalStructLen
        }
        
        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.TEMPTXNBINFILE, with: st_TxnBinList);
        }
        catch{
            fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.TEMPTXNBINFILE)")
        }
        return true
    }
    
    
    //MARK:- ProcessTxnBinDateTime()
    func ProcessTxnBinDateTime()
    {
        debugPrint("Inside ProcessTxnBinDateTime")
        let globalData = GlobalData.singleton

        if(!bitmap[43-1])
        {
            debugPrint("ERROR No Feild 43 !!")
            return;
        }

        _ = globalData.ReadMasterParamFile()

        //if previous version is same as current version then do nothing
        if(globalData.m_sMasterParamData!.m_strTxnBinDownloadDate == String(bytes: data[43 - 1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)){
            return;
        }

        //if temp bin range file exist, then replace BINRANGE file with temp.
        if(FileSystem.IsFileExist(strFileName: FileNameConstants.TEMPTXNBINFILE))
        {
            let tempData: [StTxnBin] = []
            debugPrint("TEMPTXNBINFILE exists");
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TXNBINFILE, with: tempData)
            
            if(true == FileSystem.RenameFile(strNewFileName: FileNameConstants.TXNBINFILE, strFileName: FileNameConstants.TEMPTXNBINFILE))
            {
                debugPrint( "TXNBINFILE rename done")
                globalData.m_sMasterParamData!.ulTotalTxnBin = m_ulTxnBinIterator
            }else{
                debugPrint("TXNBINFILE rename failed")
            }
        }

        // if version is different(the file is downloaded) then set reset flag and bin range changed flag true.
        // the bin range changed flag will ensure in loading files to sort bin range file.
        globalData.m_sMasterParamData!.m_strTxnBinDownloadDate = String(bytes: data[43 - 1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
        debugPrint("m_strTxnBinDownloadDate[\(globalData.m_sMasterParamData!.m_strTxnBinDownloadDate)]")

        globalData.m_sMasterParamData!.m_bIsTxnBinChanged = true

        //TODO: statemachine class needed
        //CStateMachine  Statemachine = CStateMachine.GetInstance();
        //Statemachine.m_ResetTerminal = true;

        _ = globalData.WriteMasterParamFile()
    }
    
    
    //MARK:- ProcessCSVTxnIgnoreAmtListDownload() -> Bool
    func ProcessCSVTxnIgnoreAmtListDownload() -> Bool
    {
        debugPrint("Inside ProcessCSVTxnIgnoreAmtListDownload")
        let globalData = GlobalData.singleton

        if((!bitmap[61 - 1]) || (len[61-1] <= 0))
        {
            if(globalData.m_sMasterParamData!.m_strIgnoreAmtCSVTxnListDownloadDate == String(bytes: data[43 - 1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))
            {
                //No Change in Ignore List
                debugPrint("No Change in Ignore List")
            }else{
                debugPrint("Change in Ignore List, Remove entries")
                //No Data means file is deleted
                m_ulTotalCSVTxnIgnAmtListIterator = 0
                do{
                    _ = try FileSystem.AppendFile(strFileName: FileNameConstants.TEMPCSVTXNIGNAMT,with: ["0"]); //Append Dummy
                }
                catch{
                    fatalError("Error in AppendFile, strFileName: \(FileNameConstants.TEMPCSVTXNIGNAMT)")
                }
            }
            //No Data means file is deleted
            debugPrint("ERROR No Field 61 !!");
            return false;
        }

        let p: [Byte] = data[61-1]
        let length: Int = len[61-1]

        debugPrint("field 61 len[\(length)]")
        if(length <= 0){
            return false;
        }
        debugPrint(length, p)
        var st_CSVTxnIgnoreAmtList: [StCSVTxnIgnoreAmt] = []

        var iOffset: Int = 0;
        while(length > iOffset)
        {
            if(m_ulTotalCSVTxnIgnAmtListIterator >= AppConstant.MAX_TXN_BIN_PARAMETERES){
                debugPrint("MAX_TXN_BIN_PARAMETERES reached");
                break;
            }

            var structCSVTxnIgnoreAmt = StCSVTxnIgnoreAmt()

            var iLocalStructLen: Int = 0
            iLocalStructLen |= Int(p[iOffset] << 8) & Int(0x0000FF00)
            iOffset += 1
            iLocalStructLen |=  Int(p[iOffset] & 0x000000FF)
            iOffset += 1
            
            var iLocalOffset: Int = iOffset;

            //2 byte CSV Txn Id
            structCSVTxnIgnoreAmt.CsvTxnId |= Int(p[iLocalOffset] << 8) & Int(0x0000FF00)
            iLocalOffset += 1
            structCSVTxnIgnoreAmt.CsvTxnId |=  Int(p[iLocalOffset] & 0x000000FF)
            iLocalOffset += 1
            
            //1 Byte EMV AccountType
            structCSVTxnIgnoreAmt.iIsIgnoreAmountEnabled = (Int(p[iLocalOffset] & 0xFF) == 0x01)
            iLocalOffset += 1
            
            //1 Byte Signature Required flag
            structCSVTxnIgnoreAmt.iIsSignatureRequired = (Int(p[iLocalOffset] & 0xFF) == 0x01)
            iLocalOffset += 1
            
            m_ulTotalCSVTxnIgnAmtListIterator += 1

            debugPrint("CSV Bin File it[\(m_ulTotalCSVTxnIgnAmtListIterator)]");
            debugPrint("CsvTxnId[\(structCSVTxnIgnoreAmt.CsvTxnId)]");
            debugPrint("iIsIgnoreAmountEnabled[\(structCSVTxnIgnoreAmt.iIsIgnoreAmountEnabled)]");
            debugPrint("iIsSignatureRequired[\(structCSVTxnIgnoreAmt.iIsSignatureRequired)]");

            st_CSVTxnIgnoreAmtList.append(structCSVTxnIgnoreAmt)

            //Local length define the length of local structure
            iOffset += iLocalStructLen;
        }

        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.TEMPCSVTXNIGNAMT,with: st_CSVTxnIgnoreAmtList)
        }
        catch
        {
            fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.TEMPCSVTXNIGNAMT)")
        }
        
        return true
    }
    
        
    //MARK:- ProcessCSVTxnIgnoreAmtDateTime()
    func ProcessCSVTxnIgnoreAmtDateTime()
    {
        debugPrint("Inside ProcessCSVTxnIgnoreAmtDateTime")
        let globalData = GlobalData.singleton

        if(!bitmap[43-1])
        {
            debugPrint("ERROR No Feild 43 !!")
            return
        }

        _ = globalData.ReadMasterParamFile();

        //if previous version is same as current version then do nothing
        if(globalData.m_sMasterParamData!.m_strIgnoreAmtCSVTxnListDownloadDate == String(bytes: data[43 - 1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)){
            return
        }

        //if temp bin range file exist, then replace BINRANGE file with temp.
        if(FileSystem.IsFileExist(strFileName: FileNameConstants.TEMPCSVTXNIGNAMT))
        {
            debugPrint("TEMPCSVTXNIGNAMT exists")
            
            let tempData: [StCSVTxnIgnoreAmt] = []
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.CSVTXNIGNAMT, with: tempData)
            if(true == FileSystem.RenameFile(strNewFileName: FileNameConstants.CSVTXNIGNAMT,strFileName: FileNameConstants.TEMPCSVTXNIGNAMT))
            {
                debugPrint("CSVTXNIGNAMT rename done");
                globalData.m_sMasterParamData!.m_ulTotalCSVTxnIgnAmtList = m_ulTotalCSVTxnIgnAmtListIterator
                debugPrint("m_ulTotalCSVTxnIgnAmtList = \(m_ulTotalCSVTxnIgnAmtListIterator)")
            }else{
                debugPrint("CSVTXNIGNAMT rename failed")
            }
        }

        // if version is different(the file is downloaded) then set reset flag and bin range changed flag true.
        // the bin range changed flag will ensure in loading files to sort bin range file.
        globalData.m_sMasterParamData!.m_strIgnoreAmtCSVTxnListDownloadDate = String(bytes: data[43 - 1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
        debugPrint("m_strIgnoreAmtCSVTxnListDownloadDate[\(globalData.m_sMasterParamData!.m_strIgnoreAmtCSVTxnListDownloadDate)]")

        //TODO: StateMachine Class needed
        //CStateMachine Statemachine = CStateMachine.GetInstance();
        //Statemachine.m_ResetTerminal = true;

        _ = globalData.WriteMasterParamFile()
    }

    //MARK:- ProcessEMVTagListDownload()
    func ProcessEMVTagListDownload() -> Bool
    {
        debugPrint("Inside ProcessEMVTagListDownload")
        let globalData = GlobalData.singleton

        if((!bitmap[61 - 1]) || (len[61-1] <= 0))
        {
            var chArrDownloadDate = [Byte](repeating: 0x00, count: AppConstant.MAX_DATE_LEN)
            chArrDownloadDate = Array(data[43 - 1][0 ..< data[43 - 1].count])
            //System.arraycopy(data[43-1],0,chArrDownloadDate,0,data[43-1].length);
         
            if(globalData.m_sMasterParamData!.m_strEMVTagListDownloadDate == String(bytes: chArrDownloadDate, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))
            {
                //No Change in EMV Tag List
                debugPrint("No Change in EMV Tag List")
            }else{
                debugPrint("Change in EMV Tag List, Remove entries")
                //No Data means file is deleted
                m_ulTotalEMVTagListIterator = 0;
                do{
                    _ = try FileSystem.AppendFile(strFileName: FileNameConstants.TEMPEMVTAGLIST, with: ["0"]) //Append Dummy
                }
                catch
                {
                    fatalError("Error in AppendFile, strFileName: \(FileNameConstants.TEMPEMVTAGLIST)")
                }
            }
            //No Data means file is deleted
            debugPrint("ERROR No Field 61 !!")
            return false
        }

        let p: [Byte] = data[61-1]
        let length: Int = len[61-1]


        debugPrint("EMV Tag field 61 len[\(length)]")
        if(length <= 0){
            return false
        }
        debugPrint(length, p)


        var iOffset: Int = 0;
        while(length > iOffset)
        {
            if(m_ulTotalEMVTagListIterator >= AppConstant.MAX_TXN_BIN_PARAMETERES){
                debugPrint( "MAX_TXN_BIN_PARAMETERES reached");
                break;
            }
            //Logic to append file

            var stEMVTagList: [StEMVTagList] = []

            //1 Byte EMV taglen
            stEMVTagList[0].ushLen = Int8(p[iOffset] & 0x000000FF)
            iOffset += 1
            
            if(stEMVTagList[0].ushLen == 1)
            {
                //1 byte EMV tag value
                stEMVTagList[0].Value = Int(p[iOffset] & 0x000000FF)
                iOffset += 1
            }
            else {
                //2 byte EMV tag value
                stEMVTagList[0].Value |= Int(p[iOffset] <<  8) & Int(0x0000FF00)
                iOffset += 1
                stEMVTagList[0].Value |=  Int(p[iOffset] & 0x000000FF)
                iOffset += 1
            }

            m_ulTotalEMVTagListIterator += 1

            debugPrint("EMV Tag File it[\(m_ulTotalEMVTagListIterator)]");
            debugPrint("EMV tag len[\(stEMVTagList[0].ushLen)]");
            debugPrint("Emv tag value[\(stEMVTagList[0].Value)]");

            do{
                _ = try FileSystem.AppendFile(strFileName: FileNameConstants.TEMPEMVTAGLIST, with: stEMVTagList)
            }
            catch
            {
                fatalError("Error in AppendFile, strFileName: \(FileNameConstants.TEMPEMVTAGLIST)")
            }
        }
        //Local length define the length of local structure
        return true;
    }

    //MARK:- ProcessEMVTagListDateTime()
    func ProcessEMVTagListDateTime()
    {
        debugPrint("Inside ProcessEMVTagListDateTime");
        let  globalData = GlobalData.singleton

        if(!bitmap[43-1])
        {
            debugPrint("ERROR No Feild 43 !!");
            return;
        }

        _ = globalData.ReadMasterParamFile()

        //if previous version is same as current version then do nothing
        if(globalData.m_sMasterParamData!.m_strEMVTagListDownloadDate == String(bytes: data[43 - 1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)){
            return;
        }

        //if temp bin range file exist, then replace BINRANGE file with temp.
        if(FileSystem.IsFileExist(strFileName: FileNameConstants.TEMPEMVTAGLIST))
        {
            debugPrint("TEMPCSVTXNIGNAMT exists");
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.EMVTAGLIST, with: ["0"])
            if(true == FileSystem.RenameFile(strNewFileName: FileNameConstants.EMVTAGLIST, strFileName: FileNameConstants.TEMPEMVTAGLIST))
            {
                debugPrint("EMVTAGLIST rename done")
                globalData.m_sMasterParamData!.m_ulTotalEMVTagList = m_ulTotalEMVTagListIterator
                debugPrint( "m_ulTotalEMVTagList[%d]",m_ulTotalEMVTagListIterator)
            }else{
                debugPrint("EMVTAGLIST rename failed")
            }
        }

        // if version is different(the file is downloaded) then set reset flag and bin range changed flag true.
        // the bin range changed flag will ensure in loading files to sort bin range file.
        globalData.m_sMasterParamData!.m_strEMVTagListDownloadDate = String(bytes: data[43 - 1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
        debugPrint("m_strEMVTagListDownloadDate[\(globalData.m_sMasterParamData!.m_strEMVTagListDownloadDate)]")


        //TODO: statemachine class needed
        //CStateMachine  Statemachine = CStateMachine.GetInstance();
        //Statemachine.m_ResetTerminal = true;

        _ = globalData.WriteMasterParamFile()
    }
    
    //MARK:- ProcessHubParmDownload()
    func ProcessHubParmDownload()
    {
        debugPrint("Inside ProcessParameterDownload")
        if(!bitmap[61 - 1]){
            debugPrint("ERROR No Field 61 !!")
            return
        }
        
        let p: [Byte] = data[61-1];
        var length: Int = len[61-1];
        var iOffset: Int = 0;

        while(length > 0)
        {
            if(m_ulParameterIterator >= AppConstant.MAX_COUNT_PARAMETERS)
            {
                break;
            }
            
            let iOldOffset: Int = iOffset;

            var iParameterId: Int = 0x00
            var iParameterValLen: Int = 0x00
            var iHostID: Int = 0x00

            //1 byte host id
            iHostID = Int(p[iOffset] & 0xFF)
            iOffset += 1
            
            //2 byte parameter id, 1 byte length , X ASCII chars data
            iParameterId = Int(p[iOffset] & 0xFF)
            iOffset += 1
            iParameterId <<= 8;
            iParameterId |= Int(p[iOffset] & 0xFF)
            iOffset += 1
            
            iParameterValLen = Int(p[iOffset])
            iOffset += 1
            
            if (iParameterValLen > 0) {
                m_ObjArrParameterData[m_ulParameterIterator] = ParameterData();
                m_ObjArrParameterData[m_ulParameterIterator]!.chArrParameterVal = [Byte](repeating: 0x00, count: iParameterValLen)
                
                m_ObjArrParameterData[m_ulParameterIterator]!.chArrParameterVal = Array(p[iOffset ..< iOffset + iParameterValLen])
                //System.arraycopy(p, iOffset, m_ObjArrParameterData[m_ulParameterIterator].chArrParameterVal, 0, iParameterValLen);
              
                m_ObjArrParameterData[m_ulParameterIterator]!.uiHostID = iHostID;
                m_ObjArrParameterData[m_ulParameterIterator]!.ulParameterId = iParameterId;
                m_ObjArrParameterData[m_ulParameterIterator]!.ulParameterLen = iParameterValLen;
                
                /*CLogger.TraceLog(TRACE_DEBUG, "HOST ID =%d", m_ObjArrParameterData[m_ulParameterIterator].uiHostID);
                CLogger.TraceLog(TRACE_DEBUG, "ID =%d", m_ObjArrParameterData[m_ulParameterIterator].ulParameterId);
                CLogger.TraceLog(TRACE_DEBUG, "LEN =%d", m_ObjArrParameterData[m_ulParameterIterator].ulParameterLen);
                CLogger.TraceLog(TRACE_DEBUG, "VALUE =%s", m_ObjArrParameterData[m_ulParameterIterator].chArrParameterVal);*/
                m_ulParameterIterator += 1
            }

            iOffset += iParameterValLen;
            length -= (iOffset - iOldOffset);
            m_ulLastParameterId  = Int64(iParameterId);
        }

        //check for updates
        _ = CheckForParameterUpdate()
        m_ulParameterIterator = 0
    }
    

    //MARK:- CheckForParameterUpdate() -> Int
    func CheckForParameterUpdate() -> Int
    {
        let globalData = GlobalData.singleton

        for i in 0 ..< m_ulParameterIterator
        {
            _ = globalData.UpdateParameter(ParameterData: m_ObjArrParameterData[i]!)
        }
        
        return 1;
    }
    
    
    /************************************************
    * ProcessHubParmDownloadDateTime
    *************************************************/
    //MARK:- ProcessHubParmDownloadDateTime()
    func ProcessHubParmDownloadDateTime()
    {
        debugPrint("Inside ProcessHubParmDownloadDateTime")
        if(!bitmap[43-1])
        {
            debugPrint("ERROR No Field 43 !!")
            return
        }

        var _: [TerminalParamData] = []
        let chFileName: String = String(format: "%s.plist",FileNameConstants.TERMINALPARAMFILENAME);
        debugPrint("param file name[\(chFileName)]");
            
        var tData: TerminalParamData = GlobalData.singleton.ReadParamFile()!
        
        if(tData != nil){
            tData.m_strParamDownloadDate =  (String(bytes: data[43 - 1], encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines))!
            _ = GlobalData.singleton.WriteParamFile(listParamData: tData)
            debugPrint("m_sParamDownloadDate[\(tData.m_strParamDownloadDate)]")
        }
    }
    
    //MARK:- ProcessEMVParDownload() -> Bool
    func ProcessEMVParDownload() -> Bool
    {
        debugPrint("Inside ProcessEMVParDownload")
        
        let p: [Byte] = data[61-1]
        let _: Int = len[61-1]

        let pFieldEMVparDef: [Byte] = data[53-1]
        let ilength: Int = len[53-1]
        
        
        if(ilength >= 2)
        {
            var offset: Int = 0
            self.m_bCurrentPacketCount = Int64((pFieldEMVparDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64((pFieldEMVparDef [offset]) & 0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = Int64((pFieldEMVparDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64((pFieldEMVparDef [offset]) & 0x000000FF)
            offset += 1
            
            debugPrint("Response->Field 53 found")
            debugPrint("m_bCurrentPacketCount[\(m_bCurrentPacketCount)], m_bTotalPacketCount[\(m_bTotalPacketCount)]")
        }

        if(self.m_bCurrentPacketCount == 0x01)
        {
            let tempData: [CurrentEMVParDownloadingInfo] = []
            let tempData1: [Long] = []
            debugPrint("******* EMV PAR Data******");
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TEMEMVPARFILE, with: p)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDEMVPARINFO, with: tempData)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDEMVPARCHUNKINFO, with: tempData1)
        }
         else{
            
            if(bitmap[54 - 1])
            {
                debugPrint("EMV PAR NOT First packet");
                let chEMVparVersion: [Byte] = getEMVParVersion(isoFeild: ISOFieldConstants.ISO_FIELD_54)
                if(!chEMVparVersion.isEmpty)
                {
                    debugPrint("m_chDownloadingEMVparVersion[\(String(describing: String(bytes: m_chDownloadingEMVparVersion, encoding: .utf8)))] ,chEMVparVersion[\(String(bytes: chEMVparVersion, encoding: .utf8)!)]")
                    
                    if(false != (String(bytes: chEMVparVersion, encoding: .utf8) == String(bytes: m_chDownloadingEMVparVersion, encoding: .utf8)))
                       {
                           //stop PVM download
                           //clean data
                            let tempData: [CurrentEMVParDownloadingInfo] = []
                            let tempData1: [Long] = []
                         
                            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TEMEMVPARFILE, with: p)
                            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDEMVPARINFO, with: tempData)
                            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDEMVPARCHUNKINFO, with: tempData1)
                
                            debugPrint("New EMV being downloaded")
                            return false
                       }
                   }else{
                        debugPrint("ERROR Cannot retrive cless version!!")
                       return false;
                   }
               }else{
                   debugPrint("Field 54 not found !!")
                   return false;
               }
         }

         /***************************************************************************************
          * if(this->m_bCurrentPacketCount == this->m_bTotalPacketCount)
          * extract field 59 from 330 and save in our parameter file as PVM version.
          * for new request. As of now host might not be sending this ---- to check with host team
          *
          * We will check weather PVM file is present before renaming temp file to PVM file
          ****************************************************************************************/
         if(self.m_bCurrentPacketCount == self.m_bTotalPacketCount)
         {
            let globalData = GlobalData.singleton
            
            //TODO: Statemachine class needed
            //CStateMachine Statemachine = CStateMachine.GetInstance();

            do{
                _ = try FileSystem.AppendFile(strFileName: FileNameConstants.TEMEMVPARFILE, with: p);
            }
            catch
            {
                fatalError("Error in AppendFile, strFileName: \(FileNameConstants.TEMEMVPARFILE)")
            }
            
            if(true == FileSystem.IsFileExist(strFileName: FileNameConstants.EMVPARFILE))
            {
                _ = FileSystem.DeleteFile(strFileName: FileNameConstants.EMVPARFILE, with: p)
                debugPrint("EMVPARFILE file deleted")
            }
            _ = FileSystem.RenameFile(strNewFileName: FileNameConstants.EMVPARFILE, strFileName: FileNameConstants.TEMEMVPARFILE)
               debugPrint("EMVPARFILE file created")

               //Store EMV Par Version
            var retValParse: Int = -1;
            let chEMVParVersion: [Byte] = getEMVParVersion(isoFeild:ISOFieldConstants.ISO_FIELD_54)
            if(!chEMVParVersion.isEmpty)
            {
                //carry out str to ul and store it in the database or file system as the case may be
                    //this will sent in next time in field 59 in all the next requests.
                if(true == FileSystem.IsFileExist(strFileName: FileNameConstants.EMVPARFILE))
                {
                    if(!(globalData.m_sMasterParamData!.m_strEMVParVersion == String(bytes: chEMVParVersion, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)))
                    {
                        retValParse = 0;
                        //TODO: Statemachine Class needed
                        //Statemachine.m_ResetTerminal = true;
                    }
                }
                if(0 == retValParse){
                    globalData.m_sMasterParamData!.m_strEMVParVersion = String(bytes: chEMVParVersion, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
                    _ = globalData.WriteMasterParamFile()
                }
            }
         }
         else
         {
            do{
                _ = try FileSystem.AppendFile(strFileName: FileNameConstants.TEMEMVPARFILE, with: p);
            }
            catch
            {
                fatalError("Error in AppendFile, strFileName: \(FileNameConstants.TEMEMVPARFILE)")
            }
             //CFileSystem.AppendByteFile(m_cntx,AppConst.TEMEMVPARFILE,p,length);
             _ = SaveEMVParDownloadInfoVersion()
         }
         return true;
     }
    
    //MARK:- ProcessCLESSEMVParDownload() -> Bool
    func ProcessCLESSEMVParDownload() -> Bool
    {
        debugPrint("Inside ProcessCLESSEMVParDownload")
        
        let p: [Byte] = data[61-1]
        let _: Int = len[61-1]

        let pFieldEMVparDef: [Byte] = data[53-1]
        let ilength: Int = len[53-1]
           
        if(ilength >= 2)
        {
            var offset: Int = 0
            self.m_bCurrentPacketCount = Int64((pFieldEMVparDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64((pFieldEMVparDef [offset]) & 0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = Int64((pFieldEMVparDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64((pFieldEMVparDef [offset]) & 0x000000FF)
            offset += 1
            
            debugPrint("Response->Field 53 found")
            debugPrint("m_bCurrentPacketCount[\(m_bCurrentPacketCount)], m_bTotalPacketCount[\(m_bTotalPacketCount)]")
        }

        if(self.m_bCurrentPacketCount == 0x01)
        {
            let tempData: [CurrentEMVParDownloadingInfo] = []
            let tempData1: [Long] = []
            debugPrint("*******CLESS EMV PAR Data******");
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TEMCLESSPARFILE, with: p)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDCLESSPARINFO, with: tempData)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDCLESSPARCHUNKINFO, with: tempData1)
        }
        else{
            if(bitmap[54 - 1])
            {
                debugPrint("CLESS EMV PAR NOT First packet");
                let chEMVparVersion: [Byte] = getCLESSEMVParVersion(isoFeild: ISOFieldConstants.ISO_FIELD_54)
                if(!chEMVparVersion.isEmpty)
                {
                    debugPrint("m_chDownloadingCLESSEMVparVersion[\(String(describing: String(bytes: m_chDownloadingCLESSEMVparVersion, encoding: .utf8)))] ,chEMVparVersion[\(String(bytes: chEMVparVersion, encoding: .utf8)!)]")
                    
                    if(false != (String(bytes: chEMVparVersion, encoding: .utf8) == String(bytes: m_chDownloadingCLESSEMVparVersion, encoding: .utf8)))
                       {
                           //stop PVM download
                           //clean data
                            let tempData: [CurrentEMVParDownloadingInfo] = []
                            let tempData1: [Long] = []
                         
                            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TEMCLESSPARFILE, with: p)
                            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDCLESSPARINFO, with: tempData)
                            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDCLESSPARCHUNKINFO, with: tempData1)
                
                            debugPrint("New cless being downloaded")
                            return false
                       }
                   }else{
                        debugPrint("ERROR Cannot retrive cless version!!")
                       return false;
                   }
               }else{
                   debugPrint("Field 54 not found !!")
                   return false;
               }
           }

        /***************************************************************************************
        * if(this->m_bCurrentPacketCount == this->m_bTotalPacketCount)
        * extract field 59 from 330 and save in our parameter file as PVM version.
        * for new request. As of now host might not be sending this ---- to check with host team
        *
        * We will check weather PVM file is present before renaming temp file to PVM file
        ****************************************************************************************/
        if(self.m_bCurrentPacketCount == self.m_bTotalPacketCount)
        {
            let globalData = GlobalData.singleton
            
            //TODO: Statemachine class needed
            //CStateMachine Statemachine = CStateMachine.GetInstance();

            do{
                _ = try FileSystem.AppendFile(strFileName: FileNameConstants.TEMCLESSPARFILE, with: p);
            }
            catch
            {
                fatalError("Error in AppendFile, strFileName: \(FileNameConstants.TEMCLESSPARFILE)")
            }
            
            if(true == FileSystem.IsFileExist(strFileName: FileNameConstants.CLESSPARFILE))
            {
                _ = FileSystem.DeleteFile(strFileName: FileNameConstants.CLESSPARFILE, with: p)
                debugPrint("CLESSPARFILE file deleted")
            }
            _ = FileSystem.RenameFile(strNewFileName: FileNameConstants.CLESSPARFILE, strFileName: FileNameConstants.TEMCLESSPARFILE)
               debugPrint("CLESSPARFILE file created")

               //Store EMV Par Version
            var retValParse: Int = -1;
            let chEMVParVersion: [Byte] = getCLESSEMVParVersion(isoFeild:ISOFieldConstants.ISO_FIELD_54)
            if(!chEMVParVersion.isEmpty)
            {
                //carry out str to ul and store it in the database or file system as the case may be
                    //this will sent in next time in field 59 in all the next requests.
                if(true == FileSystem.IsFileExist(strFileName: FileNameConstants.CLESSPARFILE))
                {
                    if(!(globalData.m_sMasterParamData!.m_strCLESSEMVParVersion == String(bytes: chEMVParVersion, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)))
                    {
                        retValParse = 0;
                        //TODO: Statemachine Class needed
                        //Statemachine.m_ResetTerminal = true;
                    }
                }
                if(0 == retValParse){
                    globalData.m_sMasterParamData!.m_strCLESSEMVParVersion = String(bytes: chEMVParVersion, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
                    _ = globalData.WriteMasterParamFile()
                }
            }
        }
        else
        {
            do{
                _ = try FileSystem.AppendFile(strFileName: FileNameConstants.TEMCLESSPARFILE, with: p);
            }
            catch
            {
                fatalError("Error in AppendFile, strFileName: \(FileNameConstants.TEMCLESSPARFILE)")
            }
            
            //CFileSystem.AppendByteFile(m_cntx,AppConst.TEMCLESSPARFILE,p,length);
            _ = SaveCLESSEMVParDownloadInfoVersion()
        }
        return true;
    }
    
   
    //MARK:- getEMVParVersion(isoFeild: Int) -> [Byte]
    func getEMVParVersion(isoFeild: Int) -> [Byte]
    {
        var chEMVparVersion: [Byte] = []
        if(bitmap[isoFeild - 1])
        {
            chEMVparVersion = [Byte](repeating: 0x00, count: len[isoFeild - 1])
            chEMVparVersion = Array(data[isoFeild - 1][0 ..< chEMVparVersion.count])
    
            //CLogger.TraceLog(TRACE_DEBUG,"getEMVParVersion [%s]",chEMVparVersion);
        }
        return chEMVparVersion;
    }
    
    //MARK:- getCLESSEMVParVersion(isoFeild: Int) -> [Byte]
    func getCLESSEMVParVersion(isoFeild: Int) -> [Byte]
    {
        var chEMVparVersion: [Byte] = []
        //Store PVM version
        
        if(bitmap[isoFeild - 1])
        {
            chEMVparVersion = [Byte](repeating: 0x00, count: len[isoFeild - 1])
            chEMVparVersion = Array(data[isoFeild - 1][0 ..< chEMVparVersion.count])
            //System.arraycopy(data[isoFeild-1],0,chEMVparVersion,0,chEMVparVersion.length);
            //CLogger.TraceLog(TRACE_DEBUG,"getCLESSEMVParVersion [%s]",chEMVparVersion);
        }
        
        return chEMVparVersion;
    }
    
    //MARK:- SaveEMVParDownloadInfoVersion() -> Int
    func SaveEMVParDownloadInfoVersion() -> Int
    {
        //save EMVPar Version
        if(bitmap[54 - 1])
        {
            var currentEMVParDwndInfo = CurrentEMVParDownloadingInfo()
            var ItemList: [CurrentEMVParDownloadingInfo] = []

            let chEMVParVersion: [Byte] = getEMVParVersion(isoFeild: ISOFieldConstants.ISO_FIELD_54)
            if(!chEMVParVersion.isEmpty)
            {
                currentEMVParDwndInfo.chVersion = Array(chEMVParVersion[0 ..< 12])
                //System.arraycopy(chEMVParVersion,0,currentEMVParDwndInfo.chVersion,0,12);
                
                currentEMVParDwndInfo.currentpacketCount = Int(m_bCurrentPacketCount)
                currentEMVParDwndInfo.totalpacketCount = Int(m_bTotalPacketCount)

                debugPrint("Saving Download info !!")
                debugPrint("Version[\(String(bytes: currentEMVParDwndInfo.chVersion, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))]")
                debugPrint("CurrPkt[\(currentEMVParDwndInfo.currentpacketCount)]")
                debugPrint("TotPkt [\(currentEMVParDwndInfo.totalpacketCount)]")
                ItemList.append(currentEMVParDwndInfo)

                do{
                    _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.DWNLDEMVPARINFO, with: ItemList)
                }
                catch{
                    fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.DWNLDEMVPARINFO)")
                }
                
            }else{
                debugPrint("ERROR Cannot retrive EMV version!!");
            }
        }
        else{
            debugPrint("WARNING Not Saving Download info !!");
        }

        //Save chunksize
        if(bitmap[45 - 1])
        {
            var chArrTempChunkSize = [Byte](repeating: 0x00, count: len[45 - 1])
            chArrTempChunkSize = Array(data[45 - 1][0 ..< len[45 - 1]])
            //System.arraycopy(data[45-1],0,chArrTempChunkSize,0,len[45-1]);
            var ulChunkSize = Long()
            ulChunkSize.value = Int64(strtoul(String(bytes: chArrTempChunkSize, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines), nil, 10))
                //Long.parseLong(new String(chArrTempChunkSize));

            var ItemList: [Long] = []
            ItemList.append(ulChunkSize)
            debugPrint("ulChunkSize[\(ulChunkSize.value)]")
            do{
                _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.DWNLDEMVPARCHUNKINFO, with: ItemList)
            }
            catch{
                fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.DWNLDEMVPARCHUNKINFO)")
            }
            
        }
        return 1;
    }
    
    //for contactless
    //MARK:- SaveCLESSEMVParDownloadInfoVersion() -> Int
    func SaveCLESSEMVParDownloadInfoVersion() -> Int
    {
        //save EMVPar Version
        if(bitmap[54 - 1])
        {
            var currentEMVParDwndInfo = CurrentEMVParDownloadingInfo()
            var ItemList: [CurrentEMVParDownloadingInfo] = []

            let chEMVParVersion: [Byte] = getCLESSEMVParVersion(isoFeild: ISOFieldConstants.ISO_FIELD_54)
            if(!chEMVParVersion.isEmpty)
            {
                currentEMVParDwndInfo.chVersion = Array(chEMVParVersion[0 ..< 12])
                //System.arraycopy(chEMVParVersion,0,currentEMVParDwndInfo.chVersion,0,12);
                
                currentEMVParDwndInfo.currentpacketCount = Int(m_bCurrentPacketCount)
                currentEMVParDwndInfo.totalpacketCount = Int(m_bTotalPacketCount)
                ItemList.append(currentEMVParDwndInfo)

                debugPrint("Saving Download info !!")
                debugPrint("Version[\(String(bytes: currentEMVParDwndInfo.chVersion, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))]")
                
                debugPrint("CurrPkt[\(currentEMVParDwndInfo.currentpacketCount)]")
                debugPrint("TotPkt [\(currentEMVParDwndInfo.totalpacketCount)]")

                do{
                    _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.DWNLDCLESSPARINFO, with: ItemList)
                }
                catch
                {
                    fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.DWNLDCLESSPARINFO)")
                }
                
            }else{
                debugPrint("ERROR Cannot retrive cless version!!")
            }
        }else{
            debugPrint("WARNING Not Saving Download info !!")
        }

        //Save chunksize
        if(bitmap[45 - 1])
        {
            var chArrTempChunkSize = [Byte](repeating: 0x00, count: 12)
            chArrTempChunkSize = Array(data[45 - 1][0 ..< len[45 - 1]])
            
            // System.arraycopy(data[45-1],0,chArrTempChunkSize,0,len[45-1]);

            var ulChunkSize = Long()
            ulChunkSize.value = Int64(strtoul(String(bytes: chArrTempChunkSize, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines), nil, 10))
            
            var ItemList: [Long] = []
            ItemList.append(ulChunkSize)
            debugPrint("ulChunkSize[\(ulChunkSize.value)]");
            
            do{
                _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.DWNLDCLESSPARCHUNKINFO, with: ItemList)
            }
            catch
            {
                fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.DWNLDCLESSPARCHUNKINFO)")
            }
        }
        return 1;
    }

    //MARK:- SetEMVParDownLoadVersion()
    func SetEMVParDownLoadVersion()
    {
        if(FileSystem.IsFileExist(strFileName: FileNameConstants.DWNLDEMVPARINFO))
        {
            debugPrint("DWNLDEMVPARINFO file exist")
            var lastEMVParDwndInfo: CurrentEMVParDownloadingInfo
            let ItemList: [CurrentEMVParDownloadingInfo] = FileSystem.ReadFile(strFileName: FileNameConstants.DWNLDEMVPARINFO)!
            if(!ItemList.isEmpty) {
                lastEMVParDwndInfo = ItemList[0]
                //Get EMV PAR version
                
                m_chDownloadingEMVparVersion = [Byte](repeating: 0x00, count: 13)
                //Arrays.fill(m_chDownloadingEMVparVersion, (byte) 0x00);
                m_chDownloadingCLESSEMVparVersion = Array(lastEMVParDwndInfo.chVersion[0 ..< 12])
                //System.arraycopy(lastEMVParDwndInfo.chVersion, 0, m_chDownloadingEMVparVersion, 0, 12);
                
                m_bCurrentPacketCount = Int64(lastEMVParDwndInfo.currentpacketCount)
                m_bTotalPacketCount = Int64(lastEMVParDwndInfo.totalpacketCount)
                debugPrint("m_chDownloadingEMVparVersion[\(String(describing: String(bytes: m_chDownloadingEMVparVersion, encoding: .utf8)))], m_bCurrentPacketCount[\(m_bCurrentPacketCount)], m_bTotalPacketCount[\(m_bTotalPacketCount)]")
                _ = self.addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_54, data1: m_chDownloadingEMVparVersion, length: 12)
                debugPrint( "Req->Setting field 54")
            }
        }else{
            debugPrint("DWNLDEMVPARINFO  file doesnot exits")
        }

        if(FileSystem.IsFileExist(strFileName: FileNameConstants.DWNLDEMVPARCHUNKINFO))
        {
            var ulChunkSize = Long()
            let ItemList1: [Long] = FileSystem.ReadFile(strFileName: FileNameConstants.DWNLDEMVPARCHUNKINFO)!
            if(!ItemList1.isEmpty) {
                ulChunkSize = ItemList1[0]
            }

            var chArrTempChunkSize: String = String(ulChunkSize.value)
            chArrTempChunkSize = TransactionUtils.StrLeftPad(data: chArrTempChunkSize, length: 6 , padChar: "0");
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_45, data1: [Byte](chArrTempChunkSize.utf8), bcd: true)
            debugPrint("Req->Setting field 45");
        }else{
            debugPrint("DWNLDEMVPARCHUNKINFO doesnot exist");
        }
    }
    
    //For ContactLess
    //MARK:- SetCLESSEMVParDownLoadVersion()
    func SetCLESSEMVParDownLoadVersion()
    {
        //If fileexist
        if(FileSystem.IsFileExist(strFileName: FileNameConstants.DWNLDCLESSPARINFO))
        {
            //Get CLESS EMV PAR version
            debugPrint("DWNLDCLESSPARINFO file esxits");
            var lastEMVParDwndInfo = CurrentEMVParDownloadingInfo()
            var ItemList: [CurrentEMVParDownloadingInfo] = []
            
            ItemList  = FileSystem.ReadFile(strFileName: FileNameConstants.DWNLDCLESSPARINFO)!
            if(!ItemList.isEmpty)
            {
                lastEMVParDwndInfo = ItemList[0]
            }
            
            m_chDownloadingCLESSEMVparVersion = Array(lastEMVParDwndInfo.chVersion[0 ..< 12])
            //System.arraycopy(lastEMVParDwndInfo.chVersion,0,m_chDownloadingCLESSEMVparVersion,0,12);
            
            m_bCurrentPacketCount = Int64(lastEMVParDwndInfo.currentpacketCount)
            m_bTotalPacketCount   = Int64(lastEMVParDwndInfo.totalpacketCount)
            
            debugPrint("Earlier m_chDownloadingCLESSEMVparVersion[\(String(describing: String(bytes: m_chDownloadingCLESSEMVparVersion, encoding: .utf8)))]")
            debugPrint("Earlier m_chDownloadingCLESSEMVparVersion[\(String(describing: String(bytes: m_chDownloadingCLESSEMVparVersion, encoding: .utf8))) m_bCurrentPacketCount(\(m_bCurrentPacketCount)] m_bTotalPacketCount(\(m_bTotalPacketCount))")
            //debugPrint("m_chDownloadingCLESSEMVparVersion[%s], m_bCurrentPacketCount[%d], m_bTotalPacketCount[%d]",new String(m_chDownloadingCLESSEMVparVersion),m_bCurrentPacketCount,m_bTotalPacketCount);
            _ = self.addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_54, data1: m_chDownloadingCLESSEMVparVersion, length: 12)
            debugPrint("Req->Setting field 54")
        }else{
            debugPrint("DWNLDCLESSPARINFO  file doesnot exits");
        }

        if(FileSystem.IsFileExist(strFileName: FileNameConstants.DWNLDCLESSPARCHUNKINFO))
        {
            var ulChunkSize: Long?
            let ItemList1: [Long] = FileSystem.ReadFile(strFileName: FileNameConstants.DWNLDCLESSPARCHUNKINFO)!
            if(!ItemList1.isEmpty)
            {
                ulChunkSize = ItemList1[0]
            }
            
            debugPrint("Earlier ulChunkSize[\(ulChunkSize!.value)]")
            let chArrTempChunkSize: String = String(format: "%06d", ulChunkSize!.value)
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_45, data1: [Byte](chArrTempChunkSize.utf8), bcd: true)
            debugPrint("Req->Setting field 45");
        }else{
            debugPrint("DWNLDCLESSPARCHUNKINFO doesnot exist");
        }
    }
    
    /****************************************************************
     * ProcessPVMData
     ****************************************************************/
    //MARK:- ProcessPVMData() -> Bool
    func ProcessPVMData() -> Bool
    {
        debugPrint("Inside ProcessPVMData")
        let  p: [Byte] = data[61-1]
        let length: Int = len[61-1]

        //Check for Field 61 present or not
        if(length <= 0){
            debugPrint("Field 61 not present")
            return false
        }

        let pFieldPVMDef: [Byte] = data[53-1]
        let ilength: Int  = len[53-1]
        debugPrint("field 53 len[\(ilength)]")
    

        if(ilength >= 2){
            var offset: Int = 0;
            self.m_bCurrentPacketCount = Int64((pFieldPVMDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            debugPrint("this->m_bCurrentPacketCount1[\(self.m_bCurrentPacketCount)]")
            self.m_bCurrentPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1

            debugPrint("this->m_bCurrentPacketCount2[\(self.m_bCurrentPacketCount)]")

            self.m_bTotalPacketCount = Int64((pFieldPVMDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            debugPrint("this->m_bTotalPacketCount1[%d]",self.m_bTotalPacketCount)
            self.m_bTotalPacketCount |= Int64((pFieldPVMDef [offset]) & 0x000000FF)
            offset += 1
            debugPrint("this->m_bTotalPacketCount2[\(self.m_bTotalPacketCount)]")
            debugPrint("Response->Field 53 found")
        }

        if(self.m_bCurrentPacketCount == 0x01)
        {
            let tempData: [Long] = []
            debugPrint("**********PVM Data*********");
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TEMPVMFILE, with: p)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDPVMINFO, with: p)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDCHUNKINFO, with: tempData)
        }
        else{
            if(bitmap[44 - 1])
            {
                debugPrint("PVM NOT First packet");
                var _: CurrentDownloadingInfo
                var ulPVMVersion = Long()
                ulPVMVersion.value = 0x00
                if(1 == getPVMVersion(isoFeild: ISOFieldConstants.ISO_FIELD_44, ulPVMVersion: &ulPVMVersion))
                {
                    debugPrint("m_ulDownloadingPvmVersion[\(m_ulDownloadingPvmVersion)] ,ulPVMVersion[\(ulPVMVersion.value)]")

                    if(ulPVMVersion.value != m_ulDownloadingPvmVersion)
                    {
                        let tempData: [Long] = []
                        //stop PVM download
                        //clean data
                        _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TEMPVMFILE, with: p)
                        _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDPVMINFO, with: p)
                        _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDCHUNKINFO, with: tempData)
                        debugPrint("New PVM being downloaded");
                        return false;
                    }
                }else{
                    debugPrint("ERROR Cannot retrive PVM version!!");
                    return false
                }

            }else{
                debugPrint("Feild 44 not found !!")
                return false
            }
        }

        /***************************************************************************************
         * if(this->m_bCurrentPacketCount == this->m_bTotalPacketCount)
         * extract field 59 from 330 and save in our parameter file as PVM version.
         * for new request. As of now host might not be sending this ---- to check with host team
         *
         * We will check weather PVM file is present before renaming temp file to PVM file
         ****************************************************************************************/
        if(self.m_bCurrentPacketCount == self.m_bTotalPacketCount)
        {
            let  globalData = GlobalData.singleton
            //TODO:- State Machine Class needed
            //CStateMachine  Statemachine = CStateMachine.GetInstance();
            
            do{
                _ = try FileSystem.AppendFile(strFileName: FileNameConstants.TEMPVMFILE,with: p);
            }
            catch
            {
                fatalError("Error in AppendFile, strFileName: \(FileNameConstants.TEMPVMFILE)")
            }
            
            //FileSystem.AppendByteFile(m_cntx,AppConst.TEMPVMFILE,p,length);
            if(true == FileSystem.IsFileExist(strFileName: FileNameConstants.PVMFILE))
            {
                _ = FileSystem.DeleteFile(strFileName: FileNameConstants.PVMFILE, with: p);
                debugPrint("PVM file deleted");
            }
            _ = FileSystem.RenameFile(strNewFileName: FileNameConstants.PVMFILE,strFileName: FileNameConstants.TEMPVMFILE);
            debugPrint("PVM file created")

            //Store PVM version
            var ulPVMVersion = Long()
            ulPVMVersion.value = 0x00
            if(1 == getPVMVersion(isoFeild: ISOFieldConstants.ISO_FIELD_59,ulPVMVersion: &ulPVMVersion)){
                if(true == FileSystem.IsFileExist(strFileName: FileNameConstants.PVMFILE))
                {
                    if(globalData.m_sMasterParamData!.ulPvmVersion != ulPVMVersion.value)
                    {
                        //TODO:- State Machine Class needed
                        //Statemachine.m_ResetTerminal = true;
                    }
                }
                globalData.m_sMasterParamData!.ulPvmVersion = ulPVMVersion.value;
                _ = globalData.WriteMasterParamFile()
            }
        }
        else
        {
            do{
                _ = try FileSystem.AppendFile(strFileName: FileNameConstants.TEMPVMFILE,with: p);
            }
            catch
            {
                fatalError("Error in AppendFile, strFileName: \(FileNameConstants.TEMPVMFILE)")
            }
            
            //FileSystem.AppendByteFile(m_cntx,AppConst.TEMPVMFILE,p,length);
            _ = SavePVMDownloadInfoVersion()
        }
        return true;
    }
    
    
    //MARK:- ProcessMINIPVMIdDownload()
    func ProcessMINIPVMIdDownload()
    {
        
        debugPrint("Inside ProcessMINIPVMIdDownload")
        let p: [Byte] = data[61-1]
        var length: Int = len[61-1]
        
        var chArrTemp: [Byte] = []
        var iOffset: Int = 0x00

        //Check for Field 61 Value
        if(length <= 0){
            debugPrint("Field 61 not present")
            return
        }

        if(self.m_bCurrentPacketCount == 0x00){
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.ADDMINIPVMLIST)
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DELETEMINIPVMLIST)
        }
        
        while(length > 0){
            
            var temp = [Byte](repeating: 0x00, count: 4)
                  
            temp = Array(p[iOffset ..< iOffset + 4])
            //System.arraycopy(p,iOffset,temp,0,4);
            chArrTemp = TransactionUtils.bcd2a(temp, 4)!;
            iOffset += 4;

            debugPrint("MINIPVM ID from Host[\(String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))], Action[\((p[iOffset] == AppConstant.ACTION_ADD ? "ACTION_ADD" : p[iOffset] == AppConstant.ACTION_DELETE ? "ACTION_DELETE" : "Unknown ACtion"))]")
            debugPrint("Action[%0x0x]", p[iOffset])
            
            if(p[iOffset] == AppConstant.ACTION_ADD)
            {
                debugPrint("ADD ID[\(String(bytes: chArrTemp, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines))]")
                
                if(m_ulCountOfMINIPVMIdAdd < AppConstant.MAX_COUNT_MINIPVM){
                    m_ulArrMINIPVMIdAdd[Int(m_ulCountOfMINIPVMIdAdd)] = Int64(strtoul(String(bytes: chArrTemp, encoding: .utf8)!, nil, 10))

                    debugPrint("MINIPVM Id to Add[\(m_ulArrMINIPVMIdAdd[Int(m_ulCountOfMINIPVMIdAdd)])], Count[\(m_ulCountOfMINIPVMIdAdd)]")

                    /** Increment counts Charegeslip ids to be added to terminal **/
                    m_ulCountOfMINIPVMIdAdd += 1
                }else{
                    /** send log **/
                    var ulVal: DataLong = 0x00;
                    ulVal = DataLong(strtoul(String(bytes: chArrTemp, encoding: .utf8)!, nil, 10))
                          
                    debugPrint("MINIPVM Id to Add[\(ulVal)] FAILED")
                }
            }
            else {
                
                debugPrint("DELETE ID[\(String(bytes: chArrTemp, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines))]");
                
                /**************************************************************************
                 * write the action for delete skipped on PC but basically
                 * Create 2 list one for ADD and other for delete
                 * merge the 2 and create a final list.
                 * we will read the list one by one and send the request to host for this
                 * and download the chargeslip template and image in the same way.
                 **************************************************************************/
                
                debugPrint("m_ulCountOfMINIPVMIdDelete[\(m_ulCountOfMINIPVMIdDelete)]")
                
                if(m_ulCountOfMINIPVMIdDelete < AppConstant.MAX_COUNT_MINIPVM)
                {
                    m_ulArrMINIPVMIdDelete[Int(m_ulCountOfMINIPVMIdDelete)] = DataLong(strtoul(String(bytes: chArrTemp, encoding: .utf8)!, nil, 10))

                    /** Delete File and Append to deleted list **/
                    let chTemplateName: String = String(format: "ct%08d.plist", m_ulArrMINIPVMIdDelete[Int(m_ulCountOfMINIPVMIdDelete)])
                    let tempData: [Long] = []
                    _ = FileSystem.DeleteFile(strFileName: chTemplateName, with: tempData)

                    if(false == FileSystem.IsFileExist(strFileName: chTemplateName))
                    {
                        var temp1: [Long] = []
                        temp1[0].value = m_ulArrMINIPVMIdDelete[Int(m_ulCountOfMINIPVMIdDelete)]
                              
                        do{
                            _ = try FileSystem.AppendFile(strFileName: FileNameConstants.DELETECTLIST, with: temp1);
                        }
                        catch
                        {
                            fatalError("Error in AppendFile, strFileName: \(FileNameConstants.DELETECTLIST)")
                        }
                                  
                        debugPrint("MINIPVM Id Deleted[\(m_ulArrMINIPVMIdDelete[Int(m_ulCountOfMINIPVMIdDelete)])], Count[\(m_ulCountOfMINIPVMIdDelete)]");
                    }

                    /** Increment counts for CTid and CTidDelete **/
                    m_ulCountOfMINIPVMIdDelete += 1
                }
                else
                {
                          /** send log **/
                    var ulVal: DataLong = 0x00;
                    ulVal = DataLong(strtoul(String(bytes: chArrTemp, encoding: .utf8)!, nil, 10))
                    debugPrint("MINIPVM Id to Delete[\(ulVal)] FAILED");
                }
            }
            /**subtract 5 in each iteration,
            * 4 for each charge slip template Id one for actions ADD/DELETE.**/
            length -= 5;
            iOffset += 1
        }
       

        let pFieldPVMDef: [Byte] = data[53-1]
        let ilength: Int  = len[53-1]
        if(ilength >= 2){
            //moving packet count to 2 bytes
            var offset: Int = 0
            self.m_bCurrentPacketCount = Int64(pFieldPVMDef [offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64((pFieldPVMDef [offset]) & 0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = Int64(pFieldPVMDef[offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1

            debugPrint("Response field 53 in ProcessMiniPcmIdIdDownload Current Packet Count[\(m_bCurrentPacketCount)], Total Packet count[\(m_bTotalPacketCount)]")
        }
    }
    
    //MARK:- ProcessChargeSlipIdDownload()
    func ProcessChargeSlipIdDownload()
    {
        debugPrint("Inside ProcessChargeSlipIdDownload")
        let p: [Byte] = data[61-1]
        var length: Int = len[61-1]
        
        var chArrTemp: [Byte]
        var iOffset: Int = 0x00

        //Check for Field 61 Value
        if(length <= 0){
            debugPrint("Field 61 not present")
            return
        }

        if(self.m_bCurrentPacketCount == 0x00){
            let tempData: [Long] = []
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.ADDCTLIST, with: tempData)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DELETECTLIST, with: tempData)
        }

        while(length > 0){
            var temp = [Byte](repeating: 0x00, count: 4)
            
            temp = Array(p[iOffset ..< iOffset + 4])
            //System.arraycopy(p,iOffset,temp,0,4);
            chArrTemp = TransactionUtils.bcd2a(temp, 4)!
            iOffset += 4;

            debugPrint("IAMGE ID from Host[\(String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))], Action[\((p[iOffset] == AppConstant.ACTION_ADD ? "ACTION_ADD" : p[iOffset] == AppConstant.ACTION_DELETE ? "ACTION_DELETE" : "Unknown ACtion"))]")
            debugPrint("Action[%0x0x]", p[iOffset])
      
            if(p[iOffset] == AppConstant.ACTION_ADD)
            {
                if(m_ulCountOfChargeSlipIdAdd < AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES){
                    m_ulArrChargeSlipIdAdd[Int(m_ulCountOfChargeSlipIdAdd)] = Int64(strtoul(String(bytes: chArrTemp, encoding: .utf8)!, nil, 10))

                    debugPrint("ChargeSlip Id to Add[\(m_ulArrChargeSlipIdAdd[Int(m_ulCountOfChargeSlipIdAdd)])], Count[\(m_ulCountOfChargeSlipIdAdd)]");

                    /** Increment counts Charegeslip ids to be added to terminal **/
                    m_ulCountOfChargeSlipIdAdd += 1
                }else{
                    /** send log **/
                    var ulVal: DataLong = 0x00;
                    ulVal = DataLong(strtoul(String(bytes: chArrTemp, encoding: .utf8)!, nil, 10))
                    
                    debugPrint("ChargeSlip Id to Add[\(ulVal)] FAILED")
                }
            }
            else {
                /**************************************************************************
                 * write the action for delete skipped on PC but basically
                 * Create 2 list one for ADD and other for delete
                 * merge the 2 and create a final list.
                 * we will read the list one by one and send the request to host for this
                 * and download the chargeslip template and image in the same way.
                 **************************************************************************/
                debugPrint("DELETE[\(String(describing: String(bytes: chArrTemp, encoding: .utf8)))]")
                if(m_ulCountOfChargeSlipIdDelete < AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES)
                {
                    m_ulArrChargeSlipIdDelete[Int(m_ulCountOfChargeSlipIdDelete)] = DataLong(strtoul(String(bytes: chArrTemp, encoding: .utf8)!, nil, 10))

                    /** Delete File and Append to deleted list **/
                    let chTemplateName: String = String(format: "ct%08d", m_ulArrChargeSlipIdDelete[Int(m_ulCountOfChargeSlipIdDelete)])
                    let tempData: [Long] = []
                    _ = FileSystem.DeleteFile(strFileName: chTemplateName, with: tempData)

                    if(false == FileSystem.IsFileExist(strFileName: chTemplateName))
                    {
                        var temp1: [Long] = []
                        temp1[0].value = m_ulArrChargeSlipIdDelete[Int(m_ulCountOfChargeSlipIdDelete)]
                        
                        do{
                            _ = try FileSystem.AppendFile(strFileName: FileNameConstants.DELETECTLIST, with: temp1);
                        }
                        catch
                        {
                            fatalError("Error in AppendFile, strFileName: \(FileNameConstants.DELETECTLIST)")
                        }
                            
                        debugPrint("ChargeSlip Id Deleted[\(m_ulArrChargeSlipIdDelete[Int(m_ulCountOfChargeSlipIdDelete)])], Count[\(m_ulCountOfChargeSlipIdDelete)]");
                    }

                    /** Increment counts for CTid and CTidDelete **/
                    m_ulCountOfChargeSlipIdDelete += 1
                }
                else
                {
                    /** send log **/
                    var ulVal: DataLong = 0x00;
                    ulVal = DataLong(strtoul(String(bytes: chArrTemp, encoding: .utf8)!, nil, 10))
                    debugPrint("ChargeSlip Id to Delete[\(ulVal)] FAILED");
                }
            }
            /**subtract 5 in each iteration,
             * 4 for each charge slip template Id one for actions ADD/DELETE.**/
            length -= 5;
            iOffset += 1
        }

        let pFieldPVMDef: [Byte] = data[53-1];
        let ilength: Int  = len[53-1];
        if(ilength >= 2){
            //moving packet count to 2 bytes
            var offset: Int = 0
            self.m_bCurrentPacketCount = Int64(pFieldPVMDef [offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64((pFieldPVMDef [offset]) & 0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = Int64(pFieldPVMDef[offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1

            debugPrint("Response field 53 in ProcessChargeSlipIdDownload Current Packet Count[\(m_bCurrentPacketCount)], Total Packet count[\(m_bTotalPacketCount)]");
        }
    }

    //MARK:- ProcessChargeSlipDownload()
    func ProcessChargeSlipDownload()
    {
        debugPrint("Inside ProcessChargeSlipDownload")
        let p: [Byte] = data[61-1]
        let length: Int = len[61-1]

        //Check for Field 61 present or not
        if(length <= 0){
            debugPrint("Field 61 not present")
            return
        }

        let pFieldPVMDef: [Byte] = data[53-1]
        let ilength: Int  = len[53-1]
        if(ilength >= 2){
            //this->m_bCurrentPacketCount = *(pFieldPVMDef);
            //this->m_bTotalPacketCount = *(pFieldPVMDef+1);

            //Amitesh::moving packet count to 2 bytes
            var offset: Int = 0
            self.m_bCurrentPacketCount = Int64(pFieldPVMDef [offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64((pFieldPVMDef [offset]) & 0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = Int64(pFieldPVMDef[offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1
            debugPrint("Response->Field 53 found in ProcessChargeSlipDownload")
        }

        if(self.m_bCurrentPacketCount == 0x00){
            let tempData: [DataLong] = []
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TEMPCGFILE, with: tempData)
        }

        if(self.m_bCurrentPacketCount == self.m_bTotalPacketCount)
        {
            //12-07-2012 isomsg buffer is directly written to file
            do{
                _ = try FileSystem.AppendFile(strFileName: FileNameConstants.TEMPCGFILE, with: p)
            }
            catch{
                fatalError("Error in AppendFile, strFileName: \(FileNameConstants.TEMPCGFILE)")
            }
            //CFileSystem.AppendByteFile(m_cntx,AppConst.TEMPCGFILE,p,length);

            let chTemplateName: String = String(format: "ct%08d",m_ulArrChargeSlipIdAdd[Int(m_ulTotalChargeSlipTemplateAdded)])
            let tempData: [Long] = []
            _ = FileSystem.DeleteFile(strFileName: chTemplateName, with: tempData)
            
            if(true == FileSystem.RenameFile(strNewFileName: chTemplateName, strFileName: FileNameConstants.TEMPCGFILE))
            {
                /** Append to ADDED LIST File **/
                var temp: [Long] = []
                temp[0].value = m_ulArrChargeSlipIdAdd[Int(m_ulTotalChargeSlipTemplateAdded)]
                
                do{
                    _ = try FileSystem.AppendFile(strFileName: FileNameConstants.ADDCTLIST, with: temp);
                }
                catch
                {
                    fatalError("Error in AppendFile, strFileName: \(FileNameConstants.ADDCTLIST)")
                }
            }
        }
        else
        {
            //12-07-2012 isomsg buffer is directly written to file
            do{
                _ = try FileSystem.AppendFile(strFileName: FileNameConstants.TEMPCGFILE, with: p)
            }
            catch{
                fatalError("Error in AppendFile, strFileName: \(FileNameConstants.TEMPCGFILE)")
            }
            //CFileSystem.AppendByteFile(m_cntx,AppConst.TEMPCGFILE,p,length);
        }
    }
    
    //MARK:- ProcessFixedChargeSlipIdDownload()
    func ProcessFixedChargeSlipIdDownload()
    {
        debugPrint("Inside ProcessFixedChargeSlipIdDownload")

        let p: [Byte] = data[61-1]
        var length: Int = len[61-1]

        var chArrTemp: [Byte] = []
        var iOffset = 0x00

        //Check for Field 61 present or not
        if(length <= 0){
            debugPrint("Field 61 not present")
            return
        }

        if(self.m_bCurrentPacketCount == 0x00)
        {
            let tempData: [Long] = []
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.ADDFCTLIST, with: tempData)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DELETEFCTLIST, with: tempData)
        }
        

        while(length > 0){
            var temp = [Byte](repeating: 0x00, count: 4)
            temp = Array(p[iOffset ..< iOffset + 4])
            
            //System.arraycopy(p,iOffset,temp,0,4);
            chArrTemp = TransactionUtils.bcd2a(temp, 4)!;
            iOffset += 4;

            debugPrint("IAMGE ID from Host[\(String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))], Action[\((p[iOffset] == AppConstant.ACTION_ADD ? "ACTION_ADD" : p[iOffset]==AppConstant.ACTION_DELETE ? "ACTION_DELETE" : "Unknown ACtion"))]")
            debugPrint("Action[%0x0x]", p[iOffset])
            
      
            if(p[iOffset] == AppConstant.ACTION_ADD){
                debugPrint("ADD ID[\(String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))]");
                if(m_ulCountOfFixedChargeSlipIdAdd < AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES){
                    m_ulArrFixedChargeSlipIdAdd[m_ulCountOfFixedChargeSlipIdAdd] = Int64(strtoul(String(bytes: chArrTemp, encoding: .utf8), nil, 10))

                    /** Increment counts for Image id and Image id add **/
                    m_ulCountOfFixedChargeSlipIdAdd += 1

                }else{
                    let ulVal: DataLong = Int64(strtoul(String(bytes: chArrTemp, encoding: .utf8), nil, 10))
                      //  Long.parseLong(new String(chArrTemp));
                    let res = String(format: "chargeslip Id to Add[%d] FAILED", ulVal);
                    debugPrint(res)
                }
            }
            else {
                /**************************************************************************
                 * write the action for delete skipped on PC but basically
                 * Create 2 list one for ADD and other for delete
                 * merge the 2 and create a final list.
                 * we will read the list one by one and send the request to host for this
                 * and download the chargeslip template and image in the same way.
                 **************************************************************************/
                debugPrint("DELETE[\(String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))]")
                debugPrint("m_ulCountOfFixedChargeSlipIdDelete[\(m_ulCountOfFixedChargeSlipIdDelete)] ")
                
                if(m_ulCountOfFixedChargeSlipIdDelete < AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES){
                    m_ulArrFixedChargeSlipIdDelete[m_ulCountOfFixedChargeSlipIdDelete] = Int64(strtoul(String(bytes: chArrTemp, encoding: .utf8), nil, 10))
                        //Long.parseLong(new String(chArrTemp));

                    /** Delete File and Append to deleted list **/
                    let tempData: [Int64] = []
                    let chFileName: String = String(format: "im%08d",m_ulArrFixedChargeSlipIdDelete[m_ulCountOfFixedChargeSlipIdDelete]);
                    _ = FileSystem.DeleteFile(strFileName: chFileName, with: tempData)

                    var temp_obj: [Long] = []
                    temp_obj[0].value = m_ulArrFixedChargeSlipIdDelete[m_ulCountOfFixedChargeSlipIdDelete]
                    
                    do{
                        _ = try FileSystem.AppendFile(strFileName: FileNameConstants.DELETEFCTLIST, with: temp_obj)
                    }
                    catch
                    {
                        fatalError("Error in AppendFile, strFileName: \(FileNameConstants.DELETEFCTLIST)")
                    }
                    
                    _ = FileSystem.DeleteFile(strFileName: chFileName, with:  tempData)

                    /** Increment counts for Image id and Image id delete **/
                    m_ulCountOfFixedChargeSlipIdDelete += 1
                }else{
                    /** logs **/
                    let ulVal: DataLong = DataLong(strtoul(String(bytes: chArrTemp, encoding: .utf8), nil, 10))
                    let res: String = String(format: "FixedChargeSlip Id to Delete[%d] FAILED", ulVal)
                    debugPrint(res)
                }
            }
            /**subtract 5 in each iteration,
             * 4 for each charge slip template Id one for actions ADD/DELETE.**/
            length -= 5;
            iOffset += 1
        }

        let pFieldPVMDef: [Byte] = data[53-1]
        let ilength: Int  = len[53-1];
        if(ilength >= 2){
            var offset: Int = 0;
            self.m_bCurrentPacketCount = Int64((pFieldPVMDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = Int64((pFieldPVMDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1

            let res = String(format: "Resposne field 53 in ProcessFixedChargeSlipIdDownload Current Packet Count[%d], Total Packet count[%d]",m_bCurrentPacketCount,m_bTotalPacketCount)
            debugPrint(res)
        }
    }
    
    
    //MARK:- func ProcessFixedChargeSlipDownload() -> Bool
    func ProcessFixedChargeSlipDownload() -> Bool
    {
        debugPrint("Inside ProcessFixedChargeSlipDownload")
        
        let p: [Byte] = data[61-1]
        let length: Int = len[61-1]

        //Check for Field 61 present or not
        if(length <= 0){
            debugPrint("Field 61 not present")
            return false
        }

        let pFieldPVMDef: [Byte] = data[53-1]
        let ilength: Int  = len[53-1]
        
        if(ilength >= 2){
            var offset: Int = 0
            
            self.m_bCurrentPacketCount = Int64((pFieldPVMDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = Int64((pFieldPVMDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1
            debugPrint("Response->Field 53 found in ProcessImageDownload")
        }

        if(self.m_bCurrentPacketCount == 0x01){
            debugPrint("******fixed chargeslip download*********")
            let tempData: [Long] = []
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDCGFINFO, with: tempData)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TEMPFCGFILE, with: tempData)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDCHUNKINFO, with: tempData)
        }

        if(self.m_bCurrentPacketCount == self.m_bTotalPacketCount)
        {
            //12-07-2012 isomsg buffer is directly written to file
            do{
                _ = try FileSystem.AppendFile(strFileName: m_chTempFixedChargeSlipfileName, with: p)
            }
            catch
            {
                fatalError("Error in AppendFile, strFileName: \(m_chTempFixedChargeSlipfileName)")
            }
            
            //CFileSystem.AppendByteFile(m_chTempFixedChargeSlipfileName,p);
            let chFixedChargeSlipIdName: String = String(format: "ch%08d", m_ulArrFixedChargeSlipIdAdd[m_ulTotalFixedChargeSlipAdded])
            _ = FileSystem.DeleteFile(strFileName: chFixedChargeSlipIdName, with: p)

            if(true == FileSystem.RenameFile(strNewFileName: chFixedChargeSlipIdName,strFileName: m_chTempFixedChargeSlipfileName))
            {
                /** Append to ADDED LIST File **/
                var temp: [Long] = []
                temp[0].value = m_ulArrFixedChargeSlipIdAdd[m_ulTotalFixedChargeSlipAdded];
                
                do{
                    _ = try FileSystem.AppendFile(strFileName: FileNameConstants.ADDFCTLIST, with: temp)
                }
                catch
                {
                    fatalError("Error in AppendFile, strFileName: \(FileNameConstants.ADDFCTLIST)")
                }
            }
        }
        else
        {
            //12-07-2012 isomsg buffer is directly written to file
            do{
                _ = try FileSystem.AppendFile(strFileName: m_chTempFixedChargeSlipfileName, with: p)
            }
            catch
            {
                fatalError("Error in AppendFile, strFileName: \(m_chTempFixedChargeSlipfileName)")
            }
                      
            _ = SaveFixedChargeSlipDownloadInfoVersion(chargeslipId: m_ulArrFixedChargeSlipIdAdd[m_ulTotalFixedChargeSlipAdded])
        }

        return true;
    }
    
    //MARK:- SearchInCharListLIB(number: long, ItemList: [LIBStruct?], numberOfItems: Int) -> Int
    func SearchInCharListLIB(number: DataLong, ItemList: [LIBStruct?], numberOfItems: Int) -> Int
    {
        var searchedIndex: Int = 255;
        
        for i in 0 ..< numberOfItems
        {
            if(number == ItemList[i]!.id) {
                searchedIndex = i;
                break;
            }
        }
        
        return searchedIndex
    }
    
    //MARK:- SearchFileNamefromMasterList(id: long)
    func SearchFileNamefromMasterList(id: DataLong) -> String?
    {
        var LibFileName: String?
        debugPrint("Inside SearchFileNamefromMasterList");

        var ItemList: [LIBStruct?]
        
        if(true == FileSystem.IsFileExist(strFileName: FileNameConstants.MASTERLIBFILE))
        {
            ItemList = FileSystem.ReadFile(strFileName: FileNameConstants.MASTERLIBFILE)!
            if(ItemList.isEmpty) {
                let numberOfItems: Int = ItemList.count
                debugPrint("numberOfItems[\(numberOfItems)]");
                
                let searchedIndex: Int = SearchInCharListLIB(number: id, ItemList: ItemList, numberOfItems: numberOfItems)
                if (255 != searchedIndex) {
                    debugPrint("ItemList[searchedIndex].id[\(ItemList[searchedIndex]!.id)] filename[\(ItemList[searchedIndex]!.LibFileName)]");
                    LibFileName = ItemList[searchedIndex]!.LibFileName;
                }
            }
        }
        else {
            debugPrint(" MASTERLIBFILE doesnt exist")
        }

        return LibFileName
    }
    
    
    //MARK:- ProcessLibIdDownload()
    func ProcessLibIdDownload()
    {
        debugPrint("Inside ProcessLibIdDownload");
        let p: [Byte] = data[61-1]
        let length : Int = len[61-1]

        var iOffset: Int = 0x00
        var chArrTemp: [Byte] = []
        var action: Int = -1

        //Check for Field 61 present or not
        if(length <= 0){
            debugPrint("Field 61 not present")
            return
        }

        if(self.m_bCurrentPacketCount == 0x00)
        {
            let tempData: [LIBStruct] = []
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.ADDLIBLIST, with: tempData)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DELETELIBLIST, with: tempData)
        }

        while((length - iOffset) > 1){
            var libinfo = LIBStruct()
            action = Int(p[iOffset] & 0x00FF)
            iOffset += 1
            
            var temp = [Byte](repeating: 0x00, count: 4)
            
            temp = Array(p[iOffset ..< iOffset + 4])
            //System.arraycopy(p,iOffset,temp,0,4);
            chArrTemp = TransactionUtils.bcd2a(temp, 4)!
            iOffset += 4;

            //Action - ADD or DELETE
            debugPrint("Action[%d]",action);
            if(action == AppConstant.ACTION_ADD){
                //Library Id
                libinfo.id =  Int(strtoul(String(bytes: chArrTemp, encoding: .utf8), nil, 16))
                //Long.parseLong(new String(chArrTemp),16);

                //Length of tag
                let lenTag: Int = Int(p[iOffset] & 0x00FF)
                iOffset += 1
                
                //Lib File name
                var tempFileName = [Byte](repeating: 0x00, count: lenTag)
                tempFileName = Array(p[iOffset ..< iOffset + lenTag])
                
                //System.arraycopy(p,iOffset,tempFileName,0,lenTag);
                libinfo.LibFileName = String(bytes: tempFileName, encoding: .utf8)!
                iOffset += lenTag

                debugPrint("Lib[\(libinfo.id)], lenTag[\(lenTag)]");
                debugPrint("LIb filename[\(libinfo.LibFileName)]")

                if(m_ulCountOflibIdAdd < AppConstant.MAX_LIB_FILE){
                    m_ulArrlibIdAdd[m_ulCountOflibIdAdd] = LIBStruct()
                    m_ulArrlibIdAdd[m_ulCountOflibIdAdd]!.id = libinfo.id;
                    m_ulArrlibIdAdd[m_ulCountOflibIdAdd]!.LibFileName = libinfo.LibFileName;

                    /** Increment counts for Library id and Library id add **/
                    m_ulCountOflibIdAdd += 1
                }else{
                    /** send log **/
                    debugPrint("Lib Id to Add[%d] FAILED",m_ulCountOflibIdAdd);

                }
            }
            else if(action == AppConstant.ACTION_DELETE) {
                /**************************************************************************
                 * write the action for delete skipped on PC but basically
                 * Create 2 list one for ADD and other for delete
                 * merge the 2 and create a final list.
                 * we will read the list one by one and send the request to host for this
                 * and download the Library template and Library in the same way.
                 **************************************************************************/
                debugPrint("DELETE[\(String(bytes: chArrTemp, encoding: .utf8)!)]")
                debugPrint("m_ulCountOflibIdDelete[\(m_ulCountOflibIdDelete)] ")

                //Library Id
                libinfo.id = Int(strtoul(String(bytes: chArrTemp, encoding: .utf8), nil, 10))
                var _: String = SearchFileNamefromMasterList(id: DataLong(libinfo.id))!

                if(m_ulCountOflibIdDelete < AppConstant.MAX_LIB_FILE)
                {
                    
                    m_ulArrlibIdDelete[m_ulCountOflibIdDelete]!.id = libinfo.id
                    m_ulArrlibIdAdd[m_ulCountOflibIdDelete]!.LibFileName = libinfo.LibFileName
                    let tempData: [LIBStruct?] = [m_ulArrlibIdAdd[m_ulCountOflibIdDelete]]
                    
                    /** Delete File and Append to deleted list **/
                    _ = FileSystem.DeleteFileComplete(strFileName: libinfo.LibFileName)
                    
                    do{
                        _ = try FileSystem.AppendFile(strFileName: FileNameConstants.DELETELIBLIST, with: tempData)
                    }
                    catch
                    {
                        fatalError("Error in AppendFile, strFileName: \(FileNameConstants.DELETELIBLIST)")
                    }
                        
                    debugPrint("DELETE id[\(m_ulArrlibIdDelete[m_ulCountOflibIdDelete]!.id))], name[\(m_ulArrlibIdDelete[m_ulCountOflibIdDelete]!.LibFileName)]");

                    /** Increment counts for Library id and Library id delete **/
                    m_ulCountOflibIdDelete += 1

                }else{
                    /** logs **/
                    debugPrint("Lib Id to delete[\(m_ulCountOflibIdDelete)] FAILED");
                }
            }
        }

        let pFieldPVMDef: [Byte] = data[53-1];
        let ilength: Int = len[53-1];
        if(ilength >= 2){
            var offset: Int = 0;
            self.m_bCurrentPacketCount = Int64((pFieldPVMDef [offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64(((pFieldPVMDef [offset])) & 0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = Int64((pFieldPVMDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64(((pFieldPVMDef [offset])) & 0x000000FF)
            offset += 1

            debugPrint("Response field 53 in Lib download Current Packet Count[\(m_bCurrentPacketCount)], Total Packet count[\(m_bTotalPacketCount)]");
        }
    }
    
    //MARK:- ProcessLibDownload() -> Bool
    func ProcessLibDownload() -> Bool
    {
        debugPrint("Inside ProcessLibDownload");

        let p: [Byte] = data[61-1]
        let length: Int = len[61-1]

        //Check for Field 61 present or not
        if(length <= 0){
            debugPrint("Field 61 not present")
            return false
        }

        let pFieldPVMDef: [Byte] = data[53-1]
        let ilength: Int  = len[53-1]
        if(ilength >= 2){
            var offset: Int = 0
            self.m_bCurrentPacketCount = Int64((pFieldPVMDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = Int64(pFieldPVMDef [offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64((pFieldPVMDef [offset]) & 0x000000FF)
            offset += 1
            debugPrint("Response->Field 53 found in ProcessLibDownload")
        }

        if(self.m_bCurrentPacketCount == self.m_bTotalPacketCount)
        {
            do{
                _ = try FileSystem.AppendFile(strFileName: m_chTemplibfileName,with: p)
            }
            catch{
                fatalError("Error in AppendFile \(m_chTemplibfileName)")
            }
            //amitesh:Check SHA1 for Downloaded File
            var bFileisOK: Bool = false
            if(bitmap[62-1] && len[62-1] == 20)
            {
                debugPrint("bFileisOK bitmap[ISO_FIELD_62-1] ");
                var uchArrFileSha1Downloaded = [Byte](repeating: 0x00 , count: 20)

                uchArrFileSha1Downloaded = Array(data[62 - 1][0 ..< len[62 - 1]])
                //System.arraycopy(data[62-1],0,uchArrFileSha1Downloaded,0,len[62-1]);

                let uchArrFileSha1Calculated: [Byte] = FileSystem.GetSHA1ofFile(strFileName: m_chTemplibfileName)!
                
                if(!uchArrFileSha1Calculated.isEmpty && (uchArrFileSha1Downloaded == uchArrFileSha1Calculated))
                {
                    debugPrint("bFileisOK memcmp SHA1 OK");
                    bFileisOK = true
                }else{
                    debugPrint("chArrFileSha1Download[\(String(bytes: uchArrFileSha1Downloaded, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))], chArrFileSha1Calculated[\(String(bytes: uchArrFileSha1Downloaded, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))]")
                }
            }

            if(bFileisOK){
                //rename file as library name
                if(true == FileSystem.RenameFile(strNewFileName: m_ulArrlibIdAdd[m_ulTotallibAdded]!.LibFileName, strFileName: m_chTemplibfileName)){
                    
                    let tempData: [LIBStruct?] = [m_ulArrlibIdAdd[m_ulCountOflibIdDelete]]
                    /** Append to ADDED LIST File **/
                    do{
                        _ = try FileSystem.AppendFile(strFileName: FileNameConstants.ADDLIBLIST, with: tempData)
                    }
                    catch{
                        fatalError("Error in AppendFile, strFileName: \(FileNameConstants.ADDLIBLIST)")
                    }
                }
            }
            else {
                debugPrint("memcmp SHA1 Failed");
                let tempData: [LIBStruct?] = []
                _ = FileSystem.DeleteFile(strFileName: m_chTemplibfileName, with: tempData);
                return false;
            }
        }
        else
        {
            //12-07-2012 isomsg buffer is directly written to file
            do{
                _ = try FileSystem.AppendFile(strFileName: m_chTemplibfileName,with: p)
            }
            catch{
                fatalError("Error in AppendFile \(m_chTemplibfileName)")
            }

            _ = SaveLibDownloadInfoVersion(LibId: Int64(m_ulArrlibIdAdd[m_ulTotallibAdded]!.id));
        }

        return true;
    }
    
    //MARK:- Start()
    func Start()
    {
        debugPrint("Inside Start")
        if(CConx.isSerial())
        {
            m_iChangeNumber = ISO320ChangeNumberConstants.EDC_LIB_LIST_DOWNLOAD
        }
        else
        {
            m_iChangeNumber = ISO320ChangeNumberConstants.HOST_PVM_DOWNLOAD
        }

        m_iHostUploadPacketNumber = ISO320HostUploadChangeNum.SERIAL_UPLOAD_PACKET
        m_iPKExchangePacketNumber = ISO320PineKeyExchangeChangeNum.START_SESSION
        m_iResPKExchangePacket = 0x00;
        m_bCurrentPacketCount = 0x00;
        m_bTotalPacketCount = 0x00;
        m_temp_content_chunk = 0x00;

        
        m_uchMessage = [Byte](repeating: 0x00, count: AppConstant.MAX_MESSAGE_LEN + 1)
        m_imessageOffset = 0;
        
        m_ulArrChargeSlipIdAdd = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
        m_ulArrChargeSlipIdDelete = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
        m_ulArrImageIdAdd = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
        m_ulArrImageIdDelete = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
        m_ulArrColoredImageIdAdd = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
        m_ulArrColoredImageIdDelete = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) //
        
        m_ulArrMessageIdAdd = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_MESSAGES + 1) // MAX_COUNT_MESSAGES
        m_ulArrMessageIdDelete = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_MESSAGES + 1) // MAX_COUNT_MESSAGES

        m_ObjArrParameterData = [ParameterData?](repeating: nil, count: AppConstant.MAX_COUNT_PARAMETERS)
        
        m_ulCountOfChargeSlipIdAdd = 0x00
        m_ulCountOfChargeSlipIdDelete = 0x00
        m_ulTotalChargeSlipTemplateAdded = 0x00
        m_ulCountOfImageIdAdd = 0x00
        m_ulCountOfImageIdDelete = 0x00
        m_ulTotalImagesAdded = 0x00
        m_ulCountOfColoredImageIdAdd = 0x00
        m_ulCountOfColoredImageIdDelete = 0x00
        m_ulTotalColoredImagesAdded = 0x00

        // for dynamic charge slip Font
        m_ulCountOfFixedChargeSlipIdAdd = 0x00
        m_ulCountOfFixedChargeSlipIdDelete = 0x00
        m_ulTotalFixedChargeSlipAdded = 0x00

        // reset count for Library download
        m_ulCountOflibIdAdd = 0x00
        m_ulCountOflibIdDelete = 0x00
        m_ulTotallibAdded = 0x00
        m_ulCountOfMessageIdAdd = 0x00
        m_ulCountOfMessageIdDelete = 0x00
        m_ulTotalMessagesAdded = 0x00
        m_ulParameterIterator = 0x00
        m_ulLastParameterId = 0x00
        m_ulDownloadingPvmVersion = 0
        m_ulBinRangeIterator = 0x00
        // if temp file exist, delete it so that fresh download can occur.
        if (FileSystem.IsFileExist(strFileName: FileNameConstants.TEMPBINRANGEFILE)) {
            let tempData: [StBINRange] = []
            debugPrint("TEMPBINRANGEFILE exists");
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TEMPBINRANGEFILE, with: tempData);
        }
        m_ulCSVTxnMapIterator = 0x00;
        // if temp file exist, delete it so that fresh download can occur.
        if (FileSystem.IsFileExist(strFileName: FileNameConstants.TEMPCSVTXNMAPFILE)) {
            let tempData: [StCSVTxnMap] = []
            debugPrint("TEMPCSVTXNMAPFILE exists");
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TEMPCSVTXNMAPFILE, with: tempData);
        }
        
        // Transaction Bin
        m_ulTxnBinIterator = 0x00;
        // if temp file exist, delete it so that fresh download can occur.
        if (FileSystem.IsFileExist(strFileName: FileNameConstants.TEMPTXNBINFILE)) {
            let tempData: [StTxnBin] = []
            debugPrint("TEMPTXNBINFILE exists");
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TEMPTXNBINFILE, with: tempData)
        }
        m_ulTotalCSVTxnIgnAmtListIterator = 0x00;
        // if temp file exist, delete it so that fresh download can occur.
        if (FileSystem.IsFileExist(strFileName: FileNameConstants.TEMPCSVTXNIGNAMT)) {
            let tempData: [StCSVTxnIgnoreAmt] = []
            debugPrint("TEMPCSVTXNIGNAMT exists");
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TEMPCSVTXNIGNAMT, with: tempData)
        }
        
        m_chDownloadingEDCAppVersion = [Byte](repeating: 0x00, count: AppConstant.MAX_APP_VERSION_LEN + 1)// Parameter to store current
        // amitesh::for dynamic charge slip
        m_ulArrFixedChargeSlipIdAdd = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
        m_ulArrFixedChargeSlipIdDelete = [Int64](repeating: 0x00, count: AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) //

        // POS Printing Location
        m_ulTotalTxnwisePrintingLocationIterator = 0x00;
        // if temp file exist, delete it so that fresh download can occur.
        if (FileSystem.IsFileExist(strFileName: FileNameConstants.POSPRINTINGLOCATIONFILE)) {
            let tempData: [StPOSPrintinglocationDetails] = []
            debugPrint("POSPRINTINGLOCATIONFILE exists");
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.POSPRINTINGLOCATIONFILE, with: tempData);
        }

        m_ulTotalTxnwiseIsPasswordIterator = 0x00;

        m_ulArrlibIdAdd = [LIBStruct?](repeating: nil, count: AppConstant.MAX_LIB_FILE)
        m_ulArrlibIdDelete = [LIBStruct?](repeating: nil, count: AppConstant.MAX_LIB_FILE)
        
    }

    //MARK:- ProcessImageIdDownload()
    func ProcessImageIdDownload()
    {
        debugPrint("Inside ProcessImageIdDownload")
        let p: [Byte] = data[61-1]
        var length: Int = len[61-1]
        
        var iOffset = 0x00
        var chArrTemp: [Byte]

        //Check for Field 61 present or not
        if(length <= 0){
            debugPrint("Field 61 not present")
            return
        }

        if(self.m_bCurrentPacketCount == 0x00){
            let long_obj: [Long] = []
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.ADDIMLIST, with: long_obj);
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DELETEIMLIST, with: long_obj);
        }
        while(length > 0){
            var temp = [Byte](repeating: 0x00, count: 4)
            temp = Array(p[0 ..< 4])
            
            //System.arraycopy(p,iOffset,temp,0,4);
            chArrTemp = TransactionUtils.bcd2a(temp, 4)!
            iOffset += 4;

            debugPrint("IAMGE ID from Host[\(String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))], Action[\((p[iOffset] == AppConstant.ACTION_ADD ? "ACTION_ADD" : p[iOffset]==AppConstant.ACTION_DELETE ? "ACTION_DELETE" : "Unknown ACtion"))]")
            debugPrint("Action = p[iOffset]")
            if(p[iOffset] == AppConstant.ACTION_ADD){
                debugPrint(String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))
                if(m_ulCountOfImageIdAdd < AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES){
                    m_ulArrImageIdAdd[m_ulCountOfImageIdAdd] = Int64(String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))!

                    let csData: String = String(format: "Image Id to Add[\(m_ulArrImageIdAdd[m_ulCountOfImageIdAdd])], Count[\(m_ulCountOfImageIdAdd)]")
                    debugPrint(csData)

                    /** Increment counts for Image id and Image id add **/
                    m_ulCountOfColoredImageIdAdd += 1
                }else{
                    let ulVal: Int64 = Int64(String(bytes: chArrTemp, encoding: .utf8)!)!
                    let csData: String = String(format: "Image Id to Add[\(ulVal)] FAILED");
                    debugPrint(csData);
                }
            }
            else{

                debugPrint(String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines));
                /*************************************************************************
                * Write the action for delete skipped on PC but basically
                * Create 2 list one for ADD and other for delete
                * merge the 2 and create a final list.
                * we will read the list one by one and send the request to host for this
                * and download the charge slip template and image in the same way.
                ************************************************************************/

                debugPrint("m_ulCountOfImageIdDelete[\(m_ulCountOfImageIdDelete)]")
                if(m_ulCountOfImageIdDelete < AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES){
                    m_ulArrImageIdDelete[m_ulCountOfImageIdDelete] = Int64(String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))!

                    /** Delete File and Append to deleted list **/
                    let chFileName: String = String(format: "im%08d",m_ulArrImageIdDelete[m_ulCountOfImageIdDelete])

                    var long_obj: [Long] = []
                    _ = FileSystem.DeleteFile(strFileName: chFileName, with: long_obj)
                    long_obj[0].value = m_ulArrImageIdDelete[m_ulCountOfImageIdDelete];
                    do{
                        _ = try FileSystem.AppendFile(strFileName: FileNameConstants.DELETEIMLIST, with: long_obj);
                    }
                    catch{
                        fatalError("Error in AppendFile \(FileNameConstants.DELETEIMLIST)")
                    }
                            
                    let csData: String = String(format: "ImageIdDeleted[\(m_ulArrImageIdDelete[m_ulCountOfImageIdDelete])],Coun[\(m_ulCountOfImageIdDelete)]")
                    debugPrint(csData)
                    /** Increment counts for Image id and Image id delete **/
                    m_ulCountOfImageIdDelete += 1

                    }else{
                        let csData: String = String(format: "Image Id to Delete[\(Int64(String(bytes: chArrTemp, encoding: .utf8)!)!)]FAILED")
                        debugPrint(csData)
                    }
                }
                    /**subtract 5 in each iteration, 4 for each charge slip template Id and 1 for actions ADD/DELETE.**/
                length -= 5;
                iOffset += 1
            }

            let pFieldPVMDef: [Byte] = data[53-1]
            let ilength: Int = len[53-1]
            if(ilength >= 2){
                var offset: Int = 0
                self.m_bCurrentPacketCount = Int64(pFieldPVMDef[offset] << 8) & Int64(0x0000FF00)
                offset += 1
                self.m_bCurrentPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
                offset += 1
                self.m_bTotalPacketCount = Int64(pFieldPVMDef[offset] << 8) & Int64(0x0000FF00)
                offset += 1
                self.m_bTotalPacketCount |= Int64(pFieldPVMDef[offset] & 0x000000FF)
                offset += 1
                let csData: String = String(format: "Resposne field 53 in ProcessImageIdDownload Current PacketCount[\(m_bCurrentPacketCount)], Total Packet count[\(m_bTotalPacketCount)]")
                debugPrint(csData)
            }
    }

    //MARK:- ProcessImageDownload() -> Bool
    func ProcessImageDownload() -> Bool
    {
        debugPrint("Inside ProcessImageDownload")
        let p: [Byte] = data[61-1]
        let length: Int = len[61-1]

        //Check for Field 61 present or not
        if(length <= 0){
            debugPrint("Field 61 not present")
            return false
        }

        let pFieldPVMDef: [Byte] = data[53-1]
        let ilength: Int  = len[53-1]
        if(ilength >= 2){
            var offset: Int = 0
            self.m_bCurrentPacketCount = Int64((pFieldPVMDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = Int64((pFieldPVMDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1
            debugPrint("Response->Field 53 found in ProcessImageDownload");
        }

        let tempData: [Int64] = []
        if(self.m_bCurrentPacketCount == 0x01){
            debugPrint("******Image download*********");
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDCHUNKINFO, with: tempData);
        }

        if(self.m_bCurrentPacketCount == self.m_bTotalPacketCount)
        {
            //12-07-2012 isomsg buffer is directly written to file
            do{
                _ = try FileSystem.AppendFile(strFileName: m_chTempImagefileName,with: p)
            }
            catch
            {
                fatalError("Error in AppendFile, strFileName: \(m_chTempImagefileName)")
            }
            
            //CFileSystem.AppendByteFile(m_cntx,m_chTempImagefileName,p,length);
            let chImageIdName: String = String(format: "im%08d",m_ulArrImageIdAdd[m_ulTotalImagesAdded])
            _ = FileSystem.DeleteFile(strFileName: chImageIdName, with: p);

            if(true == FileSystem.RenameFile(strNewFileName: chImageIdName,strFileName: m_chTempImagefileName))
            {
                /** Append to ADDED LIST File **/
                var long_obj: [Long] = []
                long_obj[0].value = m_ulArrImageIdAdd[m_ulTotalImagesAdded]
                do{
                    _ = try FileSystem.AppendFile(strFileName: FileNameConstants.ADDIMLIST,with: long_obj)
                }
                catch
                {
                    fatalError("Error in AppendFile, strFileName: \(FileNameConstants.ADDIMLIST)")
                }
            }
        }
        else
        {
            //12-07-2012 isomsg buffer is directly written to file
            do{
                _ = try FileSystem.AppendFile(strFileName: m_chTempImagefileName,with: p)
            }
            catch
            {
                fatalError("Error in AppendFile, strFileName: \(m_chTempImagefileName)")
            }
            //CFileSystem.AppendByteFile(m_cntx,m_chTempImagefileName,p,length);
            _ = SaveImageDownloadInfoVersion(imageId: m_ulArrImageIdAdd[m_ulTotalImagesAdded]);
        }

        return true;
    }
    
    
    //MARK:- ProcessColoredImageIdDownload()
    func ProcessColoredImageIdDownload()
    {
        debugPrint("Inside ProcessColoredImageIdDownload")
        let p: [Byte] = data[61-1]
        var length: Int = len[61-1]
        
        var iOffset = 0x00
        var chArrTemp: [Byte]

        //Check for Field 61 present or not
        if(length <= 0){
            debugPrint("Field 61 not present")
            return
        }

        if(self.m_bCurrentPacketCount == 0x00){
            let long_obj: [Long] = []
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.ADDCLRDIMLIST, with: long_obj);
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DELETECLRDIMLIST, with: long_obj);
        }
        while(length > 0){
            var temp = [Byte](repeating: 0x00, count: 4)
            temp = Array(p[0 ..< 4])
            
            //System.arraycopy(p,iOffset,temp,0,4);
            chArrTemp = TransactionUtils.bcd2a(temp, 4)!
            iOffset += 4

            debugPrint("IAMGE ID from Host[\(String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))], Action[\((p[iOffset] == AppConstant.ACTION_ADD ? "ACTION_ADD" : p[iOffset]==AppConstant.ACTION_DELETE ? "ACTION_DELETE" : "Unknown ACtion"))]")
            debugPrint("Action = p[iOffset]")
            if(p[iOffset] == AppConstant.ACTION_ADD){
                debugPrint(String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))
                if(m_ulCountOfColoredImageIdAdd < AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES){
                    m_ulArrColoredImageIdAdd[m_ulCountOfColoredImageIdAdd] = Int64(String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))!

                    let csData: String = String(format: "Image Id to Add[\(m_ulArrColoredImageIdAdd[m_ulCountOfColoredImageIdAdd])], Count[\(m_ulCountOfColoredImageIdAdd)]")
                    debugPrint(csData)

                    /** Increment counts for Image id and Image id add **/
                    m_ulCountOfColoredImageIdAdd += 1
                }else{
                    let ulVal: Int64 = Int64(String(bytes: chArrTemp, encoding: .utf8)!)!
                    let csData: String = String(format: "Image Id to Add[\(ulVal)] FAILED");
                    debugPrint(csData);
                }
            }
            else{

                debugPrint(String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines));
                /*************************************************************************
                 * Write the action for delete skipped on PC but basically
                 * Create 2 list one for ADD and other for delete
                 * merge the 2 and create a final list.
                 * we will read the list one by one and send the request to host for this
                 * and download the charge slip template and image in the same way.
                 ************************************************************************/

                debugPrint("m_ulCountOfImageIdDelete[\(m_ulCountOfColoredImageIdDelete)]")
                if(m_ulCountOfColoredImageIdDelete < AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES){
                    m_ulArrColoredImageIdDelete[m_ulCountOfColoredImageIdDelete] = Int64(String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))!

                    /** Delete File and Append to deleted list **/
                    let chFileName: String = String(format: "im%08d",m_ulArrColoredImageIdDelete[m_ulCountOfColoredImageIdDelete])

                    var long_obj: [Long] = []
                    _ = FileSystem.DeleteFile(strFileName: chFileName, with: long_obj)
                    long_obj[0].value = m_ulArrColoredImageIdDelete[m_ulCountOfColoredImageIdDelete];
                    do{
                        _ = try FileSystem.AppendFile(strFileName: FileNameConstants.DELETECLRDIMLIST, with: long_obj);
                    }
                    catch{
                        fatalError("Error in AppendFile \(FileNameConstants.DELETECLRDIMLIST)")
                    }
                    
                    let csData: String = String(format: "Image Id Deleted[\(m_ulArrColoredImageIdDelete[m_ulCountOfColoredImageIdDelete])], Count[\(m_ulCountOfColoredImageIdDelete)]")
                    debugPrint(csData)

                    /** Increment counts for Image id and Image id delete **/
                    m_ulCountOfColoredImageIdDelete += 1

                }else{
                    let csData: String = String(format: "Image Id to Delete[\(Int64(String(bytes: chArrTemp, encoding: .utf8)!)!)] FAILED")
                    debugPrint(csData)
                }
            }
            /**subtract 5 in each iteration, 4 for each charge slip template Id and 1 for actions ADD/DELETE.**/
            length -= 5;
            iOffset += 1
        }

        let pFieldPVMDef: [Byte] = data[53-1]
        let ilength: Int = len[53-1]
        if(ilength >= 2){
            var offset: Int = 0
            self.m_bCurrentPacketCount = Int64(pFieldPVMDef[offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = Int64(pFieldPVMDef[offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64(pFieldPVMDef[offset] & 0x000000FF)
            offset += 1

            let csData: String = String(format: "Resposne field 53 in ProcessColoredImageIdDownload Current Packet Count[\(m_bCurrentPacketCount)], Total Packet count[\(m_bTotalPacketCount)]")
            debugPrint(csData)
        }
    }

    //MARK:- ProcessColoredImageDownload() -> Bool
    func ProcessColoredImageDownload() -> Bool
    {
        debugPrint("Inside ProcessColoredImageDownload")
        
        let p: [Byte] = data[61-1];
        let length: Int = len[61-1];

        //Check for Field 61 present or not
        if(length <= 0){
            debugPrint("Field 61 not present")
            return false
        }

        let pFieldPVMDef: [Byte] = data[53-1]
        let ilength: Int  = len[53-1]
        
        if(ilength >= 2){
            var offset: Int = 0
            self.m_bCurrentPacketCount = Int64((pFieldPVMDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = Int64((pFieldPVMDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1
            debugPrint("Response->Field 53 found in ProcessImageDownload")
        }

        let tempData: [Int64] = []
        if(self.m_bCurrentPacketCount == 0x01){
            debugPrint("******Colored Image download*********");
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDCHUNKINFO, with: tempData)
        }

        if(self.m_bCurrentPacketCount == self.m_bTotalPacketCount)
        {
            //12-07-2012 isomsg buffer is directly written to file
            //FileSystem.AppendByteFile(m_chTempClrdImagefileName,p,length);
            
            do{
                _ = try FileSystem.AppendFile(strFileName: m_chTempClrdImagefileName,with: p)
            }
            catch{
                fatalError("Error in AppendFile, strFileName: \(m_chTempClrdImagefileName)")
            }
            
            let chImageIdName: String = String(format: "im_clrd%08d",m_ulArrColoredImageIdAdd[m_ulTotalColoredImagesAdded])
 
            _ = FileSystem.DeleteFile(strFileName: chImageIdName, with: p)

            if( true == FileSystem.RenameFile(strNewFileName: chImageIdName,strFileName: m_chTempClrdImagefileName))
            {
                /** Append to ADDED LIST File **/
                var long_obj: [Long] = []
                long_obj[0].value = m_ulArrColoredImageIdAdd[m_ulTotalColoredImagesAdded]
                
                do{
                    _ = try FileSystem.AppendFile(strFileName: FileNameConstants.ADDCLRDIMLIST,with: long_obj)
                }
                catch{
                    fatalError("Error in AppendFile, strFileName: \(FileNameConstants.ADDCLRDIMLIST)")
                }
            }
        }
        else
        {
            //12-07-2012 isomsg buffer is directly written to file
            //FileSystem.AppendByteFile(m_chTempClrdImagefileName,p);
            do{
                _ = try FileSystem.AppendFile(strFileName: m_chTempClrdImagefileName,with: p)
            }
            catch{
                fatalError("Error in AppendFile, strFileName: \(m_chTempClrdImagefileName)")
            }
            
            _ = SaveColoredImageDownloadInfoVersion(imageId: m_ulArrColoredImageIdAdd[m_ulTotalColoredImagesAdded])
        }

        return true;
    }
    
    
    /****************************************************************
     * ProcessBatchId The Batch Id to use will be come in this packet
     * We will store the Batch Id in Global Data
     ****************************************************************/
    //MARK:- ProcessBatchId()
    func ProcessBatchId()
    {
        debugPrint("ProcessBatchId");

        //Check for Field 26 present or not
        if((!bitmap[26 - 1]) || (len[26 - 1] <= 0)){
            debugPrint("Field 26 not present")
            return
        }

        var chArrTempBatch = [Byte](repeating: 0x00, count: len[26 - 1])
        chArrTempBatch = Array(data[26 - 1][0 ..< len[26 - 1]])
        
        //System.arraycopy(data[26-1],0,chArrTempBatch,0,len[26-1]);
        let ulBatchID: Int8 = Int8(String(bytes: chArrTempBatch, encoding: .utf8)!)!

        //store this as the current batch id in Global Data
        let  globalData = GlobalData.singleton
        var m_sParamData: TerminalParamData  = globalData.ReadParamFile()!
        m_sParamData.iCurrentBatchId = Int(ulBatchID)
        debugPrint("ulBatchID[\(ulBatchID)]")
        _ = globalData.WriteParamFile(listParamData: m_sParamData)
    }
    
    //MARK:- ProcessClockSynchronization()
    func ProcessClockSynchronization()
    {
        debugPrint("Inside ProcessClockSynchronization");

        //Check for Field 12 present or not
        if((!bitmap[12 - 1]) || (len[12 - 1] <= 0)){
            debugPrint("Field 12 not present");
            return
        }

        var chArrTempDateTime = [Byte](repeating: 0x00, count: 13)
        
        chArrTempDateTime = Array(data[12 - 1][0 ..< len[12 - 1]])
        //System.arraycopy(data[12-1],0,chArrTempDateTime,0,len[12-1]);
        
        //set the local clock date time by the value in chArrTempDateTime
        TransactionUtils.SetCurrentDateTime(buff: chArrTempDateTime)
    }
        
    //MARK:- ProcessMessageIdDownload()
    func ProcessMessageIdDownload(){
        debugPrint("Inside ProcessMessageIdDownload");

        if(!bitmap[61 - 1]){
            return;
        }

        let p: [Byte] = data[61-1];
        var length: Int = len[61-1];
        var chArrTemp: [Byte] = []
        var iOffset: Int = 0x00;

        if(self.m_bCurrentPacketCount == 0x00){
            let messageId: [StructMESSAGEID] = []
            
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.ADDMSGLIST, with: messageId)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DELETEMSGLIST, with: messageId)
        }

        while(length > 0){
            let temp = [Byte](repeating: 0x00, count: 4)
            chArrTemp = TransactionUtils.bcd2a(temp, 4)!
            iOffset += 4

                if(p[iOffset] == AppConstant.ACTION_ADD){
                    debugPrint("ADD MessageID[\(String(describing: String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)))]")
                    if(m_ulCountOfMessageIdAdd < AppConstant.MAX_COUNT_MESSAGES)
                    {
                        m_ulArrMessageIdAdd[m_ulCountOfMessageIdAdd] = DataLong(String(describing: String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)))!
                        
                        debugPrint("Message Id to Add[\(m_ulArrMessageIdAdd[m_ulCountOfMessageIdAdd])], Count[\(m_ulCountOfMessageIdAdd)]");
                        m_ulCountOfMessageIdAdd += 1
                    }else
                    {
                        let ulVal: DataLong = DataLong(String(describing: String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)))!
                        debugPrint("Message Id to Add[\(ulVal)] FAILED")
                    }
                }else{
                   debugPrint("DELETE MessageID[\(String(describing: String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)))]")
                    
                    /*************************************************************************
                     * Write the action for delete skipped on PC but basically
                     * Create 2 list one for ADD and other for delete
                     * merge the 2 and create a final list.
                     * we will read the list one by one and send the request to host for this
                     * and download the charge slip template and image in the same way.
                     ************************************************************************/

                    debugPrint("m_ulCountOfMessageIdDelete[\(m_ulCountOfMessageIdDelete)]")
                    if(m_ulCountOfMessageIdDelete < AppConstant.MAX_COUNT_MESSAGES)
                    {
                        m_ulArrMessageIdDelete[m_ulCountOfMessageIdDelete] = DataLong(String(describing: String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)))!

                        var longobj: [Long] = []
                        longobj[0].value = m_ulArrMessageIdDelete[m_ulCountOfMessageIdDelete];
                        do{
                            _ = try FileSystem.AppendFile(strFileName: FileNameConstants.DELETEMSGLIST, with: longobj);
                        }
                        catch
                        {
                            debugPrint("Error in AppendFile, strFileName: \(FileNameConstants.DELETEMSGLIST)")
                        }
                        
                        let csData: String = String(format: "Message Id Deleted[%d], Count[%d]",m_ulArrMessageIdDelete[m_ulCountOfMessageIdDelete],m_ulCountOfMessageIdDelete)
                        debugPrint(csData)

                        /** Increment counts for Image id and Image id delete **/
                        m_ulCountOfMessageIdDelete += 1
                    }
                    else
                    {
                        let ulVal: Int = Int(DataLong(String(describing: String(bytes: chArrTemp, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)))!)
                        let csData: String = String(format: "Message Id to Delete[%d] FAILED", ulVal)
                        debugPrint(csData)
                    }
                }
                iOffset += 1
                length -= 5 //subtract 5 in each iteration, 4 for each charge slip template Id and one for actions ADD/DELETE.
            }


        let pFieldPVMDef: [Byte] = data[53-1];
        let ilength: Int = len[53-1]
        if(ilength >= 2){
            var offset: Int = 0
            self.m_bCurrentPacketCount = Int64(pFieldPVMDef[offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1
            self.m_bTotalPacketCount = Int64(pFieldPVMDef[offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64(pFieldPVMDef[offset] & 0x000000FF)
            offset += 1
            
            debugPrint("Resposne field 53 in ProcessMessageDownload Current Packet Count[\(m_bCurrentPacketCount)], TotalPacket count[\(m_bTotalPacketCount)]")
        }
    }

    
    //MARK: - ProcessMessageDownload()
    func ProcessMessageDownload()
    {
        debugPrint("Inside ProcessMessageDownload")
        //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"Inside ProcessMessageDownload");
        if(!bitmap[61 - 1]){
            debugPrint("ERROR No Field 61")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"ERROR No Feild 61 !!");
            return;
        }
        let p: [Byte] = data[61-1]
        let length: Int = len[61-1]
        let pFieldPVMDef: [Byte] = data[53-1]
        let ilength: Int  = len[53-1]
        
        if(ilength >= 2)
        {
            var offset: Int = 0
            self.m_bCurrentPacketCount = Int64((pFieldPVMDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64(((pFieldPVMDef[offset])) & 0x000000FF)
            offset += 1
            self.m_bTotalPacketCount = Int64((pFieldPVMDef[offset]) << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1
            debugPrint("Response->Field 53 found in ProcessMessageDownload")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"Response->Field 53 found in ProcessMessageDownload");
        }
        
        if(self.m_bCurrentPacketCount == self.m_bTotalPacketCount)
        {
            m_uchMessage[m_imessageOffset ..< m_imessageOffset + length] = ArraySlice<Byte>(p[0 ..< length])
            //System.arraycopy(p,0,m_uchMessage,m_imessageOffset,length);
            m_imessageOffset+=length;
            if(m_imessageOffset <= AppConstant.MAX_MESSAGE_LEN)
            {
                var messageId: [StructMESSAGEID] = []
                messageId[0].lmessageId = m_ulArrMessageIdAdd[m_ulTotalMessagesAdded]
                
                debugPrint("ADD MessageID[\(messageId[0].lmessageId)], Message[\((String(bytes: m_uchMessage, encoding: String.Encoding.utf8)?.trimmingCharacters(in: .whitespacesAndNewlines))!)], len[\(m_uchMessage.count)]")
                //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"ADD Messageid[%d], Message[%s], len[%d] ",messageId.lmessageId,newString(m_uchMessage).trim(),m_uchMessage.length);
                
                let bArrMessage: [Byte] = Array(m_uchMessage[0 ..< m_imessageOffset])
                messageId[0].strArrMessage = String(bytes: bArrMessage, encoding: String.Encoding.utf8)!
                
                //System.arraycopy(m_uchMessage,0,messageId.strArrMessage.getBytes(),0,m_imessageOffset);
                
                debugPrint("ADD MessageID[\(messageId[0].lmessageId)], Message[\(messageId[0].strArrMessage)] len[\(messageId[0].strArrMessage.count)]")
                //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"ADD Messageid[%d], Message[%s],len[%d]",messageId.lmessageId,messageId.strArrMessage,messageId.strArrMessage.length());
                
                do{
                    _ = try FileSystem.AppendFile(strFileName: FileNameConstants.ADDMSGLIST,with: messageId)
                }
                catch
                {
                    fatalError("AppendFile : \(FileNameConstants.ADDMSGLIST)")
                }
            }
            else
            {
                debugPrint("Message ID[\(m_ulArrMessageIdAdd[m_ulCountOfMessageIdAdd])]")
                //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"Message Id[%d] EXCEEDLength",m_ulArrMessageIdAdd[m_ulCountOfMessageIdAdd]);
            }
        }
        else
        {
            m_uchMessage[m_imessageOffset ..< m_imessageOffset + length] = ArraySlice<Byte>(p[0 ..< length])
            //System.arraycopy(p,0,m_uchMessage,m_imessageOffset,length);
            m_imessageOffset+=length;
        }
    }

    
    //MARK:- ProcessParameterDownload()
    func ProcessParameterDownload()
    {
        debugPrint("Inside ProcessParameterDownload");
        if(!bitmap[61 - 1]){
            debugPrint("ERROR No Field 61 !!");
            return;
        }

        let p: [Byte] = data[61-1]
        var length: Int = len[61-1]
        var iOffset: Int = 0

        while(length > 0)
        {
            if(m_ulParameterIterator >= AppConstant.MAX_COUNT_PARAMETERS){
                break;
            }
            
            let iOldOffset: Int = iOffset

            var iParameterId: Int = 0x00;
            var iParameterValLen: Int = 0x00;

            //2 byte parameter id, 1 byte length , X ASCII chars data

            iParameterId = Int(p[iOffset] & 0x000000FF)
            iOffset += 1
            iParameterId <<= 8;
            iParameterId |=  Int(p[iOffset] & 0x000000FF)
            iOffset += 1

            iParameterValLen = Int(p[iOffset])
            iOffset += 1
            
            m_ObjArrParameterData[m_ulParameterIterator]!.chArrParameterVal = Array(p[iOffset ..< iOffset + iParameterValLen])
            //System.arraycopy(p,iOffset,m_ObjArrParameterData[m_ulParameterIterator].chArrParameterVal,0,iParameterValLen);
 
            m_ObjArrParameterData[m_ulParameterIterator]!.ulParameterId = iParameterId
            m_ObjArrParameterData[m_ulParameterIterator]!.ulParameterLen = iParameterValLen
            debugPrint("ID[\(m_ObjArrParameterData[m_ulParameterIterator]!.ulParameterId)]")
            debugPrint("LEN[\(m_ObjArrParameterData[m_ulParameterIterator]!.ulParameterLen)]")
            debugPrint("VALUE[\(TransactionUtils.byteArray2HexString(arr: m_ObjArrParameterData[m_ulParameterIterator]!.chArrParameterVal))]")
            m_ulParameterIterator += 1

            iOffset += iParameterValLen
            length -= (iOffset - iOldOffset)
            m_ulLastParameterId = Int64(iParameterId)
        }
    }
    
    //MARK:- ProcessParameterDownloadDateTime()
    func ProcessParameterDownloadDateTime()
    {
        debugPrint("Inside ProcessParameterDownloadDateTime")

        if(!bitmap[43-1])
        {
            debugPrint("ERROR No Field 43 !!")
            return
        }

        var m_sParamData = TerminalParamData()
        let chFileName: String = String(format: "%s",FileNameConstants.TERMINALPARAMFILENAME)
        debugPrint("param file name[\(chFileName)]");
        let list_ofItem: [TerminalParamData] = FileSystem.ReadFile(strFileName: chFileName)!
        if(!list_ofItem.isEmpty)
        {
            m_sParamData = list_ofItem[0]
        }

        m_sParamData.m_strParamDownloadDate = String(bytes: data[43 - 1], encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do{
            _ = try FileSystem.ReWriteFile(strFileName: chFileName, with: list_ofItem)
        }
        catch{
            fatalError("Error in ReWriteFile, strFileName: \(chFileName)")
        }
        debugPrint("m_sParamDownloadDate[\(m_sParamData.m_strParamDownloadDate)]")
    }
    
    //MARK:- SetPVMDownLoadVersion()
    func SetPVMDownLoadVersion()
    {
        //If fileexist
        if(FileSystem.IsFileExist(strFileName: FileNameConstants.DWNLDPVMINFO))
         {
            debugPrint("DWNLDPVMINFO file esxits")
            var lastPVMDwndInfo = CurrentDownloadingInfo()
            
            let list_of_Items: [CurrentDownloadingInfo] = FileSystem.ReadFile(strFileName: FileNameConstants.DWNLDPVMINFO)!
            if(!list_of_Items.isEmpty)
             {
                lastPVMDwndInfo = list_of_Items[0]
             }
             //Get PVM version
             m_ulDownloadingCACRTVersion = lastPVMDwndInfo.id;
            m_bCurrentPacketCount = Int64(lastPVMDwndInfo.currentpacketCount);
            m_bTotalPacketCount   = Int64(lastPVMDwndInfo.totalpacketCount);
            debugPrint("m_ulDownloadingPvmVersion[\(m_ulDownloadingPvmVersion)], m_bCurrentPacketCount[\(m_bCurrentPacketCount)], m_bTotalPacketCount[\(m_bTotalPacketCount)]");

            debugPrint("Earlier m_ulDownloadingPvmVersion[\(m_ulDownloadingPvmVersion)]")
            var newbuffer: String = String(format: "%d",m_ulDownloadingPvmVersion)
            newbuffer = TransactionUtils.StrRightPad(data: newbuffer, length: 6, padChar: " ")
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_44, data1: [Byte](newbuffer.utf8), bcd: false)
            debugPrint("Req->Setting field 44");

            if(FileSystem.IsFileExist(strFileName: FileNameConstants.DWNLDCHUNKINFO))
             {
                var ulChunkSize = Long()
                let list_of_Item: [Long] = FileSystem.ReadFile(strFileName: FileNameConstants.DWNLDCHUNKINFO)!
                if(!list_of_Item.isEmpty)
                {
                    ulChunkSize = list_of_Item[0]
                }

                debugPrint("Earlier ulChunkSize[\(ulChunkSize.value)]")
                var chArrTempChunkSize: String = "\(ulChunkSize.value)"
                chArrTempChunkSize = TransactionUtils.StrLeftPad(data: chArrTempChunkSize, length: 6, padChar: "0")
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_45, data1: [Byte](chArrTempChunkSize.utf8), bcd: true)
                debugPrint("Req->Setting field 45")
             }
         }else{
             debugPrint("DWNLDCACRTINFO not file esxits")
         }
    }
    
    //MARK:- SetImageDownLoadData(imageId: long)
    func SetImageDownLoadData(imageId: DataLong)
    {
        m_chTempImagefileName = String(format: "tm%08d", m_ulArrImageIdAdd[m_ulTotalImagesAdded])
        m_chTempImageDwnFile = String(format: "de%08d", m_ulArrImageIdAdd[m_ulTotalImagesAdded])
        m_chTempImageChunkFile = String(format: "ck%08d", m_ulArrImageIdAdd[m_ulTotalImagesAdded])

        debugPrint("tmp image file name[\(m_chTempImagefileName)]")
        debugPrint("tmp image dwn file name[\(m_chTempImageDwnFile)]")
        
        if(FileSystem.IsFileExist(strFileName: m_chTempImageDwnFile))
        {
            debugPrint("\(m_chTempClrdImageDwnFile) file esxits");
            var lastIMGDwndInfo = CurrentDownloadingInfo()
            let list_of_Items: [CurrentDownloadingInfo] = FileSystem.ReadFile(strFileName: m_chTempImageDwnFile)!
            if (!list_of_Items.isEmpty){
                lastIMGDwndInfo = list_of_Items[0]
            }

            //Check if the library to be downloaded is same as to be previously downloaded
            if(lastIMGDwndInfo.id == imageId)
            {
                m_bCurrentPacketCount = Int64(lastIMGDwndInfo.currentpacketCount);                  //Get current packet count
                m_bTotalPacketCount   = Int64(lastIMGDwndInfo.totalpacketCount);                    //Get Total packet count
                debugPrint("imageId[\(imageId)], m_bCurrentPacketCount[\(m_bCurrentPacketCount)], m_bTotalPacketCount[\(m_bTotalPacketCount)]")
            }else{
                debugPrint("imageId not matched ");
            }
        }
        else
        {
            debugPrint("\(m_chTempClrdImageDwnFile) not file esxits");
        }
        
        if(FileSystem.IsFileExist(strFileName: m_chTempImageChunkFile))
        {
            var ulChunkSize = Long()
            let list_of_Items: [Long] = FileSystem.ReadFile(strFileName: m_chTempImageChunkFile)!
            if (!list_of_Items.isEmpty){
                ulChunkSize = list_of_Items[0]
            }
            debugPrint("Earlier ulChunkSize[\(ulChunkSize.value)]")

            var chArrTempChunkSize: String = "\(ulChunkSize.value)"
            chArrTempChunkSize = TransactionUtils.StrLeftPad(data: chArrTempChunkSize, length: 6, padChar: "0")
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_45, data1: [Byte](chArrTempChunkSize.utf8), bcd: true);
            debugPrint("Req->Setting field 45")
        }
    }

    //MARK:- SetColoredImageDownLoadData(imageId: long)
    func SetColoredImageDownLoadData(imageId: DataLong)
    {
        m_chTempClrdImagefileName = String(format: "tm_clrd%08d", m_ulArrColoredImageIdAdd[m_ulTotalColoredImagesAdded])
        m_chTempClrdImageDwnFile = String(format: "dw_clrd%08d", m_ulArrColoredImageIdAdd[m_ulTotalColoredImagesAdded])
        m_chTempClrdImageChunkFile = String(format: "ck_clrd%08d", m_ulArrColoredImageIdAdd[m_ulTotalColoredImagesAdded])

        debugPrint("tmp image file name[\(m_chTempClrdImagefileName)]")
        debugPrint("tmp image dwn file name[\(m_chTempClrdImageDwnFile)]")

        if(FileSystem.IsFileExist(strFileName: m_chTempClrdImageDwnFile))
        {
            debugPrint("\(m_chTempClrdImageDwnFile) file esxits");
            var lastIMGDwndInfo = CurrentDownloadingInfo()
            let list_of_Items: [CurrentDownloadingInfo] = FileSystem.ReadFile(strFileName: m_chTempClrdImageDwnFile)!
            if (!list_of_Items.isEmpty){
                lastIMGDwndInfo = list_of_Items[0]
            }

            //Check if the library to be downloaded is same as to be previously downloaded
            if(lastIMGDwndInfo.id == imageId)
            {
                m_bCurrentPacketCount = Int64(lastIMGDwndInfo.currentpacketCount);                  //Get current packet count
                m_bTotalPacketCount   = Int64(lastIMGDwndInfo.totalpacketCount);                    //Get Total packet count
                debugPrint("imageId[\(imageId)], m_bCurrentPacketCount[\(m_bCurrentPacketCount)], m_bTotalPacketCount[\(m_bTotalPacketCount)]")
            }else{
                debugPrint("imageId not matched ");
            }
        }

        if(FileSystem.IsFileExist(strFileName: m_chTempClrdImageChunkFile))
        {
            var ulChunkSize = Long()
            let list_of_Items: [Long] = FileSystem.ReadFile(strFileName: m_chTempClrdImageChunkFile)!
            if (!list_of_Items.isEmpty){
                ulChunkSize = list_of_Items[0]
            }
            debugPrint("Earlier ulChunkSize[\(ulChunkSize.value)]")

            var chArrTempChunkSize: String = "\(ulChunkSize.value)"
            chArrTempChunkSize = TransactionUtils.StrLeftPad(data: chArrTempChunkSize, length: 6, padChar: "0")
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_45, data1: [Byte](chArrTempChunkSize.utf8), bcd: true);
            debugPrint("Req->Setting field 45")
        }
    }
    
    //MARK:- SaveImageDownloadInfoVersion(imageId: long) -> Int
    func SaveImageDownloadInfoVersion(imageId: DataLong) -> Int
    {
        var currentIMGDwndInfo = CurrentDownloadingInfo()
        debugPrint("Saving Image Download info !!")
        currentIMGDwndInfo.id = imageId
        currentIMGDwndInfo.currentpacketCount = Int(m_bCurrentPacketCount)
        currentIMGDwndInfo.totalpacketCount = Int(m_bTotalPacketCount)
        var list_of_Items: [CurrentDownloadingInfo] = []
        list_of_Items.append(currentIMGDwndInfo)
        
        do{
            _ = try FileSystem.ReWriteFile(strFileName: m_chTemplibDwnFile, with: list_of_Items)
        }
        catch{
            fatalError("Error in ReWriteFile, strFileName: \(m_chTemplibDwnFile)")
        }
    
        if(bitmap[45 - 1])
        {
            var chArrTempChunkSize = [Byte](repeating: 0x00, count: 13)
            chArrTempChunkSize = Array(data[45 - 1][0 ..< data[45 - 1].count])
            //System.arraycopy(data[45-1],0,chArrTempChunkSize,0,data[45-1].length);
            
            var ulChunkSize = Long()
            ulChunkSize.value = Int64(String(bytes: chArrTempChunkSize, encoding: .utf8)!)! /*strtoul(chArrTempChunkSize, NULL, 10);*/
            debugPrint("ulChunkSize[\(ulChunkSize.value)]");
            var list_of_Item: [Long] = []
            list_of_Item.append(ulChunkSize)
            do{
                _ = try FileSystem.ReWriteFile(strFileName: m_chTempImageChunkFile, with: list_of_Item)
            }
            catch{
                fatalError("Error in ReWriteFile, strFileName: \(m_chTempImageChunkFile)")
            }
        }
        return AppConstant.TRUE;
    }

    //MARK:- SaveColoredImageDownloadInfoVersion(imageId: long) -> Int
    func SaveColoredImageDownloadInfoVersion(imageId: DataLong) -> Int
    {
        
        var currentIMGDwndInfo = CurrentDownloadingInfo()
        debugPrint("Saving Colored Image Download info !!")
        currentIMGDwndInfo.id = imageId
        currentIMGDwndInfo.currentpacketCount = Int(m_bCurrentPacketCount)
        currentIMGDwndInfo.totalpacketCount = Int(m_bTotalPacketCount)
        var list_of_Items: [CurrentDownloadingInfo] = []
        list_of_Items.append(currentIMGDwndInfo)
        
        do{
            _ = try FileSystem.ReWriteFile(strFileName: m_chTempClrdImageDwnFile, with: list_of_Items)
        }
        catch{
            fatalError("Error in ReWriteFile, strFileName: \(m_chTempClrdImageDwnFile)")
        }

        if(bitmap[45 - 1])
        {
            
            var chArrTempChunkSize = [Byte](repeating: 0x00, count: 13)
            chArrTempChunkSize = Array(data[45 - 1][0 ..< data[45 - 1].count])
            //System.arraycopy(data[45-1],0,chArrTempChunkSize,0,data[45-1].length);
            
            var ulChunkSize = Long()
            ulChunkSize.value = Int64(String(bytes: chArrTempChunkSize, encoding: .utf8)!)! /*strtoul(chArrTempChunkSize, NULL, 10);*/
            debugPrint("ulChunkSize[\(ulChunkSize.value)]")
            var list_of_Item: [Long] = []
            list_of_Item.append(ulChunkSize);
            do{
                _ = try FileSystem.ReWriteFile(strFileName: m_chTempClrdImageChunkFile, with: list_of_Item)
            }
            catch{
                fatalError("Error in ReWriteFile, strFileName: \(m_chTempClrdImageChunkFile)")
            }
        }
        return AppConstant.TRUE;

    }

    //MARK:- SaveFixedChargeSlipDownloadInfoVersion(chargeslipId: long) -> Int
    func SaveFixedChargeSlipDownloadInfoVersion(chargeslipId: DataLong) -> Int
    {
        var currentIMGDwndInfo = CurrentDownloadingInfo()
        debugPrint("Saving chargeslip Download info !!")
        currentIMGDwndInfo.id = chargeslipId
        currentIMGDwndInfo.currentpacketCount = Int(m_bCurrentPacketCount)
        currentIMGDwndInfo.totalpacketCount = Int(m_bTotalPacketCount)
        var list_of_Items: [CurrentDownloadingInfo] = []
        list_of_Items.append(currentIMGDwndInfo)
            
        do{
            _ = try FileSystem.ReWriteFile(strFileName: m_chTempFixedChargeSlipDwnFile, with: list_of_Items)
        }
        catch{
            fatalError("Error in ReWriteFile, strFileName: \(m_chTempFixedChargeSlipDwnFile)")
        }
        
        if(bitmap[45 - 1])
        {
            var chArrTempChunkSize = [Byte](repeating: 0x00, count: 13)
            chArrTempChunkSize = Array(data[45 - 1][0 ..< data[45 - 1].count])
            //System.arraycopy(data[45-1],0,chArrTempChunkSize,0,data[45-1].length)
                
            var ulChunkSize = Long()
            ulChunkSize.value = Int64(String(bytes: chArrTempChunkSize, encoding: .utf8)!)! /*strtoul(chArrTempChunkSize, NULL, 10);*/
            debugPrint("ulChunkSize[\(ulChunkSize.value)]")
            var list_of_Item: [Long] = []
            list_of_Item.append(ulChunkSize);
            do{
                _ = try FileSystem.ReWriteFile(strFileName: m_chTempFixedChargeSlipChunkFile, with: list_of_Item);
            }
            catch{
                fatalError("Error in ReWriteFile, strFileName: \(m_chTempFixedChargeSlipChunkFile)")
            }
        }
        
        return AppConstant.TRUE
    }

    //MARK:- SetFixedChargeSlipDownLoadData(chargeslipId: long)
    func SetFixedChargeSlipDownLoadData(chargeslipId: DataLong)
    {

        m_chTempFixedChargeSlipfileName = String(format: "tm%08d", m_ulArrFixedChargeSlipIdAdd[m_ulTotalFixedChargeSlipAdded])
        m_chTempFixedChargeSlipDwnFile = String(format: "dw%08d", m_ulArrFixedChargeSlipIdAdd[m_ulTotalFixedChargeSlipAdded])
        m_chTempFixedChargeSlipChunkFile = String(format: "ck%08d", m_ulArrFixedChargeSlipIdAdd[m_ulTotalFixedChargeSlipAdded])

        debugPrint("tmp chargeslip file name[\(m_chTempFixedChargeSlipfileName)]")
        debugPrint("tmp chargeslip dwn file name[\(m_chTempFixedChargeSlipDwnFile)]")

        if(FileSystem.IsFileExist(strFileName: m_chTempFixedChargeSlipDwnFile))
        {
            debugPrint("\(m_chTempFixedChargeSlipDwnFile) file esxits");
            var lastIMGDwndInfo = CurrentDownloadingInfo()
            let list_of_Items: [CurrentDownloadingInfo] = FileSystem.ReadFile(strFileName: m_chTempFixedChargeSlipDwnFile)!
            if (!list_of_Items.isEmpty){
                lastIMGDwndInfo = list_of_Items[0]
            }

            //Check if the library to be downloaded is same as to be previously downloaded
            if(lastIMGDwndInfo.id == chargeslipId)
            {
                m_bCurrentPacketCount = Int64(lastIMGDwndInfo.currentpacketCount);                  //Get current packet count
                m_bTotalPacketCount   = Int64(lastIMGDwndInfo.totalpacketCount);                    //Get Total packet count
                debugPrint("ChargeSlipId[\(chargeslipId)], m_bCurrentPacketCount[\(m_bCurrentPacketCount)], m_bTotalPacketCount[\(m_bTotalPacketCount)]");
            }else{
                debugPrint("chargeslip not matched ");
            }
        }

        if(FileSystem.IsFileExist(strFileName: m_chTemplibChunkFile))
        {
            var ulChunkSize = Long()
            let list_of_Items: [Long] = FileSystem.ReadFile(strFileName: m_chTempFixedChargeSlipChunkFile)!
            if (!list_of_Items.isEmpty){
                ulChunkSize = list_of_Items[0]
            }
            debugPrint("Earlier ulChunkSize[\(ulChunkSize.value)]")

            let chArrTempChunkSize: String = String(format: "%06d",ulChunkSize.value);
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_45, data1: [Byte](chArrTempChunkSize.utf8), bcd: true);
            debugPrint("Req->Setting field 45")
        }
    }
    
    
    //MARK:- SaveLibDownloadInfoVersion(LibId: Int64) -> Int
    func SaveLibDownloadInfoVersion(LibId: Int64) -> Int
    {
        var currentLIBDwndInfo = CurrentDownloadingInfo()
        debugPrint("Saving Lib file info !!");

        currentLIBDwndInfo.id = LibId;
        currentLIBDwndInfo.currentpacketCount = Int(m_bCurrentPacketCount)
        currentLIBDwndInfo.totalpacketCount = Int(m_bTotalPacketCount)
        var list_of_Item: [CurrentDownloadingInfo] = []
        list_of_Item.append(currentLIBDwndInfo);
        
        do{
            _ = try FileSystem.ReWriteFile(strFileName: m_chTemplibDwnFile, with: list_of_Item);
        }
        catch{
            fatalError("Error in ReWriteFile, strFileName: \(m_chTemplibDwnFile)")
        }

        if(bitmap[45 - 1])
        {
            var chArrTempChunkSize = [Byte](repeating: 0x00, count: len[45 - 1])
            chArrTempChunkSize = Array(data[45 - 1][0 ..< len[45 - 1]])

            var ulChunkSize = Long()
            ulChunkSize.value = Int64(String(bytes: chArrTempChunkSize, encoding: .utf8)!)!
            debugPrint("ulChunkSize[\(ulChunkSize.value)]")
            
            var list_of_Items: [Long] = []
            list_of_Items.append(ulChunkSize);
            
            do{
                _ = try FileSystem.ReWriteFile(strFileName: m_chTemplibDwnFile, with: list_of_Item)
            }
            catch{
                fatalError("Error in ReWriteFile, strFileName: \(m_chTemplibDwnFile)")
            }
        }
        return AppConstant.TRUE;
    }

    //MARK:- SetLibDownLoadData(LibId: Int64)
    func SetLibDownLoadData(LibId: Int64)
    {
        m_chTemplibfileName = String(format: "tm%08d", m_ulArrlibIdAdd[m_ulTotallibAdded]!.id)
        m_chTemplibDwnFile = String(format: "dw%08d", m_ulArrlibIdAdd[m_ulTotallibAdded]!.id)
        m_chTemplibChunkFile = String(format: "ck%08d", m_ulArrlibIdAdd[m_ulTotallibAdded]!.id)

        debugPrint("tmp lib file name[\(m_chTemplibfileName)]")
        debugPrint("tmp lib dwn file name[\(m_chTemplibDwnFile)]")

        if(FileSystem.IsFileExist(strFileName: m_chTemplibDwnFile))
        {
            debugPrint("\(m_chTemplibDwnFile) file esxits");
            var lastLIBDwndInfo = CurrentDownloadingInfo()
            let list_of_Items: [CurrentDownloadingInfo] = FileSystem.ReadFile(strFileName: m_chTemplibDwnFile)!
            if (!list_of_Items.isEmpty){
                lastLIBDwndInfo = list_of_Items[0]
            }

            //Check if the library to be downloaded is same as to be previously downloaded
            if(lastLIBDwndInfo.id == LibId)
            {
                m_bCurrentPacketCount = Int64(lastLIBDwndInfo.currentpacketCount);                  //Get current packet count
                m_bTotalPacketCount   = Int64(lastLIBDwndInfo.totalpacketCount);                    //Get Total packet count
                debugPrint("LibId[\(LibId)], m_bCurrentPacketCount[\(m_bCurrentPacketCount)], m_bTotalPacketCount[\(m_bTotalPacketCount)]");
            }else{
                debugPrint("Lib id not matched ");
            }
        }

        if(FileSystem.IsFileExist(strFileName: m_chTemplibChunkFile))
        {
            var ulChunkSize = Long()
            let list_of_Items: [Long] = FileSystem.ReadFile(strFileName: m_chTemplibChunkFile)!
            if (!list_of_Items.isEmpty){
                ulChunkSize = list_of_Items[0]
            }
            debugPrint("Earlier ulChunkSize[\(ulChunkSize.value)]")

            var chArrTempChunkSize: String = "\(ulChunkSize.value)"
            chArrTempChunkSize = TransactionUtils.StrLeftPad(data: chArrTempChunkSize, length: 6 , padChar: "0");
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_45, data1: [Byte](chArrTempChunkSize.utf8), bcd: true);
            debugPrint("Req->Setting field 45")
        }
    }
    
    //MARK:- getPVMVersion(isoFeild: Int, ulPVMVersion: Int64) -> Int
    func getPVMVersion(isoFeild: Int, ulPVMVersion: inout Long) -> Int
    {
        if(bitmap[isoFeild - 1])
        {
            var chPvmVersion = [Byte](repeating: 0x00, count: len[isoFeild - 1])
            chPvmVersion = Array(data[isoFeild - 1][0 ..< chPvmVersion.count])
            //System.arraycopy(data[isoFeild-1],0,chPvmVersion,0,chPvmVersion.length);
            ulPVMVersion.value = Int64((String(bytes: chPvmVersion, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines))!)!
            return AppConstant.TRUE;
        }
        return  AppConstant.FALSE;
    }

    //MARK:- SavePVMDownloadInfoVersion() -> Int
    func SavePVMDownloadInfoVersion() -> Int
    {
        if(bitmap[44 - 1])
        {
            var currentPVMDwndInfo = CurrentDownloadingInfo()
            var ulPVMVersion = Long()
            
            if(AppConstant.TRUE == getPVMVersion(isoFeild: ISOFieldConstants.ISO_FIELD_44, ulPVMVersion: &ulPVMVersion)){
                //carry out str to ul and store it in the database or file system as the case may be this will sent in next time in field 59 in all the next requests.
                debugPrint("Saving Download info !!");
                currentPVMDwndInfo.id = ulPVMVersion.value;
                currentPVMDwndInfo.currentpacketCount = Int(m_bCurrentPacketCount)
                currentPVMDwndInfo.totalpacketCount = Int(m_bTotalPacketCount)
                var list_of_Item: [CurrentDownloadingInfo] = []
                list_of_Item.append(currentPVMDwndInfo)
                
                do{
                    _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.DWNLDPVMINFO, with: list_of_Item);
                }
                catch{
                    fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.DWNLDPVMINFO)")
                }
                
            }else{
                debugPrint("ERROR Cannot retrive PVM version!!")
            }
        }else{
            debugPrint("WARNING Not Saving Download info !!")
        }

        if(bitmap[45 - 1])
        {
            var chArrTempChunkSize = [Byte](repeating: 0x00, count: 13)
            chArrTempChunkSize = Array(data[45 - 1][0 ..< data[45 - 1].count])
            //System.arraycopy(data[45-1],0,chArrTempChunkSize,0,data[45-1].length);
            
            var ulChunkSize = Long()
            ulChunkSize.value = Int64(String(bytes: chArrTempChunkSize, encoding: .utf8)!)! /*strtoul(chArrTempChunkSize, NULL, 10);*/
            debugPrint("ulChunkSize[\(ulChunkSize.value)]");
            var list_of_Item: [Long] = []
            list_of_Item.append(ulChunkSize);
            do{
                _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.DWNLDCHUNKINFO, with: list_of_Item);
            }
            catch{
                fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.DWNLDCHUNKINFO)")
            }
            
        }
        return AppConstant.TRUE;
    }
    
    //MARK:- SetCACRTDownLoadVersion()
    func SetCACRTDownLoadVersion()
    {
         //If fileexist
        if(FileSystem.IsFileExist(strFileName: FileNameConstants.DWNLDCACRTINFO))
         {
            debugPrint("DWNLDCACRTINFO file esxits")
            var lastCACRTDwndInfo = CurrentDownloadingInfo()
            
            let list_of_Items: [CurrentDownloadingInfo] = FileSystem.ReadFile(strFileName: FileNameConstants.DWNLDCACRTINFO)!
            if(!list_of_Items.isEmpty)
             {
                 lastCACRTDwndInfo = list_of_Items[0]
             }
             //Get PVM version
             m_ulDownloadingCACRTVersion = lastCACRTDwndInfo.id;
            m_bCurrentPacketCount = Int64(lastCACRTDwndInfo.currentpacketCount);
            m_bTotalPacketCount   = Int64(lastCACRTDwndInfo.totalpacketCount);
            debugPrint("m_ulDownloadingCACRTVersion[\(m_ulDownloadingCACRTVersion)], m_bCurrentPacketCount[\(m_bCurrentPacketCount)], m_bTotalPacketCount[\(m_bTotalPacketCount)]");

            debugPrint("Earlier m_ulDownloadingCACRTVersion[\(m_ulDownloadingCACRTVersion)]")
            var newbuffer: String = String(format: "%d",m_ulDownloadingCACRTVersion)
            newbuffer = TransactionUtils.StrRightPad(data: newbuffer, length: 6, padChar: " ")
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_44, data1: [Byte](newbuffer.utf8), bcd: false)
            debugPrint("Req->Setting field 44");

            if(FileSystem.IsFileExist(strFileName: FileNameConstants.DWNLDCACRTCHUNKINFO))
             {
                var ulChunkSize = Long()
                let list_of_Item: [Long] = FileSystem.ReadFile(strFileName: FileNameConstants.DWNLDCACRTCHUNKINFO)!
                if(!list_of_Item.isEmpty)
                {
                    ulChunkSize = list_of_Item[0]
                }

                debugPrint("Earlier ulChunkSize[\(ulChunkSize.value)]")
                var chArrTempChunkSize: String = "\(ulChunkSize.value)"
                chArrTempChunkSize = TransactionUtils.StrLeftPad(data: chArrTempChunkSize, length: 6, padChar: "0")
                _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_45, data1: [Byte](chArrTempChunkSize.utf8), bcd: true)
                debugPrint("Req->Setting field 45")
             }
         }else{
             debugPrint("DWNLDCACRTINFO not file esxits")
         }
    }
    
    //MARK:- getCACRTVersion(isoFeild: Int, ulCACRTVersion: inout Int64) -> Int
    func getCACRTVersion(isoFeild: Int, ulCACRTVersion: inout Long) -> Int
     {
         if(bitmap[isoFeild - 1])
         {
            var chCACRTVersion = [Byte](repeating: 0x00, count: len[isoFeild - 1])
            chCACRTVersion = Array(data[isoFeild - 1][0 ..< chCACRTVersion.count])
            //System.arraycopy(data[isoFeild-1],0,chCACRTVersion,0,chCACRTVersion.length);
            
            let strCACRTVersion: String = (String(bytes: chCACRTVersion, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines))!
            ulCACRTVersion.value = Int64(strCACRTVersion)!
            return AppConstant.TRUE;
         }
        
        return  AppConstant.FALSE;
     }

    //MARK: SaveCACRTDownloadInfoVersion() -> Int
    func SaveCACRTDownloadInfoVersion() -> Int
    {
        if(bitmap[44 - 1])
        {
            var currentCACRTDwndInfo = CurrentDownloadingInfo()
            var ulCACRTVersion = Long()
            if(AppConstant.TRUE == getCACRTVersion(isoFeild: ISOFieldConstants.ISO_FIELD_44,ulCACRTVersion: &ulCACRTVersion)){
                //carry out str to ul and store it in the database or file system as the case may be
                //this will sent in next time in field 59 in all the next requests.
                debugPrint("Saving Download info !!");
                currentCACRTDwndInfo.id = ulCACRTVersion.value
                currentCACRTDwndInfo.currentpacketCount = Int(m_bCurrentPacketCount)
                currentCACRTDwndInfo.totalpacketCount = Int(m_bTotalPacketCount)
                
                var list_of_Item: [CurrentDownloadingInfo] = []
                list_of_Item.append(currentCACRTDwndInfo);
                do{
                    _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.DWNLDCACRTINFO, with: list_of_Item);
                }
                catch{
                    fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.DWNLDCACRTINFO)")
                }
                
            }else{
                debugPrint("ERROR Cannot retrive PVM version!!");
            }
        }else{
             debugPrint("WARNING Not Saving Download info !!");
        }

        if(bitmap[45 - 1])
        {
            var chArrTempChunkSize = [Byte](repeating: 0x00, count: 12)
            chArrTempChunkSize = Array(data[45 - 1][0 ..< len[45 - 1]])
            
            //System.arraycopy(data[45-1],0,chArrTempChunkSize,0,len[45-1]);
            var ulChunkSize = Long()
            ulChunkSize.value = Int64(String(bytes: chArrTempChunkSize, encoding: .utf8)!)!
            debugPrint("ulChunkSize[\(ulChunkSize.value)]")
            var list_of_Item: [Long] = []
            list_of_Item.append(ulChunkSize);
            
            do{
                _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.DWNLDCACRTINFO, with: list_of_Item);
            }
            catch{
                fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.DWNLDCACRTINFO)")
            }
        }
        return AppConstant.TRUE;
    }

    //MARK:- ProcessCACRTData() -> Bool
    func ProcessCACRTData() -> Bool{
        debugPrint("Inside ProcessCACRTData")
        
        let p: [Byte] = data[61-1]
        var _: Int = len[61-1]

        let pFieldCACRTDef: [Byte] = data[53-1]
        let ilength: Int  = len[53-1]
        
        if(ilength >= 2){
            var offset: Int = 0
            self.m_bCurrentPacketCount = Int64(pFieldCACRTDef[offset]) << 8 & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64(pFieldCACRTDef[offset] & 0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = Int64(pFieldCACRTDef[offset] << 8) & Int64(0x0000FF00 )
            offset += 1
            self.m_bTotalPacketCount |= Int64(pFieldCACRTDef[offset] & 0x000000FF )
            offset += 1
            
            debugPrint("Response->Field 53 found")
        }

        if(self.m_bCurrentPacketCount == 0x01)
        {
            //CLogger.TraceLog("\n**********PVM Data*********\n");
            debugPrint("**********CA CRT Data*********")
            
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TEMCACRTFILE, with: p)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDCACRTINFO, with: p)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDCACRTCHUNKINFO, with: p)
        }
        else{

            if(bitmap[44 - 1])
            {
                debugPrint("CACRT NOT First packet")
                var _: CurrentDownloadingInfo
                var ulCACRTVersion = Long()
                if(AppConstant.TRUE == getCACRTVersion(isoFeild: ISOFieldConstants.ISO_FIELD_44, ulCACRTVersion: &ulCACRTVersion))
                {
                    debugPrint("m_ulDownloadingCACRTVersion[\(m_ulDownloadingCACRTVersion)], ulCACRTVersion[\(ulCACRTVersion)]")

                    if(ulCACRTVersion.value != m_ulDownloadingCACRTVersion)
                    {
                        //stop CACRT download
                        //clean data
                        _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TEMCACRTFILE, with: p)
                        _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDCACRTINFO, with: p)
                        _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDCACRTCHUNKINFO, with: p)
                        debugPrint("New CACRT being downloaded");
                        return false;
                    }
                }else{
                    debugPrint("ERROR Cannot retrive CACRT version!!")
                    return false
                }

            }else{
                debugPrint("Field 44 not found !!")
                return false;
            }
        }


        /***************************************************************************************
         * if(this->m_bCurrentPacketCount == this->m_bTotalPacketCount)
         * extract field 59 from 330 and save in our parameter file as PVM version.
         * for new request. As of now host might not be sending this ---- to check with host team
         *
         * We will check weather CACRT file is present before renaming temp file to CACRT file
         ****************************************************************************************/
        if(self.m_bCurrentPacketCount == self.m_bTotalPacketCount)
        {
            let globalData = GlobalData.singleton
            
            //TODO:- State Machine Class needed
            //CStateMachine  Statemachine = CStateMachine.GetInstance();
            do{
                _ = try FileSystem.AppendFile(strFileName: FileNameConstants.TEMCACRTFILE, with: p)
            }
            catch
            {
                fatalError("Error in AppendFile strFileName: \(FileNameConstants.TEMCACRTFILE)")
            }
            
            if(true == FileSystem.IsFileExist(strFileName: FileNameConstants.CACRTFILE))
            {
                _ = FileSystem.DeleteFile(strFileName: FileNameConstants.CACRTFILE, with: p);
                debugPrint("CACRT file deleted")
            }
            
            _ = FileSystem.RenameFile(strNewFileName: FileNameConstants.CACRTFILE,strFileName: FileNameConstants.TEMCACRTFILE)
            debugPrint("CACRT file created")

            //Store PVM version
            var ulCACRTVersion = Long()
            if(AppConstant.TRUE == getCACRTVersion(isoFeild: ISOFieldConstants.ISO_FIELD_59,ulCACRTVersion: &ulCACRTVersion)){
                //carry out str to ul and store it in the database or file system as the case may be
                //this will sent in next time in field 59 in all the next requests.
                if(true == FileSystem.IsFileExist(strFileName: FileNameConstants.CACRTFILE))
                {
                    if(globalData.m_sMasterParamData!.ulCACRTVersion != ulCACRTVersion.value)
                    {
                        //TODO:- State Machine Class needed
                        //Statemachine.m_ResetTerminal = true;
                    }
                }
                globalData.m_sMasterParamData!.ulCACRTVersion = ulCACRTVersion.value
                _ = globalData.WriteMasterParamFile()
            }
        }
        else
        {
            do{
                _  = try FileSystem.AppendFile(strFileName: FileNameConstants.TEMCACRTFILE, with: p)
            }
            catch{
                fatalError("Error in AppendFile strFileName: \(FileNameConstants.TEMCACRTFILE)")
            }
            
            _ = SaveCACRTDownloadInfoVersion()
        }
        return true;
    }
    
    //MARK:- packHostUploadPacket()
    func packHostUploadPacket()
    {
        m_chArrBuffer = [Byte](repeating: 0x00, count: 2000)
        m_iOffsetBuffer = 0

        while((m_iOffsetBuffer <= 0) && (m_iHostUploadPacketNumber <= ISO320HostUploadChangeNum.AUTOSETTLE_UPLOAD_PACKET)){
            switch (m_iHostUploadPacketNumber) {
            case ISO320HostUploadChangeNum.SERIAL_UPLOAD_PACKET:
                    getSerialParameters()
                    break;
                case ISO320HostUploadChangeNum.GPRS_UPLOAD_PACKET:
                    getGPRSParameters()
                    break;
                case ISO320HostUploadChangeNum.ETHERNET_UPLOAD_PACKET:
                    getEthernetParameters()
                    break;
                case ISO320HostUploadChangeNum.TERMINAL_PARAM_UPLOAD_PACKET:
                    getTerminalParameters()
                    break;
                case ISO320HostUploadChangeNum.MASTER_PARAM_UPLOAD_PACKET:
                    getTerminalMasterParameters()
                    break;
                case ISO320HostUploadChangeNum.AUTOSETTLE_UPLOAD_PACKET:
                    getAutoSettlementParameters()
                    break;
                default:
                    break;
            }
            if(m_iOffsetBuffer <= 0){
                m_iHostUploadPacketNumber += 1
            }
        }
        _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61,data1: m_chArrBuffer , length: m_iOffsetBuffer);
    }
    
    //MARK:- getSerialParameters()
    func getSerialParameters()
    {
        let globalData = GlobalData.singleton
        var uchArrBitmap320 = [Byte](repeating: 0x00, count: 4)
        
        uchArrBitmap320 = Array(globalData.m_sMasterParamData!.m_uchArrBitmap320ActiveHost[0 ..< AppConstant.LEN_BITMAP_PACKET])
        //System.arraycopy(GlobalData.m_sMasterParamData.m_uchArrBitmap320ActiveHost,0,uchArrBitmap320,0,AppConst.LEN_BITMAP_PACKET);

        for it in (0 ..< AppConstant.LEN_BITMAP_PACKET * 8 - 1).reversed()
        {
            if ((uchArrBitmap320[it/8] & (0x80 >> (it%8))) != 0 )
            {
                let chArrConnectionDataFile: String = String(format: "%s",FileNameConstants.CONNECTIONDATAFILENAME);
                debugPrint("chArrConnectionDataFile[\(chArrConnectionDataFile)]")

                let tData: TerminalConxData? = FileSystem.SeekRead(strFileName: chArrConnectionDataFile,iOffset: globalData.m_sConxData.m_bArrConnIndex.CON_SerialIp.index)!
                if(tData != nil) {
                    debugPrint("m_bIsDataChanged[\(tData!.bIsDataChanged)]")
                    
                    if (tData!.bIsDataChanged == true) {

                        _ = insertTLV(iParamID: ParameterIDs._Serial_Transaction_SSL_IP, chArrParamData: [Byte](tData!.strTransactionSSLServerIP.utf8), dataLen: tData!.strTransactionSSLServerIP.count)
                        let chArrTransactionSSLPort: String = String(format: "%d",tData!.iTransactionSSLPort)
                        _ = insertTLV(iParamID: ParameterIDs._Serial_Transaction_SSL_IP, chArrParamData: [Byte](chArrTransactionSSLPort.utf8), dataLen: chArrTransactionSSLPort.count);
   
                        
                        _ = insertTLV(iParamID: ParameterIDs._Serial_Secondary_Transaction_SSL_IP, chArrParamData: [Byte](tData!.strSecondaryTransactionSSLServerIP.utf8), dataLen: tData!.strSecondaryTransactionSSLServerIP.count)
                        let chArrSecondaryTransactionSSLPort: String = String(format: "%d",tData!.iSecondaryTransactionSSLPort)
                        _ = insertTLV(iParamID: ParameterIDs._Serial_Secondary_Transaction_SSL_Port, chArrParamData: [Byte](chArrSecondaryTransactionSSLPort.utf8), dataLen: chArrSecondaryTransactionSSLPort.count)
        
                        let chArrConnTimeout: String = String(format: "%d",tData!.iConnTimeout)
                        _ = insertTLV(iParamID: ParameterIDs._Serial_Connect_Timeout, chArrParamData: [Byte](chArrConnTimeout.utf8),dataLen: chArrConnTimeout.count)
                        let chArrSendRecTimeout: String = String(format: "%d",tData!.iSendRecTimeout)
                        _ = insertTLV(iParamID: ParameterIDs._Serial_Send_Rec_Timeout, chArrParamData: [Byte](chArrSendRecTimeout.utf8), dataLen: chArrSendRecTimeout.count)

                        _ = insertTLV(iParamID: ParameterIDs._Serial_User_Id, chArrParamData: [Byte](tData!.strLoginID.utf8), dataLen: tData!.strLoginID.count)
                        _ = insertTLV(iParamID: ParameterIDs._Serial_Password, chArrParamData: [Byte](tData!.strPassword.utf8), dataLen: tData!.strPassword.count)
                    }
                }
            }
        }

    }
    
    
    //MARK:- getGPRSParameters()
    func getGPRSParameters()
    {
        let globalData = GlobalData.singleton
        
        var uchArrBitmap320 =  [Byte](repeating: 0x00, count: 4)
        uchArrBitmap320 = Array(globalData.m_sMasterParamData!.m_uchArrBitmap320ActiveHost[0 ..< AppConstant.LEN_BITMAP_PACKET])
        
        //System.arraycopy(GlobalData.m_sMasterParamData.m_uchArrBitmap320ActiveHost,0,uchArrBitmap320,0,AppConst.LEN_BITMAP_PACKET);

        for it in (0 ..< AppConstant.LEN_BITMAP_PACKET * 8 - 1).reversed()
        {
            if ((uchArrBitmap320[it/8] & (0x80 >> (it%8))) != 0) {
                
                let chArrConnectionDataFile: String = String(format: "%s", FileNameConstants.CONNECTIONDATAFILENAME)
                
                debugPrint("chArrConnectionDataFile[\(chArrConnectionDataFile)]");
                
                let tData: TerminalConxData? = FileSystem.SeekRead(strFileName: chArrConnectionDataFile, iOffset: globalData.m_sConxData.m_bArrConnIndex.CON_GPRS.index)!
                
                if (tData != nil) {
                    debugPrint("m_bIsDataChanged[\(tData!.bIsDataChanged)] ");
                    
                    if (tData!.bIsDataChanged == true) {
                        
                        _ = insertTLV(iParamID: ParameterIDs._GPRS_Transaction_SSL_IP, chArrParamData: [Byte](tData!.strTransactionSSLServerIP.utf8), dataLen: tData!.strTransactionSSLServerIP.count)
                        let chArrTransactionSSLPort: String = String(format: "%d",tData!.iTransactionSSLPort)
                        _ = insertTLV(iParamID: ParameterIDs._GPRS_Transaction_SSL_Port, chArrParamData: [Byte](chArrTransactionSSLPort.utf8), dataLen: chArrTransactionSSLPort.count);

                        
                        _ = insertTLV(iParamID: ParameterIDs._GPRS_Secondary_Transaction_SSL_IP, chArrParamData: [Byte](tData!.strSecondaryTransactionSSLServerIP.utf8), dataLen: tData!.strSecondaryTransactionSSLServerIP.count)
                        
                        let chArrSecondaryTransactionSSLPort: String = String(format: "%d",tData!.iSecondaryTransactionSSLPort)
                        _ = insertTLV(iParamID: ParameterIDs._GPRS_Secondary_Transaction_SSL_Port, chArrParamData: [Byte](chArrSecondaryTransactionSSLPort.utf8), dataLen: chArrSecondaryTransactionSSLPort.count);
                        
                        
                        let chArrConnTimeout: String = String(format: "%d",tData!.iConnTimeout)
                        _ = insertTLV(iParamID: ParameterIDs._GPRS_Connect_Timeout, chArrParamData: [Byte](chArrConnTimeout.utf8),dataLen: chArrConnTimeout.count)
                        let chArrSendRecTimeout: String = String(format: "%d",tData!.iSendRecTimeout)
                        _ = insertTLV(iParamID: ParameterIDs._GPRS_Send_Rec_Timeout, chArrParamData: [Byte](chArrSendRecTimeout.utf8), dataLen: chArrSendRecTimeout.count)
                        
                        

                        _ = insertTLV(iParamID: ParameterIDs._GPRS_User_Id, chArrParamData: [Byte](tData!.strLoginID.utf8), dataLen: tData!.strLoginID.count)
                        _ = insertTLV(iParamID: ParameterIDs._GPRS_Password, chArrParamData: [Byte](tData!.strPassword.utf8), dataLen: tData!.strPassword.count)

                        _ = insertTLV(iParamID: ParameterIDs._GPRS_GPRS_Service_provider, chArrParamData: [Byte](tData!.strGPRSServiceProvider.utf8), dataLen: tData!.strGPRSServiceProvider.count)

                        _ = insertTLV(iParamID: ParameterIDs._GPRS_APN_Name, chArrParamData: [Byte](tData!.strAPN.utf8), dataLen: tData!.strAPN.count)    // Sunder S: Added for APN as a downloadable param : 25-Mar-2015
                    }
                }
            }
        }
    }
    
    
    //MARK:- getEthernetParameters()
    func getEthernetParameters()
    {
        let  globalData = GlobalData.singleton

        var uchArrBitmap320 = [Byte](repeating: 0x00, count: 4)
        uchArrBitmap320 = Array(globalData.m_sMasterParamData!.m_uchArrBitmap320ActiveHost[0 ..< AppConstant.LEN_BITMAP_PACKET])
        //System.arraycopy(GlobalData.m_sMasterParamData.m_uchArrBitmap320ActiveHost,0,uchArrBitmap320,0,AppConst.LEN_BITMAP_PACKET);

        for it in (0 ..< AppConstant.LEN_BITMAP_PACKET * 8 - 1).reversed()
        {
            if ((uchArrBitmap320[it/8] & (0x80 >> (it % 8))) != 0 ) {
                let chArrConnectionDataFile: String = String(format: "%s", FileNameConstants.CONNECTIONDATAFILENAME)
                debugPrint("chArrConnectionDataFile[\(chArrConnectionDataFile)]")

                
                let tData: TerminalConxData? = FileSystem.SeekRead(strFileName: chArrConnectionDataFile, iOffset: globalData.m_sConxData.m_bArrConnIndex.CON_ETHERNET.index)!
                
                if (tData != nil) {
                    debugPrint("m_bIsDataChanged[\(tData!.bIsDataChanged)]")
                    
                    if (tData!.bIsDataChanged == true) {

                        _ = insertTLV(iParamID: ParameterIDs._Ethernet_Transaction_SSL_IP, chArrParamData: [Byte](tData!.strTransactionSSLServerIP.utf8), dataLen: tData!.strTransactionSSLServerIP.count)
                         let chArrTransactionSSLPort: String = String(format: "%d",tData!.iTransactionSSLPort)
                        _ = insertTLV(iParamID: ParameterIDs._Ethernet_Transaction_SSL_Port, chArrParamData: [Byte](chArrTransactionSSLPort.utf8), dataLen: chArrTransactionSSLPort.count)

                        _ = insertTLV(iParamID: ParameterIDs._Ethernet_Secondary_Transaction_SSL_IP, chArrParamData: [Byte](tData!.strSecondaryTransactionSSLServerIP.utf8), dataLen: tData!.strSecondaryTransactionSSLServerIP.count)
                        let chArrSecondaryTransactionSSLPort: String = String(format: "%d",tData!.iSecondaryTransactionSSLPort)
                        _ = insertTLV(iParamID: ParameterIDs._Ethernet_Secondary_Transaction_SSL_Port, chArrParamData: [Byte](chArrSecondaryTransactionSSLPort.utf8) , dataLen: chArrSecondaryTransactionSSLPort.count);

                        let chArrConnTimeout: String = String(format: "%d",tData!.iConnTimeout)
                        _ = insertTLV(iParamID: ParameterIDs._Ethernet_Connect_Timeout, chArrParamData: [Byte](chArrConnTimeout.utf8),dataLen: chArrConnTimeout.count)
                        let chArrSendRecTimeout: String = String(format: "%d",tData!.iSendRecTimeout)
                        _ = insertTLV(iParamID: ParameterIDs._Ethernet_Send_Rec_Timeout, chArrParamData: [Byte](chArrSendRecTimeout.utf8), dataLen: chArrSendRecTimeout.count)
                    }
                }
            }
        }
    }
    
    
    //MARK:- getTerminalParameters()
    func getTerminalParameters()
    {
        let  globalData = GlobalData.singleton

        var uchArrBitmap320 = [Byte](repeating: 0x00, count: 4)
        
        uchArrBitmap320 = Array(globalData.m_sMasterParamData!.m_uchArrBitmap320ActiveHost[0 ..< AppConstant.LEN_BITMAP_PACKET])
        //System.arraycopy(GlobalData.m_sMasterParamData.m_uchArrBitmap320ActiveHost,0,uchArrBitmap320,0,AppConst.LEN_BITMAP_PACKET);

        for it in (0 ..< AppConstant.LEN_BITMAP_PACKET * 8 - 1).reversed()
        {
            if ((uchArrBitmap320[it/8] & ((0x80 >> (it % 8)))) != 0) {

                let chArrTerminalParamDataFile: String = String(format: "%s", FileNameConstants.TERMINALPARAMFILENAME)
                debugPrint("chArrTerminalParamDataFile[\(chArrTerminalParamDataFile)]");

                let tData: TerminalParamData? = globalData.ReadParamFile()!
                //TerminalParamData tData = CFileSystem.SeekRead(m_cntx, TerminalParamData[].class, chArrTerminalParamDataFile, 0);
                if (tData != nil) {
                    if (tData!.m_bIsDataChanged == true) {
                        let chArrBatchSize: String = String(format: "%d",tData!.iBatchSize);
                        _ = insertTLV(iParamID: ParameterIDs._Batch_Size, chArrParamData: [Byte](chArrBatchSize.utf8), dataLen: chArrBatchSize.count);

                        let chArrSecondaryIPMaxRetryCount: String = String(format: "%d",tData!.m_SecondaryIPMaxRetryCount);
                        _ = insertTLV(iParamID: ParameterIDs._Secondary_IP_Max_Retry_Count, chArrParamData: [Byte](chArrSecondaryIPMaxRetryCount.utf8), dataLen: chArrSecondaryIPMaxRetryCount.count);

                        let chArrEMVChipRetryCount: String = String(format: "%d",tData!.m_EMVChipRetryCount);
                        _ = insertTLV(iParamID: ParameterIDs._EMVFallbackChipRetryCounter, chArrParamData: [Byte](chArrEMVChipRetryCount.utf8), dataLen: chArrEMVChipRetryCount.count);
                    }
                }
            }
        }
    }
    
    
    
    //MARK:- getAutoSettlementParameters()
    func getAutoSettlementParameters()
    {
        let tAutoSettlementData: AutoSettlementParams? = FileSystem.SeekRead(strFileName: FileNameConstants.AUTOSETTLEPARFILE, iOffset: 0)
        m_iOffsetBuffer = 0

        if(tAutoSettlementData != nil) {
            if (tAutoSettlementData!.m_bIsDataChanged == true) {

                let bArrSettlementStartTime: [Byte] = [Byte](tAutoSettlementData!.m_strSettlementStartTime.utf8)
                _ = insertTLV(iParamID: ParameterIDs._Settlement_Start_Time, chArrParamData: bArrSettlementStartTime, dataLen: bArrSettlementStartTime.count)

                let bArrSettlementFrequency: [Byte] = withUnsafeBytes(of: tAutoSettlementData!.m_iSettlementFrequency.bigEndian, Array.init)
                _ = insertTLV(iParamID: ParameterIDs._Settlement_Frequency, chArrParamData: bArrSettlementFrequency, dataLen: bArrSettlementFrequency.count)

                let bArrSettlementRetryCount: [Byte] = withUnsafeBytes(of: tAutoSettlementData!.m_iSettlementRetryCount.bigEndian, Array.init)
                _ = insertTLV(iParamID: ParameterIDs._Settlement_Retry_Count, chArrParamData: bArrSettlementRetryCount, dataLen: bArrSettlementRetryCount.count)

                let bArrSettlementRetryInterval: [Byte] = withUnsafeBytes(of: tAutoSettlementData!.m_iSettlementRetryIntervalInSeconds.bigEndian, Array.init)
                _ = insertTLV(iParamID: ParameterIDs._Settlement_Retry_Interval, chArrParamData: bArrSettlementRetryInterval, dataLen: bArrSettlementRetryInterval.count)

                let iAutoSettlementEnabledFlag: Int = tAutoSettlementData!.m_iAutoSettlementEnabledflag ? 1 : 0
                let bArrSettlementFlag: [Byte] = withUnsafeBytes(of: iAutoSettlementEnabledFlag.bigEndian, Array.init)
                _ = insertTLV(iParamID: ParameterIDs._Auto_Settlement_Enabled, chArrParamData: bArrSettlementFlag, dataLen: 1)
            }
        }
    }
    
    
    //MARK:- getTerminalMasterParameters()
    func getTerminalMasterParameters()
    {
        let tData: TerminalMasterParamData? = FileSystem.SeekRead(strFileName: FileNameConstants.TERMINALMASTERPARAMFILE, iOffset: 0)
        m_iOffsetBuffer = 0
        
        if (tData != nil){
            if (tData!.bIsDataChanged) {
                _ = insertTLV(iParamID: ParameterIDs._HSM_Primay_IP, chArrParamData: [Byte](tData!.m_strHSMPrimaryIP.utf8), dataLen: tData!.m_strHSMPrimaryIP.count)

                let sHSMPrimaryPort: String = String(format: "%d",tData!.m_lHSMPrimaryPort)
                _ = insertTLV(iParamID: ParameterIDs._HSM_Primay_Port, chArrParamData: [Byte](sHSMPrimaryPort.utf8), dataLen: sHSMPrimaryPort.count)

                _ = insertTLV(iParamID: ParameterIDs._HSM_Secondary_IP, chArrParamData: [Byte](tData!.m_strHSMSecondaryIP.utf8), dataLen: tData!.m_strHSMSecondaryIP.count)

                let HSMSecondaryPort: String = String(format: "%d",tData!.m_lHSMSecondaryPort)
                _ = insertTLV(iParamID: ParameterIDs._HSM_Secondary_Port, chArrParamData: [Byte](HSMSecondaryPort.utf8), dataLen: HSMSecondaryPort.count)

                let chArrHSMRetryCount: String = String(format: "%d",tData!.m_iHSMRetryCount)
                _ = insertTLV(iParamID: ParameterIDs._HSM_Retry_Count, chArrParamData: [Byte](chArrHSMRetryCount.utf8), dataLen: chArrHSMRetryCount.count)

                let chArrOnlinePinFirstCharTimeout: String = String(format: "%d",tData!.m_iOnlinePinFirstCharTimeout)
                _ = insertTLV(iParamID: ParameterIDs._Online_Pin_First_Char_Timeout, chArrParamData: [Byte](chArrOnlinePinFirstCharTimeout.utf8), dataLen: chArrOnlinePinFirstCharTimeout.count)

                let chArrOnlinePinInterCharTimeout: String = String(format: "%d",tData!.m_iOnlinePinInterCharTimeout)
                _ = insertTLV(iParamID: ParameterIDs._Online_Pin_Interchar_Timeout, chArrParamData: [Byte](chArrOnlinePinInterCharTimeout.utf8), dataLen: chArrOnlinePinInterCharTimeout.count)

                let chArrMinPinLength: String = String(format: "%d",tData!.m_iMinPinLength)
                _ = insertTLV(iParamID: ParameterIDs._Min_Pin_Length, chArrParamData: [Byte](chArrMinPinLength.utf8), dataLen: chArrMinPinLength.count)

                let chArrMaxPinLength: String = String(format: "%d",tData!.m_iMaxPinLength)
                _ = insertTLV(iParamID: ParameterIDs._Max_Pin_Length, chArrParamData: [Byte](chArrMaxPinLength.utf8), dataLen: chArrMaxPinLength.count)

                let chArrDisplayMenuTimeout: String = String(format: "%d",tData!.m_iDisplayMenuTimeout)
                _ = insertTLV(iParamID: ParameterIDs._Display_Menu_Timeout, chArrParamData: [Byte](chArrDisplayMenuTimeout.utf8), dataLen: chArrDisplayMenuTimeout.count)

                let chArrDisplayMessasgeTimeout: String = String(format: "%d",tData!.m_iDisplayMessasgeTimeout)
                _ = insertTLV(iParamID: ParameterIDs._Display_Message_Timeout, chArrParamData: [Byte](chArrDisplayMessasgeTimeout.utf8), dataLen: chArrDisplayMessasgeTimeout.count)

                let chArrHotKeyConfirmationTimeout: String = String(format: "%d",tData!.m_iHotKeyConfirmationTimeout)
                _ = insertTLV(iParamID: ParameterIDs._HotKey_Confirmation_Timeout, chArrParamData: [Byte](chArrHotKeyConfirmationTimeout.utf8), dataLen: chArrHotKeyConfirmationTimeout.count)
              }
          }
    }
    
    
    //MARK:- SetPineKeyExchangeRequest()
    func SetPineKeyExchangeRequest()
    {
     /*
        CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Inside SetPineKeyExchangeRequest");
        m_iOffsetBuffer.value = 0;
        ByteArray chArrBuffer = new ByteArray();
        chArrBuffer.m_ByteArray = new byte[2000];

        PineKeyInjectionApp pineKeyInjectionApp = PineKeyInjectionApp.GetInstance();
        CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "m_iPKExchangePacketNumber[%d]", m_iPKExchangePacketNumber);
        ISO320PineKeyExchangeChangeNum enumPKExchangePacketNumber = ISO320PineKeyExchangeChangeNum.values()[m_iPKExchangePacketNumber-1];
        switch (enumPKExchangePacketNumber) {
            case START_SESSION:
                pineKeyInjectionApp.iStartSessionRequest(chArrBuffer, m_iOffsetBuffer);
                break;

            /*case GET_MYTOKEN_REQ:
                pineKeyInjectionApp.iGetAuthTokenRequest(chArrBuffer, m_iOffsetBuffer);
                break;

            case GET_PMKDATA_REQ:
                pineKeyInjectionApp.iGetPMKDataRequest(chArrBuffer, m_iOffsetBuffer);
                break;*/

            case RESETKEY_REQ:
                pineKeyInjectionApp.iGetPTMKRequest(AppConst.RESET_PTMK, chArrBuffer, m_iOffsetBuffer);
                break;

            case RENEWKEY_REQ:
                pineKeyInjectionApp.iGetPTMKRequest(AppConst.RENEW_PTMK, chArrBuffer, m_iOffsetBuffer);
                break;

            case END_SESSION:
                pineKeyInjectionApp.iEndSessionRequest(chArrBuffer, m_iOffsetBuffer);

                //The 1 is sent if response is set in RENEW Response parsing.
                CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "m_iResPKExchangePacket[%d]", m_iResPKExchangePacket);

                if(m_iResPKExchangePacket != 0x00){
                    addField(IsoFieldConstant.ISO_FIELD_7, "01".getBytes(), true);
                    CGlobalData GlobalData = CGlobalData.GetInstance();
                    GlobalData.ReadMasterParamFile(CStateMachine.m_context);
                    GlobalData.m_sMasterParamData.m_bIsPKExchangePacket = false;
                    GlobalData.WriteMasterParamFile(CStateMachine.m_context);
                }else{
                    addField(IsoFieldConstant.ISO_FIELD_7, "00".getBytes(), true);
                }
                break;

            default:
                break;
        }

        System.arraycopy(chArrBuffer.m_ByteArray,0,m_chArrBuffer,0,m_iOffsetBuffer.value);
        addLLLCHARData(IsoFieldConstant.ISO_FIELD_61,m_chArrBuffer,m_iOffsetBuffer.value);
 */
    }
    
    
    //MARK:- ProcessPineKeyExchangeResponse() -> Bool
    func ProcessPineKeyExchangeResponse() -> Bool
    {
        return true;
     /*
        debugPrint("Inside ProcessPineKeyExchangeResponse")

        if(!bitmap[61 - 1]){
            debugPrint("ERROR No Field 61 !!")
            m_iChangeNumber += 1
            return false
        }

        m_iOffsetBuffer = 0

        let p: [Byte] = data[61-1]
        let length: Int = len[61-1]

        var iRetVal: Bool = false;

        debugPrint("field 61 len[%d]", length)
        if(length <= 0)
        {
            m_iChangeNumber += 1
            return false;
        }

        PineKeyInjectionApp  pineKeyInjectionApp = PineKeyInjectionApp.GetInstance();
        
        CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "m_iPKExchangePacketNumber[%d]", m_iPKExchangePacketNumber);
        ISO320PineKeyExchangeChangeNum enum_obj = ISO320PineKeyExchangeChangeNum.values()[m_iPKExchangePacketNumber-1];
        switch (enum_obj) {
            case START_SESSION:
                iRetVal = pineKeyInjectionApp.iStartSessionResponse(p, length);
                CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "iStartSessionResponse ret[%s]", Boolean.toString(iRetVal));
                if(iRetVal != true)
                {
                    m_iChangeNumber++;
                }
                else{
                    m_iPKExchangePacketNumber++;
                }
                break;
            case RESETKEY_REQ:
                iRetVal = pineKeyInjectionApp.iGetPTMKResponse(AppConst.RESET_PTMK, p, length);
                CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "iGetPTMKResponse RESET ret[%s]", Boolean.toString(iRetVal));
                if(iRetVal != true){
                    m_iPKExchangePacketNumber = ISO320PineKeyExchangeChangeNum.END_SESSION.getValue();
                }
                else{
                    m_iPKExchangePacketNumber++;
                }
                break;

            case RENEWKEY_REQ:
                iRetVal = pineKeyInjectionApp.iGetPTMKResponse(AppConst.RENEW_PTMK, p, length);
                CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "iGetPTMKResponse RENEW ret[%s]", Boolean.toString(iRetVal));
                if(iRetVal != true){
                    m_iPKExchangePacketNumber = ISO320PineKeyExchangeChangeNum.END_SESSION.getValue();
                    m_iResPKExchangePacket = 0x00;
                }
                else{
                    m_iPKExchangePacketNumber++;
                    //response is set to 1 only if this packet exchange is successful.
                    //otherwise it would be an error.
                    m_iResPKExchangePacket = 0x01;
                }
                break;
            case END_SESSION:
                iRetVal = pineKeyInjectionApp.iEndSessionResponse(p, length);
                CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "iEndSessionResponse ret[%s]", Boolean.toString(iRetVal));
                m_iChangeNumber++;
                break;
            default:
                break;
        }
        return iRetVal;*/
    }
    
    //MARK:- getEDCAppVersion(isoFeild: Int) -> [Byte]
    func getEDCAppVersion(isoFeild: Int) -> [Byte]
    {
        var chEDCAppVersion: [Byte] = []
        
        if(bitmap[isoFeild - 1]){
            chEDCAppVersion = [Byte](repeating: 0x00, count: len[isoFeild - 1])
            chEDCAppVersion = Array(data[isoFeild - 1][0 ..< chEDCAppVersion.count])
            
            debugPrint("getEDCAppVersion [\(String(bytes: chEDCAppVersion, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))]")
        }
        return chEDCAppVersion;
    }
    
    //MARK:- ProcessEDCAppDownload -> Bool
    func ProcessEDCAppDownload() -> Bool {
        debugPrint("Inside ProcessEDCAppDownload")

        var bFileisOK: Bool = false;
        let p: [Byte] = data[61 - 1]
        var _: Int = len[61 - 1]

         //---FIELD 53 Download Counters --------------------------------
        let pFieldEDCAppDef: [Byte] = data[53 - 1]
        let ilength: Int = len[53 - 1]
         if(ilength >= 2) {
            
            var offset: Int = 0
            self.m_bCurrentPacketCount = Int64(pFieldEDCAppDef[offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64(pFieldEDCAppDef[offset] & 0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = Int64(pFieldEDCAppDef[offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64(pFieldEDCAppDef[offset] & 0x000000FF)
            offset += 1

            debugPrint("Response->Field 53 found ")
            debugPrint("m_bCurrentPacketCount[\(m_bCurrentPacketCount)], m_bTotalPacketCount[\(m_bTotalPacketCount)]");
         }

         if (self.m_bCurrentPacketCount == 0x01) {
             debugPrint("*******EDC APP DWN Data******")
             debugPrint("Delete Old Files")
            
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.TEMEDCAPPFILE)
             _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DWNLDEDCAPPINFO)
             _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DWNLDEDCAPPCHUNKINFO)
         } else {
             if (bitmap[54 - 1]) {
                 debugPrint("EDC APP DWN NOT First packet")
                
                let chEDCAppVersion: [Byte] = getEDCAppVersion(isoFeild: 54)
                if (!chEDCAppVersion.isEmpty) {
                    debugPrint("m_chDownloadingEDCAppVersion[\(String(bytes: m_chDownloadingEDCAppVersion, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))], chEDCAppVersion[\(String(bytes: m_chDownloadingEDCAppVersion, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)))]")
                    
                    if (!chEDCAppVersion.elementsEqual(m_chDownloadingEDCAppVersion)) {
                         debugPrint("version Mismatch")
                         return false
                     }
                 } else {
                     debugPrint("ERROR Cannot retrive EDC APP version!!")
                     return false;
                 }
             } else {
                 debugPrint("Field 54 not found !!")
                 return false;
             }
         }


         /***************************************************************************************
          * if(this->m_bCurrentPacketCount == this->m_bTotalPacketCount)
          * extract field 59 from 330 and save in our parameter file as EDC APP version.
          * for new request. As of now host might not be sending this ---- to check with host team
          *
          * We will check weather EDC APP file is present before renaming temp file to EDC APP file
          ****************************************************************************************/
         if (self.m_bCurrentPacketCount == self.m_bTotalPacketCount) {
             
            let globalData = GlobalData.singleton
            do{
                _ = try FileSystem.AppendFile(strFileName: FileNameConstants.TEMEDCAPPFILE, with: p)
            }
            catch{
                fatalError("Error in AppendFile, strFileName: \(FileNameConstants.TEMEDCAPPFILE)")
            }
            
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DWNLDEDCAPPINFO)
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DWNLDEDCAPPCHUNKINFO)

             //Check SHA1 for Downloaded File
             if(bitmap[62-1] && (len[62-1] == 20))
             {
                 debugPrint("bFileisOK bitmap[ISO_FIELD_62-1] ");
                var uchArrFileSha1Downloaded = [Byte](repeating: 0x00, count: len[62 - 1])
                uchArrFileSha1Downloaded = Array(data[62 - 1][0 ..< len[62 - 1]])
                
                //System.arraycopy(data[62-1],0,uchArrFileSha1Downloaded,0,len[62-1]);
                let uchArrFileSha1Calculated: [Byte] = FileSystem.GetSHA1ofFile(strFileName: FileNameConstants.TEMEDCAPPFILE)!
                
                if(uchArrFileSha1Calculated.isEmpty && uchArrFileSha1Downloaded.elementsEqual(uchArrFileSha1Calculated))
                 {
                     debugPrint("bFileisOK memcmp SHA1 OK")
                     bFileisOK = true
                 }else{
                     globalData.m_csFinalMsgDisplay58 = "New App SHA1 Mismatch" + "\n" + "Initialization Failed!!!"
                    
                    debugPrint("chArrFileSha1Download[\(String(bytes: uchArrFileSha1Downloaded, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))], chArrFileSha1Calculated[\(String(bytes: uchArrFileSha1Calculated, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))]")
                 }
             }

             debugPrint("bFileisOK[\(bFileisOK)]")
             if (bFileisOK) {
                _ = FileSystem.RenameFile(strNewFileName: FileNameConstants.EDCAPPFILE, strFileName: FileNameConstants.TEMEDCAPPFILE)
                debugPrint("EDC APP file created")

                 //Store EMV Par Version
                let chEDCAppVersion: [Byte] = getEDCAppVersion(isoFeild: 54)
                
                if (!chEDCAppVersion.isEmpty) {
                    let strAppVersion: String = String(bytes: chEDCAppVersion, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if (!strAppVersion.elementsEqual(globalData.m_sMasterParamData!.m_strAppVersion)) {
                         debugPrint("APP Version Different Activating Software")

                        let bAppStatus: [Byte] = [1]
                         
                        do{
                            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.EDCINITSTATUS, with: bAppStatus)
                        }
                        catch
                        {
                            fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.EDCINITSTATUS)")
                        }
                         //Save the login info
                         if (globalData.m_bIsLoggedIn) {
                            let currentLoginInfo: [Byte] = TransactionUtils.objectToByteArray(obj: globalData.m_objCurrentLoggedInAccount)
                            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.LOGININFO);
                            do{
                                _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.LOGININFO, with: currentLoginInfo)
                            }
                            catch
                            {
                                fatalError("Error in ReWrteFile, strFileName: \(FileNameConstants.LOGININFO)")
                            }
                            
                            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.CURRENT_PIN)
                            
                            do{
                                _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.CURRENT_PIN, with: [Byte](globalData.m_strCurrentLoggedInUserPIN.utf8))
                            }
                            catch
                            {
                                fatalError("Error in ReWrteFile, strFileName: \(FileNameConstants.CURRENT_PIN)")
                            }
                         }
                        let bArrUserInfoData: [Byte] = FileSystem.ReadFile(strFileName: FileNameConstants.USERINFOFILE)!;
                        do{
                            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.USERINFOFILE, with: bArrUserInfoData)
                        }
                        catch
                        {
                            fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.USERINFOFILE)")
                        }
                        let strConnectionDataFile: String = String(format: "%s.plist", FileNameConstants.CONNECTIONDATAFILENAME)
                         
                        let bArrConxData: [Byte] = FileSystem.ReadFile(strFileName: strConnectionDataFile)!
                        
                        do{
                            _ = try FileSystem.ReWriteFile(strFileName: strConnectionDataFile, with: bArrConxData)
                        }
                        catch
                        {
                            fatalError("Error in ReWriteFile, strFileName: \(strConnectionDataFile)")
                        }
                        
                        let conx = CConx.singleton
                         _ = conx.disconnect();

                        if (!PlatFormUtils.installApk(fileName: FileNameConstants.EDCAPPFILE)){
                            
                             globalData.m_csFinalMsgDisplay58 = "New App Installation Failed" + "\n" + "Initialization Failed!!!";
                            //TODO : yet to Implement - Format for directory
                            //CFileSystem.FormatExternalDirectory();
                             return false;
                         }
                     }
                 }
             }
         } else {
            do{
                _ = try FileSystem.AppendFile(strFileName: FileNameConstants.TEMEDCAPPFILE, with: p)
            }
            catch{
                fatalError("Error in AppendFile, strFileName: \(FileNameConstants.TEMEDCAPPFILE)")
            }
            _ = SaveEDCAppDownloadInfoVersion();
             bFileisOK = true;
         }
         return bFileisOK;
     }

    
    
    //MARK:- SaveEDCAppDownloadInfoVersion() -> Int
    func SaveEDCAppDownloadInfoVersion() -> Int
    {
        if(bitmap[54 - 1])          //save EDCApp Version
        {
            var currentEDCAppDwndInfo = CurrentEDCAppDownloadingInfo()
            let chEDCAppVersion: [Byte] = getEDCAppVersion(isoFeild: 54)
            if(!chEDCAppVersion.isEmpty)
            {
                //carry out str to ul and store it in the database or file system as the case may be this will sent in next time in field 59 in all the next requests.
                currentEDCAppDwndInfo.chVersion = Array(chEDCAppVersion[0 ..< AppConstant.MAX_APP_VERSION_LEN])
                //System.arraycopy(chEDCAppVersion,0,currentEDCAppDwndInfo.chVersion,0,AppConst.MAX_APP_VERSION_LEN);
                currentEDCAppDwndInfo.currentpacketCount = Int(m_bCurrentPacketCount)
                currentEDCAppDwndInfo.totalpacketCount = Int(m_bTotalPacketCount)

                debugPrint("Saving Download info !!");
                debugPrint("Version[\(String(bytes: currentEDCAppDwndInfo.chVersion, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))], CurrPkt[\(currentEDCAppDwndInfo.currentpacketCount)], TotPkt [\(currentEDCAppDwndInfo.totalpacketCount)]")

                var list_of_Item: [CurrentEDCAppDownloadingInfo] = []
                list_of_Item.append(currentEDCAppDwndInfo)
                do{
                    _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.DWNLDEDCAPPINFO, with: list_of_Item)
                }
                catch{
                    fatalError("Error in ReWriteFile \(FileNameConstants.DWNLDEDCAPPINFO)")
                }
            }else{
                debugPrint("ERROR Cannot retrive EDC App version!!");
            }
        }else{
            debugPrint("EDC App version info Not Present!!");
        }

        if(bitmap[45 - 1])          //Save chunksize
        {
            var chArrTempChunkSize = [Byte](repeating: 0x00, count: data[45 - 1].count)
            chArrTempChunkSize = Array(data[45 - 1][0 ..< data[45 - 1].count])
            //System.arraycopy(data[45-1],0,chArrTempChunkSize,0,data[45-1].length);

            var ulChunkSize: Int64
            ulChunkSize = Int64(String(bytes: chArrTempChunkSize, encoding: .utf8)!)!
            debugPrint("ulChunkSize[\(ulChunkSize)]")
            
            var list_of_Item: [Int64] = []
            list_of_Item.append(ulChunkSize);
            do{
                _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.DWNLDEDCAPPCHUNKINFO, with: list_of_Item)
            }
            catch {
                fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.DWNLDEDCAPPCHUNKINFO)")
            }
            
        }
        return AppConstant.TRUE;
    }
    
    //MARK:- SetEDCAppDownLoadVersion()
    func SetEDCAppDownLoadVersion()
    {
        if(FileSystem.IsFileExist(strFileName: FileNameConstants.DWNLDEDCAPPINFO))
        {
            debugPrint("DWNLDEDCAPPINFO file exists")
            var lastEDCAppDwndInfo = CurrentEDCAppDownloadingInfo()
            
            let list_of_Items: [CurrentEDCAppDownloadingInfo] = FileSystem.ReadFile(strFileName: FileNameConstants.DWNLDEDCAPPINFO)!
            
            if(!list_of_Items.isEmpty){
                lastEDCAppDwndInfo = list_of_Items[0]
            }
            
            m_chDownloadingEDCAppVersion = Array(lastEDCAppDwndInfo.chVersion[0 ..< AppConstant.MAX_APP_VERSION_LEN])
            m_bCurrentPacketCount = Int64(lastEDCAppDwndInfo.currentpacketCount);                //Get current packet count
            m_bTotalPacketCount   = Int64(lastEDCAppDwndInfo.totalpacketCount);
            //Get Total packet count
            debugPrint("Earlier m_chDownloadingEDCAppVersion[\(String(bytes: m_chDownloadingEDCAppVersion, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))]")
            debugPrint("m_chDownloadingEDCAppVersion[\(String(bytes: m_chDownloadingEDCAppVersion, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))], m_bCurrentPacketCount[\(m_bCurrentPacketCount)],m_bTotalPacketCount[\(m_bTotalPacketCount)]")
            
            _ = self.addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_54, data1: m_chDownloadingEDCAppVersion,length: AppConstant.MAX_APP_VERSION_LEN)
            debugPrint("Req->Setting field 54")
        }
        
        if(FileSystem.IsFileExist(strFileName: FileNameConstants.DWNLDEDCAPPCHUNKINFO))
        {
            var ulChunkSize = Long()
            let list_of_Item: [Long] = FileSystem.ReadFile(strFileName: FileNameConstants.DWNLDEDCAPPCHUNKINFO)!
            if (!list_of_Item.isEmpty){
                ulChunkSize = list_of_Item[0]
            }
            debugPrint("Earlier ulChunkSize[\(ulChunkSize.value)]")
            var chArrTempChunkSize: String = "\(ulChunkSize.value)"
            
            chArrTempChunkSize = TransactionUtils.StrLeftPad(data: chArrTempChunkSize, length: 6 , padChar: "0")
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_45, data1: [Byte](chArrTempChunkSize.utf8), bcd: true)
            debugPrint("Req->Setting field 45")
        }
    }
    
    //MARK:- ProcessPrintingLocationDetailsDownload() -> Bool
    func ProcessPrintingLocationDetailsDownload() -> Bool
    {
        debugPrint("Inside ProcessPrintingLocationDetailsDownload")

        if(!bitmap[61 - 1])
        {
            debugPrint("ERROR No Field 61 !!")
            return false;
        }

        let p: [Byte] = data[61-1];
        let length: Int = len[61-1];

        debugPrint("field 61 len[\(length)]")
        
        if(length <= 0){
            return false
        }
        
        debugPrint(length, p)
        var st_POSPrintinglocationDetailsList: [StPOSPrintinglocationDetails] = []

        var iOffset: Int = 0
        
        while(length > iOffset)
        {
            if(m_ulTotalTxnwisePrintingLocationIterator >= AppConstant.MAX_TXN_PRINTING_LOCATION_PARAMETERES)
            {
                debugPrint("MAX_TXN_PRINTING_LOCATION_PARAMETERES reached");
                break;
            }

            var stPosLocation = StPOSPrintinglocationDetails()
            
            var iLocalStructLen: Int = 0;
            iLocalStructLen |=  Int(p[iOffset] << 8) & Int(0x0000FF00)
            iOffset += 1
            iLocalStructLen |=  Int(p[iOffset] & 0x000000FF)
            iOffset += 1
            
            var iLocalOffset: Int = iOffset

            //2 Byte HAT Txn Type
            stPosLocation.iHATTxnType |=  Int(p[iLocalOffset] <<  8) & Int(0x0000FF00)
            iLocalOffset += 1
            stPosLocation.iHATTxnType |=  Int(p[iLocalOffset] & 0x000000FF)
            iLocalOffset += 1
            
            //2 Byte Bin High
            stPosLocation.iCSVTxnType |=  Int(p[iLocalOffset] <<  8) & Int(0x0000FF00)
            iLocalOffset += 1
            stPosLocation.iCSVTxnType |=  Int(p[iLocalOffset] & 0x000000FF)
            iLocalOffset += 1
            
            //1 Byte EMV AccountType
            stPosLocation.iPrintingFlag = Int(p[iLocalOffset] & 0x000000FF)

            m_ulTotalTxnwisePrintingLocationIterator += 1

            debugPrint("POS Location it[\(m_ulTotalTxnwisePrintingLocationIterator)]")
            debugPrint("iHATTxnType[\(stPosLocation.iHATTxnType)], iCSVTxnType[\(stPosLocation.iCSVTxnType)], iPrintingFlag[\(stPosLocation.iPrintingFlag)]")

            st_POSPrintinglocationDetailsList.append(stPosLocation)
            
            //Local length define the length of local structure
            iOffset += iLocalStructLen
        }
        
        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.POSPRINTINGLOCATIONFILE, with: st_POSPrintinglocationDetailsList)
        }
        catch{
            fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.POSPRINTINGLOCATIONFILE)")
        }
    
        return true
    }
    
    
    //MARK:- CISO320MsgD()
    func CISO320MsgD()
    {
        // TODO Auto-generated method stub
        m_iChangeNumber = ISO320ChangeNumberConstants.HOST_PVM_DOWNLOAD
        
        //m_ulArrChargeSlipIdAdd = null;
        //m_ulArrChargeSlipIdDelete = null;
        //m_ulArrImageIdAdd = null;
        //m_ulArrImageIdDelete = null;
        //m_ulArrMessageIdAdd = null;
        //m_ulArrColoredImageIdAdd = null;
        //m_ulArrColoredImageIdDelete = null;
        //m_ulArrMessageIdDelete = null;
        //m_ObjArrParameterData = null;
        m_bCurrentPacketCount = 0x00;
        m_ulCountOfChargeSlipIdAdd          = 0x00;
        m_ulCountOfChargeSlipIdDelete    = 0x00;
        m_ulTotalChargeSlipTemplateAdded = 0x00;

        m_ulCountOfImageIdAdd              = 0x00;
        m_ulCountOfImageIdDelete          = 0x00;
        m_ulTotalImagesAdded              = 0x00;
        m_ulCountOfColoredImageIdAdd              = 0x00;
        m_ulCountOfColoredImageIdDelete          = 0x00;
        m_ulTotalColoredImagesAdded              = 0x00;


        m_ulCountOfMessageIdAdd             = 0x00;
        m_ulCountOfMessageIdDelete         = 0x00;
        m_ulTotalMessagesAdded             = 0x00;

        m_ulParameterIterator              = 0x00;
        m_ulLastParameterId              = 0x00;

        m_ulDownloadingPvmVersion          = 0;
        m_ulBinRangeIterator            = 0x00;
        m_ulCSVTxnMapIterator            = 0x00;

        m_ulTxnBinIterator            = 0x00;
        m_ulTotalCSVTxnIgnAmtListIterator = 0x00;
        
        //m_chDownloadingEDCAppVersion = null;
        //m_ulArrFixedChargeSlipIdAdd = null;
        //m_ulArrFixedChargeSlipIdDelete = null;
        //m_ulArrlibIdAdd = null;
        //m_ulArrlibIdDelete = null;
        //m_ulArrMINIPVMIdAdd = null;
        //m_ulArrMINIPVMIdDelete = null;
    }

    //MARK:- ProcessAIDEMVTXNTYPEDownload()
    func ProcessAIDEMVTXNTYPEDownload() -> Bool
    {
        debugPrint("Inside ProcessAIDEMVTXNTYPEDownload")

        if(!bitmap[61 - 1])
        {
            debugPrint("ERROR No Field 61 !!")
            return false;
        }

        let p: [Byte] = data[61-1];
        let length: Int = len[61-1];

        debugPrint("field 61 len[\(length)]")
        if(length <= 0){
            return false;
        }
        
        debugPrint(length, p)

        var stAIDTxnMapList: [StAIDTxnMapingDetails] = []
        var iOffset: Int = 0
        
        while(length > iOffset)
        {
            var stAIDTxnMap = StAIDTxnMapingDetails()
            
            var iLocalStructLen: Int = 0
            iLocalStructLen |= Int(p[iOffset] << 8) & Int(0x0000FF00)
            iOffset += 1
            iLocalStructLen |=  Int(p[iOffset] & 0x000000FF)
            iOffset += 1

            var iLocalOffset: Int = iOffset;

            //1 byte AId len
            let AIDlen: Int = Int(p[iLocalOffset] & 0x000000FF)
            iLocalOffset += 1
            
            debugPrint("AIDlen[\(AIDlen)], iLocalOffset[\(iLocalOffset)]");

            if(AIDlen > 0)
            {
                stAIDTxnMap.ucAID = Array(p[iLocalOffset ..< iLocalOffset + AIDlen])
                //System.arraycopy(p,iLocalOffset,stAIDTxnMap.ucAID,0,AIDlen);
                iLocalOffset += AIDlen
            }

            //2 Byte CSV  tXN TYPE
            stAIDTxnMap.iCSVTxnType |= Int(p[iLocalOffset] << 8) & Int(0x0000FF00)
            iLocalOffset += 1
            stAIDTxnMap.iCSVTxnType |=  Int(p[iLocalOffset] & 0x000000FF)
            iLocalOffset  += 1
            
            //2 Byte HAT Txn Type
            stAIDTxnMap.iHATTxnType |= Int(p[iLocalOffset] << 8) & Int(0x0000FF00)
            iLocalOffset += 1
            stAIDTxnMap.iHATTxnType |= Int(p[iLocalOffset] & 0x000000FF)
            iLocalOffset += 1

            //1 Byte EMV TXN TYPE
            stAIDTxnMap.iEMVTxnType = Int(p[iLocalOffset] & 0x000000FF)
            iLocalOffset += 1

            debugPrint("stAIDTxnMap ucAID[\(String(bytes: stAIDTxnMap.ucAID, encoding: String.Encoding.utf8)!.trimmingCharacters(in: .whitespacesAndNewlines))]")
            
            debugPrint("iHATTxnType[\(stAIDTxnMap.iHATTxnType)], iCSVTxnType[\(stAIDTxnMap.iCSVTxnType)], iEMVTxnType[\(stAIDTxnMap.iEMVTxnType)]")

            stAIDTxnMapList.append(stAIDTxnMap)
            
            //Local length define the length of local structure
            iOffset += iLocalStructLen;
        }
        
        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.TEMPAIDEMVTXNTYPEFILE,with: stAIDTxnMapList)
        }
        catch{
            fatalError("Error in ReWriteFile, strFileName: \(FileNameConstants.TEMPAIDEMVTXNTYPEFILE)")
        }
        return true;
    }
    
    
    //MARK:- ProcessAIDEMVTXNTYPEDateTime()
    func ProcessAIDEMVTXNTYPEDateTime()
    {
        debugPrint("Inside ProcessAIDEMVTXNTYPEDateTime")
        let globalData = GlobalData.singleton

        if(!bitmap[43-1])
        {
            debugPrint("ERROR No Feild 43 !!")
            return;
        }

        _ = globalData.ReadMasterParamFile()

        //if previous version is same as current version then do nothing
        if(globalData.m_sMasterParamData!.m_strAIDEMVTXNTYPEDownloadDate == String(bytes: data[43 - 1], encoding: String.Encoding.utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)){
            return;
        }

        //if temp bin range file exist, then replace BINRANGE file with temp.
        if(FileSystem.IsFileExist(strFileName: FileNameConstants.TEMPAIDEMVTXNTYPEFILE))
        {
            debugPrint("TEMPAIDEMVTXNTYPEFILE exists")
            let tempStruct: [StAIDTxnMapingDetails] = []
            
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.POSAIDEMVTXNTYPEFILE, with: tempStruct)
            if(true == FileSystem.RenameFile(strNewFileName: FileNameConstants.POSAIDEMVTXNTYPEFILE,strFileName: FileNameConstants.TEMPAIDEMVTXNTYPEFILE))
            {
               debugPrint("POSAIDEMVTXNTYPEFILE rename done")

            }else{
                debugPrint("POSAIDEMVTXNTYPEFILE rename failed")
            }
        }

        // if version is different(the file is downloaded) then set reset flag and bin range changed flag true.
        // the bin range changed flag will ensure in loading files to sort bin range file.
        globalData.m_sMasterParamData!.m_strAIDEMVTXNTYPEDownloadDate = String(bytes: data[43 - 1], encoding: String.Encoding.utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        debugPrint("m_strAIDEMVTXNTYPEDownloadDate[\(globalData.m_sMasterParamData!.m_strAIDEMVTXNTYPEDownloadDate)]")
        
        //TODO:- State Machine Class needed
        //CStateMachine  Statemachine = CStateMachine.GetInstance();
        //Statemachine.m_ResetTerminal = true;

        _ = globalData.WriteMasterParamFile()
    }

    
    //MARK:- ProcessTxnTypeFlagsMappingDownload
    func ProcessTxnTypeFlagsMappingDownload() -> Bool
    {
        debugPrint("Inside ProcessTxnTypeFlagsMappingDownload")

        if(!bitmap[61 - 1])
        {
            debugPrint("ERROR No Field 61 !!")
            return false
        }

        let p: [Byte] = data[61-1]
        let length: Int = len[61-1]

        debugPrint("field 61 len[%d]", length)
        
        if(length <= 0){
            return false;
        }
        debugPrint(length,p)

        var stTxnTypeFlagsList: [StTxnTypeFlagsMappingDetails] = []
        
        var iOffset: Int = 0
        while(length > iOffset)
        {
            var stTxnTypeFlags = StTxnTypeFlagsMappingDetails()

            var iLocalStructLen: Int = 0
            iLocalStructLen |= Int(p[iOffset] <<  8) & Int(0x0000FF00)
            iOffset += 1
            iLocalStructLen |=  Int(p[iOffset] & 0x000000FF)
            iOffset += 1
            
            var iLocalOffset: Int = iOffset

            //1 byte HAT len
            var _: Int = Int(p[iLocalOffset] & 0x000000FF)  //set hardcoded 4 at Payment Controller
            iLocalOffset += 1
            
            //HAT Txn Type
            stTxnTypeFlags.iHATTxnType |= Int(p[iLocalOffset] << 24) & Int(0xFF000000)
            iLocalOffset += 1
            stTxnTypeFlags.iHATTxnType |= Int(p[iLocalOffset] << 16) & Int(0x00FF0000)
            iLocalOffset += 1
            stTxnTypeFlags.iHATTxnType |= Int(p[iLocalOffset] << 8) & Int(0x0000FF00)
            iLocalOffset += 1
            stTxnTypeFlags.iHATTxnType |=  Int(p[iLocalOffset] & 0x000000FF)
            iLocalOffset += 1


            //1 byte CSV len
            var _: Int = Int(p[iLocalOffset] & 0x000000FF)   //set hardcoded 4 at Payment Controller
            iLocalOffset += 1
            
            //CSV Txn Type
            stTxnTypeFlags.iCSVTxnType |= Int(p[iLocalOffset] << 24) & Int(0xFF000000)
            iLocalOffset += 1
            stTxnTypeFlags.iCSVTxnType |= Int(p[iLocalOffset] << 16) & Int(0x00FF0000)
            iLocalOffset += 1
            stTxnTypeFlags.iCSVTxnType |= Int(p[iLocalOffset] << 8) & Int(0x0000FF00)
            iLocalOffset += 1
            stTxnTypeFlags.iCSVTxnType |=  Int(p[iLocalOffset] & 0x000000FF)
            iLocalOffset += 1


            //1 Byte Card Data Encryption
            stTxnTypeFlags.bIsCardDataEncryptionNeeded = (p[iLocalOffset] & 0xFF) == 0x01;
            iLocalOffset += 1
            
            //1 Byte Printing Location
            stTxnTypeFlags.iPrintingLocation = Int(p[iLocalOffset] & 0x000000FF)
            iLocalOffset += 1
            
            
            //1 Byte Ignore Amount Enabled
            stTxnTypeFlags.bIsIgnoreAmountEnabled = (p[iLocalOffset] & 0x000000FF) == 0x01;
            iLocalOffset += 1
                        
            //1 Byte Signature Required
            stTxnTypeFlags.bIsSignatureRequired = (p[iLocalOffset] & 0x000000FF) == 0x01;
            iLocalOffset += 1
            
            
            debugPrint("iHATTxnType[\(stTxnTypeFlags.iHATTxnType)], iCSVTxnType[\(stTxnTypeFlags.iCSVTxnType)]")
            debugPrint("bIsCardDataEncryptionNeeded[\(stTxnTypeFlags.bIsCardDataEncryptionNeeded)]");
            debugPrint("iPrintingLocation[\(stTxnTypeFlags.iPrintingLocation)]");
            debugPrint("bIsIgnoreAmountEnabled[\(stTxnTypeFlags.bIsIgnoreAmountEnabled)]");
            debugPrint("bIsSignatureRequired[\(stTxnTypeFlags.bIsSignatureRequired)]")

            stTxnTypeFlagsList.append(stTxnTypeFlags)
            
            //Local length define the length of local structure
            iOffset += iLocalStructLen;
        }

        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.TEMPTXNTYPEFLAGSMAPPINGFILE, with: stTxnTypeFlagsList)
        }
        catch{
            fatalError("Error in ReWriteFile \(FileNameConstants.TEMPTXNTYPEFLAGSMAPPINGFILE)")
        }
        return true;
    }
    
    
    //MARK:- ProcessTxnTypeFlagsMappingDateTime
    func ProcessTxnTypeFlagsMappingDateTime()
    {
        debugPrint("Inside ProcessTxnTypeFlagsMappingDateTime")
        let globalData = GlobalData.singleton
        
        if(!bitmap[43-1])
        {
            debugPrint("ERROR No Field 43 !!")
            return;
        }
        
        _ = globalData.ReadMasterParamFile()
        
        //if previous version is same as current version then do nothing
        if(globalData.m_sMasterParamData!.m_strTxnTypeFlagsMappingDownloadDate == String(bytes: data[43 - 1], encoding: String.Encoding.utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)){
            return;
        }
        //if temp bin range file exist, then replace BINRANGE file with temp.
        if(FileSystem.IsFileExist(strFileName: FileNameConstants.TEMPTXNTYPEFLAGSMAPPINGFILE))
        {
            let stTxnTypeFlagsList: [StTxnTypeFlagsMappingDetails] = []
            debugPrint("TEMPTXNTYPEFLAGSMAPPINGFILE exists")
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.POSTXNTYPEFLAGSMAPPINGFILE, with: stTxnTypeFlagsList)
            
            if(true == FileSystem.RenameFile(strNewFileName: FileNameConstants.POSTXNTYPEFLAGSMAPPINGFILE,strFileName: FileNameConstants.TEMPTXNTYPEFLAGSMAPPINGFILE))
            {
                debugPrint( "POSTXNTYPEFLAGSMAPPINGFILE rename done")
            }else{
                debugPrint("POSTXNTYPEFLAGSMAPPINGFILE rename failed");
            }
        }
        // if version is different(the file is downloaded) then set reset flag and bin range changed flag true.
        // the bin range changed flag will ensure in loading files to sort bin range file.
        globalData.m_sMasterParamData!.m_strTxnTypeFlagsMappingDownloadDate = String(bytes: data[43 - 1], encoding: String.Encoding.utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        debugPrint("m_strTxnTypeFlagsMappingDownloadDat[\(globalData.m_sMasterParamData!.m_strTxnTypeFlagsMappingDownloadDate)]")
        
        //TODO:- //TO DO: State Machine Class needed
        //CStateMachine Statemachine = CStateMachine.GetInstance();
        //Statemachine.m_ResetTerminal = true;
        
        _ = globalData.WriteMasterParamFile()
    }
    
    //MARK:- ProcessMINIPVMDownload -> Bool
    func ProcessMINIPVMDownload() -> Bool
    {
        debugPrint("Inside ProcessMINIPVMDownload")
        let p: [Byte] = data[61-1]
        let length: Int = len[61-1]

        //Check for Field 61 present or not
        if(length <= 0){
            debugPrint("Field 61 not present")
            return false;
        }

        debugPrint(p, length)

        let pFieldPVMDef: [Byte] = data[53-1]
        let ilength: Int = len[53-1]
        
        if(ilength >= 2){
            var offset: Int = 0
            self.m_bCurrentPacketCount = Int64(pFieldPVMDef[offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64(pFieldPVMDef[offset] & 0x000000FF)
            offset += 1

            self.m_bTotalPacketCount = Int64(pFieldPVMDef[offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64(pFieldPVMDef[offset] & 0x000000FF)
            offset += 1

            debugPrint("Response->Field 53 found in ProcessMINIPVMDownload")
        }

        let tempData: [Int64] = []
        
        if(self.m_bCurrentPacketCount == 0x01){
            debugPrint("*******MINIPVM download*****")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_INFO,"******MINIPVM download*********");
            
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDMINIPVMINFO, with: tempData)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.TEMMINIPVMFILE, with: tempData)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DWNLDCHUNKINFO, with: tempData)
        }

        if(self.m_bCurrentPacketCount == self.m_bTotalPacketCount)
        {
            //12-07-2012 isomsg buffer is directly written to file
            do{
                _ = try FileSystem.AppendFile(strFileName: m_chTempMINIPVMfileName, with: p)
            }
            catch{
                fatalError("Error in AppendFile \(m_chTempMINIPVMfileName)")
            }
            
            let chMINIPVMIdName: String = String(format: "%d.plist",m_ulArrMINIPVMIdAdd[m_ulTotalMINIPVMAdded])
            _ = FileSystem.DeleteFile(strFileName: chMINIPVMIdName, with: tempData)
            
            debugPrint("chMINIPVMIdName[\(chMINIPVMIdName)]")
            if(true == FileSystem.RenameFile(strNewFileName: chMINIPVMIdName,strFileName: m_chTempMINIPVMfileName))
            {
                /** Append to ADDED LIST File **/
                var long_obj: [Long] = []
                long_obj[0].value = m_ulArrMINIPVMIdAdd[m_ulTotalMINIPVMAdded]
                
                do{
                    _ = try FileSystem.AppendFile(strFileName: FileNameConstants.ADDMINIPVMLIST, with: long_obj)
                }
                catch{
                    fatalError("Error in AppendFile \(FileNameConstants.ADDMINIPVMLIST)")
                }
            }
        }
        else
        {
            //12-07-2012 isomsg buffer is directly written to file
            do{
            _ = try FileSystem.AppendFile(strFileName: m_chTempMINIPVMfileName, with: p)
            }
            catch{
                fatalError("Error in AppendFile \(m_chTempMINIPVMfileName)")
            }
            
            _ = SaveMINIPVMDownloadInfoVersion(minipvmId: m_ulArrMINIPVMIdAdd[m_ulTotalMINIPVMAdded])
        }
        return true;
    }
    
    //MARK:- SetMINIPVMDownLoadData(MinipvmId: Int64)
    func SetMINIPVMDownLoadData(MinipvmId: Int64)
    {
        m_chTempMINIPVMfileName = String(format: "tm%08d",m_ulArrMINIPVMIdAdd[m_ulTotalMINIPVMAdded])
        m_chTempMINIPVMDwnFile = String(format: "dw%08d",m_ulArrMINIPVMIdAdd[m_ulTotalMINIPVMAdded])
        m_chTempMINIPVMChunkFile = String(format: "ck%08d",m_ulArrMINIPVMIdAdd[m_ulTotalMINIPVMAdded])
        
        debugPrint("tmp MINIPVM file name[\(m_chTempMINIPVMfileName)]")
        debugPrint("tmp dwn MINIPVM file name[\(m_chTempMINIPVMDwnFile)]")
        
        if(FileSystem.IsFileExist(strFileName: m_chTempMINIPVMDwnFile))
        {
            debugPrint("\(m_chTempMINIPVMDwnFile) file exists")
            
            var lastMINIPVMDwndInfo = CurrentDownloadingInfo()
            var list_of_Items: [CurrentDownloadingInfo] = []
            
            list_of_Items = FileSystem.ReadFile(strFileName: m_chTempMINIPVMDwnFile)!
            
            if(!list_of_Items.isEmpty)
            {
                lastMINIPVMDwndInfo = list_of_Items[0]
            }
            
            //Check if the image to be downloaded is same as to be previously downloaded
            if(lastMINIPVMDwndInfo.id == MinipvmId)
            {
                m_bCurrentPacketCount = Int64(lastMINIPVMDwndInfo.currentpacketCount)
                m_bTotalPacketCount   = Int64(lastMINIPVMDwndInfo.totalpacketCount)
                
                debugPrint("MINIPVM[\(MinipvmId)], m_bCurrentPacketCount[\(m_bCurrentPacketCount)], m_bTotalPacketCount[\(m_bTotalPacketCount)]")
            }else{
                debugPrint("MINIPVM not matched")
            }
        }else
        {
           debugPrint("MINIPVM not file exists")
        }
        
        if(FileSystem.IsFileExist(strFileName: m_chTempMINIPVMChunkFile))
        {
            var ulChunkSize = Long()
            let list_of_Items: [Long] = FileSystem.ReadFile(strFileName: m_chTempMINIPVMChunkFile)!
            
            if (!list_of_Items.isEmpty)
            {
                ulChunkSize = list_of_Items[0]
            }
            
            debugPrint("Earlier ulChunkSize[\(ulChunkSize.value)]")
            let chArrTempChunkSize: String = String(format: "%06d",ulChunkSize.value)
            
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_45, data1: [Byte](chArrTempChunkSize.utf8), bcd: true)
            debugPrint("Req->Setting field 45")
        }
    }
    
    //MARK:- SaveMINIPVMDownloadInfoVersion(minipvmId: Int64) -> Int
    func SaveMINIPVMDownloadInfoVersion(minipvmId: Int64) -> Int
    {
        var currentMINIPVMDwndInfo = CurrentDownloadingInfo()
        debugPrint("Saving MINI PVM Download info !!")
        
        currentMINIPVMDwndInfo.id = minipvmId
        currentMINIPVMDwndInfo.currentpacketCount = Int(m_bCurrentPacketCount)
        currentMINIPVMDwndInfo.totalpacketCount = Int(m_bTotalPacketCount)
        
        var list_of_Item: [CurrentDownloadingInfo] = []
        list_of_Item.append(currentMINIPVMDwndInfo)
        
        do{
            _ = try FileSystem.ReWriteFile(strFileName: m_chTempMINIPVMDwnFile, with: list_of_Item)
        }
        catch{
            fatalError("Error in ReWriteFile \(m_chTempMINIPVMDwnFile)")
        }
        
        if(bitmap[45 - 1])
        {
            var chArrTempChunkSize = [Byte](repeating: 0x00, count: 13)
       
            chArrTempChunkSize = Array(data[45 - 1][0 ..< len[45 - 1]])
            //System.arraycopy(data[45-1],0,chArrTempChunkSize,0,len[45-1]);
            var ulChunkSize: Int64
            ulChunkSize = Int64(String(bytes: chArrTempChunkSize, encoding: String.Encoding.utf8)!)!
            
            debugPrint("ulChunkSize[\(ulChunkSize)]")
            
            var list_of_Items: [Int64] = []
            list_of_Items.append(ulChunkSize)
            
            do {
                _ = try FileSystem.ReWriteFile(strFileName: m_chTempMINIPVMChunkFile, with: list_of_Items)
            }
            catch{
                fatalError("")
            }
        }
        return AppConstant.TRUE;
    }
    
    //MARK:- ProcessCSVTxnTypeMiniPvmMappingDownload() -> Bool
    func ProcessCSVTxnTypeMiniPvmMappingDownload() -> Bool
    {
        debugPrint("Inside ProcessCSVTxnTypeMiniPvmMappingDownload")

        if(!bitmap[61 - 1])
        {
            debugPrint("ERROR No Field 61")
            return false;
        }

        let p: [Byte] = data[61-1];
        let length: Int = len[61-1];

        debugPrint("Field 61 len[\(length)]")
        if(length <= 0){
            return false;
        }
        debugPrint(length, p)

        var iOffset: Int = 0
        while(length > iOffset)
        {
            var stTxnTypeMiniPvm: [StCSVTxnTypeMiniPvmMappingDetails] = []

            //CSV Txn Type
            stTxnTypeMiniPvm[0].iCsvTxnType |= Int(p[iOffset] <<  24) & Int(0xFF000000)
            iOffset += 1
            stTxnTypeMiniPvm[0].iCsvTxnType |= Int(p[iOffset] <<  16) & Int(0x00FF0000)
            iOffset += 1
            stTxnTypeMiniPvm[0].iCsvTxnType |= Int(p[iOffset] <<  8)  & Int(0x0000FF00)
            iOffset += 1
            stTxnTypeMiniPvm[0].iCsvTxnType |=  Int(p[iOffset] & 0x000000FF)
            iOffset += 1

            //MiniPvm Id
            stTxnTypeMiniPvm[0].MiniPVMid |= Int64(p[iOffset] <<  24) & Int64(0xFF000000)
            iOffset += 1
            stTxnTypeMiniPvm[0].MiniPVMid |= Int64(p[iOffset] <<  16) & Int64(0x00FF0000)
            iOffset += 1
            stTxnTypeMiniPvm[0].MiniPVMid |= Int64(p[iOffset] <<  8)  & Int64(0x0000FF00)
            iOffset += 1
            stTxnTypeMiniPvm[0].MiniPVMid |=  Int64(p[iOffset] & 0x000000FF)
            iOffset += 1
            
            debugPrint("iCSVTxnType[\(stTxnTypeMiniPvm[0].iCsvTxnType)]")
            debugPrint("MiniPVMid[\(stTxnTypeMiniPvm[0].MiniPVMid)]")
           
            do{
                _ = try FileSystem.AppendFile(strFileName: FileNameConstants.TEMPCSVTXNTYPEMINIPVMMAPPINGFILE, with: stTxnTypeMiniPvm)
            }
            catch
            {
                fatalError("Error in AppendFile, fileName: \(FileNameConstants.TEMPCSVTXNTYPEMINIPVMMAPPINGFILE)")
            }
            debugPrint("iOfsset \(iOffset)")
        }

        return true;
    }
    
    //MARK:- ProcessIsPasswordMappingDownload() -> Bool
    func ProcessIsPasswordMappingDownload() -> Bool
    {
        let p: [Byte] = data[61-1];
        let length: Int = len[61-1];

        debugPrint("Field 61 len \(length)")
        if(length <= 0){
            return false;
        }

        var stIsPasswordList = [StISPASSWORDDetails]()
        var iOffset: Int = 0
        
        while(length > iOffset)
        {
            if(m_ulTotalTxnwiseIsPasswordIterator >= AppConstant.MAX_TXN_ISPASSWORD_PARAMETERES)
            {
                debugPrint("MAX_TXN_ISPASSWORD_PARAMETERES reached")
                //CLogger.TraceLog(TRACE_DEBUG, "MAX_TXN_ISPASSWORD_PARAMETERES reached");
                break;
            }
            
            var stIsPassword = StISPASSWORDDetails()

            var iLocalStructLen: Int = 0;
            var iLocalOffset: Int = iOffset;

            //4 Byte HAT Txn Type
            stIsPassword.iHATTxnType  = Int(p[iLocalOffset] << 24) & Int(0xFF000000)
            iLocalOffset += 1
            stIsPassword.iHATTxnType |= Int(p[iLocalOffset] << 16) & Int(0x00FF0000)
            iLocalOffset += 1
            stIsPassword.iHATTxnType |= Int(p[iLocalOffset] <<  8) & Int(0x0000FF00)
            iLocalOffset += 1
            stIsPassword.iHATTxnType |=  Int(p[iLocalOffset] & 0x000000FF)
            iLocalOffset += 1
            iLocalStructLen+=4;

            //4 Byte CSV txn type
            stIsPassword.iCSVTxnType  = Int(p[iLocalOffset] << 24) & Int(0xFF000000)
            iLocalOffset += 1
            stIsPassword.iCSVTxnType |= Int(p[iLocalOffset] << 16) & Int(0x00FF0000)
            iLocalOffset += 1
            stIsPassword.iCSVTxnType |= Int(p[iLocalOffset] <<  8) & Int(0x0000FF00)
            iLocalOffset += 1
            stIsPassword.iCSVTxnType |=  Int(p[iLocalOffset] & 0x000000FF)
            iLocalOffset += 1
            iLocalStructLen += 4;

            //1 Byte iIsPASSFlag
            stIsPassword.iIsPASSFlag = ((p[iLocalOffset] & 0xFF) == 0x30) ? 0 : 1
            iLocalOffset += 1
            iLocalStructLen += 1

            m_ulTotalTxnwiseIsPasswordIterator += 1

            debugPrint("Password it[\(m_ulTotalTxnwiseIsPasswordIterator)]")
            debugPrint("iHATTxnType[\(stIsPassword.iHATTxnType)], iCSVTxnType[\(stIsPassword.iCSVTxnType)]")
            debugPrint("iIsPASSFlag[\(stIsPassword.iIsPASSFlag)]")

            stIsPasswordList.append(stIsPassword);

            //Local length define the length of local structure
            iOffset += iLocalStructLen;
        }

        _ = FileSystem.DeleteFile(strFileName: FileNameConstants.ISPASSWORDMAPPINGFILE, with: stIsPasswordList)
        
        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.ISPASSWORDMAPPINGFILE, with: stIsPasswordList)
        }
        catch
        {
            fatalError("Error in RewriteFile: \(FileNameConstants.ISPASSWORDMAPPINGFILE)")
        }
        
        return true;
    }
    
    
    //MARK: - ProcessISPasswordDateTime()
    func ProcessISPasswordDateTime()
    {
        debugPrint("ProcessISPasswordDateTime")
        let globalData = GlobalData.singleton

        if(!bitmap[43-1])
        {
            debugPrint("ERROR No Field 43 !!")
            return;
        }

        _ = globalData.ReadMasterParamFile()

        //if previous version is same as current version then do nothing
        if(globalData.m_sMasterParamData!.m_strISPasswordDownloadDate == String(bytes: data[43 - 1], encoding: String.Encoding.utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)){
            return
        }

        // if version is different(the file is downloaded) then set reset flag and bin range changed flag true.
        // the bin range changed flag will ensure in loading files to sort bin range file.
        globalData.m_sMasterParamData!.m_strISPasswordDownloadDate = String(bytes: data[43 - 1], encoding: String.Encoding.utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        debugPrint("m_strISPasswordDownloadDate[\(globalData.m_sMasterParamData!.m_strISPasswordDownloadDate)]")
        
        //TODO:- State Machine Class needed
        //CStateMachine Statemachine = CStateMachine.GetInstance();
        //Statemachine.m_ResetTerminal = true;

        _ = globalData.WriteMasterParamFile()
    }
    
    
    //MARK: - ProcessCSVTxnTypeMiniPvmMappingDateTime()
    func ProcessCSVTxnTypeMiniPvmMappingDateTime()
    {
        debugPrint("ProcessCSVTxnTypeMiniPvmMappingDateTime")
        //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"Inside ProcessCSVTxnTypeMiniPvmMappingDateTime");
        let globalData = GlobalData.singleton

        if(!bitmap[43-1])
        {
            debugPrint("ERROR No Field 43 !!")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR,"ERROR No Feild 43 !!");
            return;
        }

       _ = globalData.ReadMasterParamFile()

        //if previous version is same as current version then do nothing
         if(globalData.m_sMasterParamData!.m_strCsvTxnTypeMiniPvmMappingDownloadDate == String(bytes: data[43 - 1], encoding: String.Encoding.utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)){
            return;
        }

        //if temp file exist, then replace file with temp file.
        if(FileSystem.IsFileExist(strFileName: FileNameConstants.TEMPCSVTXNTYPEMINIPVMMAPPINGFILE))
        {
            debugPrint("TEMPCSVTXNTYPEMINIPVMMAPPINGFILE exists")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "TEMPCSVTXNTYPEMINIPVMMAPPINGFILE exists");
            
            let tempStruct: [StCSVTxnTypeMiniPvmMappingDetails]  = []
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.CSVTXNTYPEMINIPVMMAPPINGFILE, with: tempStruct);
            if(true == FileSystem.RenameFile(strNewFileName: FileNameConstants.CSVTXNTYPEMINIPVMMAPPINGFILE,strFileName:  FileNameConstants.TEMPCSVTXNTYPEMINIPVMMAPPINGFILE))
            {
                debugPrint("CSVTXNTYPEMINIPVMMAPPINGFILE rename done")
                //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "CSVTXNTYPEMINIPVMMAPPINGFILE rename done");
            }else{
                debugPrint("CSVTXNTYPEMINIPVMMAPPINGFILE rename failed")
                //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "CSVTXNTYPEMINIPVMMAPPINGFILE rename failed");
            }
        }

        // if version is different(the file is downloaded) then set reset flag and bin range changed flag true.
        // the bin range changed flag will ensure in loading files to sort bin range file.
        
        globalData.m_sMasterParamData!.m_strCsvTxnTypeMiniPvmMappingDownloadDate = String(bytes: data[43 - 1], encoding: String.Encoding.utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        debugPrint("m_strCsvTxnTypeMiniPvmMappingDownloadDate\(globalData.m_sMasterParamData!.m_strCsvTxnTypeMiniPvmMappingDownloadDate)")
        
        //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"m_strCsvTxnTypeMiniPvmMappingDownloadDate[%s]", GlobalData.m_sMasterParamData.m_strCsvTxnTypeMiniPvmMappingDownloadDate);

        //TODO:- State Machine Class needed
        //CStateMachine Statemachine = CStateMachine.GetInstance();
        //Statemachine.m_ResetTerminal = true;

        _ = globalData.WriteMasterParamFile()
    }

    //MARK:- RemoveCsvTxnTypeMiniPvmMappingFile()
    func RemoveCsvTxnTypeMiniPvmMappingFile()
    {
        debugPrint("Inside RemoveCsvTxnTypeMiniPvmMappingFile")
        //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"Inside CsvTxnTypeMiniPvmMappingFile");
        let globalData = GlobalData.singleton

        if(!bitmap[43-1])
        {
            debugPrint("ERROR No Field 43!!")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR,"ERROR No Feild 43 !!");
            return;
        }

        _ = globalData.ReadMasterParamFile()

        //if previous version is same as current version then do nothing
        if(globalData.m_sMasterParamData!.m_strCsvTxnTypeMiniPvmMappingDownloadDate == String(bytes: data[43 - 1], encoding: String.Encoding.utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)){
            return;
        }

        let tempStruct: [StCSVTxnTypeMiniPvmMappingDetails] = []
        _ = FileSystem.DeleteFile(strFileName: FileNameConstants.CSVTXNTYPEMINIPVMMAPPINGFILE, with: tempStruct)
    }
    
    //MARK:- ProcessLogShippingDetailsDownload()
    func ProcessLogShippingDetailsDownload() -> Bool
    {
        let p: [Byte] = data[61-1]
        let length: Int = len[61-1]

        debugPrint("field 61 len[\(length)]")
        //CLogger.TraceLog(TRACE_DEBUG, "field 61 len[%d]", length);
        
        if(length <= 0){
            return false;
        }

        var ObjCred = AutoLogShippingCredential()
        let sAutoParamsCred: [AutoLogShippingCredential] = FileSystem.ReadFile(strFileName: FileNameConstants.AUTOLOGSHIPMENTSMTPCREDENTIAL)!
        if(sAutoParamsCred.count > 0) {
            ObjCred = sAutoParamsCred[0]
        }

        var Obj = AutoLogShippingParams()
        let sAutoParams: [AutoLogShippingParams] = FileSystem.ReadFile(strFileName: FileNameConstants.AUTOLOGSHIPMENTFILE)!
        if(sAutoParamsCred.count > 0) {
            Obj = sAutoParams[0]
        }
    
        var iOffset: Int = 0
        while(length > iOffset)
        {
            let iTag: Int = Int(p[iOffset])
            iOffset += 1
            let ilength: Int = Int(p[iOffset])
            iOffset += 1
            var bData = [Byte](repeating: 0x00, count: ilength)
            bData = Array(p[iOffset ..< iOffset + ilength])
            //System.arraycopy(p, iOffset, bData, 0, ilength);
            iOffset += ilength;

            switch (iTag)
            {
                case 0x01:
                    ObjCred.Hostname = String(bytes: bData, encoding: String.Encoding.utf8)!
                    break;
                case 0x02:
                    var iPort: Int = Int(bData[0] & 0xFF)
                    iPort = (iPort << 8)
                    iPort |= Int(bData[1] & 0xFF)
                    ObjCred.port = iPort;
                    break;
                case 0x03:
                    ObjCred.Username = String(bytes: bData, encoding:  String.Encoding.utf8)!
                    break;
                case 0x04:
                    ObjCred.Password = String(bytes: bData, encoding:  String.Encoding.utf8)!
                    break;
                case 0x05:
                    Obj.m_bLogEnabledFlag = bData[0] == 1 ? true : false
                    break;
                case 0x06:
                    Obj.m_iLogShipmentLevel = Int(bData[0])
                    break;
                case 0x07:
                    Obj.m_iLogShipmentRetentionDays = Int(bData[0])
                    break;
                case 0x08:
                    var iSize: Int = Int(bData[0] & 0xFF)
                    iSize = (iSize << 8);
                    iSize |= Int(bData[1] & 0xFF)
                    Obj.m_iLogShipmentRetentionSizeInMB = iSize;
                    break;
                case 0x09:
                    Obj.m_iLogShipmentFrequency = Int(bData[0])
                    break;
                case 0x0A:
                    Obj.m_iLogShipmentRetryCount = Int(bData[0])
                    break;
                case 0x0B:
                    var iRetryInterval: Int = Int(bData[0] & 0xFF)
                    iRetryInterval = iRetryInterval << 8
                    iRetryInterval |= Int(bData[1] & 0xFF)
                    Obj.m_iLogShipmentRetryInterval = iRetryInterval
                    break;
                case 0x0C:
                    Obj.m_strLogShipmentStartTime = String(bytes: bData, encoding:  String.Encoding.utf8)!
                    break;
                case 0x0D:
                    Obj.m_sLogShippingDirecetorypath = String(bytes: bData, encoding:  String.Encoding.utf8)!
                    break;
                case 0x0E:
                    Obj.m_strLogBlackListStartTime = String(bytes: bData, encoding:  String.Encoding.utf8)!
                    break;
                case 0x0F:
                    Obj.m_strLogBlackListEndTime = String(bytes: bData, encoding:  String.Encoding.utf8)!
                    break;
                case 0x10:
                    Obj.m_iAutoLogShippingEnabledFlag = Int(bData[0])
                    break;
                case 0x11:
                    var iMaxLogFileSize: Int = Int((bData[0] & 0xFF) << 24)
                    iMaxLogFileSize |= Int((bData[1] & 0xFF) << 16)
                    iMaxLogFileSize |= Int((bData[2] & 0xFF) << 8)
                    iMaxLogFileSize |= Int((bData[3] & 0xFF))
                    Obj.m_iMaxLogFileSize = iMaxLogFileSize;
                    break;
                case 0x12:
                    var iMaxLogFileCountOfADay: Int = Int((bData[0] & 0xFF) << 24)
                    iMaxLogFileCountOfADay |= Int((bData[1] & 0xFF) << 16)
                    iMaxLogFileCountOfADay |= Int((bData[2] & 0xFF) << 8)
                    iMaxLogFileCountOfADay |= Int(bData[3] & 0xFF)
                    Obj.m_iMaxLogFileCountOfADay = iMaxLogFileCountOfADay;
                    break;
                default:
                    break;
            }
        }

        var sNewAutoParams: [AutoLogShippingParams] = []
        sNewAutoParams.append(Obj)
        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.AUTOLOGSHIPMENTFILE, with: sNewAutoParams)
        }
        catch{
            fatalError("ReWriteFile : \(FileNameConstants.AUTOLOGSHIPMENTFILE)")
        }

        var sNewAutoCred: [AutoLogShippingCredential] = []
        sNewAutoCred.append(ObjCred)
        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.AUTOLOGSHIPMENTSMTPCREDENTIAL, with: sNewAutoCred)
        }
        catch{
            fatalError("ReWriteFile : \(FileNameConstants.AUTOLOGSHIPMENTFILE)")
        }
        
        return true;
    }
    
    
    //MARK:- ProcessLogShipingDtTime()
    func ProcessLogShipingDtTime() -> Bool
    {
        if(!bitmap[43-1]){
            debugPrint("Error No Field 43 !!")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR,"ERROR No Feild 43 !!");
            return false;
        }

        let globalData = GlobalData.singleton
        let strData = String(bytes: data[43 - 1], encoding: String.Encoding.utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //if previous version is same as current version then do nothing
        if(globalData.m_sMasterParamData!.m_strLogShippingDownloadDate == strData){
            return false;
        }

        _ = globalData.ReadMasterParamFile();
        globalData.m_sMasterParamData?.m_strLogShippingDownloadDate = strData
        _ = globalData.WriteMasterParamFile();

        //TODO:- State Machine Class needed
        //CStateMachine Statemachine = CStateMachine.GetInstance();
        //Statemachine.m_ResetTerminal = true;
        return true;
    }
    
    
    //MARK:- SaveAdServerHTLSync()
    func SaveAdServerHTLSync()
    {
        var llList: [Int64] = []
        for value in GlobalData.m_setAdServerHTL!.sorted()
        {
            llList.append(value)
        }
        
        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.MASTERHTLFILE, with: llList)
        }
        catch{
            fatalError("ReWriteFile : \(FileNameConstants.MASTERHTLFILE)")
        }
    }

    //MARK:- ProcessAdServerHTLSync()
    func ProcessAdServerHTLSync()
    {
        debugPrint("Inside ProcessAdServerHTLSync")
        //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_INFO,"Inside ProcessAdServerHTLSync");

        let p: [Byte] = data[61-1]
        var length: Int = len[61-1]
        var chArrTemp: [Byte]
        var iOffset = 0x00

        //Check for Field 61 present or not
        if(length <= 0){
            debugPrint("Field 61 not Present")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"Field 61 not present");
            return;
        }

        if(self.m_bCurrentPacketCount == 0x00){
            let llList: [Int64] = []
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.ADDHTLLIST, with: llList)
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DELETEHTLLIST, with: llList)
        }

        while(length > 0){
            let iActionType: Int = Int(p[iOffset])
            iOffset += 1
            var temp = [Byte](repeating: 0x00, count: 4)
            temp = Array(p[iOffset ..< iOffset + 4])
            //System.arraycopy(p,iOffset,temp,0,4);
            
            chArrTemp = TransactionUtils.bcd2a(temp, 4)!
            iOffset += 4;

            //LONG llHTL = new LONG();
            var llHTL: Int64 = 0
            let strHTLVal: String = String(bytes: chArrTemp, encoding: String.Encoding.utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //String strHTLVal = new String(chArrTemp).trim();
            llHTL = Int64(strHTLVal)!

            debugPrint("HTL from Host [\(strHTLVal)], Action[\((iActionType==AppConstant.ACTION_ADD ? "ACTION_ADD" : iActionType==AppConstant.ACTION_DELETE ? "ACTION_DELETE" : "Unknown ACtion"))]")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"HTL from Host[%s], Action[%s]",strHTLVal,(iActionType==AppConst.ACTION_ADD?"ACTION_ADD":iActionType==AppConst.ACTION_DELETE?"ACTION_DELETE":"Unknown ACtion"));

            let bCheck: Bool = (GlobalData.m_setAdServerHTL?.contains(llHTL))!
            if(iActionType == AppConstant.ACTION_ADD)
            {
                if(!bCheck)
                {
                    GlobalData.m_setAdServerHTL?.insert(llHTL)
                }
                else
                {
                    debugPrint("HTL \(strHTLVal) already exists")
                    //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"HTL "+strHTLVal+" already exist");
                }
            }
            else{
                if(bCheck)
                {
                    GlobalData.m_setAdServerHTL?.remove(llHTL)
                }
                else
                {
                    debugPrint("HTL \(strHTLVal) does not exists")
                    //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"HTL "+strHTLVal+" doesn't exist");
                }
            }
            /**subtract 5 in each iteration,
             * 4 for each charge slip template Id one for actions ADD/DELETE.**/
            length -= 5
        }


        let pFieldPVMDef: [Byte] = data[53-1]
        let ilength: Int = len[53-1]
        if(ilength >= 2){
            var offset=0
            self.m_bCurrentPacketCount = Int64(pFieldPVMDef[offset] << 8 ) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64(pFieldPVMDef[offset] & 0x000000FF)
            
            offset += 1
            self.m_bTotalPacketCount = Int64(pFieldPVMDef[offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64(pFieldPVMDef[offset] & 0x000000FF)
            offset += 1
        }
    }
    
    //MARK:- PackUserInfoData()
    func PackUserInfoData()
    {
        debugPrint("PackUserInfoData")
        //CLogger.TraceLog(TRACE_DEBUG,"PackUserInfoData");
        var bLocalBuffer = [Byte](repeating: 0x00, count: 9000)
        var iOffset: Int = 0x00;

        let globalData = GlobalData.singleton
    
        globalData.m_mLoginAccountInfo.values.forEach{ value in
            let loginAccount: LOGINACCOUNTS = value
            if let _:LOGINACCOUNTS = loginAccount
            {
                var iLength: Int = 0;
                var iLocalOffset: Int = iOffset;
                bLocalBuffer[iLocalOffset] = Byte((AppConstant.TAG_TLV_LOGIN_INFO_OBJECT >> 8) & 0xFF)
                iLocalOffset += 1
                bLocalBuffer[iLocalOffset] = Byte(AppConstant.TAG_TLV_LOGIN_INFO_OBJECT & 0xFF)
                iLocalOffset += 1
                
                iLocalOffset += 2;      //We will fill the length after packing object

                //USER NAME
                bLocalBuffer[iLocalOffset] = Byte((AppConstant.TAG_TLV_LOGIN_INFO_USER_NAME >> 8) & 0xFF)
                iLocalOffset += 1
                bLocalBuffer[iLocalOffset] = Byte((AppConstant.TAG_TLV_LOGIN_INFO_USER_NAME) & 0xFF)
                iLocalOffset += 1
                
                iLength = loginAccount.m_strUserID.count
                bLocalBuffer[iLocalOffset] = Byte((iLength >> 8) & 0xFF)
                iLocalOffset += 1
                bLocalBuffer[iLocalOffset] = Byte(iLength & 0xFF)
                
                
                if(iLength > 0)
                {
                    let bCopyBytes: [Byte] = [Byte](loginAccount.m_strUserID.utf8)
                    bLocalBuffer[iLocalOffset ..< iLocalOffset + iLength] = ArraySlice<Byte>(bCopyBytes[0 ..< iLength])
                    
                    //System.arraycopy(loginAccount.m_strUserID.getBytes(), 0, bLocalBuffer, iLocalOffset, iLength);
                    iLocalOffset += iLength;
                }

                //PASSWORD
                bLocalBuffer[iLocalOffset] = Byte((AppConstant.TAG_TLV_LOGIN_INFO_PASSWORD_HASH >> 8) & 0xFF)
                iLocalOffset += 1
                bLocalBuffer[iLocalOffset] = Byte((AppConstant.TAG_TLV_LOGIN_INFO_PASSWORD_HASH) & 0xFF)
                iLocalOffset += 1
                
                iLength = loginAccount.m_strPIN.count
                bLocalBuffer[iLocalOffset] = Byte((iLength >> 8) & 0xFF)
                iLocalOffset += 1
                bLocalBuffer[iLocalOffset] = Byte((iLength) & 0xFF)
                iLocalOffset += 1
                
                if(iLength > 0)
                {
                    let bCopyBytes: [Byte] = [Byte](loginAccount.m_strPIN.utf8)
                    bLocalBuffer[iLocalOffset ..< iLocalOffset + iLength] = ArraySlice<Byte>(bCopyBytes[0 ..< iLength])
                    
                    //System.arraycopy(loginAccount.m_strPIN.getBytes(), 0, bLocalBuffer, iLocalOffset, iLength);
                    iLocalOffset += iLength
                }

                //creation date time
                bLocalBuffer[iLocalOffset] = Byte((AppConstant.TAG_TLV_LOGIN_INFO_CREATION_DATE_TIME >> 8) & 0xFF)
                iLocalOffset += 1
                bLocalBuffer[iLocalOffset] = Byte((AppConstant.TAG_TLV_LOGIN_INFO_CREATION_DATE_TIME) & 0xFF)
                iLocalOffset += 1
                
                iLength = loginAccount.m_strCreatedOn.count
                bLocalBuffer[iLocalOffset] = Byte((iLength >> 8) & 0xFF)
                iLocalOffset += 1
                bLocalBuffer[iLocalOffset] = Byte((iLength) & 0xFF)
                iLocalOffset += 1
                
                if(iLength > 0)
                {
                    let bCopyBytes: [Byte] = [Byte](loginAccount.m_strCreatedOn.utf8)
                    bLocalBuffer[iLocalOffset ..< iLocalOffset + iLength] = ArraySlice<Byte>(bCopyBytes[0 ..< iLength])
                    
                    //System.arraycopy(loginAccount.m_strCreatedOn.getBytes(), 0, bLocalBuffer, iLocalOffset, iLength);
                    iLocalOffset += iLength;
                }

                //User Role
                bLocalBuffer[iLocalOffset] = Byte((AppConstant.TAG_TLV_LOGIN_INFO_USER_ROLE >> 8) & 0xFF)
                iLocalOffset += 1
                bLocalBuffer[iLocalOffset] = Byte((AppConstant.TAG_TLV_LOGIN_INFO_USER_ROLE) & 0xFF)
                iLocalOffset += 1

                let strAccountType: String = String(loginAccount.m_sAccountType)
                iLength = strAccountType.count
                bLocalBuffer[iLocalOffset] = Byte((iLength >> 8) & 0xFF)
                iLocalOffset += 1
                bLocalBuffer[iLocalOffset] = Byte((iLength) & 0xFF)
                iLocalOffset += 1
                
                if(iLength > 0)
                {
                    let bCopyBytes: [Byte] = [Byte](strAccountType.utf8)
                    bLocalBuffer[iLocalOffset ..< iLocalOffset + iLength] = ArraySlice<Byte>(bCopyBytes[0 ..< iLength])
                    
                    //System.arraycopy(strAccountType.getBytes(), 0, bLocalBuffer, iLocalOffset, iLength);
                    iLocalOffset += iLength;
                }

                //GUID
                bLocalBuffer[iLocalOffset] = Byte((AppConstant.TAG_TLV_LOGIN_INFO_GUID >> 8) & 0xFF)
                iLocalOffset += 1
                bLocalBuffer[iLocalOffset] = Byte((AppConstant.TAG_TLV_LOGIN_INFO_GUID) & 0xFF)
                iLocalOffset += 1
                    
                iLength = loginAccount.m_strUUID.count
                bLocalBuffer[iLocalOffset] = Byte((iLength >> 8) & 0xFF)
                iLocalOffset += 1
                bLocalBuffer[iLocalOffset] = Byte((iLength) & 0xFF)
                iLocalOffset += 1
                    
                if(iLength > 0)
                {
                    let bCopyBytes: [Byte] = [Byte](loginAccount.m_strUUID.utf8)
                    bLocalBuffer[iLocalOffset ..< iLocalOffset + iLength] = ArraySlice<Byte>(bCopyBytes[0 ..< iLength])
                    
                    //System.arraycopy(loginAccount.m_strUUID.getBytes(), 0, bLocalBuffer, iLocalOffset, iLength);
                    iLocalOffset += iLength;
                }

                //pack packet length here
                let TotalLength: Int = iLocalOffset - iOffset - 4;
                bLocalBuffer[iOffset + 2] = Byte((TotalLength >> 8) & 0xFF)
                bLocalBuffer[iOffset + 3] = Byte((TotalLength) & 0xFF)
                iOffset = iLocalOffset;
            }
        }

        if(iOffset > 0)
        {
            let asciiBuf: [Byte] = TransactionUtils.bcd2a(bLocalBuffer, iOffset)!
            let strAsciiBuff: String = String(bytes: asciiBuf, encoding: String.Encoding.utf8)!

            _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_61, data1: bLocalBuffer, length: iOffset)
            debugPrint("Req->Setting field 61 length \(iOffset), data \(strAsciiBuff)")
            //CLogger.TraceLog(TRACE_DEBUG,"Req->Setting field 61 length "+iOffset);
        }

    }
    
    //MARK:- ProcessUserInfoSync()
    func ProcessUserInfoSync()
    {
        debugPrint("Inside ProcessUserInfoSync")
        //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_INFO,"Inside ProcessUserInfoSync");

        let p: [Byte] = data[61-1];
        let length: Int = len[61-1];
        var _: [Byte]

        //Check for Field 61 present or not
        if(length <= 0){
            debugPrint("Field 61 not Present")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"Field 61 not present");
            return;
        }

        if(self.m_bCurrentPacketCount == 0x00){
            let long: [Long] = []
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.ADDHTLLIST, with: long);
            _ = FileSystem.DeleteFile(strFileName: FileNameConstants.DELETEHTLLIST, with: long);
        }

        var iOffset: Int = 0
        let UserList: [TLVObject] = TLVObject.ParseTLVBuffer(buf: p, iOffset: &iOffset, length: length)!
        //List<TLVObject> UserList = TLVObject.ParseTLVBuffer(p, iOffset, length);
        
        if(UserList.count > 0)
        {
            for tlvObject in UserList {
                iOffset = 0;
                let userInfo: [TLVObject] = TLVObject.ParseTLVBuffer(buf: tlvObject.bData, iOffset: &iOffset, length: tlvObject.iLength)!
                if(userInfo.count > 0)
                {
                    var _: String = "";
                    let loginAccounts = LOGINACCOUNTS()
                    for userInfoTLV in userInfo {
                        switch (userInfoTLV.iTag)
                        {
                            case AppConstant.TAG_TLV_LOGIN_INFO_USER_NAME:
                                loginAccounts.m_strUserID =  String(bytes: userInfoTLV.bData, encoding: String.Encoding.utf8)!
                                break;
                            case AppConstant.TAG_TLV_LOGIN_INFO_PASSWORD_HASH:
                                loginAccounts.m_strPIN = String(bytes: userInfoTLV.bData, encoding: String.Encoding.utf8)!
                                break;
                            case AppConstant.TAG_TLV_LOGIN_INFO_CREATION_DATE_TIME:
                                loginAccounts.m_strCreatedOn  = String(bytes: userInfoTLV.bData, encoding: String.Encoding.utf8)!
                                break;
                            case AppConstant.TAG_TLV_LOGIN_INFO_USER_ROLE:
                                var value : Int8 = 0
                                for byte in userInfoTLV.bData {
                                    value = value << 8
                                    value = value | Int8(byte)
                                }
                                loginAccounts.m_sAccountType = value
                                break;
                            case AppConstant.TAG_TLV_LOGIN_INFO_GUID:
                                loginAccounts.m_strUUID  = String(bytes: userInfoTLV.bData, encoding: String.Encoding.utf8)!
                                break;
                            default:
                            break;
                        }
                            
                        loginAccountsMap[loginAccounts.m_strUserID] = loginAccounts
                        //loginAccountsMap.put(loginAccounts.m_strUserID, loginAccounts);
                    }
                }
            }
        }

        let pFieldPVMDef: [Byte] = data[53-1]
        let ilength: Int = len[53-1]
        if(ilength >= 2){
            var offset: Int = 0
            self.m_bCurrentPacketCount = Int64(pFieldPVMDef[offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bCurrentPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1
            self.m_bTotalPacketCount = Int64(pFieldPVMDef[offset] << 8) & Int64(0x0000FF00)
            offset += 1
            self.m_bTotalPacketCount |= Int64((pFieldPVMDef[offset]) & 0x000000FF)
            offset += 1
        }
    }
    
    //MARK:- SaveUserInfoSync()
    func SaveUserInfoSync()
    {
        let globalData = GlobalData.singleton
        globalData.m_mLoginAccountInfo.removeAll()
        globalData.m_mLoginAccountInfo = loginAccountsMap
        loginAccountsMap.removeAll()
        
        var loginAccountsList = [LOGINACCOUNTS]()
        globalData.m_mLoginAccountInfo.values.forEach{ value in
            
            loginAccountsList.append(value)
        }
        
        //List<LOGIN_ACCOUNTS> loginAccountsList = new ArrayList<>(globalData.m_mLoginAccountInfo.values());
        do
        {
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.USERINFOFILE, with: loginAccountsList);
        }
        catch{
            fatalError("ReWriteFile : \(FileNameConstants.USERINFOFILE)")
        }
    }
    
    //MARK:- ProcessContentDownload()
     func ProcessContentDownload() -> Bool
     {
         do
         {
            let p: [Byte] = data[61-1]
            let length: Int = len[61-1]
            let p_62: [Byte] = data[62-1]
            let _: Int = len[62-1]
            m_str_previous_ContentName = m_str_current_ContentName;
            //Check for Field 61 present or not

            if(length <= 0)
            {
                debugPrint("Field 61 not present for function ProcessingimageDownload_fromPC")
                //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"Field 61 not present for function ProcessImageDownload_fromPC");
                return false;
            }

            let pFieldEMVparDef: [Byte] = data[53-1]
            let ilength: Int  = len[53-1]

            if(ilength >= 2)
            {
                var offset: Int = 0
                self.m_bCurrentPacketCount = Int64((pFieldEMVparDef [offset]) << 8) & Int64(0x0000FF00)
                offset += 1
                self.m_bCurrentPacketCount |= Int64(((pFieldEMVparDef [offset])) & 0x000000FF)
                offset += 1
                self.m_bTotalPacketCount = Int64((pFieldEMVparDef [offset]) << 8) & Int64(0x0000FF00)
                offset += 1
                self.m_bTotalPacketCount |= Int64((pFieldEMVparDef [offset]) & 0x000000FF)
                offset += 1
                
                debugPrint("Response->Field 53 found")
                debugPrint("m_bCurrentPacketCount[\(m_bCurrentPacketCount)], m_bTotalPacketCount[\(m_bTotalPacketCount)]")
                //CLogger.TraceLog(TRACE_DEBUG,"Response->Field 53 found");
                //CLogger.TraceLog(TRACE_DEBUG,"m_bCurrentPacketCount[%d], m_bTotalPacketCount[%d]", m_bCurrentPacketCount ,m_bTotalPacketCount);
            }

            var imageDump = [Byte](repeating: 0x00, count: length)
            imageDump = Array(p[0 ..< length])
            //System.arraycopy(p,0,imageDump,0,length);
            var offset_62: Int = 0
            var content_id = [Byte](repeating: 0x00, count: 4)
            content_id = Array(p[0 ..< 4])
            
            offset_62 += 4;

            var l_content_id: Int64 = Int64(content_id[1] << 8) & Int64(0x0000FF00)  //Long.parseLong(new String(CUtils.bcd2a(content_id,4)),16);
            l_content_id |= Int64(content_id[0] & 0x000000FF)

            var _: String = String(format: "im%08d", l_content_id)

            let Content_Type_ID: Int = Int(p_62[offset_62]  & 0x000000FF)
            offset_62 += 1
            
            let change_Type: Int = Int(p_62[offset_62]  & 0x000000FF)
            offset_62 += 1
            let file_name_length: Int = Int(p_62[offset_62]  & 0x000000FF)
            offset_62 += 1
            
            var image_name = [Byte](repeating: 0x00, count: file_name_length)
            image_name = Array(p_62[offset_62 ..< offset_62 + file_name_length])
            
            //System.arraycopy(p_62,offset_62,image_name,0,file_name_length);

            let current_image_name: String = String(bytes: image_name, encoding: String.Encoding.utf8)!

            offset_62 += file_name_length;
            var received_sha1 = [Byte](repeating: 0x00, count: 20)
            received_sha1 = Array(p_62[offset_62 ..< offset_62 + 20])
            //System.arraycopy(p_62,offset_62,received_sha1,0,20);

            
            let calculated_sha1: [Byte] = ISO320Initialization.getSha1(image_content: imageDump)

             if (calculated_sha1 != received_sha1)
             {
                 return false;
             }

            var str_content_type: String
             switch(Content_Type_ID)
             {
                 case PCContentTypeID.IMAGE:
                     str_content_type = FileNameConstants.IMAGE;
                     break;
                 case PCContentTypeID.GIF:
                     str_content_type = FileNameConstants.GIF;
                     break;
                 case PCContentTypeID.VIDEO:
                     str_content_type = FileNameConstants.VIDEO;
                     break;
                 case PCContentTypeID.DOCUMENT:
                     str_content_type = FileNameConstants.DOCUMENT;
                     break;
                 case PCContentTypeID.MUSIC:
                     str_content_type = FileNameConstants.MUSIC;
                     break;
                 case PCContentTypeID.THEME:
                     str_content_type = FileNameConstants.THEME;
                     debugPrint("RESET on ERR \(str_content_type)")
                     break;
                 case PCContentTypeID.FONT:
                     str_content_type = FileNameConstants.FONT;
                     break;
                 default:
                     str_content_type = FileNameConstants.UKNOWN_CONTENT_TYPE;
                     debugPrint("Content ype ID Unknown[\(Content_Type_ID)]")
                     //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR,"Content Type ID Unknown[%d]",Content_Type_ID);
             }

            let temp_dir: String = str_content_type;

             m_str_current_ContentName = temp_dir + current_image_name;
            
             m_str_temp_ContentName = m_str_current_ContentName

             if(m_bCurrentPacketCount == 1)//if(str_previous_ImageName != str_current_ImageName && str_previous_ImageName != null && str_current_ImageName != null)
             {
                let bytes: [Byte] = []
                _ = FileSystem.DeleteFile(strFileName: m_str_temp_ContentName, with: bytes);
                 //An extra check to remove previous temp file
             }
             //m_str_temp_ContentName = m_str_current_ContentName + ".temp";

             switch(change_Type)
             {
                 case PCImageChangeType.NEW:
                    debugPrint("Updating bytes to File[\(m_str_current_ContentName)], [\(m_str_temp_ContentName)]")
                    //CLogger.TraceLog(TRACE_ERROR, "Apending bytes to File[%s]", m_str_temp_ContentName);
                    _ = try FileSystem.AppendFile(strFileName: m_str_temp_ContentName, with: imageDump)
                    break;
                 case PCImageChangeType.UPDATE:
                    debugPrint("Updating bytes to File[\(m_str_current_ContentName)], [\(m_str_temp_ContentName)]")
                    //CLogger.TraceLog(TRACE_ERROR, "Updating bytes to File[%s], [%s]", m_str_current_ContentName, m_str_temp_ContentName);
                    _ = FileSystem.DeleteFile(strFileName: m_str_current_ContentName, with: imageDump)
                    _ = try FileSystem.AppendFile(strFileName: m_str_temp_ContentName, with: imageDump)
                    break;
                 case PCImageChangeType.DELETE:
                    debugPrint("Deleting bytes to File[\(m_str_current_ContentName)], [\(m_str_temp_ContentName)]")
                    //CLogger.TraceLog(TRACE_ERROR, "Deleting bytes to File[%s]", m_str_current_ContentName);
                    _ = FileSystem.DeleteFile(strFileName: m_str_current_ContentName, with: imageDump)
                     break;
                default:
                    break;
            }
         }
         catch
         {
            debugPrint("Execption Occurred \(error)")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(e));
            return false;
         }
         return true;
     }
    
    //MARK:- ProcessContentDelete()
    func ProcessContentDelete() -> Bool
    {
        do
        {
            let p: [Byte] = data[62-1]
            let length: Int = len[62-1]
            m_str_previous_ContentName = m_str_current_ContentName

            var offset: Int = 0
            while(offset < length)
            {
                let content_type: Int = Int(p[offset] & 0x000000FF)
                
                offset += 1
                
                let change_type: Int = Int(p[offset] & 0x000000FF)
                offset += 1
                
                let file_name_length: Int = Int(p[offset] & 0x000000FF)
                offset += 1
                
                var image_name = [Byte](repeating: 0x00, count: file_name_length)

                image_name = Array(p[0 ..< file_name_length])
                //System.arraycopy(p, offset, image_name, 0, file_name_length);

                let current_image_name: String = String(bytes: image_name, encoding: String.Encoding.utf8)!

                var str_content_type: String
                switch(content_type)
                {
                    case PCContentTypeID.IMAGE:
                        str_content_type = FileNameConstants.IMAGE;
                        break;
                    case PCContentTypeID.GIF:
                        str_content_type = FileNameConstants.GIF;
                        break;
                    case PCContentTypeID.VIDEO:
                        str_content_type = FileNameConstants.VIDEO;
                        break;
                    case PCContentTypeID.DOCUMENT:
                        str_content_type = FileNameConstants.DOCUMENT;
                        break;
                    case PCContentTypeID.MUSIC:
                        str_content_type = FileNameConstants.MUSIC;
                        break;
                    case PCContentTypeID.THEME:
                        str_content_type = FileNameConstants.THEME;
                        break;
                    case PCContentTypeID.FONT:
                        str_content_type = FileNameConstants.FONT;
                        break;
                    default:
                        str_content_type = FileNameConstants.UKNOWN_CONTENT_TYPE;
                        debugPrint("Content type Unknown[\(content_type)]")
                        //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Content Type Unknown[%d]", content_type);
                }

                //m_str_current_ContentName = Environment.getExternalStorageDirectory() + File.separator + str_content_type + File.separator + current_image_name;

                m_str_current_ContentName = str_content_type + current_image_name
                if (change_type == PCImageChangeType.DELETE)
                {
                    debugPrint("Deleting bytes to File[\(m_str_current_ContentName)]")
                    //CLogger.TraceLog(TRACE_ERROR, "Deleting bytes to File[%s]", m_str_current_ContentName);
                    let bytes: [Byte] = []
                    _ = FileSystem.DeleteFile(strFileName: m_str_current_ContentName, with: bytes);
                }
                offset += file_name_length;
            }
        }
        catch
        {
            debugPrint("Exception Occurred : \(error)")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(e));
            return false;
        }

        return true;
    }
    
    //MARK:- getSha1(image_content: [Byte]) -> [Byte]
    private static func getSha1(image_content: [Byte]) -> [Byte] {
        let sha1: [Byte]
        do {
            
            let strSha1 = CryptoHandler.vFnGetSHA1(image_content)
            sha1 = [Byte](strSha1.utf8)
//            MessageDigest crypt = MessageDigest.getInstance("SHA-1");
//            crypt.reset();
//            crypt.update(image_content);
//            sha1 = crypt.digest();
        } catch {
        debugPrint("Exception Occurred : \(error)")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(e));
        }
        return sha1;
    }
    
    //MARK:- SetContentDownLoadInfo()
    func SetContentDownLoadInfo()
     {
         //If fileexist
        if(FileSystem.IsFileExist(strFileName: FileNameConstants.DWNLDCONTENTINFO))
         {
            debugPrint("DWNLDCONTENTINFO file exists")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"DWNLDCONTENTINFO file esxits");

            var lastContentDwndInfo = CurrentDownloadingInfo()
            let list_of_Items: [CurrentDownloadingInfo] = FileSystem.ReadFile(strFileName: FileNameConstants.DWNLDCONTENTINFO)!
            if(!list_of_Items.isEmpty)
            {
                 lastContentDwndInfo = list_of_Items[0]
            }

            m_ulDownloadingContentId = lastContentDwndInfo.id;
            m_bCurrentPacketCount = Int64(lastContentDwndInfo.currentpacketCount);
            m_bTotalPacketCount   = Int64(lastContentDwndInfo.totalpacketCount);
            
            debugPrint("m_ulDownloadingPvmVersion[\(m_ulDownloadingPvmVersion)], m_bCurrentPacketCouint[\(m_bCurrentPacketCount)], m_bCurrentPacketCount[\(m_bCurrentPacketCount)]")
            
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"m_ulDownloadingPvmVersion[%d], m_bCurrentPacketCount[%d], m_bTotalPacketCount[%d]", m_ulDownloadingContentId,m_bCurrentPacketCount,m_bTotalPacketCount);

            var newbuffer: String = String(m_ulDownloadingContentId)
            
            newbuffer = TransactionUtils.StrRightPad(data: newbuffer, length: 6 , padChar: " ")
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_44, data1: [Byte](newbuffer.utf8), bcd: false)
            debugPrint("Req->Setting field 44")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"Req->Setting field 44");
         }
         else
         {
            debugPrint("DWNLDCONTENTINFO file not exists")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR,"DWNLDCONTENTINFO not file esxits");
         }

        if(FileSystem.IsFileExist(strFileName: FileNameConstants.DWNLDCHUNKINFO))
         {
            var ulChunkSize = Long()
            let list_of_Item: [Long] = FileSystem.ReadFile(strFileName: FileNameConstants.DWNLDCHUNKINFO)!
            if(!list_of_Item.isEmpty)
            {
                ulChunkSize = list_of_Item[0]
            }
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"Earlier ulChunkSize[%d]",ulChunkSize.value);
            debugPrint("Earlier ulChunkSize[\(ulChunkSize.value)]")
            
            var chArrTempChunkSize: String = "\(ulChunkSize.value)"
            chArrTempChunkSize = TransactionUtils.StrLeftPad(data: chArrTempChunkSize, length: 6 , padChar: "0")
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_45, data1: [Byte](chArrTempChunkSize.utf8), bcd: true)
            debugPrint("Req->Setting field 45")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"Req->Setting field 45");
         }
     }
    
    //MARK:- SaveContentDownloadInfoVersion() -> Int
    func SaveContentDownloadInfoVersion() -> Int
    {
        if(bitmap[44 - 1])
        {
            var currentContentDwndInfo = CurrentDownloadingInfo()
            let ulContentVersion: Int64 = 0x00
            debugPrint("Saving Download into !!")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"Saving Download info !!");
            
            currentContentDwndInfo.id = ulContentVersion;
            currentContentDwndInfo.currentpacketCount =  Int(m_bCurrentPacketCount);
            currentContentDwndInfo.totalpacketCount =  Int(m_bTotalPacketCount);
            
            let list_of_Item: [CurrentDownloadingInfo] = [currentContentDwndInfo]
            //List<CurrentDownloadingInfo> list_of_Item = new ArrayList<>();
            //list_of_Item.add(currentContentDwndInfo);
            
            do{
              _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.DWNLDCONTENTINFO, with: list_of_Item)
            }catch
            {
                fatalError("ReWriteFile : \(FileNameConstants.DWNLDCONTENTINFO)")
            }
            
        }
        else
        {
            debugPrint("Warning Not saving download info !!")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR,"WARNING Not Saving Download info !!");
        }

        if(bitmap[45 - 1])
        {
            var chArrTempChunkSize = [Byte](repeating: 0x00, count: 13)
            
            chArrTempChunkSize = Array(data[45-1][0 ..< data[45-1].count])
            //System.arraycopy(data[45-1],0,chArrTempChunkSize,0,data[45-1].length);
            var ulChunkSize = Long()
            let sArrTempChunkSize = String(bytes: chArrTempChunkSize, encoding: String.Encoding.utf8)
            
            ulChunkSize.value = Int64(atol(sArrTempChunkSize))
            
            debugPrint("ulChunkSize[\(ulChunkSize)]")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG,"ulChunkSize[%d]",ulChunkSize.value);
            
            var list_of_Item: [Long] = []
            list_of_Item.append(ulChunkSize)
            do{
              _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.DWNLDCONTENTINFO, with: list_of_Item)
            }catch
            {
                fatalError("ReWriteFile : \(FileNameConstants.DWNLDCONTENTINFO)")
            }
        }
        return AppConstant.TRUE;
    }
}
