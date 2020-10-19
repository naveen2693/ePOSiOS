//
//  GlobalData.swift
//  ePOS
//
//  Created by Naveen Goyal on 06/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
final class GlobalData
{
    var  m_sConxData = StructConxData();
    var  fullSerialNumber:String?
    static var m_sTerminalParamData_Cache: TerminalParamData?
    var m_sMasterParamData: TerminalMasterParamData?
    var m_sPSKData:TerminalPSKData?
    var m_sAutoReversalParams:AutoReversalParams?;
    var m_sAutoSettleParams:AutoSettlementParams?;
    var m_sAutoGprsParams:AutoGPRSNetworkParams?;
    var m_sAutoPremiumServiceParams:AutoPremiumServiceParams?;
    var m_sMasterParamData_cache:TerminalMasterParamData?;
    var m_objCurrentLoggedInAccount: LOGINACCOUNTS?
    static var  m_strIMEI = "";
    var m_setAdServerHTL:Set<Int64>?
    var m_strCurrentLoggedInUserPIN: String = ""
    var m_bIsLoggedIn: Bool = false
    var m_csFinalMsgDisplay58: String = ""
    
    private init() {}
    private static var _shared: GlobalData?
    public static var singleton: GlobalData {
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
            _ = try FileSystem.AppendFile(strFileName: AppConstant.DEVICE_STATE, with: [deviceState])
        }
        catch {
            fatalError("File Write Error")
        }
    }
    
    // MARK:- readParamFile
    func ReadParamFile() -> TerminalParamData? {
        if (GlobalData.m_sTerminalParamData_Cache == nil) {
            
            if let m_sTerminalParamData:TerminalParamData = FileSystem.SeekRead(strFileName: AppConst.TERMINALPARAMFILENAME, iOffset: 0)
            {
                GlobalData.m_sTerminalParamData_Cache = m_sTerminalParamData
            }
        }
        
        return GlobalData.m_sTerminalParamData_Cache
    }
    
    // MARK:- WriteMasterParamFile
    func WriteMasterParamFile() -> Int {
        var listTerminalMasterParam = [TerminalMasterParamData]();
        if let masterTerminalData = m_sMasterParamData {
            listTerminalMasterParam.append(masterTerminalData);
            m_sMasterParamData_cache = m_sMasterParamData;//Assigning to cache for future use
            do{
              _ = try FileSystem.ReWriteFile(strFileName: AppConstant.TERMINALMASTERPARAMFILE, with: listTerminalMasterParam);
            }catch
            {
                fatalError("ReWriteFile : WriteMasterParamFile")
            }
        }
        return AppConstant.TRUE;
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
        return AppConstant.TRUE;
    }
    
    // MARK:- ReadMasterParamFile
    func  ReadMasterParamFile() -> Int {
        if m_sMasterParamData_cache == nil
        {
            m_sMasterParamData = FileSystem.SeekRead(strFileName: AppConstant.TERMINALMASTERPARAMFILE, iOffset: 0);
            m_sMasterParamData_cache = m_sMasterParamData;
        }
        else
        {
            m_sMasterParamData = m_sMasterParamData_cache;
        }
        if (m_sMasterParamData == nil) {
            return (AppConstant.FALSE);
        }
        return (AppConstant.TRUE);
        return AppConstant.TRUE;
    }
    
    
    func setFullSerialNumber(fullSerialNumber: String) {
        //setting full serial number from remote to be used in activation to generate Short Serial number
        //no need to store in file as it will be set everytime app call Plutus API
        debugPrint("Inside setFullSerialNumber : \(fullSerialNumber)")
        //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Inside setFullSerialNumber : " + fullSerialNumber);
        self.fullSerialNumber = fullSerialNumber;
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
    public func CreateMasterCLRDIMFile() -> Int  {
        
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
        terminalParamData.m_strHardwareSerialNumber = PlatFormUtils.getLast8DigitOfIMEINumber();
        _ = WriteParamFile(listParamData: terminalParamData);
        return AppConstant.TRUE;
    }
    
    
    
    public func CreateMasterParamFile() -> Int{
        var m_sMasterParamData =  TerminalMasterParamData();
        
        //App version
        m_sMasterParamData.m_strAppVersion = AppConstant.APP_VERSION;
        
        m_sMasterParamData.m_strEMVParVersion = "121212121212";
        
        //for contactless
        m_sMasterParamData.m_strCLESSEMVParVersion = "121212121212";
        
        m_sMasterParamData.bIsDataChanged = true;
        m_sMasterParamData.bIsBitmap320ActiveHostSet = false;
        m_sMasterParamData.bIsBitmap440ActiveHostSet = false;
        m_sMasterParamData.bIsBitmap500ActiveHostSet = false;
        
        m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[0] = 0x00;
        m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[1] = 0x00;
        m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[2] = 0x00;
        m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[3] = 0x00;
        m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[4] = 0x00;
        m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[5] = 0x00;
        m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[6] = 0x00;
        m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber[7] = 0x00;
        
        m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[0] = Byte(0xFF);
        m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[1] = Byte(0xFF);
        m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[2] = Byte(0xFF);
        m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[3] = Byte(0xFF);
        m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[4] = Byte(0xFF);
        m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[5] = Byte(0xFF);
        m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[6] = Byte(0xFF);
        m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber[7] = Byte(0xFF);
        
        let strInitialValue = "010101000000";
        let bArrInitialValue = strInitialValue.bytes;
        m_sMasterParamData.m_strBinRangeDownloadDate = strInitialValue;
        m_sMasterParamData.m_bIsBinRangeChanged = false;
        
        //Transaction Bin
        m_sMasterParamData.m_strTxnBinDownloadDate = strInitialValue;
        m_sMasterParamData.m_bIsTxnBinChanged = false;
        
        m_sMasterParamData.m_strCSVTxnMapVersion = strInitialValue;
        
        m_sMasterParamData.m_strAIDEMVTXNTYPEDownloadDate = strInitialValue;
        
        m_sMasterParamData.m_strTxnTypeFlagsMappingDownloadDate = strInitialValue;
        
        //CSV transaction Ignore Amt List
        m_sMasterParamData.m_strIgnoreAmtCSVTxnListDownloadDate = strInitialValue;
        
        //EMV TAG  List
        m_sMasterParamData.m_strEMVTagListDownloadDate = strInitialValue;
        
        //cless param  List
        m_sMasterParamData.m_strCLessParamDownloadDate = strInitialValue;
        
        //AID EMV TXNTYPE
        m_sMasterParamData.m_strAIDEMVTXNTYPEDownloadDate = strInitialValue;
        
        //TXNTYPE Flags Mapping  abhishek added 23/11/2015
        m_sMasterParamData.m_strAIDEMVTXNTYPEDownloadDate = strInitialValue;
        m_sMasterParamData.m_strCsvTxnTypeMiniPvmMappingDownloadDate = strInitialValue;
        m_sMasterParamData.m_strISPasswordDownloadDate = strInitialValue;
        m_sMasterParamData.m_strLogShippingDownloadDate = strInitialValue;
        
        //Use Pine Encryption Key
        //Ini we will be using Bank Keys so this flag is 0.
        m_sMasterParamData.m_iUsePineEncryptionKeys = 0;
        
        // Use Default Key Slot Only
        //Ini we will be using only single default KeyslotID (10)
        m_sMasterParamData.m_iUseDefaultKeySlotOnly = true;
        
        //Additional Parameters
        m_sMasterParamData.m_iOnlinePinFirstCharTimeout = 60;
        m_sMasterParamData.m_iOnlinePinInterCharTimeout = 30;
        m_sMasterParamData.m_iMinPinLength = 4;
        m_sMasterParamData.m_iMaxPinLength = 12;
        m_sMasterParamData.m_iDisplayMenuTimeout = 40;
        m_sMasterParamData.m_iDisplayMessasgeTimeout = 2;
        m_sMasterParamData.m_iHotKeyConfirmationTimeout = 10;
        
        //Save default parameter data
        if !(FileSystem.IsFileExist(strFileName: AppConstant.TERMINALMASTERPARAMFILE))
        {
            _  = WriteMasterParamFile();
        }
        else
        {
            _  =  ReadMasterParamFile();
        }
        return AppConst.TRUE;
    }
    
    
    func  CreateAdServerHTLFile() {
        if FileSystem.IsFileExist(strFileName: AppConstant.MASTERHTLFILE)
        {
            m_setAdServerHTL = Set<Int64>();
            m_setAdServerHTL?.insert(1001);
            m_setAdServerHTL?.insert(1021);
            m_setAdServerHTL?.insert(1112);
            m_setAdServerHTL?.insert(1555);
            m_setAdServerHTL?.insert(4001);
            m_setAdServerHTL?.insert(4003);
            let llList = [m_setAdServerHTL];
            do {
                _ = try FileSystem.ReWriteFile(strFileName: AppConstant.MASTERHTLFILE, with: llList);
            }catch {
                fatalError("Rewrite File Error: CreateAdServerHTLFile")
            }
        }
        else {
            if let readData:[Int64] = FileSystem.ReadFile(strFileName: AppConstant.MASTERHTLFILE){
                for data in readData{
                    m_setAdServerHTL?.insert(data);
                }
            }
        }
    }
    
    public  func CreateLogShippingFile() {
        if FileSystem.IsFileExist(strFileName: AppConstant.AUTOLOGSHIPMENTSMTPCREDENTIAL) {
            let ObjCred =  AutoLogShippingCredential();
            var sNewAutoCred = [AutoLogShippingCredential]();
            sNewAutoCred.append(ObjCred);
            do{
                _ = try FileSystem.ReWriteFile(strFileName: AppConstant.AUTOLOGSHIPMENTSMTPCREDENTIAL, with: sNewAutoCred);
            }catch{
                fatalError("Rewrite Error: CreateLogShippingFile")
            }
        }
        if !(FileSystem.IsFileExist(strFileName: AppConstant.AUTOLOGSHIPMENTFILE))
        {
            var sNewAutoParams = [AutoLogShippingParams]();
            let ObjAutoLogShippingParams =  AutoLogShippingParams();
            sNewAutoParams.append(ObjAutoLogShippingParams);
            do{
                _ = try FileSystem.ReWriteFile(strFileName: AppConstant.AUTOLOGSHIPMENTFILE, with: sNewAutoParams);
            }catch{
                fatalError("Rewrite Error: CreateLogShippingFile")
            }
        }
    }
    
    /**
     * @return
     * @details Initialize Global variables from files present
     */
    public func InitializeFromDatabase() -> Int {
        LoadFromFiles();
        return AppConstant.TRUE;
    }
    
    
    /*****************************************************************************
     * Name     :  LoadFromFiles
     * Function :  Load Global data structures from files
     *                Only for single row_c_display_set_connection datas are loaded
     * Parameter:
     * Return   :
     *****************************************************************************/
    public func LoadFromFiles() -> Int {
        var m_mLoginAccountInfo = Dictionary<String,String>();
        m_sAutoSettleParams = AutoSettlementParams();
        _ = ReadMasterParamFile();
        if let login_accountsList:[LoginAccounts] = ReadLoginAccountFile(fileName: AppConstant.USERINFOFILE)
        {
            var numberOfAccounts = 0;
            numberOfAccounts = login_accountsList.count ;
            for value in 0...numberOfAccounts {
                m_mLoginAccountInfo["m_strUserID"] =  login_accountsList[value].userID
            }
            
            m_sAutoSettleParams = FileSystem.SeekRead(strFileName: AppConstant.AUTOSETTLEPARFILE, iOffset: 0);
            LoadConnectionIndex();
            m_sPSKData = FileSystem.SeekRead(strFileName: AppConstant.PSKSDWNLDFILE, iOffset: 0);
            _ = FileSystem.DeleteFileComplete(strFileName: AppConstant.TEMPBINRANGEFILE);
            if ((m_sMasterParamData?.m_bIsBinRangeChanged) != nil) {
                _ = SortBinRangeFile();
                m_sMasterParamData?.m_bIsBinRangeChanged = false;
                _ =  WriteMasterParamFile();
            }
            _  = FileSystem.DeleteFileComplete(strFileName: AppConstant.TEMPCSVTXNMAPFILE);
            
            //Transaction Bin
            //delete temp file if present.
            _  = FileSystem.DeleteFileComplete(strFileName: AppConstant.TEMPTXNBINFILE);
            //if flag true, sort transaction bin file as it is currently downloaded and update flag.
            if ((m_sMasterParamData?.m_bIsTxnBinChanged) != nil) {
                _ = SortBinRangeFile();
                m_sMasterParamData?.m_bIsTxnBinChanged = false;
                _  = WriteMasterParamFile();
            }
        }
        return AppConstant.TRUE;
    }
    
    
    public func LoadConnectionIndex() {
        var tData:TerminalConxData?;
        m_sConxData.m_bArrConnIndex = StructConnIndex();
        if let listParams:[TerminalConxData] = FileSystem.ReadFile(strFileName: AppConstant.CONNECTIONDATAFILENAME){
            let numberOfRow = listParams.count;
            for count in 0...numberOfRow  {
                tData = listParams[count];
                if ConnectionTypes.DIALUP_SERIAL == tData?.iConnType {
                    m_sConxData.m_bArrConnIndex.CON_SerialIp.index = count;
                } else if ConnectionTypes.DIALUP_GPRS == tData?.iConnType {
                    m_sConxData.m_bArrConnIndex.CON_GPRS.index = count;
                } else if ConnectionTypes.DIALUP_ETHERNET == tData?.iConnType  {
                    m_sConxData.m_bArrConnIndex.CON_ETHERNET.index = count;
                } else if ConnectionTypes.DIALUP_WIFI == tData?.iConnType {
                    m_sConxData.m_bArrConnIndex.CON_WIFI.index = count;
                }
            }
        }
    }
    
    
    /*****************************************************************************
     * Name     :  UpdateParameter
     * Function :  Update parameter download from Server
     * Parameter:
     * Return   :
     *****************************************************************************/
    
    func UpdateParameter(ParameterData:ParameterData) -> Bool {
        let iParameterID = ParameterData.ulParameterId;
        switch (iParameterID) {
        case ParameterIDs._Serial_Initialization_IP
        ,ParameterIDs._Serial_Initialization_Port
        , ParameterIDs._Serial_Transaction_IP
        , ParameterIDs._Serial_Transaction_Port
        , ParameterIDs._Serial_Transaction_SSL_IP
        , ParameterIDs._Serial_Transaction_SSL_Port
        , ParameterIDs._Serial_Connect_Timeout
        , ParameterIDs._Serial_Send_Rec_Timeout
        , ParameterIDs._Serial_User_Id
        , ParameterIDs._Serial_Password
        , ParameterIDs._Serial_IP_Com_Port
        , ParameterIDs._Serial_Secondary_Initialization_IP
        , ParameterIDs._Serial_Secondary_Initialization_Port
        , ParameterIDs._Serial_Secondary_Transaction_IP
        , ParameterIDs._Serial_Secondary_Transaction_Port
        , ParameterIDs._Serial_Secondary_Transaction_SSL_IP
        , ParameterIDs._Serial_Secondary_Transaction_SSL_Port:
        UpdateSerialIPParameters(ParameterDatas: ParameterData);
            
            
        case ParameterIDs._GPRS_Primary_Phone_Number
        , ParameterIDs._GPRS_Secondary_Phone_Number
        , ParameterIDs._GPRS_Initialization_IP
        , ParameterIDs._GPRS_Initialization_Port
        , ParameterIDs._GPRS_Transaction_IP
        , ParameterIDs._GPRS_Transaction_Port
        , ParameterIDs._GPRS_Transaction_SSL_IP
        , ParameterIDs._GPRS_Transaction_SSL_Port
        , ParameterIDs._GPRS_Connect_Timeout
        , ParameterIDs._GPRS_Send_Rec_Timeout
        , ParameterIDs._GPRS_User_Id
        , ParameterIDs._GPRS_Password
        , ParameterIDs._GPRS_GPRS_Service_provider
        , ParameterIDs._GPRS_Secondary_Initialization_IP
        , ParameterIDs._GPRS_Secondary_Initialization_Port
        , ParameterIDs._GPRS_Secondary_Transaction_IP
        , ParameterIDs._GPRS_Secondary_Transaction_Port
        , ParameterIDs._GPRS_Secondary_Transaction_SSL_IP
        , ParameterIDs._GPRS_Secondary_Transaction_SSL_Port
        , ParameterIDs._GPRS_APN_Name:
            UpdateGPRSParameters(ParameterDatas: ParameterData);
            
            
        case ParameterIDs._Batch_Size:
            UpdateTerminalParameters(ParameterDatas: ParameterData);
            
        case ParameterIDs._Log_File_Size
        ,ParameterIDs._Log_Shipping_Flag
        ,ParameterIDs._Logging_Level:
            UpdateLoggingParameters(ParameterDatas: ParameterData);
            
        case ParameterIDs._Auto_Settlement_Enabled
             , ParameterIDs._Settlement_Start_Time
        , ParameterIDs._Settlement_Frequency
        , ParameterIDs._Settlement_Retry_Count
        , ParameterIDs._Settlement_Retry_Interval:
            UpdateAutoSettlementParametes(ParameterDatas: ParameterData);
            
        case ParameterIDs._Auto_Reversal_Enabled
        , ParameterIDs._Auto_Reversal_First_Try_Interval
        , ParameterIDs._Auto_Reversal_Retry_Interval
        , ParameterIDs._Auto_Reversal_Max_Retry_Count:
            UpdateAutoReversalParametes(ParameterDatas: ParameterData);
            
        case ParameterIDs._Secondary_IP_Max_Retry_Count:
            UpdateSecondaryIPMaxRetryCounterParameters(ParameterDatas: ParameterData);
            
            
        case ParameterIDs._Always_On_GPRS_PPP   // Sunder S: 29-10-2014 Added for GPRS
        , ParameterIDs._Always_On_GPRS_TCP   // Sunder S: 29-10-2014 Added for GPRS
        , ParameterIDs._Amex_Gprs_EMV_Field55_Hex_Data_Tag_Enable    // Sunder S: 06-02-2015 Added for Amex EMV Sale GPRS
        , ParameterIDs._Amex_Gprs_EMV_Receipt_61_Dump_Enable:         // Sunder S: 11-02-2015 Added for Amex 61 dump printing
            UpdatePPPTCPAlwaysOnParameters(ParameterDatas: ParameterData);
            
            
        case ParameterIDs._Auto_Gprs_Always_On_Enabled                   // Sunder S: 06-02-2015 Added for AutoGprs
        , ParameterIDs._Auto_Gprs_Always_On_Retry_Interval:            // Sunder S: 11-02-2015 Added for AutoGprs
            UpdateAutoGprsParametes(ParameterDatas: ParameterData);
            
        case ParameterIDs._Sign_Upload_Chunk_size:                        //Amitesh::To have chunk size
            //To update chunk size
            UpdateSignUploadchksizeOnParameters(ParameterDatas: ParameterData);
            
            
        case ParameterIDs._Cless_PreProcessing_Amount
        , ParameterIDs._Cless_PreProcessing_TxnType
        , ParameterIDs._Cless_MaxIntegration_TxnAmt:
            UpdateClessDefPreProcessingParameters(ParameterDatas: ParameterData);
            
        case ParameterIDs._IS_BIOMETRIC_ENABLED:
            UpdateBiometricEnabledFlagOnParameters(ParameterDatas: ParameterData);
            
        case ParameterIDs._NO_PRINT_CHARGESLIP_DATA:
            UpdateNoPrintMessage(ParameterDatas: ParameterData);
            
            
        case ParameterIDs._Auto_Premium_Service_Enabled,
         ParameterIDs._Auto_Premium_Service_Start_Time,
         ParameterIDs._Auto_Premium_Service_Frequency,
         ParameterIDs._Auto_Premium_Service_Retry_Count,
         ParameterIDs._Auto_Premium_Service_Retry_Interval:
            UpdateAutoPremiumServiceParametes(ParameterDatas: ParameterData);
            
        case ParameterIDs._IS_CRIS_SUPPORTED: //Amitesh:: To get Is CRIS supported flag
            UpdateISCRISEnabledFlagOnParameters(ParameterDatas: ParameterData);
            
            
        case ParameterIDs._CIMB_PRINCIPLE_OPERATOR_PASSWORD,
         ParameterIDs._CIMB_IS_PASSWORD_SETTLEMENT,   //principle user changes as per requirement
         ParameterIDs._IS_PASSWORD_NEEDED_FOR_SPECIFIC_TXNS:
            UpdateCIMBUserPasswordParameters(ParameterDatas: ParameterData);
            
            
        //--------------EMV Params -----------------------------//
        case ParameterIDs._EMVFallbackChipRetryCounter,
            ParameterIDs._EMV_MERCHANT_CATEGORY_CODE:
            UpdateEMVParameters(ParameterDatas: ParameterData);
            
            
        //Additional Parameters
        case ParameterIDs._Online_Pin_First_Char_Timeout
        , ParameterIDs._Online_Pin_Interchar_Timeout
        , ParameterIDs._Min_Pin_Length
        , ParameterIDs._Max_Pin_Length
        , ParameterIDs._Display_Menu_Timeout
        , ParameterIDs._Display_Message_Timeout
        , ParameterIDs._HotKey_Confirmation_Timeout
        , ParameterIDs._Is_Pin_Required_Service_Code_6
        , ParameterIDs._Is_Pin_Bypass_Service_Code_6
        , ParameterIDs._Ignore_Integrated_TXN_Amount_EMV_TXN:
            UpdateTerminalMasterAdditionalParameters(ParameterDatas: ParameterData);
            
            
        case ParameterIDs._Ethernet_Initialization_IP
        , ParameterIDs._Ethernet_Initialization_Port
        , ParameterIDs._Ethernet_Transaction_IP
        , ParameterIDs._Ethernet_Transaction_Port
        , ParameterIDs._Ethernet_Transaction_SSL_IP
        , ParameterIDs._Ethernet_Transaction_SSL_Port
        , ParameterIDs._Ethernet_Connect_Timeout
        , ParameterIDs._Ethernet_Send_Rec_Timeout
        , ParameterIDs._Ethernet_Secondary_Initialization_IP
        , ParameterIDs._Ethernet_Secondary_Initialization_Port
        , ParameterIDs._Ethernet_Secondary_Transaction_IP
        , ParameterIDs._Ethernet_Secondary_Transaction_Port
        , ParameterIDs._Ethernet_Secondary_Transaction_SSL_IP
        , ParameterIDs._Ethernet_Secondary_Transaction_SSL_Port:
            UpdateEthernetIPParameters(ParameterDatas: ParameterData);
            
            
            
        case ParameterIDs._HSM_Primay_IP
        , ParameterIDs._HSM_Primay_Port
        , ParameterIDs._HSM_Secondary_IP
        , ParameterIDs._HSM_Secondary_Port
        , ParameterIDs._HSM_Retry_Count
        , ParameterIDs._Initialization_Parameter_Enabled_Central
        , ParameterIDs._Initialization_Parameter_Enabled_HUB
        , ParameterIDs._Packet_Send_320
        , ParameterIDs._Packet_Send_440
        , ParameterIDs._Packet_Send_500
        , ParameterIDs._Use_Pine_Key_Encryption
        , ParameterIDs._Use_Default_KeySlotID_Only:
            UpdateTerminalMasterParameters(ParameterDatas: ParameterData);
            
            
        case ParameterIDs._Content_Server_Download_Url
        , ParameterIDs._Content_Server_Enabled
        , ParameterIDs._Content_Server_Upload_Url
        , ParameterIDs._Content_Server_Download_Apk_Url
        , ParameterIDs._Content_Server_Download_Dll_Url
        , ParameterIDs._Content_Server_Connection_Time_Out
        , ParameterIDs._Content_Server_Socket_Time_Out:
            UpdateContentServerParams(ParameterDatas: ParameterData);
            
            
        default: break
            
        }
        return true;
    }
    
    
    
    public func UpdateSerialIPParameters(ParameterDatas:ParameterData) {
        if var tData:TerminalConxData = FileSystem.SeekRead(strFileName: AppConstant.CONNECTIONDATAFILENAME, iOffset: m_sConxData.m_bArrConnIndex.CON_SerialIp.index){
            switch (ParameterDatas.ulParameterId) {
            case ParameterIDs._Serial_Transaction_SSL_IP:
                if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_IPADDR_LEN) {
                    if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                    {
                        tData.strTransactionSSLServerIP = bytes
                    }
                }
                
            case ParameterIDs._Serial_Transaction_SSL_Port:
                if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_ISO_PORT_LEN) {
                    tData.iTransactionSSLPort =  Int(UInt32(ParameterDatas.chArrParameterVal))
                }
                
            case ParameterIDs._Serial_Secondary_Transaction_SSL_IP:
                if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_IPADDR_LEN) {
                    if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                    {
                        tData.strSecondaryTransactionSSLServerIP = bytes
                    }
                }
                
            case ParameterIDs._Serial_Secondary_Transaction_SSL_Port:
                if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_ISO_PORT_LEN) {
                    tData.iSecondaryTransactionSSLPort = Int(UInt32(ParameterDatas.chArrParameterVal))
                    
                }
                
            case ParameterIDs._Serial_Connect_Timeout:
                if ((ParameterDatas.chArrParameterVal.count + 2) < AppConstant.MAX_CONNECTION_TIMEOUT_LEN) {
                    tData.iConnTimeout =  Int(UInt32(ParameterDatas.chArrParameterVal))
                }
                
            case ParameterIDs._Serial_Send_Rec_Timeout:
                if ((ParameterDatas.chArrParameterVal.count + 2) < AppConstant.MAX_CONNECTION_TIMEOUT_LEN) {
                    tData.iSendRecTimeout = Int(UInt32(ParameterDatas.chArrParameterVal))
                }
                
            case ParameterIDs._Serial_User_Id:
                if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_LOGIN_ID_LEN) {
                    if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                    {
                        tData.strLoginID = bytes
                    }
                }
                
            case ParameterIDs._Serial_Password:
                if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_LOGIN_PASS_LEN) {
                    if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                    {
                        tData.strPassword = bytes
                    }
                    
                    
                }
                
            default:
                return;
            }
        
        SetConnectionChangedFlag(isChanged: true);
        _ = FileSystem.SeekWrite(strFileName: AppConstant.CONNECTIONDATAFILENAME, with: tData, iOffset: m_sConxData.m_bArrConnIndex.CON_SerialIp.index);
        }
    }
    

    func GetMessage(id: Int64, messagebuffer: [Byte]) -> Bool {
        return true
    }

    public func UpdateEthernetIPParameters(ParameterDatas:ParameterData) {
           if var tData:TerminalConxData = FileSystem.SeekRead(strFileName: AppConstant.CONNECTIONDATAFILENAME, iOffset: m_sConxData.m_bArrConnIndex.CON_SerialIp.index){
               switch (ParameterDatas.ulParameterId) {
               case ParameterIDs._Ethernet_Transaction_SSL_IP:
                   if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_IPADDR_LEN) {
                       if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                       {
                           tData.strTransactionSSLServerIP = bytes
                       }
                   }
                   
              case ParameterIDs._Ethernet_Secondary_Transaction_SSL_IP:
                if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_IPADDR_LEN) {
                       if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                       {
                           tData.strTransactionSSLServerIP = bytes
                       }
                   }
                  
               case ParameterIDs._Ethernet_Transaction_SSL_Port:
                   if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_ISO_PORT_LEN) {
                       tData.iSecondaryTransactionSSLPort = Int(UInt32(ParameterDatas.chArrParameterVal))
                       
                   }
                   
               case ParameterIDs._Ethernet_Connect_Timeout:
                   if ((ParameterDatas.chArrParameterVal.count + 2) < AppConstant.MAX_CONNECTION_TIMEOUT_LEN) {
                       tData.iConnTimeout =  Int(UInt32(ParameterDatas.chArrParameterVal))
                   }
                   
               case ParameterIDs._Ethernet_Send_Rec_Timeout:
                   if ((ParameterDatas.chArrParameterVal.count + 2) < AppConstant.MAX_CONNECTION_TIMEOUT_LEN) {
                       tData.iSendRecTimeout = Int(UInt32(ParameterDatas.chArrParameterVal))
                   }
                   
               default:
                   return;
               }
           
           SetConnectionChangedFlag(isChanged: true);
           _ = FileSystem.SeekWrite(strFileName: AppConstant.CONNECTIONDATAFILENAME, with: tData, iOffset: m_sConxData.m_bArrConnIndex.CON_SerialIp.index);
           }
       }
    
    public func UpdateGPRSParameters(ParameterDatas:ParameterData) {
           if var tData:TerminalConxData = FileSystem.SeekRead(strFileName: AppConstant.CONNECTIONDATAFILENAME, iOffset: m_sConxData.m_bArrConnIndex.CON_GPRS.index){
               switch (ParameterDatas.ulParameterId) {
               case ParameterIDs._GPRS_Transaction_SSL_IP:
                   if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_IPADDR_LEN) {
                       if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                       {
                           tData.strTransactionSSLServerIP = bytes
                       }
                   }
                   
               case ParameterIDs._GPRS_Transaction_SSL_Port:
                   if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_ISO_PORT_LEN) {
                       tData.iTransactionSSLPort =  Int(UInt32(ParameterDatas.chArrParameterVal))
                   }
                   
               case ParameterIDs._GPRS_Secondary_Transaction_SSL_IP:
                   if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_IPADDR_LEN) {
                       if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                       {
                           tData.strSecondaryTransactionSSLServerIP = bytes
                       }
                   }
                   
               case ParameterIDs._GPRS_Secondary_Transaction_SSL_Port:
                   if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_ISO_PORT_LEN) {
                       tData.iSecondaryTransactionSSLPort = Int(UInt32(ParameterDatas.chArrParameterVal))
                       
                   }
                   
               case ParameterIDs._GPRS_Connect_Timeout:
                   if ((ParameterDatas.chArrParameterVal.count + 2) < AppConstant.MAX_CONNECTION_TIMEOUT_LEN) {
                       tData.iConnTimeout =  Int(UInt32(ParameterDatas.chArrParameterVal))
                   }
                   
               case ParameterIDs._GPRS_Send_Rec_Timeout:
                   if ((ParameterDatas.chArrParameterVal.count + 2) < AppConstant.MAX_CONNECTION_TIMEOUT_LEN) {
                       tData.iSendRecTimeout = Int(UInt32(ParameterDatas.chArrParameterVal))
                   }
                   
               case ParameterIDs._GPRS_User_Id:
                   if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_LOGIN_ID_LEN) {
                       if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                       {
                           tData.strLoginID = bytes
                       }
                   }
                   
               case ParameterIDs._GPRS_Password:
                   if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_LOGIN_PASS_LEN) {
                       if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                       {
                           tData.strPassword = bytes
                       }
                   }
                   
               case ParameterIDs._GPRS_APN_Name:
                       if (ParameterDatas.chArrParameterVal.count < 100) {
                           if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                              {
                                  tData.strAPN = bytes
                              }
                           
                       }
                       
               case ParameterIDs._GPRS_GPRS_Service_provider:
                   if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_GPRS_SERVICES_PROVIDER_LEN) {
                           if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                              {
                                  tData.strGPRSServiceProvider = bytes
                              }
                       }
                       
               default:
                   return;
               }
           
             SetConnectionChangedFlag(isChanged: true);
           _ = FileSystem.SeekWrite(strFileName: AppConstant.CONNECTIONDATAFILENAME, with: tData, iOffset: m_sConxData.m_bArrConnIndex.CON_GPRS.index);
           }
       }
    
    
    public func UpdateContentServerParams(ParameterDatas:ParameterData) {
        if var t_contentServerParamData = ReadContentServerParamFile(){
           switch (ParameterDatas.ulParameterId) {
               case ParameterIDs._Content_Server_Download_Url:
                if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                   {
                    t_contentServerParamData.m_strDownloadUrl = bytes
                    }
                
               case ParameterIDs._Content_Server_Enabled:
                t_contentServerParamData.m_bIsContentSyncEnabled = (String(ParameterDatas.chArrParameterVal[0]) == "1") ? true : false;
                   
               case ParameterIDs._Content_Server_Upload_Url:
                if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                {
                    t_contentServerParamData.m_strUploadUrl = bytes
                }
                   break
               case ParameterIDs._Content_Server_Download_Apk_Url:
                if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                               {
                                t_contentServerParamData.m_strDownloadApkUrl = bytes
                }
                   
               case ParameterIDs._Content_Server_Download_Dll_Url:
                if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                   {
                    t_contentServerParamData.m_strDownloadDllUrl = bytes
                    }
                   
               case ParameterIDs._Content_Server_Socket_Time_Out:
                   t_contentServerParamData.m_iSocketTimeOut = Int(UInt32(ParameterDatas.chArrParameterVal)) * 1000;
               case ParameterIDs._Content_Server_Connection_Time_Out:
                   t_contentServerParamData.m_iConnectionTimeOut = Int(UInt32(ParameterDatas.chArrParameterVal)) * 1000;
                   
           default: break
                
        }
        _ = WriteContentServerParamFile(tContentServerParamData: t_contentServerParamData);
        }
       }


    
    public func UpdateTerminalParameters(ParameterDatas:ParameterData) {
        _ = ParameterDatas.uiHostID;
        if var m_sParamData:TerminalParamData = ReadParamFile(){
               switch (ParameterDatas.ulParameterId) {
                   case ParameterIDs._Batch_Size:
                       m_sParamData.iBatchSize = Int(UInt32(ParameterDatas.chArrParameterVal));
                       
                   default:
                       return;
               }
            _ = WriteParamFile(listParamData: m_sParamData);
           }
       }
    
    public func UpdateLoggingParameters(ParameterDatas:ParameterData) {
       //Empty Definition
    }
    
    public func UpdateAutoSettlementParametes(ParameterDatas:ParameterData) {
        var isToUpdate = true;
            //Read file
        if var sParams:AutoSettlementParams = FileSystem.SeekRead(strFileName: AppConstant.AUTOSETTLEPARFILE, iOffset: 0){
            switch (ParameterDatas.ulParameterId) {
                case ParameterIDs._Auto_Settlement_Enabled:
                  sParams.m_iAutoSettlementEnabledflag = (String(ParameterDatas.chArrParameterVal[0]) == "1") ? true : false;
                    
                case ParameterIDs._Settlement_Start_Time:
                     if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                     {
                         sParams.m_strSettlementStartTime = bytes
                     }
                    
                    
                case ParameterIDs._Settlement_Frequency:
                    sParams.m_iSettlementFrequency = Int(UInt32(ParameterDatas.chArrParameterVal));
                    
                case ParameterIDs._Settlement_Retry_Count:
                    sParams.m_iSettlementRetryCount = Int(UInt32(ParameterDatas.chArrParameterVal))
                    
                    
                case ParameterIDs._Settlement_Retry_Interval:
                    sParams.m_iSettlementRetryIntervalInSeconds = Int(UInt32(ParameterDatas.chArrParameterVal))
                    
                    
                default:
                    isToUpdate = false;
                    
            }
            if (isToUpdate) {
               _ =  UpdateAutoSettleParamFile(newParams: sParams);
//                CStateMachine Statemachine = CStateMachine.GetInstance();
//                Statemachine.m_ResetTerminal = true;
            }
        }
    }
    
    public func UpdateAutoGprsParametes(ParameterDatas:ParameterData) {
            var isToUpdate = true;
                //Read file
            if var sParams:[AutoGPRSNetworkParams] = FileSystem.ReadFile(strFileName: AppConstant.AUTOSETTLEPARFILE){
                switch (ParameterDatas.ulParameterId) {
                    case ParameterIDs._Auto_Gprs_Always_On_Enabled:
                      sParams[0].m_bIsAutoGPRSNetworkEnableFlag = (String(ParameterDatas.chArrParameterVal[0]) == "1") ? true : false;
                        
                    case ParameterIDs._Auto_Gprs_Always_On_Retry_Interval:
                        sParams[0].m_iAutoGPRSNetworkRetryInterval = Int(UInt32(ParameterDatas.chArrParameterVal))
                        
                        
                    default:
                        isToUpdate = false;
                        
                }
                if (isToUpdate) {
                   _ =  UpdateAutoGprsParamFile(newParams: sParams[0]);
    //                CStateMachine Statemachine = CStateMachine.GetInstance();
    //                Statemachine.m_ResetTerminal = true;
                }
            }
        }
        
    

    
    public func UpdateAutoReversalParametes(ParameterDatas:ParameterData) {
            var isToUpdate = true;
                //Read file
            if var sParams:AutoReversalParams = FileSystem.SeekRead(strFileName: AppConstant.AUTOREVERSALPARFILE, iOffset: 0){
                switch (ParameterDatas.ulParameterId) {
                    case ParameterIDs._Auto_Reversal_Enabled:
                      sParams.m_bIsAutoReversalEnableFlag = (String(ParameterDatas.chArrParameterVal[0]) == "1") ? true : false;
                        
                    case ParameterIDs._Auto_Reversal_First_Try_Interval:
                        sParams.m_iAutoReversalFirstTryIntervalInSecs = Int(UInt32(ParameterDatas.chArrParameterVal));
                        
                    case ParameterIDs._Auto_Reversal_Retry_Interval:
                        sParams.m_iAutoReversalRetryIntervalInSecs = Int(UInt32(ParameterDatas.chArrParameterVal));
                        
                    case ParameterIDs._Auto_Reversal_Max_Retry_Count:
                        sParams.m_iAutoReversalMaxRetryCount = Int(UInt32(ParameterDatas.chArrParameterVal))
                        
                        
                    default:
                        isToUpdate = false;
                        
                }
                if (isToUpdate) {
                   _ =  UpdateAutoReversalParamFile(newParams: sParams);
    //                CStateMachine Statemachine = CStateMachine.GetInstance();
    //                Statemachine.m_ResetTerminal = true;
                }
            }
        }
    
    public func UpdateAutoPremiumServiceParametes(ParameterDatas:ParameterData) {
            var isToUpdate = true;
                //Read file
            if var sParams:[AutoPremiumServiceParams] = FileSystem.ReadFile(strFileName: AppConstant.AUTOPREMIUMSERVICEPARFILE){
                switch (ParameterDatas.ulParameterId) {
                    case ParameterIDs._Auto_Premium_Service_Enabled:
                      sParams[0].m_iAutoPremiumServiceEnableFlag = (String(ParameterDatas.chArrParameterVal[0]) == "1") ? true : false;
                        
                    case ParameterIDs._Auto_Premium_Service_Retry_Interval:
                        sParams[0].m_iAutoPremiumServiceRetryIntervalInSeconds = Int(UInt32(ParameterDatas.chArrParameterVal));
                        
                    case ParameterIDs._Auto_Premium_Service_Start_Time:
                        if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                        {
                        sParams[0].m_strAutoPremiumServiceStartTime = bytes
                        }
                        
                    case ParameterIDs._Auto_Premium_Service_Frequency:
                        sParams[0].m_iAutoPremiumServiceFrequency = Int(UInt32(ParameterDatas.chArrParameterVal))
                        
                    case ParameterIDs._Auto_Premium_Service_Retry_Count:
                      sParams[0].m_iAutoPremiumServiceRetryCount = Int(UInt32(ParameterDatas.chArrParameterVal))
                      
                    default:
                        isToUpdate = false;
                        
                }
                if (isToUpdate) {
                   _ =  UpdateAutoPremiumServiceParamFile(newParams: sParams[0]);
    //                CStateMachine Statemachine = CStateMachine.GetInstance();
    //                Statemachine.m_ResetTerminal = true;
                }
            }
        }
   
    
    public func UpdateTerminalMasterAdditionalParameters(ParameterDatas:ParameterData) {
           _ = ReadMasterParamFile();
           if (m_sMasterParamData != nil) {
               switch (ParameterDatas.ulParameterId) {
                   case ParameterIDs._Online_Pin_First_Char_Timeout:
                       let firstCharTimeOut = Int(UInt32(ParameterDatas.chArrParameterVal));
                       if (firstCharTimeOut > 90 || firstCharTimeOut < 15) {
                        m_sMasterParamData?.m_iOnlinePinFirstCharTimeout = 60;
                       } else {
                        m_sMasterParamData?.m_iOnlinePinFirstCharTimeout = firstCharTimeOut;
                       }
                       

                   case ParameterIDs._Online_Pin_Interchar_Timeout:
                       let interCharTimeOut = Int(UInt32(ParameterDatas.chArrParameterVal));
                       if (interCharTimeOut > 60 || interCharTimeOut < 30) {
                           m_sMasterParamData?.m_iOnlinePinInterCharTimeout = 30;
                       } else {
                           m_sMasterParamData?.m_iOnlinePinInterCharTimeout = interCharTimeOut;
                       }
                       

                   case ParameterIDs._Min_Pin_Length:
                       let minPinLength = Int(UInt32(ParameterDatas.chArrParameterVal));
                       if (minPinLength < 4) {
                           m_sMasterParamData?.m_iMinPinLength = 4;
                       } else {
                           m_sMasterParamData?.m_iMinPinLength = minPinLength;
                       }
                       

                   case ParameterIDs._Max_Pin_Length:
                       let maxPinLength = Int(UInt32(ParameterDatas.chArrParameterVal));
                       if (maxPinLength > 12) {
                           m_sMasterParamData?.m_iMaxPinLength = 12;
                       } else {
                           m_sMasterParamData?.m_iMaxPinLength = maxPinLength;
                       }
                       

                   case ParameterIDs._Display_Menu_Timeout:
                    let DisplayMenuTimeout = Int(UInt32(ParameterDatas.chArrParameterVal));
                       if (DisplayMenuTimeout < 10 || DisplayMenuTimeout > 1200) {
                           m_sMasterParamData?.m_iDisplayMenuTimeout = 40;
                       } else {
                           m_sMasterParamData?.m_iDisplayMenuTimeout = DisplayMenuTimeout;
                       }
                       

                   case ParameterIDs._Display_Message_Timeout:
                    let DisplayMessageTimeout = Int(UInt32(ParameterDatas.chArrParameterVal));
                       if (DisplayMessageTimeout < 1 || DisplayMessageTimeout > 60) {
                           m_sMasterParamData?.m_iDisplayMessasgeTimeout = 2;
                       } else {
                           m_sMasterParamData?.m_iDisplayMessasgeTimeout = DisplayMessageTimeout;
                       }
                      
                       

                   case ParameterIDs._HotKey_Confirmation_Timeout:
                       let HotKeyConfirmationTimeout = Int(UInt32(ParameterDatas.chArrParameterVal));
                       if (HotKeyConfirmationTimeout < 5 || HotKeyConfirmationTimeout > 60) {
                           m_sMasterParamData?.m_iHotKeyConfirmationTimeout = 10;
                       } else {
                           m_sMasterParamData?.m_iHotKeyConfirmationTimeout = HotKeyConfirmationTimeout;
                       }
                       
                   case ParameterIDs._Is_Pin_Required_Service_Code_6:
                       let iVal = Int(UInt32(ParameterDatas.chArrParameterVal));
                       if (0 == iVal) {
                           m_sMasterParamData?.m_bIsAskPInForServiceCode6 = false;
                       } else {
                           m_sMasterParamData?.m_bIsAskPInForServiceCode6 = true;
                       }
                     
                   
                   
                   case ParameterIDs._Is_Pin_Bypass_Service_Code_6:
                       let iVal = Int(UInt32(ParameterDatas.chArrParameterVal));
                       if (0 == iVal) {
                           m_sMasterParamData?.m_bIsPinBypassForServiceCode6 = false;
                       } else {
                           m_sMasterParamData?.m_bIsPinBypassForServiceCode6 = true;
                       }
                     
                   

                   case ParameterIDs._Ignore_Integrated_TXN_Amount_EMV_TXN:
                       let iVal = Int(UInt32(ParameterDatas.chArrParameterVal));
                       if (0 == iVal) {
                           m_sMasterParamData?.m_bIsIngnoreIngeratedAmountEMVTxn = false;
                       } else {
                           m_sMasterParamData?.m_bIsIngnoreIngeratedAmountEMVTxn = true;
                       }
                       
                    default:
                       return;
               }
               _ = WriteMasterParamFile();
           }
       }
    
    public func UpdateTerminalMasterParameters(ParameterDatas:ParameterData) {
        var chArrAsciiParamData:[Byte] = [];
        var iLenParamData = 0;
        _ = ReadMasterParamFile();
        switch (ParameterDatas.ulParameterId) {
            case ParameterIDs._Initialization_Parameter_Enabled_Central:
                if (ParameterDatas.ulParameterLen == AppConstant.LEN_INITIALIZATION_BITMAP) {
                    chArrAsciiParamData = CUtil.a2bcd(s: ParameterDatas.chArrParameterVal);
                    iLenParamData = ParameterDatas.ulParameterLen / 2;
                    m_sMasterParamData?.m_uchArrBitmap320CentralChangeNumber = "0x00".bytes
                    let centralChangeNumberArray = m_sMasterParamData?.m_uchArrBitmap320CentralChangeNumber
                    if let wrappedValue = centralChangeNumberArray?[0...iLenParamData]
                    {
                        chArrAsciiParamData[0...iLenParamData] = wrappedValue
                    }
                }
              
            case ParameterIDs._Initialization_Parameter_Enabled_HUB:
                if ((ParameterDatas.ulParameterLen / 2) == AppConstant.LEN_INITIALIZATION_BITMAP) {
                    chArrAsciiParamData = CUtil.a2bcd(s: ParameterDatas.chArrParameterVal);
                    iLenParamData = ParameterDatas.ulParameterLen / 2;
                    m_sMasterParamData?.m_uchArrBitmap320HUBChangeNumber = "0x00".bytes;
                    let centralChangeNumberArray = m_sMasterParamData?.m_uchArrBitmap320HUBChangeNumber
                    if let wrappedValue = centralChangeNumberArray?[0...iLenParamData]
                    {
                        chArrAsciiParamData[0...iLenParamData] = wrappedValue
                    }
                }
               
            case ParameterIDs._Packet_Send_320:
                if (ParameterDatas.ulParameterLen == AppConstant.LEN_BITMAP_PACKET * 2) {
                    chArrAsciiParamData = CUtil.a2bcd(s:ParameterDatas.chArrParameterVal);
                    iLenParamData = ParameterDatas.ulParameterLen / 2;
                    m_sMasterParamData?.m_uchArrBitmap320ActiveHost = "0x00".bytes;
                    let centralChangeNumberArray = m_sMasterParamData?.m_uchArrBitmap320ActiveHost
                    if let wrappedValue = centralChangeNumberArray?[0...iLenParamData]
                    {
                        chArrAsciiParamData[0...iLenParamData] = wrappedValue
                    }
                    m_sMasterParamData?.bIsBitmap320ActiveHostSet = true;
                }
               
            case ParameterIDs._Packet_Send_440:
                if (ParameterDatas.ulParameterLen == AppConstant.LEN_BITMAP_PACKET * 2) {
                    chArrAsciiParamData = CUtil.a2bcd(s:ParameterDatas.chArrParameterVal);
                    iLenParamData = ParameterDatas.ulParameterLen / 2;
                    m_sMasterParamData?.m_uchArrBitmap440ActiveHost =  "0x00".bytes;
                    let centralChangeNumberArray = m_sMasterParamData?.m_uchArrBitmap440ActiveHost
                    if let wrappedValue = centralChangeNumberArray?[0...iLenParamData]
                    {
                        chArrAsciiParamData[0...iLenParamData] = wrappedValue
                    }
                    m_sMasterParamData?.bIsBitmap440ActiveHostSet = true;
                }
             
            case ParameterIDs._Packet_Send_500:
                if (ParameterDatas.ulParameterLen == AppConstant.LEN_BITMAP_PACKET * 2) {
                    chArrAsciiParamData = CUtil.a2bcd(s:ParameterDatas.chArrParameterVal);
                    iLenParamData = ParameterDatas.ulParameterLen / 2;
                    m_sMasterParamData?.m_uchArrBitmap500ActiveHost =  "0x00".bytes;
                    let centralChangeNumberArray = m_sMasterParamData?.m_uchArrBitmap500ActiveHost
                    if let wrappedValue = centralChangeNumberArray?[0...iLenParamData]
                    {
                        chArrAsciiParamData[0...iLenParamData] = wrappedValue
                    }
                    m_sMasterParamData?.bIsBitmap500ActiveHostSet = true;
                }
               
            case ParameterIDs._HSM_Primay_IP:
                if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_IPADDR_LEN) {
                    if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                    {
                        m_sMasterParamData?.m_strHSMPrimaryIP = bytes
                    }
                }
              
            case ParameterIDs._HSM_Primay_Port:
                if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_ISO_PORT_LEN) {
                    m_sMasterParamData?.m_lHSMPrimaryPort = Int64(UInt32(ParameterDatas.chArrParameterVal));
                }
                
            case ParameterIDs._HSM_Secondary_IP:
                if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                  {
                      m_sMasterParamData?.m_strHSMSecondaryIP = bytes
                  }
               
            case ParameterIDs._HSM_Secondary_Port:
                if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_ISO_PORT_LEN) {
                    m_sMasterParamData?.m_lHSMSecondaryPort = Int64(UInt32(ParameterDatas.chArrParameterVal));
                }
             
            case ParameterIDs._HSM_Retry_Count:
                m_sMasterParamData?.m_iHSMRetryCount = Int(Int64(UInt32(ParameterDatas.chArrParameterVal)));
             
            //Use Pine Encryption Key
            case ParameterIDs._Use_Pine_Key_Encryption:
                let iEarlierUsePineEncryptionKeys = m_sMasterParamData?.m_iUsePineEncryptionKeys;

                m_sMasterParamData?.m_iUsePineEncryptionKeys = Int(UInt32(ParameterDatas.chArrParameterVal));
                //If Application is to use PINE KEYS Force PMK and PTMK exchange
                if ((0 == iEarlierUsePineEncryptionKeys) && (m_sMasterParamData?.m_iUsePineEncryptionKeys != 0)) {
                    m_sMasterParamData?.m_bIsPKExchangePacket = true;
                }
            
            // Use Default Key Slot Only
            case ParameterIDs._Use_Default_KeySlotID_Only:
                m_sMasterParamData?.m_iUseDefaultKeySlotOnly = (String(ParameterDatas.chArrParameterVal[0]) == "1")
            default:
                return;
        }
        _ = WriteMasterParamFile();
    }
 
    
    public func UpdatePPPTCPAlwaysOnParameters(ParameterDatas:ParameterData) {
        _ = ParameterDatas.uiHostID;
            if var m_sParamData:TerminalParamData = ReadParamFile(){
                   switch (ParameterDatas.ulParameterId) {
                       case ParameterIDs._Amex_Gprs_EMV_Field55_Hex_Data_Tag_Enable:
                           m_sParamData.m_bIsAmexEMVDE55HexTagDataEnable = (String(ParameterDatas.chArrParameterVal[0]) == "1") ? true : false;
                           
                    case ParameterIDs._Amex_Gprs_EMV_Receipt_61_Dump_Enable:
                        m_sParamData.m_bIsAmexEMVReceiptEnable = (String(ParameterDatas.chArrParameterVal[0]) == "1") ? true : false;
                        
                    case ParameterIDs._Always_On_GPRS_PPP:
                        m_sParamData.m_bIsPPPAlwaysOn = (String(ParameterDatas.chArrParameterVal[0]) == "1") ? true : false;
                    case ParameterIDs._Always_On_GPRS_TCP:
                        m_sParamData.m_bIsTCPAlwaysOn = (String(ParameterDatas.chArrParameterVal[0]) == "1") ? true : false;
                        
                    
                       default:
                           return;
                   }
                _ = WriteParamFile(listParamData: m_sParamData);
               }
           }
    
   
    public func UpdateSecondaryIPMaxRetryCounterParameters(ParameterDatas:ParameterData) {
              _  = ParameterDatas.uiHostID;
          if var m_sParamData:TerminalParamData = ReadParamFile(){
                 switch (ParameterDatas.ulParameterId) {
                     case ParameterIDs._Secondary_IP_Max_Retry_Count:
                         m_sParamData.m_SecondaryIPMaxRetryCount = Int(UInt32(ParameterDatas.chArrParameterVal));
                         
                     default:
                         return;
                 }
            _ = WriteParamFile(listParamData: m_sParamData);
             }
         }

        
   func UpdateAutoSettleParamFile(newParams:AutoSettlementParams) -> Bool {
            var listAutoSettleParams = [AutoSettlementParams]();
              listAutoSettleParams.append(newParams);
            do{
                _ = try FileSystem.ReWriteFile(strFileName: AppConstant.AUTOSETTLEPARFILE, with: listAutoSettleParams);
            }catch
            {
                
            }
              return true;
        }
    
    func UpdateAutoPremiumServiceParamFile(newParams:AutoPremiumServiceParams) -> Bool {
               var listParams = [AutoPremiumServiceParams]();
                 listParams.append(newParams);
               do{
                   _ = try FileSystem.ReWriteFile(strFileName: AppConstant.AUTOPREMIUMSERVICEPARFILE, with: listParams);
                 m_sAutoPremiumServiceParams = newParams;
               }catch
               {
                   
               }
                 return true;
           }
    
  
    func UpdateAutoReversalParamFile(newParams:AutoReversalParams) -> Bool {
               var listAutoReversalParams = [AutoReversalParams]();
                 listAutoReversalParams.append(newParams);
               do{
                   _ = try FileSystem.ReWriteFile(strFileName: AppConstant.AUTOREVERSALPARFILE, with: listAutoReversalParams);
                 m_sAutoReversalParams = newParams;
               }catch
               {
                   
               }
                 return true;
           }

