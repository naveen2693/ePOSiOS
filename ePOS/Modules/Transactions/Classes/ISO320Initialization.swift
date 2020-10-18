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
    var m_uchMessage = [Byte](repeating: 0x00, count: AppConst.MAX_MESSAGE_LEN + 1)
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
    var m_chDownloadingEDCAppVersion = [Byte](repeating: 0x00, count: AppConst.MAX_APP_VERSION_LEN + 1)// Parameter to store current
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

    var m_ulArrChargeSlipIdAdd = [Int64](repeating: 0x00, count: AppConst.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
    var m_ulArrChargeSlipIdDelete = [Int64](repeating: 0x00, count: AppConst.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
    var m_ulArrImageIdAdd = [Int64](repeating: 0x00, count: AppConst.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
    var m_ulArrImageIdDelete = [Int64](repeating: 0x00, count: AppConst.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
    var m_ulArrColoredImageIdAdd = [Int64](repeating: 0x00, count: AppConst.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
    var m_ulArrColoredImageIdDelete = [Int64](repeating: 0x00, count: AppConst.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
    
    // Dynamic chargeslip
    var m_ulArrFixedChargeSlipIdAdd = [Int64](repeating: 0x00, count: AppConst.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
    var m_ulArrFixedChargeSlipIdDelete = [Int64](repeating: 0x00, count: AppConst.MAX_COUNT_CHARGE_SLIP_IMAGES + 1) // MAX_COUNT_CHARGE_SLIP_IMAGES
    var m_ulArrMessageIdAdd = [Int64](repeating: 0x00, count: AppConst.MAX_COUNT_MESSAGES + 1) // MAX_COUNT_MESSAGES
    var m_ulArrMessageIdDelete = [Int64](repeating: 0x00, count: AppConst.MAX_COUNT_MESSAGES + 1) // MAX_COUNT_MESSAGES
    // unsigned long m_ulTotalMessagesReceived;

    // for CIMB mini pvm download::amitesh
    var m_ulArrMINIPVMIdAdd = [Int64](repeating: 0x00, count: AppConst.MAX_COUNT_MINIPVM + 1) // MAX_COUNT_MINIPVM
    var m_ulArrMINIPVMIdDelete = [Int64](repeating: 0x00, count: AppConst.MAX_COUNT_MINIPVM + 1) // MAX_COUNT_MINIPVM
    var m_ObjArrParameterData: [ParameterData] = []

    // for Lib file download-amitesh
    var m_ulArrlibIdAdd = [LIBstruct?](repeating: nil, count: AppConst.MAX_LIB_FILE)
    var m_ulArrlibIdDelete = [LIBstruct?](repeating: nil, count: AppConst.MAX_LIB_FILE)

    var loginAccountsMap = [String : LOGINACCOUNTS]()

    func CISO320C()
    {
        super.CISOMsgC()
        self.vFnSetTerminalActivationFlag(bTerminalActivationFlag: false)
    }

    override func vFnSetTerminalActivationFlag(bTerminalActivationFlag: Bool) {
          m_bIsTerminalActivationPacket = bTerminalActivationFlag
      }
    
    func setField7PrintPAD() {
        do {
            debugPrint("Inside setField7PrintPAD")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_INFO, "Inside setField7PrintPAD");
            let length: Int = len[ISOFieldConstants.ISO_FIELD_7.rawValue - 1]

            if (length > 0) {
                //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "ISO_FIELD_7 data[%s]", new String(data[ISOFieldConstants.ISO_FIELD_7.rawValue  - 1]));
                debugPrint("ISO_FILED_7 data[\(String(bytes: self.data[ISOFieldConstants.ISO_FIELD_7.rawValue - 1], encoding: String.Encoding.ascii)!)]")
                
                let strISOField7: String = String(bytes: self.data[ISOFieldConstants.ISO_FIELD_7.rawValue - 1], encoding: String.Encoding.ascii)!
                //String strISOField7 = new String(this.data[IsoFieldConstant.ISO_FIELD_7 - 1])
                if (strISOField7 == AppConst.AC_PRINT_PAD) {
                    m_bField7PrintPAD = true;
                } else {
                    m_bField7PrintPAD = false;
                }
            }
        } catch {
            debugPrint("Exception Occurred \(error)")
           //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(ex));
        }
    }
 
    
    
    
}
