//
//  PineKeyInjection.swift
//  ePOS
//
//  Created by Vishal Rathore on 20/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation


//public class PineKeyInjectionApp {
//
//    public static final int SOURCEID_HSM_COMMUNICATION_REQUEST = 0x1000;
//    public static final int SOURCEID_HSM_COMMUNICATION_RESPONSE = 0x9999;
//
//    public static final int FUNCTIONCODE_START_SESSION_REQ = 0x0999;
//    public static final int FUNCTIONCODE_START_SESSION_RES = 0x1999;
//
//    public static final int FUNCTIONCODE_END_SESSION_REQ = 0x0998;
//    public static final int FUNCTIONCODE_END_SESSION_RES = 0x1998;
//
//    public static final int FUNCTIONCODE_RESETKEY_REQ = 0x003E;
//    public static final int FUNCTIONCODE_RESETKEY_RES = 0x103E;
//
//    public static final int FUNCTIONCODE_RENEWKEY_REQ = 0x003F;
//    public static final int FUNCTIONCODE_RENEWKEY_RES = 0x103F;
//
//    public static final int FUNCTIONCODE_PMK_REQ = 0x0003;
//    public static final int FUNCTIONCODE_PMK_RES = 0x1003;
//
//    public static final int FUNCTIONCODE_GET_AUTH_TEXTDATA_REQ = 0x0009;
//    public static final int FUNCTIONCODE_GET_AUTH_TEXTDATA_RES = 0x1009;
//
//    public static final int FUNCTIONCODE_PMK_HSM_REQ = 0x000A;
//    public static final int FUNCTIONCODE_PMK_HSM_RES = 0x100A;
//    public static final int HSM_RESPONSE_HEADER_LEN     = 8;
//    public static final String MY_AUTH_TOKEN_SEED       = "(4E651C1E1B4E4395)*&^%$#@!{835A8A1C06CA6745}";
//
//    private static PineKeyInjectionApp Singleton = null;
//    byte[] uchArrSendRecvBuff = new byte[2000];
//
//    String chArrDeviceSerialNumber;
//    int iLenDNS;
//    int iDeviceType;
//    String chArrDateTime;
//
//    byte[] m_uchArrSessionKey = null;
//    int m_iLenSessionKey;
//
//    byte[] m_uchArrHashAuthToken = null;
//    int m_iLenHashAuthToken;
//    byte[] m_chArrReqAuthTextData = null;
//    int m_iLenReqAuthTextData;
//    byte[] m_chArrAsciiAuthDataFromSeed = null;
//
//    byte[] m_uchArrEncTokenData = null;
//    int m_iLenEncTokenData;
//    byte[] m_uchArrHexDecryptedTokenData = null;
//
//    byte[] m_uchArrAsciiAuthTextData = new byte[50];
//
//    byte[] m_uchArrHexEncPMKComp1 = new byte[40];
//    byte[] m_uchArrHexEncPMKComp2 = new byte[40];
//    byte[] m_uchArrHexPMKHSM = new byte[50];
//
//    RESET_RESPONSE stResetResponse = new RESET_RESPONSE();
//    PTMK_KCV[] sArrKCVPTMK = new PTMK_KCV[AppConst.NUM_KEYSLOTS];
//    PMK stPMK = null;
//
//    public static PineKeyInjectionApp GetInstance() {
//        if (null == Singleton) {
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "CStateMachine Constructor");
//            Singleton = new PineKeyInjectionApp();
//        }
//        return Singleton;
//    }
//
//    private String GetCurrentDateTime(){
//        String formattedDate = new SimpleDateFormat("ddMMyyyyHHmmss").format(Calendar.getInstance().getTime());
//        return formattedDate;
//    }
//
//    private boolean iClearData(){
//        CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "iClearData");
//        byte[] HarwareSerialNumber = CPlatformUtils.GetHardWareSerialNumber();
//        chArrDeviceSerialNumber = new String(HarwareSerialNumber);
//        iLenDNS = chArrDeviceSerialNumber.length();
//        iDeviceType = CPlatformUtils.iGetHardwareType();
//        chArrDateTime = GetCurrentDateTime();
//        return true;
//    }
//
//    private int iGetRequestMessage(int iFunctinCode, byte[] chArrData, int iLenData){
//        int iOffset = 0;
//
//        //Header of Message
//        //Source ID 2 bytes
//        uchArrSendRecvBuff[iOffset++] = (SOURCEID_HSM_COMMUNICATION_REQUEST >> 8) & 0x00FF;
//        uchArrSendRecvBuff[iOffset++] = SOURCEID_HSM_COMMUNICATION_REQUEST & 0x00FF;
//
//        //Function Code 2 bytes
//        uchArrSendRecvBuff[iOffset++] = (byte)((iFunctinCode >> 8) & 0x00FF);
//        uchArrSendRecvBuff[iOffset++] = (byte)(iFunctinCode & 0x00FF);
//
//        uchArrSendRecvBuff[iOffset++] = (byte)((iLenData >> 8) & 0x00FF);
//        uchArrSendRecvBuff[iOffset++] = (byte)(iLenData & 0x00FF);
//
//        if(iLenData > 0){
//            System.arraycopy(chArrData,0,uchArrSendRecvBuff,iOffset,iLenData);
//            iOffset += iLenData;
//        }
//
//        uchArrSendRecvBuff[iOffset++] = (byte)0xFF;
//        return iOffset;
//    }
//
//    private boolean iParseCommunicationResponse(byte[] chArrReceivedBuffer, int iLenReceivedBuffer, int iReqFunctionCode, Int iLenOutData){
//        int iSourceID = 0;
//        int iErrorCode = 0;
//        int iFunctionCode = 0;
//        int iOffset = 0;
//        int iDataLen = 0;
//
//        if(iLenReceivedBuffer < 8){
//            return false;
//        }
//
//        iSourceID = (chArrReceivedBuffer[iOffset++] << 8) & 0xFF00;
//        iSourceID |= chArrReceivedBuffer[iOffset++] & 0x00FF;
//        CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "iSourceID[%d]",iSourceID);
//        if(iSourceID != SOURCEID_HSM_COMMUNICATION_RESPONSE){
//            return false;
//        }
//
//        iFunctionCode = (chArrReceivedBuffer[iOffset++] << 8) & 0xFF00;
//        iFunctionCode |= chArrReceivedBuffer[iOffset++] & 0x00FF;
//        CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "iFunctionCode[%d]",iFunctionCode);
//        if(iFunctionCode != iReqFunctionCode){
//            return false;
//        }
//
//        iErrorCode = (chArrReceivedBuffer[iOffset++] << 8) & 0xFF00;
//        iErrorCode |= chArrReceivedBuffer[iOffset++] & 0x00FF;
//        CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "iErrorCode[%d]",iErrorCode);
//        if(iErrorCode != 0x00){
//            return false;
//        }
//
//        iDataLen = (chArrReceivedBuffer[iOffset++] << 8) & 0xFF00;
//        iDataLen |= chArrReceivedBuffer[iOffset++] & 0x00FF;
//        CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "iDataLen[%d]",iDataLen);
//        iLenOutData.value = iDataLen;
//
//        //CLogger::TraceBuffer((trace_sap_id_t) 0xF002, iDataLen, chArrReceivedBuffer);
//        return true;
//    }
//
//    private boolean iParsePTMKResponse(byte[] chArrReceivedBuffer, int iLenReceivedBuffer){
//        int iOffset = 0;
//        byte[] chArrTempComp = new byte[32];
//        byte[] chArrTempKCV = new byte[6];
//
//        if(iLenReceivedBuffer < 81){
//            return false;
//        }
//
//        stResetResponse.iIsZMKCompUnderPMK = chArrReceivedBuffer[iOffset++];
//        CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "iIsZMKCompUnderPMK[%d]", stResetResponse.iIsZMKCompUnderPMK);
//
//        stResetResponse.iNumKeySlots = chArrReceivedBuffer[iOffset++];
//        CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "iNumKeySlots[%d]", stResetResponse.iNumKeySlots);
//
//        int it = 0;
//        int iKeySlotID = 0;
//        for(it = 0; it < stResetResponse.iNumKeySlots; it++){
//            stResetResponse.sZMKKeys[it] = new ZMK_KEY();
//            iKeySlotID = chArrReceivedBuffer[iOffset++];
//            stResetResponse.sZMKKeys[it].iKeySlotID = iKeySlotID;
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "iKeySlotID[%d]", iKeySlotID);
//
//            byte chXChar = chArrReceivedBuffer[iOffset++];
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "chxChar[%c]", chXChar);
//            if(!('X' == chXChar || 'x' == chXChar)){
//                return false;
//            }
//
//            /*System.arraycopy(chArrReceivedBuffer,iOffset,chArrTempComp,0,32);
//            stResetResponse.sZMKKeys[it].uchArrPinZMKComp1 = CUtils.a2bcd(chArrTempComp);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrPinZMKComp1");
//            CLogger.TraceBuffer(16, stResetResponse.sZMKKeys[it].uchArrPinZMKComp1);
//            iOffset+= 32;
//
//            System.arraycopy(chArrReceivedBuffer,iOffset,chArrTempKCV,0,6);
//            stResetResponse.sZMKKeys[it].uchArrKCVPinZMKComp1 = CUtils.a2bcd(chArrTempKCV);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrKCVPinZMKComp1");
//            CLogger.TraceBuffer(3, stResetResponse.sZMKKeys[it].uchArrKCVPinZMKComp1);
//            iOffset+= 6;
//
//            chXChar = chArrReceivedBuffer[iOffset++];
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "chxChar[%c]", chXChar);
//            if(!('X' == chXChar || 'x' == chXChar)){
//                return false;
//            }
//
//            System.arraycopy(chArrReceivedBuffer,iOffset,chArrTempComp,0,32);
//            stResetResponse.sZMKKeys[it].uchArrPinZMKComp2 = CUtils.a2bcd(chArrTempComp);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrPinZMKComp2");
//            CLogger.TraceBuffer(16, stResetResponse.sZMKKeys[it].uchArrPinZMKComp2);
//            iOffset+= 32;
//
//            System.arraycopy(chArrReceivedBuffer,iOffset,chArrTempKCV,0,6);
//            stResetResponse.sZMKKeys[it].uchArrKCVPinZMKComp2 = CUtils.a2bcd(chArrTempKCV);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrKCVPinZMKComp2");
//            CLogger.TraceBuffer(3, stResetResponse.sZMKKeys[it].uchArrKCVPinZMKComp2);
//            iOffset+= 6;
//
//            chXChar = chArrReceivedBuffer[iOffset++];
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "chxChar[%c]", chXChar);
//            if(!('X' == chXChar || 'x' == chXChar)){
//                return false;
//            }
//
//            System.arraycopy(chArrReceivedBuffer,iOffset,chArrTempComp,0,32);
//            stResetResponse.sZMKKeys[it].uchArrPinZMKComp3 = CUtils.a2bcd(chArrTempComp);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrPinZMKZMKComp3");
//            CLogger.TraceBuffer(16, stResetResponse.sZMKKeys[it].uchArrPinZMKComp3);
//            iOffset+= 32;
//
//            System.arraycopy(chArrReceivedBuffer,iOffset,chArrTempKCV,0,6);
//            stResetResponse.sZMKKeys[it].uchArrKCVPinZMKComp3 = CUtils.a2bcd(chArrTempKCV);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrKCVPinZMKZMKComp3");
//            CLogger.TraceBuffer(3, stResetResponse.sZMKKeys[it].uchArrKCVPinZMKComp3);
//            iOffset+= 6;
//
//            byte[] chArrTempCompPinKey = CCryptoHandler.vFnXOR(stResetResponse.sZMKKeys[it].uchArrPinZMKComp1, stResetResponse.sZMKKeys[it].uchArrPinZMKComp2,16);
//            stResetResponse.sZMKKeys[it].uchArrPinZMKFinal = CCryptoHandler.vFnXOR(chArrTempCompPinKey, stResetResponse.sZMKKeys[it].uchArrPinZMKComp3,16);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrPinZMKFinal");
//            CLogger.TraceBuffer(16, stResetResponse.sZMKKeys[it].uchArrPinZMKFinal);*/
//
//            System.arraycopy(chArrReceivedBuffer,iOffset,chArrTempComp,0,32);
//            byte[] uchArrPinZMKFinal = CUtils.a2bcd(chArrTempComp);
//            System.arraycopy(uchArrPinZMKFinal,0,stResetResponse.sZMKKeys[it].uchArrPinZMKFinal,0,uchArrPinZMKFinal.length);
//            if (uchArrPinZMKFinal.length == 16) {
//                System.arraycopy(uchArrPinZMKFinal, 0, stResetResponse.sZMKKeys[it].uchArrPinZMKFinal, 16, 8);
//            }
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrPinZMKFinal[%s]", new String(uchArrPinZMKFinal));
//            iOffset+= 32;
//
//            System.arraycopy(chArrReceivedBuffer,iOffset,chArrTempKCV,0,6);
//            stResetResponse.sZMKKeys[it].uchArrKCVPinZMKFinal = CUtils.a2bcd(chArrTempKCV);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrKCVPinZMKFinal[%s]", new String(stResetResponse.sZMKKeys[it].uchArrKCVPinZMKFinal));
//            iOffset+= 6;
//
//            chXChar = chArrReceivedBuffer[iOffset++];
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "chxChar[%c]", chXChar);
//            if(!('X' == chXChar || 'x' == chXChar)){
//                return false;
//            }
//
//            /*System.arraycopy(chArrReceivedBuffer,iOffset,chArrTempComp,0,32);
//            stResetResponse.sZMKKeys[it].uchArrTLEZMKComp1 = CUtils.a2bcd(chArrTempComp);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrTLEZMKComp1");
//            CLogger.TraceBuffer(16, stResetResponse.sZMKKeys[it].uchArrTLEZMKComp1);
//            iOffset+= 32;
//
//            System.arraycopy(chArrReceivedBuffer,iOffset,chArrTempKCV,0,6);
//            stResetResponse.sZMKKeys[it].uchArrKCVTLEZMKComp1 = CUtils.a2bcd(chArrTempKCV);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrKCVTLEZMKComp1");
//            CLogger.TraceBuffer(3, stResetResponse.sZMKKeys[it].uchArrKCVTLEZMKComp1);
//            iOffset+= 6;
//
//            chXChar = chArrReceivedBuffer[iOffset++];
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "chxChar[%c]", chXChar);
//            if(!('X' == chXChar || 'x' == chXChar)){
//                return false;
//            }
//
//            System.arraycopy(chArrReceivedBuffer,iOffset,chArrTempComp,0,32);
//            stResetResponse.sZMKKeys[it].uchArrTLEZMKComp2 = CUtils.a2bcd(chArrTempComp);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrTLEZMKComp2");
//            CLogger.TraceBuffer(16, stResetResponse.sZMKKeys[it].uchArrTLEZMKComp2);
//            iOffset+= 32;
//
//            System.arraycopy(chArrReceivedBuffer,iOffset,chArrTempKCV,0,6);
//            stResetResponse.sZMKKeys[it].uchArrKCVTLEZMKComp2 = CUtils.a2bcd(chArrTempKCV);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrKCVTLEZMKComp2");
//            CLogger.TraceBuffer(3, stResetResponse.sZMKKeys[it].uchArrKCVTLEZMKComp2);
//            iOffset+= 6;
//
//            chXChar = chArrReceivedBuffer[iOffset++];
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "chxChar[%c]", chXChar);
//            if(!('X' == chXChar || 'x' == chXChar)){
//                return false;
//            }
//
//            System.arraycopy(chArrReceivedBuffer,iOffset,chArrTempComp,0,32);
//            stResetResponse.sZMKKeys[it].uchArrTLEZMKComp3 = CUtils.a2bcd(chArrTempComp);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrTLEZMKZMKComp3");
//            CLogger.TraceBuffer(16, stResetResponse.sZMKKeys[it].uchArrTLEZMKComp3);
//            iOffset+= 32;
//
//            System.arraycopy(chArrReceivedBuffer,iOffset,chArrTempKCV,0,6);
//            stResetResponse.sZMKKeys[it].uchArrKCVTLEZMKComp3 = CUtils.a2bcd(chArrTempKCV);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrKCVTLEZMKZMKComp3");
//            CLogger.TraceBuffer(3, stResetResponse.sZMKKeys[it].uchArrKCVTLEZMKComp3);
//            iOffset+= 6;
//
//            byte[] chArrTempCompTLEKey = CCryptoHandler.vFnXOR(stResetResponse.sZMKKeys[it].uchArrTLEZMKComp1, stResetResponse.sZMKKeys[it].uchArrTLEZMKComp2,16);
//            stResetResponse.sZMKKeys[it].uchArrTLEZMKFinal = CCryptoHandler.vFnXOR(chArrTempCompTLEKey, stResetResponse.sZMKKeys[it].uchArrTLEZMKComp3,16);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrTLEZMKFinal");
//            CLogger.TraceBuffer(16, stResetResponse.sZMKKeys[it].uchArrTLEZMKFinal);*/
//
//            System.arraycopy(chArrReceivedBuffer,iOffset,chArrTempComp,0,32);
//            byte[] uchArrTLEZMKFinal = CUtils.a2bcd(chArrTempComp);
//            System.arraycopy(uchArrTLEZMKFinal,0,stResetResponse.sZMKKeys[it].uchArrTLEZMKFinal,0,uchArrTLEZMKFinal.length);
//            if (uchArrTLEZMKFinal.length == 16)
//                System.arraycopy(uchArrTLEZMKFinal,0,stResetResponse.sZMKKeys[it].uchArrTLEZMKFinal,16,8);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrTLEZMKFinal[%s]", new String(stResetResponse.sZMKKeys[it].uchArrTLEZMKFinal));
//            iOffset+= 32;
//
//            System.arraycopy(chArrReceivedBuffer,iOffset,chArrTempKCV,0,6);
//            stResetResponse.sZMKKeys[it].uchArrKCVTLEZMKFinal = CUtils.a2bcd(chArrTempKCV);
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrKCVTLEZMKFinal[%s]", new String(stResetResponse.sZMKKeys[it].uchArrKCVTLEZMKFinal));
//            iOffset+= 6;
//        }
//
//        return true;
//    }
//
//    public boolean iStartSessionRequest(ByteArray uchSendBuffer, Int iSendLen)
//    {
//        //Clear all previous data before using this function
//        iClearData();
//
//        byte[] chArrData = new byte[200];
//        int iOffset = 0;
//
//        //DNS type
//        chArrData[iOffset++] = (byte)iDeviceType;
//
//        //DNS Length and DNS(1 + X Bytes)
//        chArrData[iOffset++] = (byte)(iLenDNS & 0x00FF);
//        if(iLenDNS > 0){
//            System.arraycopy(chArrDeviceSerialNumber.getBytes(),0,chArrData,iOffset,iLenDNS);
//            iOffset += iLenDNS;
//        }
//
//        long lSessionExpiryTimeOutMillis = 180000;
//
//        //SESSION EXPIRY TIMEOUT 4 Bytes
//        chArrData[iOffset++] = (byte)((lSessionExpiryTimeOutMillis >> 24) & 0x000000FF);
//        chArrData[iOffset++] = (byte)((lSessionExpiryTimeOutMillis >> 16) & 0x000000FF);
//        chArrData[iOffset++] = (byte)((lSessionExpiryTimeOutMillis >> 8) &  0x000000FF);
//        chArrData[iOffset++] = (byte)(lSessionExpiryTimeOutMillis & 0x000000FF);
//
//        //TRANSMISSION DATE TIME 14 bytes
//        System.arraycopy(chArrDateTime.getBytes(),0,chArrData,iOffset,AppConst.LEN_TRANSMISSION_DATE_TIME);
//        iOffset += AppConst.LEN_TRANSMISSION_DATE_TIME;
//
//        int iDataLen = iOffset;
//
//        iOffset = iGetRequestMessage(FUNCTIONCODE_START_SESSION_REQ, chArrData, iDataLen);
//        System.arraycopy(uchArrSendRecvBuff, 0, uchSendBuffer.m_ByteArray, 0, iOffset);
//        iSendLen.value = iOffset;
//
//        Arrays.fill(uchArrSendRecvBuff, (byte)0x00);
//        return true;
//    }
//
//    public boolean iStartSessionResponse(byte[] chArrReceiveBuffer, int iOffset)
//    {
//        Int iLenData = new Int();
//        boolean iRetVal = iParseCommunicationResponse(chArrReceiveBuffer, iOffset, FUNCTIONCODE_START_SESSION_RES, iLenData);
//        if(iRetVal != true) {
//            return false;
//        }
//
//        if(iLenData.value > 0)
//        {
//            m_uchArrSessionKey = new byte[iLenData.value];
//            System.arraycopy(chArrReceiveBuffer, HSM_RESPONSE_HEADER_LEN, m_uchArrSessionKey, 0, iLenData.value);
//            m_iLenSessionKey = iLenData.value;
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "uchArrSessionKey in hex: ");
//            //CLogger::TraceBuffer((trace_sap_id_t) 0xF002, 32, uchArrSessionKey);
//        }
//        return true;
//    }
//
//    public boolean iGetPTMKRequest(int iRequestType, ByteArray uchSendBuffer, Int iSendLen)
//    {
//        int iKeySlotPin = 10;
//        int iKeySlotTLE = 12;
//        int iNumKeySlot = 1;
//
//        CGlobalData GlobalData = CGlobalData.GetInstance();
//        boolean iUseDefaultKeySlotOnly = GlobalData.m_sMasterParamData.m_iUseDefaultKeySlotOnly;
//
//        iUseDefaultKeySlotOnly = true;
//        if(iUseDefaultKeySlotOnly){
//            iNumKeySlot = AppConst.DEFAULT_NUM_KEYSLOT;
//        }else{
//            iNumKeySlot = AppConst.NUM_KEYSLOTS;
//        }
//
//        CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "iNumKeySlot[%d]", iNumKeySlot);
//
//        CPineKeyInjection pineKeyInjection = new CPineKeyInjection();
//        //if renew request, Get KCV for previous PMK
//        if (iRequestType == AppConst.RENEW_PTMK) {
//            for(int it = 0; it < iNumKeySlot; it++){
//                iKeySlotPin = AppConst.keySlotMap[it][AppConst.ID_KEYSLOTPIN];
//                iKeySlotTLE = AppConst.keySlotMap[it][AppConst.ID_KEYSLOTTLE];
//                sArrKCVPTMK[it] = new PTMK_KCV();
//                byte[] tempBuffPin = pineKeyInjection.iGetPINTLEChecksum(iKeySlotPin);
//                //byte[] tempBuffPin = stResetResponse.sZMKKeys[it].uchArrKCVPinZMKFinal;
//                sArrKCVPTMK[it].uchArrKCVPTMKPIN = CUtils.bcd2a(tempBuffPin,3);
//                byte[] tempBuffTLE = pineKeyInjection.iGetPINTLEChecksum(iKeySlotTLE);
//                //byte[] tempBuffTLE = stResetResponse.sZMKKeys[it].uchArrKCVTLEZMKFinal;
//                sArrKCVPTMK[it].uchArrKCVPTMKTLE = CUtils.bcd2a(tempBuffTLE,3);
//            }
//        }
//
//        int iFunctionCode = 0;
//        byte[] chArrData = new byte[2000];
//        int iOffset = 0;
//
//        //Message BODY
//        //Device Type 1 Byte
//        chArrData[iOffset++] = (byte)(iDeviceType & 0x00FF);
//
//        //Device Serial Number Length and Data(1 + X bytes)
//        chArrData[iOffset++] = (byte)(iLenDNS & 0x00FF);
//        if (iLenDNS > 0) {
//            System.arraycopy(chArrDeviceSerialNumber.getBytes(),0,chArrData,iOffset,iLenDNS);
//            iOffset += iLenDNS;
//        }
//
//        //8 Key slots fixed as of now
//        chArrData[iOffset++] = (byte)iNumKeySlot;
//        for (int it = 0; it < iNumKeySlot; it++) {
//            //Key Slot ID
//            chArrData[iOffset++] = (byte)(AppConst.keySlotMap[it][AppConst.ID_KEYSLOTID] & 0x00FF);
//
//            //if renew request, send KCV for previous PMK
//            if (iRequestType == AppConst.RENEW_PTMK) {
//                System.arraycopy(sArrKCVPTMK[it].uchArrKCVPTMKPIN,0,chArrData,iOffset,6);
//                iOffset += 6;
//
//                System.arraycopy(sArrKCVPTMK[it].uchArrKCVPTMKTLE,0,chArrData,iOffset,6);
//                iOffset += 6;
//            }
//        }
//
//        int iDataLen = iOffset;
//
//        if (iRequestType == AppConst.RESET_PTMK) {
//            iFunctionCode = FUNCTIONCODE_RESETKEY_REQ;
//        } else {
//            iFunctionCode = FUNCTIONCODE_RENEWKEY_REQ;
//        }
//        iOffset = iGetRequestMessage(iFunctionCode, chArrData, iDataLen);
//
//        //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "send data: ");
//        //CLogger.TraceBuffer(iOffset, uchArrSendRecvBuff);
//
//        System.arraycopy(uchArrSendRecvBuff,0,uchSendBuffer.m_ByteArray,0,iOffset);
//        iSendLen.value = iOffset;
//
//        Arrays.fill(uchArrSendRecvBuff, (byte)0x00);
//        return true;
//    }
//
//    public boolean iGetPTMKResponse(int iRequestType, byte[] chArrReceiveBuffer, int iOffset)
//    {
//        Int iLenData = new Int();
//        int iFunctionCode = 0;
//
//        if(iRequestType == AppConst.RESET_PTMK){
//            iFunctionCode = FUNCTIONCODE_RESETKEY_RES;
//        }else{
//            iFunctionCode = FUNCTIONCODE_RENEWKEY_RES;
//        }
//
//        boolean iRetVal = false;
//        iRetVal = iParseCommunicationResponse(chArrReceiveBuffer, iOffset, iFunctionCode,iLenData);
//        if(iRetVal != true){
//            return iRetVal;
//        }
//
//        CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Response chArrReceiveBuffer[%d], chArrReceiveBuffer[%s]", iLenData.value, BytesUtil.byteArray2HexString(chArrReceiveBuffer));
//
//        byte[] temParseBuff = new byte[iLenData.value];
//        System.arraycopy(chArrReceiveBuffer,HSM_RESPONSE_HEADER_LEN,temParseBuff,0,iLenData.value);
//        iRetVal = iParsePTMKResponse(temParseBuff, iLenData.value);
//        if(iRetVal){
//            CPineKeyInjection pineKeyInjection = new CPineKeyInjection();
//            if(stResetResponse.iIsZMKCompUnderPMK == 0x00){
//
//                //reset PIN Master key and TLE master keyCUIHelper.SetMessage("Reset PTMK...");
//                iRetVal = pineKeyInjection.iResetPTMKTerminal(stResetResponse);
//            }
//            else{
//                //CUIHelper.SetMessage("Renew PTMK...");
//                //renew PIN Master key and TLE master key
//                iRetVal = pineKeyInjection.iRenewPTMKTerminal(stResetResponse);
//            }
//        }
//        return iRetVal;
//    }
//
//    public boolean iEndSessionRequest(ByteArray uchSendBuffer, Int iSendLen)
//    {
//
//        int iOffset = 0;
//        iOffset = iGetRequestMessage(FUNCTIONCODE_END_SESSION_REQ, null, 0);
//
//        System.arraycopy(uchArrSendRecvBuff,0,uchSendBuffer.m_ByteArray,0,iOffset);
//        iSendLen.value = iOffset;
//
//        Arrays.fill(uchArrSendRecvBuff,(byte) 0x00);
//        return true;
//    }
//
//    public boolean iEndSessionResponse(byte[] chArrReceiveBuffer, int iOffset)
//    {
//        Int iLenData = new Int();
//        boolean iRetVal = false;
//
//        iRetVal = iParseCommunicationResponse(chArrReceiveBuffer, iOffset, FUNCTIONCODE_START_SESSION_RES, iLenData);
//        return iRetVal;
//    }
//
//}