//    public func ReadContentServerParamFile() -> ContentServerParamData {
//        t_contentServerParamData = FileSystem.SeekRead(AppConstant.CONTENT_SERVER_PARAM_FILE, 0);
//        return t_contentServerParamData;
//    }
//

    func UpdateAutoGprsParamFile(newParams:AutoGPRSNetworkParams) -> Bool {
                  var listParams = [AutoGPRSNetworkParams]();
                    listParams.append(newParams);
                  do{
                      _ = try FileSystem.ReWriteFile(strFileName: AppConstant.AUTOGPRSALWAYSONPARFILE, with: listParams);
                    m_sAutoGprsParams = newParams;
                  }catch
                  {
                      
                  }
                    return true;
              }
    
    public func UpdateSignUploadchksizeOnParameters(ParameterDatas:ParameterData) {
                  var iHostID = ParameterDatas.uiHostID;
              if var m_sParamData:TerminalParamData = ReadParamFile(){
                     switch (ParameterDatas.ulParameterId) {
                         case ParameterIDs._Sign_Upload_Chunk_size:
                             m_sParamData.m_ulSignUploadChunkSize = Int64(UInt32(ParameterDatas.chArrParameterVal));
                             
                      
                         default:
                             return;
                     }
               _ =  WriteParamFile(listParamData: m_sParamData);
                 }
             }
    
    func  ReadContentServerParamFile() -> ContentServerParamData? {
        if let t_contentServerParamData:ContentServerParamData = FileSystem.SeekRead(strFileName: AppConstant.CONTENT_SERVER_PARAM_FILE, iOffset: 0)
        {
            return t_contentServerParamData;
        }
           return nil
    }
    
     func WriteContentServerParamFile(tContentServerParamData:ContentServerParamData) -> Bool{
        var listOfObjects = [ContentServerParamData]();
          listOfObjects.append(tContentServerParamData);
        do{
            _  =  try FileSystem.ReWriteFile(strFileName: AppConstant.CONTENT_SERVER_PARAM_FILE, with: listOfObjects);
        }
        catch{
            fatalError("ReWriteFile: WriteContentServerParamFile")
        }
          return true;
      }
    
    
    public func UpdateClessDefPreProcessingParameters(ParameterDatas:ParameterData) {
                     _  = ParameterDatas.uiHostID;
                    var ulAmount:Int64 = 0x00;
                 if var m_sParamData:TerminalParamData = ReadParamFile(){
                        switch (ParameterDatas.ulParameterId) {
                            case ParameterIDs._Cless_PreProcessing_Amount:
                                ulAmount = Int64(UInt32(ParameterDatas.chArrParameterVal));
                                
                         case ParameterIDs._Cless_PreProcessing_TxnType:
                               m_sParamData.bArrClessDefPreProcessTxnType[0] = ParameterDatas.chArrParameterVal[0];
                            
                         case ParameterIDs._Cless_MaxIntegration_TxnAmt:
                                ulAmount = Int64(UInt32(ParameterDatas.chArrParameterVal));
                                
                         
                            default:
                                return;
                        }
                    _ = WriteParamFile(listParamData: m_sParamData);
                    }
                }
    
    public func UpdateCIMBUserPasswordParameters(ParameterDatas:ParameterData) {
                        _ = ParameterDatas.uiHostID;
                     var _:Int64 = 0x00;
                    if var m_sParamData:TerminalParamData = ReadParamFile(){
                           switch (ParameterDatas.ulParameterId) {
                               case ParameterIDs._CIMB_PRINCIPLE_OPERATOR_PASSWORD:
                                if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                                                    {
                                    m_sParamData.m_strSettlementNSpecificTxnsPassword  = bytes
                                }
                                   
                            case ParameterIDs._CIMB_IS_PASSWORD_SETTLEMENT:
                                var iIsPasswordRequiredForSettlement = false;
                                  if (Int(UInt32(ParameterDatas.chArrParameterVal)) > 0) {
                                      iIsPasswordRequiredForSettlement = true;
                                  } else {
                                      iIsPasswordRequiredForSettlement = false;
                                  }
                               _ =  WriteParamFile(listParamData: m_sParamData)
                                   
                            case ParameterIDs._IS_PASSWORD_NEEDED_FOR_SPECIFIC_TXNS:
                                   var iIsPasswdNeededForSpecificTxns = false;
                                     if (Int(UInt32(ParameterDatas.chArrParameterVal)) > 0) {
                                         iIsPasswdNeededForSpecificTxns = true;
                                     } else {
                                         iIsPasswdNeededForSpecificTxns = false;
                                     }
                                    _ = WriteParamFile(listParamData: m_sParamData)
                                   
                            
                               default:
                                   return;
                           }
                       }
                   }
    
    
    
    public func UpdateBiometricEnabledFlagOnParameters(ParameterDatas:ParameterData) {
                        _ = ParameterDatas.uiHostID;
                       var iIsBiometricEnabled:Int = 0x00;
                    if var m_sParamData:TerminalParamData = ReadParamFile(){
                           switch (ParameterDatas.ulParameterId) {
                               case ParameterIDs._IS_BIOMETRIC_ENABLED:
                                   iIsBiometricEnabled = Int(UInt32(ParameterDatas.chArrParameterVal));
                                   m_sParamData.m_iIsBiometricEnabled = iIsBiometricEnabled;
                                   
                               default:
                                   return;
                           }
                        _ = WriteParamFile(listParamData: m_sParamData);
                       }
                   }
    
    public func UpdateEMVParameters(ParameterDatas:ParameterData) {
                           _ = ParameterDatas.uiHostID;
                        let iIsBiometricEnabled:Int = 0x00;
                       if var m_sParamData:TerminalParamData = ReadParamFile(){
                              switch (ParameterDatas.ulParameterId) {
                                  case ParameterIDs._EMVFallbackChipRetryCounter:
                                    m_sParamData.m_EMVChipRetryCount = Int(UInt32(ParameterDatas.chArrParameterVal));
                                      m_sParamData.m_iIsBiometricEnabled = iIsBiometricEnabled;
                                      
                                case ParameterIDs._EMV_MERCHANT_CATEGORY_CODE:
                               if (ParameterDatas.chArrParameterVal.count > 0) {
                                if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                                                                                   {
                                      m_sParamData.m_strMCCEMV  = bytes
                                    }
                               }
                                
                                  default:
                                      return;
                              }
                              _ = WriteParamFile(listParamData:m_sParamData);
                          }
                      }
    
    
    
    public func UpdateISCRISEnabledFlagOnParameters(ParameterDatas:ParameterData) {
                        var iHostID = ParameterDatas.uiHostID;
                       var iIsBiometricEnabled:Int = 0x00;
                    if var m_sParamData:TerminalParamData = ReadParamFile(){
                           switch (ParameterDatas.ulParameterId) {
                               case ParameterIDs._IS_CRIS_SUPPORTED:
                                   let iIsRISEnabled = Int(UInt32(ParameterDatas.chArrParameterVal));
                                     m_sParamData.m_iIsCRISEnabled = iIsRISEnabled;
                                   
                               default:
                                   return;
                           }
                         _ =  WriteParamFile(listParamData:m_sParamData);
                       }
                   }
    

    public func UpdateNoPrintMessage(ParameterDatas:ParameterData) {
         _ = ParameterDatas.uiHostID;
        var iMessagelen:Int = 0;
        if var m_sParamData:TerminalParamData = ReadParamFile(){
            switch (ParameterDatas.ulParameterId) {
            case ParameterIDs._NO_PRINT_CHARGESLIP_DATA:
                iMessagelen = ParameterDatas.chArrParameterVal.count;
                if (iMessagelen > 0) {
                    if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                    {
                        m_sParamData.m_strNoPrintMessage = bytes
                    }
                    
                }
            
            default:
                return;
            }
          _  = WriteParamFile(listParamData:m_sParamData);
        }
    }

    
  
    /*****************************************************************************
        * Name     :  SetConnectionChangedFlag
        * Function :  Set ConnectionChanged FLAG
        * Parameter:  true / false
        * Return   :
        *****************************************************************************/
    public func SetConnectionChangedFlag(isChanged:Bool)  {
           m_sConxData.bConnectionChangedFlag = isChanged;
       }
    
    
    /*******************************************************************************
     * SortBinRangeFile
     * param NONE
     * Algo is :
     * Quick sort the file with Two records are interchanged in sorting
     *
     * @return
     *******************************************************************************/
    public func SortBinRangeFile() -> Bool {
        if (true == FileSystem.IsFileExist(strFileName: AppConstant.BINRANGEFILE)) {
            if let listBinRange:[StBINRange] = FileSystem.ReadFile(strFileName: AppConstant.BINRANGEFILE) {
                let sortedArray = listBinRange.sorted {
                    (obj1, obj2) -> Bool in
                    return obj1.ulBinLow > obj2.ulBinLow
                }
                do{
                    _ = try FileSystem.ReWriteFile(strFileName: AppConstant.BINRANGEFILE, with: sortedArray);
                }catch
                {
                    fatalError("File Rewrite Error:SortBinRangeFile " )
                }
            }
        }
        return true;
    }
    
    
    
    /*****************************************************************************
     * Name     :  WriteLoginFile
     * Function :  Write Connection File with current global data
     * Parameter:
     * Return   :
     *****************************************************************************/
    
    public func WriteLoginAccountFile(login_accounts:[LoginAccounts],fileName:String) {
        do{
            
            _ = try FileSystem.AppendFile(strFileName: fileName, with: login_accounts)
        }
        catch{
            fatalError("File Append Error")
        }
    }
    
    public func ReadLoginAccountFile(fileName:String) -> [LoginAccounts]? {
        if let list:[LoginAccounts] = FileSystem.ReadFile(strFileName: fileName)
        {
            return list;
        }
        return nil
    }
    
    public func getFullSerialNumber() -> String? {
        if let serialNumber = fullSerialNumber{
            return serialNumber;
        }
        return nil
    }
    
    
    public static func GetTimeIntervalLeftInSecondsAccToFrequency(strEventStartTime:String, iFrequencyInSeconds:Int) ->Int64 {
        var lTimeInterval:Int64 = 0
        if strEventStartTime.isEmpty{
            return -1;
        }
        
        if let iEventStartTime:Int = Int(strEventStartTime){
            if (iEventStartTime < 0 || iEventStartTime > AppConstant.iMaxTimeOn24Clock) {
                return -1;
            }
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = outputFormatter.string(from: Date())
            if let iCurrentTime = Int(date){
                var iHours:Int = 0, iMinutes:Int = 0, iSeconds:Int = 0;
                iHours = iCurrentTime / 10000;
                iMinutes = (iCurrentTime % 10000) / 100;
                iSeconds = iCurrentTime % 100;
                let lCurrentTimeInSeconds:Int64 = Int64((iHours * 3600 + iMinutes * 60 + iSeconds));
                iHours = iEventStartTime / 10000;
                iMinutes = (iEventStartTime % 10000) / 100;
                iSeconds = iEventStartTime % 100;
                if (iHours > AppConstant.iMaxHourOn24Clock) {
                    return -1;
                }
                if (iMinutes > AppConstant.iMaxMinutesOn24Clock) {
                    iMinutes = 0;
                }
                if (iMinutes > AppConstant.iMaxSecondsOn24Clock) {
                    iSeconds = 0;
                }
                let lEventStartTimeInSeconds:Int64 = Int64((iHours * 3600 + iMinutes * 60 + iSeconds));
                
                
                //long lNextTimeForEventStartInSeconds=lEventStartTimeInSeconds;
                lTimeInterval = Int64(AppConstant.iMaxInSeconds);
                //long lTempTimeInterval=0;
                
                lTimeInterval = lEventStartTimeInSeconds - lCurrentTimeInSeconds;
                lTimeInterval = (lTimeInterval % Int64(iFrequencyInSeconds));
                if (lTimeInterval < 0) {
                    lTimeInterval = lTimeInterval + Int64(iFrequencyInSeconds);
                }
            }
        }
            return lTimeInterval;
    }
    
    
    
    
    /**
     * Input parameter  EventStartTime in format hhmmss
     * Output:Time interval(Seconds) in between EventStartTime and CurrentTime
     * if currentTime 110000 EventStartTime 220000 then output will be 11*3600 seconds
     * if currentTime 110000 EventStartTime 050000 then output will be 18*3600 seconds
     */
    public static func GetTimeIntervalLeftInSeconds(strEventStartTime:String) ->Int64 {
        var lTimeInterval:Int64 = 0;
        if strEventStartTime.isEmpty {
            return -1;
        }
        
        if let iEventStartTime:Int = Int(strEventStartTime){
            if (iEventStartTime < 0 || iEventStartTime > AppConstant.iMaxTimeOn24Clock) {
                return -1;
            }
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = outputFormatter.string(from: Date())
            if let iCurrentTime = Int(date){
                
                var iHours:Int = 0, iMinutes:Int = 0, iSeconds:Int = 0;
                iHours = iCurrentTime / 10000;
                iMinutes = (iCurrentTime % 10000) / 100;
                iSeconds = iCurrentTime % 100;
                let lCurrentTimeInSeconds:Int64 = Int64(iHours * 3600 + iMinutes * 60 + iSeconds);
                
                
                iHours = iEventStartTime / 10000;
                iMinutes = (iEventStartTime % 10000) / 100;
                iSeconds = iEventStartTime % 100;
                if (iHours > AppConstant.iMaxHourOn24Clock) {
                    return -1;
                }
                if (iMinutes > AppConstant.iMaxMinutesOn24Clock) {
                    iMinutes = 0;
                }
                if (iMinutes > AppConstant.iMaxSecondsOn24Clock) {
                    iSeconds = 0;
                }
                let lEventStartTimeInSeconds:Int64 = Int64((iHours * 3600 + iMinutes * 60 + iSeconds));
                
                if (lCurrentTimeInSeconds < lEventStartTimeInSeconds) {
                    lTimeInterval = lEventStartTimeInSeconds - lCurrentTimeInSeconds;
                } else {
                    lTimeInterval = (24 * 3600) - (lCurrentTimeInSeconds - lEventStartTimeInSeconds);
                }
            }
        }
        return lTimeInterval;
        
    }
    // MARK:-GetIMEI
    public static func GetIMEI() -> String{
           if m_strIMEI.isEmpty {
            if let strIMEI:String = PlatFormUtils.getIMEI(){
             m_strIMEI = strIMEI
           }
        }
           return m_strIMEI;
    }
    
    // MARK:-ClearBatch
    public func ClearBatch() -> Bool {
        if var m_sParamData =  ReadParamFile(){
            m_sParamData.m_iBatchState = BatchState.BATCH_EMPTY;
            _ = WriteParamFile(listParamData: m_sParamData);
        }
        return true;
    }
    // MARK:-UnlockBatch
    public func UnlockBatch() -> Bool {
        if var m_sParamData =  ReadParamFile(){
            m_sParamData.m_iBatchState = BatchState.BATCH_EMPTY;
            _ = WriteParamFile(listParamData: m_sParamData);
        }
        return true;
    }
    
    // MARK:- updateConnectionDataChangedFlag
    func updateConnectionDataChangedFlag(bFlag:Bool) -> Int {
        if var listTerminalConxData:[TerminalConxData] = FileSystem.ReadFile(strFileName: AppConstant.CONNECTIONDATAFILENAME){
            let numberOfTerminalConxData = listTerminalConxData.count;
               if numberOfTerminalConxData > 0 {
                for _ in 0...numberOfTerminalConxData {
                       listTerminalConxData[0].bIsDataChanged = bFlag;
                   }
                do{
                _ = try FileSystem.ReWriteFile(strFileName: AppConstant.CONNECTIONDATAFILENAME, with: listTerminalConxData);
                }catch
                {
                    fatalError("Rewrite: UpdateConnectionDataChangedFlag")
                }
               }
           }
           return AppConstant.TRUE;
       }
    
    // MARK:-updateParamDataChangedFlag
    public func updateParamDataChangedFlag(bFlag:Bool) -> Int {
        if var tData:TerminalParamData = ReadParamFile() {
            tData.m_bIsDataChanged = bFlag;
            _ = WriteParamFile(listParamData:tData);
        }
        return AppConstant.TRUE;
    }
    
    // MARK:-UpdateMasterParamDataChangedFlag
       public func updateMasterParamDataChangedFlag(bFlag:Bool) -> Int {
                _ =  ReadMasterParamFile()
           var masterParamData = TerminalMasterParamData()
               masterParamData.bIsDataChanged = bFlag;
               _ = WriteMasterParamFile();
           return AppConstant.TRUE;
       }
    
    
    // MARK:-UpdateAutoSettlementDataChangedFlag
    func UpdateAutoSettlementDataChangedFlag(bFlag:Bool) -> Int {
            if var m_sAutoSettleParams:AutoSettlementParams =  ReadAutoSettleParams(){
             m_sAutoSettleParams.m_bIsDataChanged = ((bFlag != false ) ? true : false)
                var listAutoSettlementParams = [AutoSettlementParams]()
                listAutoSettlementParams.append(m_sAutoSettleParams)
                do{
                    _ = try FileSystem.ReWriteFile(strFileName: AppConstant.AUTOSETTLEPARFILE, with: listAutoSettlementParams)
                }catch
                {
                    fatalError("Rewrite:UpdateAutoSettlementDataChangedFlag")
                }
            
         }
         return AppConstant.TRUE;
    }
      
    // MARK:-ReadAutoSettleParams
    func ReadAutoSettleParams() -> AutoSettlementParams?{
        var readParams:AutoSettlementParams?;
        if false == FileSystem.IsFileExist(strFileName: AppConstant.AUTOSETTLEPARFILE) {
              return readParams;
        }
        readParams = FileSystem.SeekRead(strFileName: AppConstant.AUTOSETTLEPARFILE, iOffset: 0);
          return readParams;

      }
    
    func binarySearchMess(FileName:String,key:Int) -> Int {
        let retIndex = -1;
        var objStructMessageId =   StructMessageId()
        objStructMessageId.lmessageId = key;
        if let ItemList:[StructMessageId] = FileSystem.ReadFile(strFileName: FileName){
            _ = ItemList.sorted {
                    (obj1, obj2) -> Bool in
                    return obj1.lmessageId > obj2.lmessageId
                }
        }
        return retIndex;
    }
    
    func getMessage(id:Int64,messagebuffer:[Byte]) -> Bool {
        var objStructMessageId = StructMessageId()
        objStructMessageId.lmessageId = Int(id);
           var retIndex = -1;
        retIndex = binarySearchMess(FileName: AppConstant.MASTERMESFILE, key: Int(id));
           if (retIndex >= 0) {
            if let objStructMessageId:StructMessageId = FileSystem.SeekRead(strFileName: AppConstant.MASTERMESFILE, iOffset: retIndex){
              _ = objStructMessageId.strArrMessage.bytes;
               return true;
           } else {
               return false;
           }
       }
        return false
    }

}







