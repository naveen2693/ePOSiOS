//
//  GlobalData.swift
//  ePOS
//
//  Created by Naveen Goyal on 06/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public class GlobalData
{
    var  m_sConxData = StructConxData();
    var  fullSerialNumber:String?
    static var m_sTerminalParamData_Cache:TerminalParamData? = nil;
    private init() {}
    private static var _shared: GlobalData?
    public static var sharedInstance: GlobalData {
        get {
            if _shared == nil {
                DispatchQueue.global().sync(flags: .barrier) {
                    if _shared == nil {
                        _shared = GlobalData()
                    }
                }
            }
            return _shared!
        }
    }
  
    // MARK:- createConnectionFile
    public func  createConnectionFile() -> Int
    {
        let iConnType:Int = 0;
        let iConxPriority:Int = 0;
        let maxCommunication:Int = AppConstant.MAX_COMMUNICATION_CHANNEL
        for _ in  0...maxCommunication
        {
            var conxData = TerminalConxData();
            conxData.iConnType += iConnType;
            conxData.iConxPriority += iConxPriority;
            conxData.bIsConnectionActive = false;
            conxData.bIsDataChanged = true;
            conxData.iConnTimeout = AppConstant.iConnectionTimeout;
            conxData.iSendRecTimeout = AppConstant.iSendReceiveTimeout;
            conxData.iInterCharTimeout = AppConstant.iInterCharTimeout;
            conxData.iComPort = AppConstant.iComPort;
            conxData.strLoginID = AppConstant.strConxLoginID;
            conxData.strPassword = AppConstant.strConxPassword;
            conxData.iTransactionSSLPort = AppConstant.HOST_PORT;
            conxData.iSecondaryTransactionSSLPort = AppConstant.HOST_PORT;
            conxData.strTransactionSSLServerIP = AppConstant.PRIMARY_IP;
            conxData.strSecondaryTransactionSSLServerIP = AppConstant.SECONDARY_IP;
            conxData.bTransactionSSLIPRetryCounter = 0;
            conxData.strGPRSServiceProvider = AppConstant.strGPRSServiceProvider;
            conxData.strAPN = AppConstant.strAPN;
            //Write this Info into file
            do{
                _ = try FileSystem.AppendFile(strFileName: AppConstant.CONNECTIONDATAFILENAME, with: [conxData])}
            catch
            {
                fatalError("File Write Error")
            }
            
        }
        //Load connection Index
        var tData:TerminalConxData?;
        m_sConxData.m_bArrConnIndex =  StructConnIndex();
        
        if let listParams:[TerminalConxData] = FileSystem.ReadFile(strFileName: AppConstant.CONNECTIONDATAFILENAME)
        {
            if (listParams.count > 0) {
                let numberOfRow:Int = listParams.count;
                for i in 0...numberOfRow {
                    tData = listParams[i];
                    if (ConnectionTypes.DIALUP_SERIAL == tData?.iConnType) {
                        m_sConxData.m_bArrConnIndex.CON_SerialIp.index = i;
                    } else if (ConnectionTypes.DIALUP_GPRS == tData?.iConnType) {
                        m_sConxData.m_bArrConnIndex.CON_GPRS.index = i;
                    } else if (ConnectionTypes.DIALUP_ETHERNET == tData?.iConnType) {
                        m_sConxData.m_bArrConnIndex.CON_ETHERNET.index = i;
                    } else if (ConnectionTypes.DIALUP_WIFI == tData?.iConnType) {
                        m_sConxData.m_bArrConnIndex.CON_WIFI.index = i;
                    }
                }
            }
        }
        return AppConstant.TRUE;
    }
    
    // MARK:- CreateSignatureParamFile
    public class func CreateSignatureParamFile() -> Int
    {
        var Objsignaturedata =  SignatureParams();
        //FileSystem.Delete(m_context, chArrSignatureParamFile);
        let bArrSignatureComPort:[UInt8] = Array("0".utf8);
        let bArrSignatureDeviceType:[UInt8] = Array("NONE".utf8);
        Objsignaturedata.bArrSignatureComPort.insert(contentsOf: bArrSignatureComPort, at: 0)
        Objsignaturedata.SignatureDeviceType.insert(contentsOf: bArrSignatureDeviceType, at: 0)
        Objsignaturedata.IsSignDeviceConnected = false;
        //        int iCurrentNumOfRecords = CFileSystem.NumberOfRows(m_context, SignatureParams[].class, chArrSignatureParamFile);
        return AppConstant.TRUE;
    }
    
    // MARK:- createDeviceStateFile
    public class func createDeviceStateFile() {
        let deviceState = DeviceState.S_INITIAL;
        do{
            _ = try FileSystem.AppendFile(strFileName: AppConstant.DEVICE_STATE, with:[String](from: deviceState  as! Decoder))
            
        }
        catch {
            fatalError("File Write Error")
        }
    }
    
    // MARK:- readParamFile
    static func readParamFile() -> [TerminalParamData]? {
        var m_terminalParamData:[TerminalParamData]?
        if (m_sTerminalParamData_Cache == nil) {
            if let m_sTerminalParamData_Cache:[TerminalParamData] = FileSystem.ReadFile(strFileName: AppConstant.TERMINALPARAMFILENAME)
            {
                m_terminalParamData = m_sTerminalParamData_Cache
            }
        }
        return m_terminalParamData;
    }
    
    // MARK:- WriteParamFile
    static func WriteParamFile(listParamData:TerminalParamData?) ->Int {
        var objTerminalParamData = [TerminalParamData]();
        if (listParamData == nil) {
            return 0;
        }
        if let unwrappedParamData = listParamData
        {
            do {
                objTerminalParamData.append(unwrappedParamData)
                m_sTerminalParamData_Cache = unwrappedParamData; //Assigning to cache for future use
                _  = try FileSystem.ReWriteFile(strFileName: AppConstant.TERMINALPARAMFILENAME, with:  objTerminalParamData);
            }catch
            {
                fatalError("File Rewrite Error")
            }
        }
        return AppConstant.TRUE;
}

final class GlobalData {

    // MARK: - Properties
    static let singleton = GlobalData()
    static var m_sTerminalParamData_Cache: TerminalParamData? = nil
    var m_sMasterParamData: TerminalMasterParamData? = nil
    
    var m_objCurrentLoggedInAccount: LOGINACCOUNTS? = nil
    var m_strCurrentLoggedInUserPIN: String = ""
    var m_bIsLoggedIn: Bool = false
    var fullSerialNumber: String = ""
    
    func ReadParamFile() -> TerminalParamData? {
        if (GlobalData.m_sTerminalParamData_Cache == nil) {

            if let m_sTerminalParamData:TerminalParamData = FileSystem.SeekRead(strFileName: AppConst.TERMINALPARAMFILENAME, iOffset: 0)
            {
                    GlobalData.m_sTerminalParamData_Cache = m_sTerminalParamData
            }
        }
        
        return GlobalData.m_sTerminalParamData_Cache
    }

    func WriteParamFile(listParamData: TerminalParamData?) ->Int {
        var objTerminalParamData: TerminalParamData
           
        if (listParamData == nil) {
               return 0;
           }

        if listParamData != nil
           {
               do {
                  GlobalData.m_sTerminalParamData_Cache = listParamData; //Assigning to cache for future use
                 objTerminalParamData = listParamData!
                
                   _  = try FileSystem.SeekWrite(strFileName: AppConst.TERMINALPARAMFILENAME, with:
                    objTerminalParamData, iOffset: 0)
                
               }catch
               {
                   fatalError("File Rewrite Error")
               }
           }
           return AppConst.TRUE;
    }
    
    func WriteMasterParamFile() -> Int {
        return AppConst.TRUE;
      }

     func ReadMasterParamFile() -> Int {
        return AppConst.TRUE;
      }

    
    func setFullSerialNumber(fullSerialNumber: String) {
        //setting full serial number from remote to be used in activation to generate Short Serial number
        //no need to store in file as it will be set everytime app call Plutus API
        debugPrint("Inside setFullSerialNumber : \(fullSerialNumber)")
        //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Inside setFullSerialNumber : " + fullSerialNumber);
        self.fullSerialNumber = fullSerialNumber;
    }
    
    func getFullSerialNumber() -> String {
        return fullSerialNumber
    }
    
    // MARK:- CreateUserAccountFile
    public  func CreateUserAccountFile() -> Int
    {
        var objLoginAccounts =  LoginAccounts();
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        objLoginAccounts.createdBy = outputFormatter.string(from:Date())
        objLoginAccounts.userID = AppConstant.DEFAULT_ORDINARY_USER;
        let udid = UIDevice.current.identifierForVendor;
        let UDID:String = udid!.uuidString
        objLoginAccounts.userID = UDID;
        objLoginAccounts.pin = CUIHelper.generatePassword(password: AppConstant.DEFAULT_ORDINARY_PIN, uuid: UDID);
        objLoginAccounts.createdBy = "EDC";
        objLoginAccounts.accountType = AppConstant.ORDINARY_USER_TYPE;
        WriteLoginAccountFile(login_accounts: [objLoginAccounts], fileName: AppConstant.USERINFOFILE);
        
        var reCreateLoginAccounts =  LoginAccounts();
        reCreateLoginAccounts.createdOn = outputFormatter.string(from:Date())
        reCreateLoginAccounts.userID = AppConstant.DEFAULT_ADMIN_USER
        reCreateLoginAccounts.userID = UDID;
        reCreateLoginAccounts.pin = CUIHelper.generatePassword(password: AppConstant.DEFAULT_ORDINARY_PIN, uuid: UDID);
        objLoginAccounts.createdBy = "EDC";
        objLoginAccounts.accountType = AppConstant.ADM_USER_TYPE;
        WriteLoginAccountFile(login_accounts: [reCreateLoginAccounts], fileName: AppConstant.USERINFOFILE);
        
        return AppConstant.TRUE;
    }
    
    // MARK:- CreateMasterCGFile
    public func CreateMasterCGFile() ->Int
    {
        let list = [Long]();
        do{
            _ = try FileSystem.ReWriteFile(strFileName: AppConstant.MASTERCGFILE, with:list)
        }catch{
            fatalError("File Rewrite Error ")
        }
        return AppConstant.TRUE;
    }
    // MARK:- CreateMasterIMFile
    public func CreateMasterIMFile() -> Int {
        
        let list = [Long]();
        do{
            _ = try FileSystem.ReWriteFile(strFileName: AppConstant.MASTERIMFILE, with:list)
        }catch{
            fatalError("File Rewrite Error ")
        }
        return AppConstant.TRUE;
        
    }
    
    // MARK:-CreateMasterCLRDIMFile
    public func CreateMasterCLRDIMFile() ->Int  {
        
        let list = [Long]();
        do{
            _ = try FileSystem.ReWriteFile(strFileName: AppConstant.MASTERCLRDIMFILE, with:list)
        }catch{
            fatalError("File Rewrite Error ")
        }
        return AppConstant.TRUE;
    }
    
    // MARK:- CreateMasterCFGFile
    /**
        * @return
        * @function CreateMasterFCGFile
        * @details Create blank MasterFCGfile
        */
    
    public func CreateMasterCFGFile() -> Int {
        let list = [Long]();
        do{
            _ = try FileSystem.ReWriteFile(strFileName: AppConstant.MASTERFCGFILE, with:list)
        }catch{
            fatalError("File Rewrite Error ")
        }
        return AppConstant.TRUE;
    }
    
 // MARK:-CreateMasterFONTFile
    /**
        * FOR UNICODE FONT FILE
        *
        * @return
        * @function CreateMasterFONTFile
        * @details Create blank CreateMasterFONTFile
        */
    
    private func CreateMasterFONTFile() -> Int{
        let maxCountChargeSlip = AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1
        var UnicodefontId = [Fontstruct?](repeating:nil, count:maxCountChargeSlip)
        for index in 0...maxCountChargeSlip{
            UnicodefontId[index] = Fontstruct();
        }
        let fontlist = [Fontstruct?](repeating:nil, count:maxCountChargeSlip);
        do{
            _ = try FileSystem.ReWriteFile(strFileName: AppConstant.MASTERFONTFILE, with: fontlist);
        }catch
        {
            fatalError("File Write Error: CreateMasterFONTFile")
        }
        return AppConstant.TRUE;
    }
    
    // MARK:- CreateMasterLIBFile
    /**
     * FOR Library FILE
     *
     * @return
     * @function CreateMasterLIBFile
     * @details Create blank CreateMasterLIBFile
     */
    public func CreateMasterLIBFile() ->Int {
        
        let LibList =  [LIBStruct]();
        do{
            _ =  try FileSystem.ReWriteFile(strFileName: AppConstant.MASTERLIBFILE, with: LibList)
        }catch
        {
            fatalError("File ReWrite Error : CreateMasterLIBFile")
        }
        return AppConstant.TRUE;
    }
    
    // MARK:- CreateMasterMINIPVMFile
    private func CreateMasterMINIPVMFile() -> Int {
        let list = [Long]();
        do{
            _ = try FileSystem.ReWriteFile(strFileName: AppConstant.MASTERFCGFILE, with:list)
        }catch{
            fatalError("File Rewrite Error ")
        }
        return AppConstant.TRUE;
    }

    // MARK:- CreateParamFile
    /**
     * @return
     * @function CreateParamFile
     * @details Create terminal param file
     */
    public func CreateParamFile() -> Int {
        var terminalParamData =  TerminalParamData();
        terminalParamData.iCurrentBatchId = AppConstant.DEFAULT_FIRST_BATCHID;
        terminalParamData.iBatchSize = AppConstant.DEFAULT_BATCH_SIZE;
        terminalParamData.TotalTransactionsOfBatch = 0
        terminalParamData.m_EMVChipRetryCount = 1;
        terminalParamData.m_SecondaryIPMaxRetryCount = 5;
        terminalParamData.m_bIsAmexEMVDE55HexTagDataEnable = false;
        terminalParamData.m_bIsAmexEMVReceiptEnable = false;
        terminalParamData.m_parityErrorToIgnoredMagSwipe = 0;
        terminalParamData.m_iIsPasswdNeededForSpecificTxns = false;
        terminalParamData.m_iIsPasswordRequiredForSettlement = false;
        terminalParamData.m_strSettlementNSpecificTxnsPassword = "123456";
        let strParamDownloadDate = "010111115959";
        terminalParamData.m_strParamDownloadDate = strParamDownloadDate;
        terminalParamData.m_bIsDataChanged = true;
        terminalParamData.m_strNoPrintMessage = AppConstant.NoPrintDefaultMessage;
        terminalParamData.m_iIsCRISEnabled = 0;
        terminalParamData.m_strHardwareSerialNumber = CPlatFormUtils.getLast8DigitOfIMEINumber();
        _ = GlobalData.WriteParamFile(listParamData: terminalParamData);
        return AppConstant.TRUE;
    }

//       public func CreateMasterParamFile(Context m_context) ->Int {
//           CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Inside CreateMasterParamFile");
//           m_sMasterParamData = new TerminalMasterParamData();
//
//           //App version
//           m_sMasterParamData.m_strAppVersion = APP_VERSION;
//
//           m_sMasterParamData.m_strEMVParVersion = "121212121212";
//
//           //for contactless
//           m_sMasterParamData.m_strCLESSEMVParVersion = "121212121212";
//
//           m_sMasterParamData.bIsDataChanged = true;
//           m_sMasterParamData.bIsBitmap320ActiveHostSet = false;
//           m_sMasterParamData.bIsBitmap440ActiveHostSet = false;
//           m_sMasterParamData.bIsBitmap500ActiveHostSet = false;
//
//           m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[0] = 0x00;
//           m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[1] = 0x00;
//           m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[2] = 0x00;
//           m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[3] = 0x00;
//           m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[4] = 0x00;
//           m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[5] = 0x00;
//           m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[6] = 0x00;
//           m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[7] = 0x00;
//
//           m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[0] = (byte) 0xFF;
//           m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[1] = (byte) 0xFF;
//           m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[2] = (byte) 0xFF;
//           m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[3] = (byte) 0xFF;
//           m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[4] = (byte) 0xFF;
//           m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[5] = (byte) 0xFF;
//           m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[6] = (byte) 0xFF;
//           m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[7] = (byte) 0xFF;
//
//           String strInitialValue = "010101000000";
//           byte[] bArrInitialValue = strInitialValue.getBytes();
//           m_sMasterParamData.m_strBinRangeDownloadDate = strInitialValue;
//           m_sMasterParamData.m_bIsBinRangeChanged = false;
//
//           //Transaction Bin
//           m_sMasterParamData.m_strTxnBinDownloadDate = strInitialValue;
//           m_sMasterParamData.m_bIsTxnBinChanged = false;
//
//           m_sMasterParamData.m_strCSVTxnMapVersion = strInitialValue;
//
//           m_sMasterParamData.m_strAIDEMVTXNTYPEDownloadDate = strInitialValue;
//
//           m_sMasterParamData.m_strTxnTypeFlagsMappingDownloadDate = strInitialValue;
//
//           //CSV transaction Ignore Amt List
//           m_sMasterParamData.m_strIgnoreAmtCSVTxnListDownloadDate = strInitialValue;
//
//           //EMV TAG  List
//           m_sMasterParamData.m_strEMVTagListDownloadDate = strInitialValue;
//
//           //cless param  List
//           m_sMasterParamData.m_strCLessParamDownloadDate = strInitialValue;
//
//           //AID EMV TXNTYPE
//           m_sMasterParamData.m_strAIDEMVTXNTYPEDownloadDate = strInitialValue;
//
//           //TXNTYPE Flags Mapping  abhishek added 23/11/2015
//           m_sMasterParamData.m_strAIDEMVTXNTYPEDownloadDate = strInitialValue;
//           m_sMasterParamData.m_strCsvTxnTypeMiniPvmMappingDownloadDate = strInitialValue;
//           m_sMasterParamData.m_strISPasswordDownloadDate = strInitialValue;
//           m_sMasterParamData.m_strLogShippingDownloadDate = strInitialValue;
//
//           //Use Pine Encryption Key
//           //Ini we will be using Bank Keys so this flag is 0.
//           m_sMasterParamData.m_iUsePineEncryptionKeys = 0;
//
//           // Use Default Key Slot Only
//           //Ini we will be using only single default KeyslotID (10)
//           m_sMasterParamData.m_iUseDefaultKeySlotOnly = true;
//
//           //Additional Parameters
//           m_sMasterParamData.m_iOnlinePinFirstCharTimeout = 60;
//           m_sMasterParamData.m_iOnlinePinInterCharTimeout = 30;
//           m_sMasterParamData.m_iMinPinLength = 4;
//           m_sMasterParamData.m_iMaxPinLength = 12;
//           m_sMasterParamData.m_iDisplayMenuTimeout = 40;
//           m_sMasterParamData.m_iDisplayMessasgeTimeout = 2;
//           m_sMasterParamData.m_iHotKeyConfirmationTimeout = 10;
//
//           //Save default parameter data
//           if (!CFileSystem.IsFileExist(m_context, TERMINALMASTERPARAMFILE)) {
//               WriteMasterParamFile(m_context);
//           } else {
//               ReadMasterParamFile(m_context);
//           }
//           return AppConst.TRUE;
//       }
//
//       void CreateAdServerHTLFile() {
//           if (!CFileSystem.IsFileExist(m_context, MASTERHTLFILE)) {
//               m_setAdServerHTL = new HashSet<>();
//
//               Long llLong = new Long(1001);
//               m_setAdServerHTL.add(llLong);
//
//               llLong = new Long(1021);
//               m_setAdServerHTL.add(llLong);
//
//               llLong = new Long(1112);
//               m_setAdServerHTL.add(llLong);
//
//               llLong = new Long(1555);
//               m_setAdServerHTL.add(llLong);
//
//               llLong = new Long(4001);
//               m_setAdServerHTL.add(llLong);
//
//               llLong = new Long(4003);
//               m_setAdServerHTL.add(llLong);
//
//               List<Long> llList = new ArrayList<>(CGlobalData.m_setAdServerHTL);
//               CFileSystem.ReWriteFile(m_context, AppConst.MASTERHTLFILE, llList);
//           } else {
//               List<Long> llList = CFileSystem.ReadFile(m_context, Long[].class, AppConst.MASTERHTLFILE);
//               if(llList != null){
//                   m_setAdServerHTL.addAll(llList);
//               }
//           }
//       }
//
//       public void CreateLogShippingFile() {
//           CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Inside CreateLogShippingFile");
//           if (!CFileSystem.IsFileExist(m_context, AppConst.AUTOLOGSHIPMENTSMTPCREDENTIAL)) {
//               AutoLogShippingCredential ObjCred = new AutoLogShippingCredential();
//               List<AutoLogShippingCredential> sNewAutoCred = new ArrayList<>();
//               sNewAutoCred.add(ObjCred);
//               CFileSystem.ReWriteFile(m_context, AppConst.AUTOLOGSHIPMENTSMTPCREDENTIAL, sNewAutoCred);
//           }
//
//           if (!CFileSystem.IsFileExist(m_context, AppConst.AUTOLOGSHIPMENTFILE)) {
//               List<AutoLogShippingParams> sNewAutoParams = new ArrayList<>();
//               AutoLogShippingParams Obj = new AutoLogShippingParams();
//               sNewAutoParams.add(Obj);
//               CFileSystem.ReWriteFile(m_context, AppConst.AUTOLOGSHIPMENTFILE, sNewAutoParams);
//           }
//       }
//
//   public int InitializeFromDatabase(int iHostID, Context m_context) {
//         CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Inside InitializeFromDatabase");
//         LoadFromFiles(iHostID, m_context);
//         return AppConst.TRUE;
//     }
//
//     public int UpdateConnectionDataChangedFlag(int iHostID, boolean bFlag) {
//         String chArrConnectionDataFile = String.format("%s%01d.txt", CONNECTIONDATAFILENAME, iHostID);
//         CLogger.TraceLog(TRACE_DEBUG, "chArrConnectionDataFile[%s]", chArrConnectionDataFile);
//         List<TerminalConxData> listTerminalConxData = CFileSystem.ReadFile(m_context, TerminalConxData[].class, chArrConnectionDataFile);
//         if (listTerminalConxData != null) {
//             int numberOfTerminalConxData = listTerminalConxData.size();
//             if (numberOfTerminalConxData > 0) {
//                 for (int i = 0; i < numberOfTerminalConxData; i++) {
//                     CLogger.TraceLog(TRACE_DEBUG, "numberOfRow[%d]", numberOfTerminalConxData);
//                     listTerminalConxData.get(i).bIsDataChanged = bFlag;
//                     CLogger.TraceLog(TRACE_DEBUG, "m_bIsDataChanged[%s]", Boolean.toString(listTerminalConxData.get(i).bIsDataChanged));
//                 }
//                 CFileSystem.ReWriteFile(m_context, chArrConnectionDataFile, listTerminalConxData);
//             }
//         }
//         return AppConst.TRUE;
//     }
//
//     public int UpdateParamDataChangedFlag(int iHostID, boolean bFlag, Context m_context) {
//         String chFileName = String.format("%s%d.txt", TERMINALPARAMFILENAME, iHostID);
//         CLogger.TraceLog(TRACE_DEBUG, "param file name[%s]", chFileName);
//         //List<TerminalParamData> listTerminalParamData = CFileSystem.ReadFile(m_context, TerminalParamData[].class, chFileName);
//         TerminalParamData tData = CGlobalData.GetInstance().ReadParamFile(iHostID, m_context);
//         if (tData != null) {
//             tData.m_bIsDataChanged = bFlag;
//             CLogger.TraceLog(TRACE_DEBUG, "m_bIsDataChanged[%s]", Boolean.toString(tData.m_bIsDataChanged));
//             CGlobalData.GetInstance().WriteParamFile(iHostID, tData, m_context);
//         }
//         return AppConst.TRUE;
//     }
//
//     public int UpdateMasterParamDataChangedFlag(boolean bFlag, Context context) {
//         ReadMasterParamFile(context);
//         m_sMasterParamData.bIsDataChanged = bFlag;
//         CLogger.TraceLog(TRACE_DEBUG, "bIsDataChanged[%s]", Boolean.toString(m_sMasterParamData.bIsDataChanged));
//         WriteMasterParamFile(context);
//         return AppConst.TRUE;
//     }
//
//     public int UpdateAutoSettlementDataChangedFlag(int bFlag) {
//         m_sAutoSettleParams = ReadAutoSettleParams();
//         if (m_sAutoSettleParams != null) {
//             m_sAutoSettleParams.m_bIsDataChanged = bFlag != 0 ? true : false;
//             CLogger.TraceLog(TRACE_DEBUG, "m_bIsDataChanged[%s]", Boolean.toString(m_sAutoSettleParams.m_bIsDataChanged));
//             List<AutoSettlementParams> listAutoSettlementParams = new ArrayList<>();
//             listAutoSettlementParams.add(m_sAutoSettleParams);
//             CFileSystem.ReWriteFile(m_context, AUTOSETTLEPARFILE, listAutoSettlementParams);
//         }
//         return AppConst.TRUE;
//     }
//
//public int FirstInitialize(Context context) {
//       CLogger.TraceLog(TRACE_INFO, "Inside FirstInitialize");
//       int retVal = ExecutionResult._OK;
//
//       //Create MasterCGFile
//       CreateMasterCGFile();
//
//       //Create MasterIMFile
//       CreateMasterIMFile();
//
//       //Create MasterCLRDIMFile
//       CreateMasterCLRDIMFile();
//
//       //create MaterFCGfile
//       CreateMasterCFGFile();
//
//       //create MaterFONTfile
//       CreateMasterFONTFile();//FOR UNICODE FONT FILE
//
//       //create MaterLIbfile
//       CreateMasterLIBFile();//FOR Library FILE
//
//       //create CIMB minipvm file
//       CreateMasterMINIPVMFile();
//
//       //Create ParamFile
//       CreateParamFile(1, context);
//       CreateParamFile(2, context);
//
//       //Create UserAccountInfo File
//       CreateUserAccountFile(context);
//
//       //Create UserInfo File
//       CreateMasterParamFile(context);
//
//       CreateAdServerHTLFile();
//
//       //Create Conx File
//       CreateConnectionFile(1);
//
//       CreateConnectionFile(2);
//
//       CreateSignatureParamFile(2);
//
//       CreateDeviceStateFile();
//
//       CreateLogShippingFile();
//
//       //Save default Auto Settle params
//       if (false == CFileSystem.IsFileExist(m_context, AUTOSETTLEPARFILE)) {
//           WriteDefaultAutoSettleParams();
//       }
//
//       //Save default Auto Reversal params
//       if (false == CFileSystem.IsFileExist(m_context, AUTOREVERSALPARFILE)) {
//           WriteDefaultAutoReversalParams();
//       }
//
//       //Save default Auto Gprs params
//       if (false == CFileSystem.IsFileExist(m_context, AUTOGPRSALWAYSONPARFILE)) {
//           WriteDefaultAutoGprsParams();
//       }
//
//       //Save default Auto Premium Service params
//       if (false == CFileSystem.IsFileExist(m_context, AUTOPREMIUMSERVICEPARFILE)) {
//           WriteDefaultAutoPremiumServiceParams();
//       }
//       return retVal;
//   }
//
//   /*****************************************************************************
//    * Name     :  GetSerialPort
//    * Function :  This API return the current active COM port in the
//    *                connection configuration
//    *
//    * Parameter:
//    * Return   :
//    *****************************************************************************/
//   public int GetSerialPort(int iHostID) {
//       CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_INFO, "GetSerialPort");
//       int ComPort = COM0;
//       String chArrConnectionDataFile = String.format("%s%01d.txt", CONNECTIONDATAFILENAME, iHostID);
//       List<TerminalConxData> listTerminalConxData = CFileSystem.ReadFile(m_context, TerminalConxData[].class, chArrConnectionDataFile);
//       if (listTerminalConxData != null && listTerminalConxData.size() > 0) {
//           for (int i = 0; i < listTerminalConxData.size(); i++) {
//               TerminalConxData tData = listTerminalConxData.get(i);
//               if (tData != null) {
//                   if (ConnectionTypes.DIALUP_SERIAL == tData.iConnType) {
//                       CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_INFO, "atoi = %d ", tData.iComPort);
//                       int iComPort = tData.iComPort;
//                       switch (iComPort) {
//                           case 0:
//                               ComPort = COM0;
//                               CLogger.TraceLog(TRACE_INFO, "ComPort = COM0");
//                               break;
//                           case 10:
//                               ComPort = COM5;
//                               CLogger.TraceLog(TRACE_INFO, "ComPort = COM5");
//                               break;
//                           case 20:
//                               ComPort = COM_EXT;
//                               CLogger.TraceLog(TRACE_INFO, "ComPort = COM_EXT");
//                               break;
//                       }
//                   }
//               }
//           }
//       }
//       CLogger.TraceLog(TRACE_INFO, "ComPort = %d ", ComPort);
//       return ComPort;
//   }
//   /*****************************************************************************
//       * Name     :  GetSerialSendReceiveTimeout
//       * Function :  This API return the Send Receive Timeout in the
//       *                connection configuration
//       *
//       * Parameter:
//       * Return   : iSendReceiveTimeout
//       *****************************************************************************/
//      public int GetSerialSendReceiveTimeout(int iHostID) {
//          CLogger.TraceLog(TRACE_INFO, "GetSerialSendReceiveTimeout");
//          TerminalConxData tData = null;
//          int iSendReceiveTimeout = 30;
//          String chArrConnectionDataFile = String.format("%s%01d.txt", CONNECTIONDATAFILENAME, iHostID);
//          List<TerminalConxData> listTerminalConxData = CFileSystem.ReadFile(m_context, TerminalConxData[].class, chArrConnectionDataFile);
//          if (listTerminalConxData != null && listTerminalConxData.size() > 0) {
//              for (int i = 0; i < listTerminalConxData.size(); i++) {
//                  tData = listTerminalConxData.get(i);
//                  if (tData != null) {
//                      int iConnType = tData.iConnType;
//                      CLogger.TraceLog(TRACE_INFO, "bArrConnType = %d ", iConnType);
//                      if (ConnectionTypes.DIALUP_SERIAL == iConnType) {
//                          iSendReceiveTimeout = tData.iSendRecTimeout;
//                      }
//                  }
//              }
//          }
//          CLogger.TraceLog(TRACE_INFO, "iSendReceiveTimeout = %d ", iSendReceiveTimeout);
//          return iSendReceiveTimeout;
//      }
//
//      /*****************************************************************************
//       * Name     :  SetSSLMode
//       * Function :  This API set the SSL Mode to ON /Off
//       *
//       * Parameter:
//       * Return   :
//       *****************************************************************************/
//      public int SetSSLMode(boolean isON) {
//          CLogger.TraceLog(TRACE_DEBUG, "SetSSLMode[%s]", Boolean.toString(isON));
//          m_bIsSSL = isON;
//          return AppConst.TRUE;
//      }
//
//      /*****************************************************************************
//       * Name     :  GetSSLMode
//       * Function :  This API Get the SSL flag to use
//       *
//       * Parameter:
//       * Return   :
//       *****************************************************************************/
//      public boolean GetSSLMode() {
//          //Hardcoding SSL ON
//          return true;
//      }
//
//
//      /*****************************************************************************
//       * Name     :  SetSignCapMode
//       * Function :  This API set the Sign Capture Mode to ON /Off
//       *
//       * Parameter:
//       * Return   :
//       *****************************************************************************/
//      public int SetSignCapMode(boolean isON) {
//          CLogger.TraceLog(TRACE_DEBUG, "SetSignCapMode[%s]", Boolean.toString(isON));
//          m_bIsSignCapture = isON;
//          return AppConst.TRUE;
//      }
//
//      /*****************************************************************************
//       * Name     :  LoadFromFiles
//       * Function :  Load Global data structures from files
//       *                Only for single row_c_display_set_connection datas are loaded
//       * Parameter:
//       * Return   :
//       *****************************************************************************/
//      public byte LoadFromFiles(int iHostID, Context m_context) {
//          CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Inside LoadFromFiles");
//  //        m_sLoginInfo = new TerminalLoginInfo();
//          m_mLoginAccountInfo = new HashMap<>();
//          m_sAutoSettleParams = new AutoSettlementParams();
//
//          ReadMasterParamFile(m_context);
//
//  //        m_sLoginInfo = CFileSystem.SeekRead(m_context, TerminalLoginInfo[].class, USERINFOFILE, 0);
//
//          List<LOGIN_ACCOUNTS> login_accountsList = ReadLoginAccountFile(USERINFOFILE);
//          int numberOfAccounts = 0;
//          if (null != login_accountsList) {
//              numberOfAccounts = login_accountsList.size();
//          }
//          m_mLoginAccountInfo = new HashMap<>();
//          for (int i = 0; i < numberOfAccounts; i++) {
//              m_mLoginAccountInfo.put(login_accountsList.get(i).m_strUserID, login_accountsList.get(i));
//          }
//
//          m_sAutoSettleParams = CFileSystem.SeekRead(m_context, AutoSettlementParams[].class, AUTOSETTLEPARFILE, 0);
//          LoadConnectionIndex(iHostID);
//          m_sPSKData = CFileSystem.SeekRead(m_context, TerminalPSKData[].class, PSKSDWNLDFILE, 0);
//          CFileSystem.DeleteFile(m_context, TEMPBINRANGEFILE);
//          if (m_sMasterParamData.m_bIsBinRangeChanged) {
//              SortBinRangeFile();
//              m_sMasterParamData.m_bIsBinRangeChanged = false;
//              WriteMasterParamFile(m_context);
//          }
//          CFileSystem.DeleteFile(m_context, TEMPCSVTXNMAPFILE);
//
//          //Transaction Bin
//          //delete temp file if present.
//          CFileSystem.DeleteFile(m_context, TEMPTXNBINFILE);
//          //if flag true, sort transaction bin file as it is currently downloaded and update flag.
//          if (m_sMasterParamData.m_bIsTxnBinChanged) {
//              SortTxnBinFile();
//              m_sMasterParamData.m_bIsTxnBinChanged = false;
//              WriteMasterParamFile(m_context);
//          }
//          return ((byte) AppConst.TRUE);
//      }
//
//      public void LoadConnectionIndex(int iHostID) {
//          CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Inside LoadConnectionIndex");
//          TerminalConxData tData;
//          m_sConxData.m_bArrConnIndex = new StructConnIndex();
//          String chArrConnectionDataFile = String.format("%s%01d.txt", CONNECTIONDATAFILENAME, iHostID);
//          List<TerminalConxData> listParams = CFileSystem.ReadFile(m_context, TerminalConxData[].class, chArrConnectionDataFile);
//          if (listParams != null && listParams.size() > 0) {
//              int numberOfRow = listParams.size();
//              for (int i = 0; i < numberOfRow; i++) {
//                  tData = listParams.get(i);
//                  if (ConnectionTypes.DIALUP_SERIAL == tData.iConnType) {
//                      m_sConxData.m_bArrConnIndex.CON_SerialIp.index = i;
//                  } else if (ConnectionTypes.DIALUP_GPRS == tData.iConnType) {
//                      m_sConxData.m_bArrConnIndex.CON_GPRS.index = i;
//                  } else if (ConnectionTypes.DIALUP_ETHERNET == tData.iConnType) {
//                      m_sConxData.m_bArrConnIndex.CON_ETHERNET.index = i;
//                  } else if (ConnectionTypes.DIALUP_WIFI == tData.iConnType) {
//                      m_sConxData.m_bArrConnIndex.CON_WIFI.index = i;
//                  }
//              }
//          }
//      }
//
//
//
//
//    /*****************************************************************************
//     * Name     :  WriteLoginFile
//     * Function :  Write Connection File with current global data
//     * Parameter:
//     * Return   :
//     *****************************************************************************/
//
//    public func WriteLoginAccountFile(login_accounts:[LoginAccounts],fileName:String) {
//        do{
//
//            _ = try FileSystem.AppendFile(strFileName: fileName, with: login_accounts)
//        }
//        catch{
//            fatalError("File Append Error")
//        }
//    }
//    public func ReadLoginAccountFile(fileName:String) -> [LoginAccounts] {
//        if let list:[LoginAccounts] = FileSystem.ReadFile(strFileName: fileName)
//        {
//            return list;
//        }
//    }
//
//<<<<<<< Updated upstream
//=======
//    // MARK:- CreateUserAccountFile
//    public  func CreateUserAccountFile() -> Int
//    {
//        var objLoginAccounts =  LoginAccounts();
//        let outputFormatter = DateFormatter()
//        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        objLoginAccounts.createdBy = outputFormatter.string(from:Date())
//        objLoginAccounts.userID = AppConstant.DEFAULT_ORDINARY_USER;
//        let udid = UIDevice.current.identifierForVendor;
//        let UDID:String = udid!.uuidString
//        objLoginAccounts.userID = UDID;
//        objLoginAccounts.pin = CUIHelper.generatePassword(password: AppConstant.DEFAULT_ORDINARY_PIN, uuid: UDID);
//        objLoginAccounts.createdBy = "EDC";
//        objLoginAccounts.accountType = AppConstant.ORDINARY_USER_TYPE;
//        WriteLoginAccountFile(login_accounts: [objLoginAccounts], fileName: AppConstant.USERINFOFILE);
//
//        var reCreateLoginAccounts =  LoginAccounts();
//        reCreateLoginAccounts.createdOn = outputFormatter.string(from:Date())
//        reCreateLoginAccounts.userID = AppConstant.DEFAULT_ADMIN_USER
//        reCreateLoginAccounts.userID = UDID;
//        reCreateLoginAccounts.pin = CUIHelper.generatePassword(password: AppConstant.DEFAULT_ORDINARY_PIN, uuid: UDID);
//        objLoginAccounts.createdBy = "EDC";
//        objLoginAccounts.accountType = AppConstant.ADM_USER_TYPE;
//        WriteLoginAccountFile(login_accounts: [reCreateLoginAccounts], fileName: AppConstant.USERINFOFILE);
//
//        return AppConstant.TRUE;
//    }
//
//    // MARK:- CreateMasterCGFile
//    public func CreateMasterCGFile() ->Int
//    {
//        let list = [Long]();
//        do{
//            _ = try FileSystem.ReWriteFile(strFileName: AppConstant.MASTERCGFILE, with:list)
//        }catch{
//            fatalError("File Rewrite Error ")
//        }
//        return AppConstant.TRUE;
//    }
//    // MARK:- CreateMasterIMFile
//    public func CreateMasterIMFile() -> Int {
//
//        let list = [Long]();
//        do{
//            _ = try FileSystem.ReWriteFile(strFileName: AppConstant.MASTERIMFILE, with:list)
//        }catch{
//            fatalError("File Rewrite Error ")
//        }
//        return AppConstant.TRUE;
//
//    }
//
//    // MARK:-CreateMasterCLRDIMFile
//    public func CreateMasterCLRDIMFile() ->Int  {
//
//        let list = [Long]();
//        do{
//            _ = try FileSystem.ReWriteFile(strFileName: AppConstant.MASTERCLRDIMFILE, with:list)
//        }catch{
//            fatalError("File Rewrite Error ")
//        }
//        return AppConstant.TRUE;
//    }
//
//    // MARK:- CreateMasterCFGFile
//    /**
//        * @return
//        * @function CreateMasterFCGFile
//        * @details Create blank MasterFCGfile
//        */
//
//    public func CreateMasterCFGFile() -> Int {
//        let list = [Long]();
//        do{
//            _ = try FileSystem.ReWriteFile(strFileName: AppConstant.MASTERFCGFILE, with:list)
//        }catch{
//            fatalError("File Rewrite Error ")
//        }
//        return AppConstant.TRUE;
//    }
//
// // MARK:-CreateMasterFONTFile
//    /**
//        * FOR UNICODE FONT FILE
//        *
//        * @return
//        * @function CreateMasterFONTFile
//        * @details Create blank CreateMasterFONTFile
//        */
//
//    private func CreateMasterFONTFile() -> Int{
//        let maxCountChargeSlip = AppConstant.MAX_COUNT_CHARGE_SLIP_IMAGES + 1
//        var UnicodefontId = [Fontstruct?](repeating:nil, count:maxCountChargeSlip)
//        for index in 0...maxCountChargeSlip{
//            UnicodefontId[index] = Fontstruct();
//        }
//        let fontlist = [Fontstruct?](repeating:nil, count:maxCountChargeSlip);
//        do{
//            _ = try FileSystem.ReWriteFile(strFileName: AppConstant.MASTERFONTFILE, with: fontlist);
//        }catch
//        {
//            fatalError("File Write Error: CreateMasterFONTFile")
//        }
//        return AppConstant.TRUE;
//    }
//
//    // MARK:- CreateMasterLIBFile
//    /**
//     * FOR Library FILE
//     *
//     * @return
//     * @function CreateMasterLIBFile
//     * @details Create blank CreateMasterLIBFile
//     */
//    public func CreateMasterLIBFile() ->Int {
//
//        let LibList =  [LIBStruct]();
//        do{
//            _ =  try FileSystem.ReWriteFile(strFileName: AppConstant.MASTERLIBFILE, with: LibList)
//        }catch
//        {
//            fatalError("File ReWrite Error : CreateMasterLIBFile")
//        }
//        return AppConstant.TRUE;
//    }
//
//    // MARK:- CreateMasterMINIPVMFile
//    private func CreateMasterMINIPVMFile() -> Int {
//        let list = [Long]();
//        do{
//            _ = try FileSystem.ReWriteFile(strFileName: AppConstant.MASTERFCGFILE, with:list)
//        }catch{
//            fatalError("File Rewrite Error ")
//        }
//        return AppConstant.TRUE;
//    }
//
//    // MARK:- CreateParamFile
//    /**
//     * @return
//     * @function CreateParamFile
//     * @details Create terminal param file
//     */
//    public func CreateParamFile() -> Int {
//        var terminalParamData =  TerminalParamData();
//        terminalParamData.iCurrentBatchId = AppConstant.DEFAULT_FIRST_BATCHID;
//        terminalParamData.iBatchSize = AppConstant.DEFAULT_BATCH_SIZE;
//        terminalParamData.TotalTransactionsOfBatch = 0
//        terminalParamData.m_EMVChipRetryCount = 1;
//        terminalParamData.m_SecondaryIPMaxRetryCount = 5;
//        terminalParamData.m_bIsAmexEMVDE55HexTagDataEnable = false;
//        terminalParamData.m_bIsAmexEMVReceiptEnable = false;
//        terminalParamData.m_parityErrorToIgnoredMagSwipe = 0;
//        terminalParamData.m_iIsPasswdNeededForSpecificTxns = false;
//        terminalParamData.m_iIsPasswordRequiredForSettlement = false;
//        terminalParamData.m_strSettlementNSpecificTxnsPassword = "123456";
//        let strParamDownloadDate = "010111115959";
//        terminalParamData.m_strParamDownloadDate = strParamDownloadDate;
//        terminalParamData.m_bIsDataChanged = true;
//        terminalParamData.m_strNoPrintMessage = AppConstant.NoPrintDefaultMessage;
//        terminalParamData.m_iIsCRISEnabled = 0;
//        terminalParamData.m_strHardwareSerialNumber = CPlatFormUtils.getLast8DigitOfIMEINumber();
//        _ = GlobalData.WriteParamFile(listParamData: terminalParamData);
//        return AppConstant.TRUE;
//    }
//
////       public func CreateMasterParamFile(Context m_context) ->Int {
////           CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Inside CreateMasterParamFile");
////           m_sMasterParamData = new TerminalMasterParamData();
////
////           //App version
////           m_sMasterParamData.m_strAppVersion = APP_VERSION;
////
////           m_sMasterParamData.m_strEMVParVersion = "121212121212";
////
////           //for contactless
////           m_sMasterParamData.m_strCLESSEMVParVersion = "121212121212";
////
////           m_sMasterParamData.bIsDataChanged = true;
////           m_sMasterParamData.bIsBitmap320ActiveHostSet = false;
////           m_sMasterParamData.bIsBitmap440ActiveHostSet = false;
////           m_sMasterParamData.bIsBitmap500ActiveHostSet = false;
////
////           m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[0] = 0x00;
////           m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[1] = 0x00;
////           m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[2] = 0x00;
////           m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[3] = 0x00;
////           m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[4] = 0x00;
////           m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[5] = 0x00;
////           m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[6] = 0x00;
////           m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[7] = 0x00;
////
////           m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[0] = (byte) 0xFF;
////           m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[1] = (byte) 0xFF;
////           m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[2] = (byte) 0xFF;
////           m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[3] = (byte) 0xFF;
////           m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[4] = (byte) 0xFF;
////           m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[5] = (byte) 0xFF;
////           m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[6] = (byte) 0xFF;
////           m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[7] = (byte) 0xFF;
////
////           String strInitialValue = "010101000000";
////           byte[] bArrInitialValue = strInitialValue.getBytes();
////           m_sMasterParamData.m_strBinRangeDownloadDate = strInitialValue;
////           m_sMasterParamData.m_bIsBinRangeChanged = false;
////
////           //Transaction Bin
////           m_sMasterParamData.m_strTxnBinDownloadDate = strInitialValue;
////           m_sMasterParamData.m_bIsTxnBinChanged = false;
////
////           m_sMasterParamData.m_strCSVTxnMapVersion = strInitialValue;
////
////           m_sMasterParamData.m_strAIDEMVTXNTYPEDownloadDate = strInitialValue;
////
////           m_sMasterParamData.m_strTxnTypeFlagsMappingDownloadDate = strInitialValue;
////
////           //CSV transaction Ignore Amt List
////           m_sMasterParamData.m_strIgnoreAmtCSVTxnListDownloadDate = strInitialValue;
////
////           //EMV TAG  List
////           m_sMasterParamData.m_strEMVTagListDownloadDate = strInitialValue;
////
////           //cless param  List
////           m_sMasterParamData.m_strCLessParamDownloadDate = strInitialValue;
////
////           //AID EMV TXNTYPE
////           m_sMasterParamData.m_strAIDEMVTXNTYPEDownloadDate = strInitialValue;
////
////           //TXNTYPE Flags Mapping  abhishek added 23/11/2015
////           m_sMasterParamData.m_strAIDEMVTXNTYPEDownloadDate = strInitialValue;
////           m_sMasterParamData.m_strCsvTxnTypeMiniPvmMappingDownloadDate = strInitialValue;
////           m_sMasterParamData.m_strISPasswordDownloadDate = strInitialValue;
////           m_sMasterParamData.m_strLogShippingDownloadDate = strInitialValue;
////
////           //Use Pine Encryption Key
////           //Ini we will be using Bank Keys so this flag is 0.
////           m_sMasterParamData.m_iUsePineEncryptionKeys = 0;
////
////           // Use Default Key Slot Only
////           //Ini we will be using only single default KeyslotID (10)
////           m_sMasterParamData.m_iUseDefaultKeySlotOnly = true;
////
////           //Additional Parameters
////           m_sMasterParamData.m_iOnlinePinFirstCharTimeout = 60;
////           m_sMasterParamData.m_iOnlinePinInterCharTimeout = 30;
////           m_sMasterParamData.m_iMinPinLength = 4;
////           m_sMasterParamData.m_iMaxPinLength = 12;
////           m_sMasterParamData.m_iDisplayMenuTimeout = 40;
////           m_sMasterParamData.m_iDisplayMessasgeTimeout = 2;
////           m_sMasterParamData.m_iHotKeyConfirmationTimeout = 10;
////
////           //Save default parameter data
////           if (!CFileSystem.IsFileExist(m_context, TERMINALMASTERPARAMFILE)) {
////               WriteMasterParamFile(m_context);
////           } else {
////               ReadMasterParamFile(m_context);
////           }
////           return AppConst.TRUE;
////       }
////
////       void CreateAdServerHTLFile() {
////           if (!CFileSystem.IsFileExist(m_context, MASTERHTLFILE)) {
////               m_setAdServerHTL = new HashSet<>();
////
////               Long llLong = new Long(1001);
////               m_setAdServerHTL.add(llLong);
////
////               llLong = new Long(1021);
////               m_setAdServerHTL.add(llLong);
////
////               llLong = new Long(1112);
////               m_setAdServerHTL.add(llLong);
////
////               llLong = new Long(1555);
////               m_setAdServerHTL.add(llLong);
////
////               llLong = new Long(4001);
////               m_setAdServerHTL.add(llLong);
////
////               llLong = new Long(4003);
////               m_setAdServerHTL.add(llLong);
////
////               List<Long> llList = new ArrayList<>(CGlobalData.m_setAdServerHTL);
////               CFileSystem.ReWriteFile(m_context, AppConst.MASTERHTLFILE, llList);
////           } else {
////               List<Long> llList = CFileSystem.ReadFile(m_context, Long[].class, AppConst.MASTERHTLFILE);
////               if(llList != null){
////                   m_setAdServerHTL.addAll(llList);
////               }
////           }
////       }
////
////       public void CreateLogShippingFile() {
////           CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Inside CreateLogShippingFile");
////           if (!CFileSystem.IsFileExist(m_context, AppConst.AUTOLOGSHIPMENTSMTPCREDENTIAL)) {
////               AutoLogShippingCredential ObjCred = new AutoLogShippingCredential();
////               List<AutoLogShippingCredential> sNewAutoCred = new ArrayList<>();
////               sNewAutoCred.add(ObjCred);
////               CFileSystem.ReWriteFile(m_context, AppConst.AUTOLOGSHIPMENTSMTPCREDENTIAL, sNewAutoCred);
////           }
////
////           if (!CFileSystem.IsFileExist(m_context, AppConst.AUTOLOGSHIPMENTFILE)) {
////               List<AutoLogShippingParams> sNewAutoParams = new ArrayList<>();
////               AutoLogShippingParams Obj = new AutoLogShippingParams();
////               sNewAutoParams.add(Obj);
////               CFileSystem.ReWriteFile(m_context, AppConst.AUTOLOGSHIPMENTFILE, sNewAutoParams);
////           }
////       }
////
////   public int InitializeFromDatabase(int iHostID, Context m_context) {
////         CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Inside InitializeFromDatabase");
////         LoadFromFiles(iHostID, m_context);
////         return AppConst.TRUE;
////     }
////
////     public int UpdateConnectionDataChangedFlag(int iHostID, boolean bFlag) {
////         String chArrConnectionDataFile = String.format("%s%01d.txt", CONNECTIONDATAFILENAME, iHostID);
////         CLogger.TraceLog(TRACE_DEBUG, "chArrConnectionDataFile[%s]", chArrConnectionDataFile);
////         List<TerminalConxData> listTerminalConxData = CFileSystem.ReadFile(m_context, TerminalConxData[].class, chArrConnectionDataFile);
////         if (listTerminalConxData != null) {
////             int numberOfTerminalConxData = listTerminalConxData.size();
////             if (numberOfTerminalConxData > 0) {
////                 for (int i = 0; i < numberOfTerminalConxData; i++) {
////                     CLogger.TraceLog(TRACE_DEBUG, "numberOfRow[%d]", numberOfTerminalConxData);
////                     listTerminalConxData.get(i).bIsDataChanged = bFlag;
////                     CLogger.TraceLog(TRACE_DEBUG, "m_bIsDataChanged[%s]", Boolean.toString(listTerminalConxData.get(i).bIsDataChanged));
////                 }
////                 CFileSystem.ReWriteFile(m_context, chArrConnectionDataFile, listTerminalConxData);
////             }
////         }
////         return AppConst.TRUE;
////     }
////
////     public int UpdateParamDataChangedFlag(int iHostID, boolean bFlag, Context m_context) {
////         String chFileName = String.format("%s%d.txt", TERMINALPARAMFILENAME, iHostID);
////         CLogger.TraceLog(TRACE_DEBUG, "param file name[%s]", chFileName);
////         //List<TerminalParamData> listTerminalParamData = CFileSystem.ReadFile(m_context, TerminalParamData[].class, chFileName);
////         TerminalParamData tData = CGlobalData.GetInstance().ReadParamFile(iHostID, m_context);
////         if (tData != null) {
////             tData.m_bIsDataChanged = bFlag;
////             CLogger.TraceLog(TRACE_DEBUG, "m_bIsDataChanged[%s]", Boolean.toString(tData.m_bIsDataChanged));
////             CGlobalData.GetInstance().WriteParamFile(iHostID, tData, m_context);
////         }
////         return AppConst.TRUE;
////     }
////
////     public int UpdateMasterParamDataChangedFlag(boolean bFlag, Context context) {
////         ReadMasterParamFile(context);
////         m_sMasterParamData.bIsDataChanged = bFlag;
////         CLogger.TraceLog(TRACE_DEBUG, "bIsDataChanged[%s]", Boolean.toString(m_sMasterParamData.bIsDataChanged));
////         WriteMasterParamFile(context);
////         return AppConst.TRUE;
////     }
////
////     public int UpdateAutoSettlementDataChangedFlag(int bFlag) {
////         m_sAutoSettleParams = ReadAutoSettleParams();
////         if (m_sAutoSettleParams != null) {
////             m_sAutoSettleParams.m_bIsDataChanged = bFlag != 0 ? true : false;
////             CLogger.TraceLog(TRACE_DEBUG, "m_bIsDataChanged[%s]", Boolean.toString(m_sAutoSettleParams.m_bIsDataChanged));
////             List<AutoSettlementParams> listAutoSettlementParams = new ArrayList<>();
////             listAutoSettlementParams.add(m_sAutoSettleParams);
////             CFileSystem.ReWriteFile(m_context, AUTOSETTLEPARFILE, listAutoSettlementParams);
////         }
////         return AppConst.TRUE;
////     }
////
////public int FirstInitialize(Context context) {
////       CLogger.TraceLog(TRACE_INFO, "Inside FirstInitialize");
////       int retVal = ExecutionResult._OK;
////
////       //Create MasterCGFile
////       CreateMasterCGFile();
////
////       //Create MasterIMFile
////       CreateMasterIMFile();
////
////       //Create MasterCLRDIMFile
////       CreateMasterCLRDIMFile();
////
////       //create MaterFCGfile
////       CreateMasterCFGFile();
////
////       //create MaterFONTfile
////       CreateMasterFONTFile();//FOR UNICODE FONT FILE
////
////       //create MaterLIbfile
////       CreateMasterLIBFile();//FOR Library FILE
////
////       //create CIMB minipvm file
////       CreateMasterMINIPVMFile();
////
////       //Create ParamFile
////       CreateParamFile(1, context);
////       CreateParamFile(2, context);
////
////       //Create UserAccountInfo File
////       CreateUserAccountFile(context);
////
////       //Create UserInfo File
////       CreateMasterParamFile(context);
////
////       CreateAdServerHTLFile();
////
////       //Create Conx File
////       CreateConnectionFile(1);
////
////       CreateConnectionFile(2);
////
////       CreateSignatureParamFile(2);
////
////       CreateDeviceStateFile();
////
////       CreateLogShippingFile();
////
////       //Save default Auto Settle params
////       if (false == CFileSystem.IsFileExist(m_context, AUTOSETTLEPARFILE)) {
////           WriteDefaultAutoSettleParams();
////       }
////
////       //Save default Auto Reversal params
////       if (false == CFileSystem.IsFileExist(m_context, AUTOREVERSALPARFILE)) {
////           WriteDefaultAutoReversalParams();
////       }
////
////       //Save default Auto Gprs params
////       if (false == CFileSystem.IsFileExist(m_context, AUTOGPRSALWAYSONPARFILE)) {
////           WriteDefaultAutoGprsParams();
////       }
////
////       //Save default Auto Premium Service params
////       if (false == CFileSystem.IsFileExist(m_context, AUTOPREMIUMSERVICEPARFILE)) {
////           WriteDefaultAutoPremiumServiceParams();
////       }
////       return retVal;
////   }
////
////   /*****************************************************************************
////    * Name     :  GetSerialPort
////    * Function :  This API return the current active COM port in the
////    *                connection configuration
////    *
////    * Parameter:
////    * Return   :
////    *****************************************************************************/
////   public int GetSerialPort(int iHostID) {
////       CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_INFO, "GetSerialPort");
////       int ComPort = COM0;
////       String chArrConnectionDataFile = String.format("%s%01d.txt", CONNECTIONDATAFILENAME, iHostID);
////       List<TerminalConxData> listTerminalConxData = CFileSystem.ReadFile(m_context, TerminalConxData[].class, chArrConnectionDataFile);
////       if (listTerminalConxData != null && listTerminalConxData.size() > 0) {
////           for (int i = 0; i < listTerminalConxData.size(); i++) {
////               TerminalConxData tData = listTerminalConxData.get(i);
////               if (tData != null) {
////                   if (ConnectionTypes.DIALUP_SERIAL == tData.iConnType) {
////                       CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_INFO, "atoi = %d ", tData.iComPort);
////                       int iComPort = tData.iComPort;
////                       switch (iComPort) {
////                           case 0:
////                               ComPort = COM0;
////                               CLogger.TraceLog(TRACE_INFO, "ComPort = COM0");
////                               break;
////                           case 10:
////                               ComPort = COM5;
////                               CLogger.TraceLog(TRACE_INFO, "ComPort = COM5");
////                               break;
////                           case 20:
////                               ComPort = COM_EXT;
////                               CLogger.TraceLog(TRACE_INFO, "ComPort = COM_EXT");
////                               break;
////                       }
////                   }
////               }
////           }
////       }
////       CLogger.TraceLog(TRACE_INFO, "ComPort = %d ", ComPort);
////       return ComPort;
////   }
////   /*****************************************************************************
////       * Name     :  GetSerialSendReceiveTimeout
////       * Function :  This API return the Send Receive Timeout in the
////       *                connection configuration
////       *
////       * Parameter:
////       * Return   : iSendReceiveTimeout
////       *****************************************************************************/
////      public int GetSerialSendReceiveTimeout(int iHostID) {
////          CLogger.TraceLog(TRACE_INFO, "GetSerialSendReceiveTimeout");
////          TerminalConxData tData = null;
////          int iSendReceiveTimeout = 30;
////          String chArrConnectionDataFile = String.format("%s%01d.txt", CONNECTIONDATAFILENAME, iHostID);
////          List<TerminalConxData> listTerminalConxData = CFileSystem.ReadFile(m_context, TerminalConxData[].class, chArrConnectionDataFile);
////          if (listTerminalConxData != null && listTerminalConxData.size() > 0) {
////              for (int i = 0; i < listTerminalConxData.size(); i++) {
////                  tData = listTerminalConxData.get(i);
////                  if (tData != null) {
////                      int iConnType = tData.iConnType;
////                      CLogger.TraceLog(TRACE_INFO, "bArrConnType = %d ", iConnType);
////                      if (ConnectionTypes.DIALUP_SERIAL == iConnType) {
////                          iSendReceiveTimeout = tData.iSendRecTimeout;
////                      }
////                  }
////              }
////          }
////          CLogger.TraceLog(TRACE_INFO, "iSendReceiveTimeout = %d ", iSendReceiveTimeout);
////          return iSendReceiveTimeout;
////      }
////
////      /*****************************************************************************
////       * Name     :  SetSSLMode
////       * Function :  This API set the SSL Mode to ON /Off
////       *
////       * Parameter:
////       * Return   :
////       *****************************************************************************/
////      public int SetSSLMode(boolean isON) {
////          CLogger.TraceLog(TRACE_DEBUG, "SetSSLMode[%s]", Boolean.toString(isON));
////          m_bIsSSL = isON;
////          return AppConst.TRUE;
////      }
////
////      /*****************************************************************************
////       * Name     :  GetSSLMode
////       * Function :  This API Get the SSL flag to use
////       *
////       * Parameter:
////       * Return   :
////       *****************************************************************************/
////      public boolean GetSSLMode() {
////          //Hardcoding SSL ON
////          return true;
////      }
////
////
////      /*****************************************************************************
////       * Name     :  SetSignCapMode
////       * Function :  This API set the Sign Capture Mode to ON /Off
////       *
////       * Parameter:
////       * Return   :
////       *****************************************************************************/
////      public int SetSignCapMode(boolean isON) {
////          CLogger.TraceLog(TRACE_DEBUG, "SetSignCapMode[%s]", Boolean.toString(isON));
////          m_bIsSignCapture = isON;
////          return AppConst.TRUE;
////      }
////
////      /*****************************************************************************
////       * Name     :  LoadFromFiles
////       * Function :  Load Global data structures from files
////       *                Only for single row_c_display_set_connection datas are loaded
////       * Parameter:
////       * Return   :
////       *****************************************************************************/
////      public byte LoadFromFiles(int iHostID, Context m_context) {
////          CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Inside LoadFromFiles");
////  //        m_sLoginInfo = new TerminalLoginInfo();
////          m_mLoginAccountInfo = new HashMap<>();
////          m_sAutoSettleParams = new AutoSettlementParams();
////
////          ReadMasterParamFile(m_context);
////
////  //        m_sLoginInfo = CFileSystem.SeekRead(m_context, TerminalLoginInfo[].class, USERINFOFILE, 0);
////
////          List<LOGIN_ACCOUNTS> login_accountsList = ReadLoginAccountFile(USERINFOFILE);
////          int numberOfAccounts = 0;
////          if (null != login_accountsList) {
////              numberOfAccounts = login_accountsList.size();
////          }
////          m_mLoginAccountInfo = new HashMap<>();
////          for (int i = 0; i < numberOfAccounts; i++) {
////              m_mLoginAccountInfo.put(login_accountsList.get(i).m_strUserID, login_accountsList.get(i));
////          }
////
////          m_sAutoSettleParams = CFileSystem.SeekRead(m_context, AutoSettlementParams[].class, AUTOSETTLEPARFILE, 0);
////          LoadConnectionIndex(iHostID);
////          m_sPSKData = CFileSystem.SeekRead(m_context, TerminalPSKData[].class, PSKSDWNLDFILE, 0);
////          CFileSystem.DeleteFile(m_context, TEMPBINRANGEFILE);
////          if (m_sMasterParamData.m_bIsBinRangeChanged) {
////              SortBinRangeFile();
////              m_sMasterParamData.m_bIsBinRangeChanged = false;
////              WriteMasterParamFile(m_context);
////          }
////          CFileSystem.DeleteFile(m_context, TEMPCSVTXNMAPFILE);
////
////          //Transaction Bin
////          //delete temp file if present.
////          CFileSystem.DeleteFile(m_context, TEMPTXNBINFILE);
////          //if flag true, sort transaction bin file as it is currently downloaded and update flag.
////          if (m_sMasterParamData.m_bIsTxnBinChanged) {
////              SortTxnBinFile();
////              m_sMasterParamData.m_bIsTxnBinChanged = false;
////              WriteMasterParamFile(m_context);
////          }
////          return ((byte) AppConst.TRUE);
////      }
////
////      public void LoadConnectionIndex(int iHostID) {
////          CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Inside LoadConnectionIndex");
////          TerminalConxData tData;
////          m_sConxData.m_bArrConnIndex = new StructConnIndex();
////          String chArrConnectionDataFile = String.format("%s%01d.txt", CONNECTIONDATAFILENAME, iHostID);
////          List<TerminalConxData> listParams = CFileSystem.ReadFile(m_context, TerminalConxData[].class, chArrConnectionDataFile);
////          if (listParams != null && listParams.size() > 0) {
////              int numberOfRow = listParams.size();
////              for (int i = 0; i < numberOfRow; i++) {
////                  tData = listParams.get(i);
////                  if (ConnectionTypes.DIALUP_SERIAL == tData.iConnType) {
////                      m_sConxData.m_bArrConnIndex.CON_SerialIp.index = i;
////                  } else if (ConnectionTypes.DIALUP_GPRS == tData.iConnType) {
////                      m_sConxData.m_bArrConnIndex.CON_GPRS.index = i;
////                  } else if (ConnectionTypes.DIALUP_ETHERNET == tData.iConnType) {
////                      m_sConxData.m_bArrConnIndex.CON_ETHERNET.index = i;
////                  } else if (ConnectionTypes.DIALUP_WIFI == tData.iConnType) {
////                      m_sConxData.m_bArrConnIndex.CON_WIFI.index = i;
////                  }
////              }
////          }
////      }
////
////
////
////
////    /*****************************************************************************
////     * Name     :  WriteLoginFile
////     * Function :  Write Connection File with current global data
////     * Parameter:
////     * Return   :
////     *****************************************************************************/
////
////    public func WriteLoginAccountFile(login_accounts:[LoginAccounts],fileName:String) {
////        do{
////
////            _ = try FileSystem.AppendFile(strFileName: fileName, with: login_accounts)
////        }
////        catch{
////            fatalError("File Append Error")
////        }
////    }
////    public func ReadLoginAccountFile(fileName:String) -> [LoginAccounts] {
////        if let list:[LoginAccounts] = FileSystem.ReadFile(strFileName: fileName)
////        {
////            return list;
////        }
////    }

    public func getFullSerialNumber() -> String {
        if let serialNumber = fullSerialNumber{
           return serialNumber;
        }
       }
}

    
