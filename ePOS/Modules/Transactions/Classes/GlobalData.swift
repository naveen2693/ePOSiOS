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
    var  fullSerialNumber:String? = "EPOSIOS12345678"
    static var m_sTerminalParamData_Cache: TerminalParamData?
    var m_sMasterParamData: TerminalMasterParamData?
    var m_sPSKData:TerminalPSKData?
    var m_sAutoReversalParams:AutoReversalParams?
    var m_sAutoGprsParams:AutoGPRSNetworkParams?
    var m_sAutoPremiumServiceParams:AutoPremiumServiceParams?
    var m_sMasterParamData_cache:TerminalMasterParamData?
    var m_objCurrentLoggedInAccount: LOGINACCOUNTS?
    static var  m_strIMEI = "";
    var m_ptrCSVDATA = CsvData()
    var IsGoOnline = false;
    var m_bIsToCaptureSignature = false;
    var m_iEMVTxnType = 0;
    var m_iHostIndicator:Int = 0;
    var m_csFinalMsgDoHubOnlineTxn = "";
    var m_bIsSSL = false;
    var  m_sAutoSettleParams:AutoSettlementParams?;
    var m_bIsSignCapture = false;
    var m_bIsSignAsked = false
    //var m_sNewTxnData:TerminalTransactionData =  TerminalTransactionData()
    static var m_setAdServerHTL: Set<Int64>?
    public var m_strCurrentLoggedInUserPIN: String = ""
    var m_bIsLoggedIn: Bool = false
    var mFinalMsgDisplayField58: String = ""
    var mFinalMsgActivation:String = ""
    static var responseCode: String = ""
    static var m_bIsTxnDeclined: Bool = false;
    var m_sTxnTlvData = TxnTLVData();
    var m_sNewTxnData:TerminalTransactionData =  TerminalTransactionData()
    static var m_iMaxBytesToAddPrinter: Int = 9000
    var m_bPrinterData = [Byte](repeating: 0x00, count: 20000)
    var m_iPrintLen: Int = 0
    
    static var m_bIsFiled58Absent: Bool = false;
    static var m_csFinalMsgDisplay58: String = ""
    static var m_csFinalMsgDoHubInitialization: String = ""
    
    var m_mLoginAccountInfo = [String:LOGINACCOUNTS]()
    
    
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
        for _ in  0 ..< maxCommunication
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
                _ = try FileSystem.AppendFile(strFileName: FileNameConstants.CONNECTIONDATAFILENAME, with: [conxData])}
            catch
            {
                fatalError("File Write Error")
            }
            
        }
        //Load connection Index
        var tData:TerminalConxData?;
        m_sConxData.m_bArrConnIndex =  StructConnIndex();
        
        if let listParams:[TerminalConxData] = FileSystem.ReadFile(strFileName: FileNameConstants.CONNECTIONDATAFILENAME)
        {
            if (listParams.count > 0) {
                let numberOfRow:Int = listParams.count;
                for i in 0..<numberOfRow {
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
        let bArrSignatureComPort:[UInt8] = Array("0".utf8);
        let bArrSignatureDeviceType:[UInt8] = Array("NONE".utf8);
        //FileSystem.Delete(m_context, chArrSignatureParamFile);
        Objsignaturedata.bArrSignatureComPort[0..<bArrSignatureComPort.count] = bArrSignatureComPort[0..<bArrSignatureComPort.count]
        Objsignaturedata.SignatureDeviceType[0..<bArrSignatureDeviceType.count] = bArrSignatureDeviceType[0..<bArrSignatureDeviceType.count]
        Objsignaturedata.IsSignDeviceConnected = false;
        //        int iCurrentNumOfRecords = CFileSystem.NumberOfRows(m_context, SignatureParams[].class, chArrSignatureParamFile);
        return AppConstant.TRUE;
    }
    
    // MARK:- createDeviceStateFile
    public class func createDeviceStateFile() {
        let deviceState = DeviceState.S_INITIAL;
        do{
            _ = try FileSystem.AppendFile(strFileName: FileNameConstants.DEVICE_STATE, with: [deviceState])
        }
        catch {
            fatalError("File Write Error")
        }
    }
    
    // MARK:- readParamFile
    func ReadParamFile() -> TerminalParamData? {
        if (GlobalData.m_sTerminalParamData_Cache == nil) {
            
            if let m_sTerminalParamData:TerminalParamData = FileSystem.SeekRead(strFileName: FileNameConstants.TERMINALPARAMFILENAME, iOffset: 0)
            {
                GlobalData.m_sTerminalParamData_Cache = m_sTerminalParamData
            }
            else{
                let terminalParamData = TerminalParamData()
                GlobalData.m_sTerminalParamData_Cache = terminalParamData
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
                _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.TERMINALMASTERPARAMFILE, with: listTerminalMasterParam);
            }catch
            {
                fatalError("ReWriteFile : WriteMasterParamFile")
            }
        }
        return AppConstant.TRUE;
    }
    
    
    func WriteParamFile(listParamData: TerminalParamData?) -> Int {
        var objTerminalParamData = [TerminalParamData]()
        
        if(listParamData == nil) {
            return 0;
        }
        
        if listParamData != nil
        {
            do {
                GlobalData.m_sTerminalParamData_Cache = listParamData; //Assigning to cache for future use
                objTerminalParamData.append(listParamData!)
                _  = try FileSystem.ReWriteFile(strFileName: FileNameConstants.TERMINALPARAMFILENAME, with:
                    objTerminalParamData)
                
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
            if let m_sMasterParamData: TerminalMasterParamData = FileSystem.SeekRead(strFileName: FileNameConstants.TERMINALMASTERPARAMFILE, iOffset: 0)
            {
                m_sMasterParamData_cache = m_sMasterParamData
            }
            else
            {
                let terminalMasterParamData = TerminalMasterParamData()
                m_sMasterParamData_cache = terminalMasterParamData
            }
        }
        else
        {
            m_sMasterParamData = m_sMasterParamData_cache!;
        }
        
        if (m_sMasterParamData == nil) {
            return (AppConstant.FALSE);
        }
        return (AppConstant.TRUE);
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
        WriteLoginAccountFile(login_accounts: [objLoginAccounts], fileName: FileNameConstants.USERINFOFILE);
        
        var reCreateLoginAccounts =  LoginAccounts();
        reCreateLoginAccounts.createdOn = outputFormatter.string(from:Date())
        reCreateLoginAccounts.userID = AppConstant.DEFAULT_ADMIN_USER
        reCreateLoginAccounts.userID = UDID;
        reCreateLoginAccounts.pin = CUIHelper.generatePassword(password: AppConstant.DEFAULT_ORDINARY_PIN, uuid: UDID);
        objLoginAccounts.createdBy = "EDC";
        objLoginAccounts.accountType = AppConstant.ADM_USER_TYPE;
        WriteLoginAccountFile(login_accounts: [reCreateLoginAccounts], fileName: FileNameConstants.USERINFOFILE);
        
        return AppConstant.TRUE;
    }
    
    // MARK:- CreateMasterCGFile
    public func CreateMasterCGFile() -> Int
    {
        let list = [Long]();
        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.MASTERCGFILE, with:list)
        }catch{
            fatalError("File Rewrite Error ")
        }
        return AppConstant.TRUE;
    }
    // MARK:- CreateMasterIMFile
    public func CreateMasterIMFile() -> Int {
        
        let list = [Long]();
        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.MASTERIMFILE, with:list)
        }catch{
            fatalError("File Rewrite Error ")
        }
        return AppConstant.TRUE;
        
    }
    
    // MARK:-CreateMasterCLRDIMFile
    public func CreateMasterCLRDIMFile() -> Int  {
        
        let list = [Long]();
        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.MASTERCLRDIMFILE, with:list)
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
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.MASTERFCGFILE, with:list)
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
        for index in 0..<maxCountChargeSlip{
            UnicodefontId[index] = Fontstruct();
        }
        let fontlist = [Fontstruct?](repeating:nil, count:maxCountChargeSlip);
        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.MASTERFONTFILE, with: fontlist);
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
    public func CreateMasterLIBFile() -> Int {
        
        let LibList =  [LIBStruct]();
        do{
            _ =  try FileSystem.ReWriteFile(strFileName: FileNameConstants.MASTERLIBFILE, with: LibList)
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
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.MASTERFCGFILE, with:list)
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
        //let strParamDownloadDate = "010111115959";
        terminalParamData.m_strParamDownloadDate = "010111115959";
        terminalParamData.m_bIsDataChanged = true;
        terminalParamData.m_strNoPrintMessage = AppConstant.NoPrintDefaultMessage;
        terminalParamData.m_iIsCRISEnabled = 0;
        terminalParamData.m_strHardwareSerialNumber = PlatFormUtils.getLast8DigitOfFullSerialNumber();
        _ = WriteParamFile(listParamData: terminalParamData);
        return AppConstant.TRUE;
    }
    
    
    public func CreateMasterParamFile() -> Int{
        
        m_sMasterParamData =  TerminalMasterParamData();
        
        //App version
        m_sMasterParamData!.m_strAppVersion = AppConstant.APP_VERSION;
        
        m_sMasterParamData!.m_strEMVParVersion = "121212121212";
        
        //for contactless
        m_sMasterParamData!.m_strCLESSEMVParVersion = "121212121212";
        
        m_sMasterParamData!.bIsDataChanged = true;
        m_sMasterParamData!.bIsBitmap320ActiveHostSet = false;
        m_sMasterParamData!.bIsBitmap440ActiveHostSet = false;
        m_sMasterParamData!.bIsBitmap500ActiveHostSet = false;
        
        m_sMasterParamData!.m_uchArrBitmap320CentralChangeNumber[0] = Byte(0x00)
        m_sMasterParamData!.m_uchArrBitmap320CentralChangeNumber[1] = Byte(0x00)
        m_sMasterParamData!.m_uchArrBitmap320CentralChangeNumber[2] = Byte(0x00)
        m_sMasterParamData!.m_uchArrBitmap320CentralChangeNumber[3] = Byte(0x00)
        m_sMasterParamData!.m_uchArrBitmap320CentralChangeNumber[4] = Byte(0x00)
        m_sMasterParamData!.m_uchArrBitmap320CentralChangeNumber[5] = Byte(0x00)
        m_sMasterParamData!.m_uchArrBitmap320CentralChangeNumber[6] = Byte(0x00)
        m_sMasterParamData!.m_uchArrBitmap320CentralChangeNumber[7] = Byte(0x00)
        
        m_sMasterParamData!.m_uchArrBitmap320HUBChangeNumber[0] = Byte(0xFF)
        m_sMasterParamData!.m_uchArrBitmap320HUBChangeNumber[1] = Byte(0xFF)
        m_sMasterParamData!.m_uchArrBitmap320HUBChangeNumber[2] = Byte(0xFF)
        m_sMasterParamData!.m_uchArrBitmap320HUBChangeNumber[3] = Byte(0xFF)
        m_sMasterParamData!.m_uchArrBitmap320HUBChangeNumber[4] = Byte(0xFF)
        m_sMasterParamData!.m_uchArrBitmap320HUBChangeNumber[5] = Byte(0xFF)
        m_sMasterParamData!.m_uchArrBitmap320HUBChangeNumber[6] = Byte(0xFF)
        m_sMasterParamData!.m_uchArrBitmap320HUBChangeNumber[7] = Byte(0xFF)
        m_sMasterParamData!.m_uchArrBitmap320ActiveHost[0] = Byte(0x00)
        m_sMasterParamData!.m_uchArrBitmap320ActiveHost[1] = Byte(0x00)
        m_sMasterParamData!.m_uchArrBitmap320ActiveHost[2] = Byte(0x00)
        
        m_sMasterParamData!.m_uchArrBitmap440ActiveHost[0] = Byte(0x00)
        m_sMasterParamData!.m_uchArrBitmap440ActiveHost[1] = Byte(0x00)
        m_sMasterParamData!.m_uchArrBitmap440ActiveHost[2] = Byte(0x00)
        
        m_sMasterParamData!.m_uchArrBitmap500ActiveHost[0] = Byte(0x00)
        m_sMasterParamData!.m_uchArrBitmap500ActiveHost[1] = Byte(0x00)
        m_sMasterParamData!.m_uchArrBitmap500ActiveHost[2] = Byte(0x00)
        
        let strInitialValue = "010101000000";
        let bArrInitialValue = strInitialValue.bytes;
        m_sMasterParamData!.m_strBinRangeDownloadDate = strInitialValue;
        m_sMasterParamData!.m_bIsBinRangeChanged = false;
        
        //        m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber.append(0x00);
        //        m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber.append(0x00);
        //        m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber.append(0x00);
        //        m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber.append(0x00);
        //        m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber.append(0x00);
        //        m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber.append(0x00);
        //        m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber.append(0x00);
        //        m_sMasterParamData.m_uchArrBitmap320CentralChangeNumber.append(0x00);
        //
        //        m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber.append(Byte(0xFF));
        //        m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber.append(Byte(0xFF));
        //        m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber.append(Byte(0xFF));
        //        m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber.append(Byte(0xFF));
        //        m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber.append(Byte(0xFF));
        //        m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber.append(Byte(0xFF));
        //        m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber.append(Byte(0xFF));
        //        m_sMasterParamData.m_uchArrBitmap320HUBChangeNumber.append(Byte(0xFF));
        //
        //        let strInitialValue = "010101000000";
        //        _ = strInitialValue.bytes;
        //        m_sMasterParamData.m_strBinRangeDownloadDate = strInitialValue;
        //        m_sMasterParamData.m_bIsBinRangeChanged = false;
        
        //Transaction Bin
        m_sMasterParamData!.m_strTxnBinDownloadDate = strInitialValue;
        m_sMasterParamData!.m_bIsTxnBinChanged = false;
        
        m_sMasterParamData!.m_strCSVTxnMapVersion = strInitialValue;
        
        m_sMasterParamData!.m_strAIDEMVTXNTYPEDownloadDate = strInitialValue;
        
        m_sMasterParamData!.m_strTxnTypeFlagsMappingDownloadDate = strInitialValue;
        
        //CSV transaction Ignore Amt List
        m_sMasterParamData!.m_strIgnoreAmtCSVTxnListDownloadDate = strInitialValue;
        
        //EMV TAG  List
        m_sMasterParamData!.m_strEMVTagListDownloadDate = strInitialValue;
        
        //cless param  List
        m_sMasterParamData!.m_strCLessParamDownloadDate = strInitialValue;
        
        //AID EMV TXNTYPE
        m_sMasterParamData!.m_strAIDEMVTXNTYPEDownloadDate = strInitialValue;
        
        //TXNTYPE Flags Mapping  abhishek added 23/11/2015
        m_sMasterParamData!.m_strAIDEMVTXNTYPEDownloadDate = strInitialValue;
        m_sMasterParamData!.m_strCsvTxnTypeMiniPvmMappingDownloadDate = strInitialValue;
        m_sMasterParamData!.m_strISPasswordDownloadDate = strInitialValue;
        m_sMasterParamData!.m_strLogShippingDownloadDate = strInitialValue;
        
        //Use Pine Encryption Key
        //Ini we will be using Bank Keys so this flag is 0.
        m_sMasterParamData!.m_iUsePineEncryptionKeys = 0;
        
        // Use Default Key Slot Only
        //Ini we will be using only single default KeyslotID (10)
        m_sMasterParamData!.m_iUseDefaultKeySlotOnly = true;
        
        //Additional Parameters
        m_sMasterParamData!.m_iOnlinePinFirstCharTimeout = 60;
        m_sMasterParamData!.m_iOnlinePinInterCharTimeout = 30;
        m_sMasterParamData!.m_iMinPinLength = 4;
        m_sMasterParamData!.m_iMaxPinLength = 12;
        m_sMasterParamData!.m_iDisplayMenuTimeout = 40;
        m_sMasterParamData!.m_iDisplayMessasgeTimeout = 2;
        m_sMasterParamData!.m_iHotKeyConfirmationTimeout = 10;
        
        //Save default parameter data
        if !(FileSystem.IsFileExist(strFileName: FileNameConstants.TERMINALMASTERPARAMFILE))
        {
            _  = WriteMasterParamFile();
        }
        else
        {
            _  =  ReadMasterParamFile();
        }
        
        return AppConstant.TRUE;
    }
    
    func  CreateAdServerHTLFile() {
        if FileSystem.IsFileExist(strFileName: FileNameConstants.MASTERHTLFILE)
        {
            GlobalData.m_setAdServerHTL = Set<Int64>();
            GlobalData.m_setAdServerHTL?.insert(1001);
            GlobalData.m_setAdServerHTL?.insert(1021);
            GlobalData.m_setAdServerHTL?.insert(1112);
            GlobalData.m_setAdServerHTL?.insert(1555);
            GlobalData.m_setAdServerHTL?.insert(4001);
            GlobalData.m_setAdServerHTL?.insert(4003);
            let llList = [GlobalData.m_setAdServerHTL];
            do {
                _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.MASTERHTLFILE, with: llList);
            }catch {
                fatalError("Rewrite File Error: CreateAdServerHTLFile")
            }
        }
        else {
            if let readData:[Int64] = FileSystem.ReadFile(strFileName: FileNameConstants.MASTERHTLFILE){
                for data in readData{
                    GlobalData.m_setAdServerHTL?.insert(data);
                }
            }
        }
    }
    
    public  func CreateLogShippingFile() {
        if FileSystem.IsFileExist(strFileName: FileNameConstants.AUTOLOGSHIPMENTSMTPCREDENTIAL) {
            let ObjCred =  AutoLogShippingCredential();
            var sNewAutoCred = [AutoLogShippingCredential]();
            sNewAutoCred.append(ObjCred);
            do{
                _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.AUTOLOGSHIPMENTSMTPCREDENTIAL, with: sNewAutoCred);
            }catch{
                fatalError("Rewrite Error: CreateLogShippingFile")
            }
        }
        if !(FileSystem.IsFileExist(strFileName: FileNameConstants.AUTOLOGSHIPMENTFILE))
        {
            var sNewAutoParams = [AutoLogShippingParams]();
            let ObjAutoLogShippingParams =  AutoLogShippingParams();
            sNewAutoParams.append(ObjAutoLogShippingParams);
            do{
                _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.AUTOLOGSHIPMENTFILE, with: sNewAutoParams);
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
        _ = LoadFromFiles();
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
        if let login_accountsList:[LoginAccounts] = ReadLoginAccountFile(fileName: FileNameConstants.USERINFOFILE)
        {
            var numberOfAccounts = 0;
            numberOfAccounts = login_accountsList.count ;
            for value in 0...numberOfAccounts {
                m_mLoginAccountInfo["m_strUserID"] =  login_accountsList[value].userID
            }
            
            m_sAutoSettleParams = FileSystem.SeekRead(strFileName: FileNameConstants.AUTOSETTLEPARFILE, iOffset: 0);
            LoadConnectionIndex();
            m_sPSKData = FileSystem.SeekRead(strFileName: FileNameConstants.PSKSDWNLDFILE, iOffset: 0);
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.TEMPBINRANGEFILE);
            if ((m_sMasterParamData?.m_bIsBinRangeChanged) != nil) {
                _ = SortBinRangeFile();
                m_sMasterParamData?.m_bIsBinRangeChanged = false;
                _ =  WriteMasterParamFile();
            }
            _  = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.TEMPCSVTXNMAPFILE);
            
            //Transaction Bin
            //delete temp file if present.
            _  = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.TEMPTXNBINFILE);
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
        if let listParams:[TerminalConxData] = FileSystem.ReadFile(strFileName: FileNameConstants.CONNECTIONDATAFILENAME){
            let numberOfRow = listParams.count;
            for count in 0 ..< numberOfRow  {
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
        if var tData:TerminalConxData = FileSystem.SeekRead(strFileName: FileNameConstants.CONNECTIONDATAFILENAME, iOffset: m_sConxData.m_bArrConnIndex.CON_SerialIp.index){
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
                    var tempData: Int = 0
                    let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                    tempData = Int(strTempData) ?? 0

                    tData.iTransactionSSLPort = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
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
                    var tempData: Int = 0
                    let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                    tempData = Int(strTempData) ?? 0
                    
                    tData.iSecondaryTransactionSSLPort = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
                }
                
            case ParameterIDs._Serial_Connect_Timeout:
                if ((ParameterDatas.chArrParameterVal.count + 2) < AppConstant.MAX_CONNECTION_TIMEOUT_LEN) {
                    var tempData: Int = 0
                    let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                    tempData = Int(strTempData) ?? 0
                    
                    tData.iConnTimeout =  tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
                }
                
            case ParameterIDs._Serial_Send_Rec_Timeout:
                if ((ParameterDatas.chArrParameterVal.count + 2) < AppConstant.MAX_CONNECTION_TIMEOUT_LEN) {
                    var tempData: Int = 0
                    let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                    tempData = Int(strTempData) ?? 0
                    
                    tData.iSendRecTimeout = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
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
            _ = FileSystem.SeekWrite(strFileName: FileNameConstants.CONNECTIONDATAFILENAME, with: tData, iOffset: m_sConxData.m_bArrConnIndex.CON_SerialIp.index);
        }
    }
    
    public func UpdateEthernetIPParameters(ParameterDatas:ParameterData) {
        if var tData:TerminalConxData = FileSystem.SeekRead(strFileName: FileNameConstants.CONNECTIONDATAFILENAME, iOffset: m_sConxData.m_bArrConnIndex.CON_SerialIp.index){
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
                    var tempData: Int = 0
                    let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                    tempData = Int(strTempData) ?? 0
                    
                    tData.iSecondaryTransactionSSLPort = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
                }
                
            case ParameterIDs._Ethernet_Connect_Timeout:
                if ((ParameterDatas.chArrParameterVal.count + 2) < AppConstant.MAX_CONNECTION_TIMEOUT_LEN) {
                    var tempData: Int = 0
                    let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                    tempData = Int(strTempData) ?? 0
                    tData.iConnTimeout = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
                }
                
            case ParameterIDs._Ethernet_Send_Rec_Timeout:
                if ((ParameterDatas.chArrParameterVal.count + 2) < AppConstant.MAX_CONNECTION_TIMEOUT_LEN) {
                    var tempData: Int = 0
                    let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                    tempData = Int(strTempData) ?? 0
                    tData.iSendRecTimeout = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
                }
                
            default:
                return;
            }
            
            SetConnectionChangedFlag(isChanged: true);
            _ = FileSystem.SeekWrite(strFileName: FileNameConstants.CONNECTIONDATAFILENAME, with: tData, iOffset: m_sConxData.m_bArrConnIndex.CON_SerialIp.index);
        }
    }
    
    public func UpdateGPRSParameters(ParameterDatas:ParameterData) {
        if var tData:TerminalConxData = FileSystem.SeekRead(strFileName: FileNameConstants.CONNECTIONDATAFILENAME, iOffset: m_sConxData.m_bArrConnIndex.CON_GPRS.index){
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
                    var tempData: Int = 0
                    let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                    tempData = Int(strTempData) ?? 0
                    tData.iTransactionSSLPort =  tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
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
                    var tempData: Int = 0
                    let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                    tempData = Int(strTempData) ?? 0
                    tData.iSecondaryTransactionSSLPort = tempData/*Int(UInt32(ParameterDatas.chArrParameterVal))*/
                }
                
            case ParameterIDs._GPRS_Connect_Timeout:
                if ((ParameterDatas.chArrParameterVal.count + 2) < AppConstant.MAX_CONNECTION_TIMEOUT_LEN) {
                    var tempData: Int = 0
                    let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                    tempData = Int(strTempData) ?? 0
                    tData.iConnTimeout = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
                }
                
            case ParameterIDs._GPRS_Send_Rec_Timeout:
                if ((ParameterDatas.chArrParameterVal.count + 2) < AppConstant.MAX_CONNECTION_TIMEOUT_LEN) {
                    var tempData: Int = 0
                    let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                    tempData = Int(strTempData) ?? 0
                    tData.iSendRecTimeout = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
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
            _ = FileSystem.SeekWrite(strFileName: FileNameConstants.CONNECTIONDATAFILENAME, with: tData, iOffset: m_sConxData.m_bArrConnIndex.CON_GPRS.index);
        }
    }
    
    
    public func UpdateContentServerParams(ParameterDatas:ParameterData) {
        if var t_contentServerParamData = GlobalData.ReadContentServerParamFile(){
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
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int(strTempData) ?? 0
                
                t_contentServerParamData.m_iSocketTimeOut = tempData/*Int(UInt32(ParameterDatas.chArrParameterVal))*/ * 1000;
            case ParameterIDs._Content_Server_Connection_Time_Out:
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int(strTempData) ?? 0
                
                t_contentServerParamData.m_iConnectionTimeOut = tempData/*Int(UInt32(ParameterDatas.chArrParameterVal))*/ * 1000;
                
            default: break
                
            }
            _ = GlobalData.WriteContentServerParamFile(tContentServerParamData: t_contentServerParamData);
        }
    }
    
    
    
    public func UpdateTerminalParameters(ParameterDatas:ParameterData) {
        _ = ParameterDatas.uiHostID;
        if var m_sParamData:TerminalParamData = ReadParamFile(){
            switch (ParameterDatas.ulParameterId) {
            case ParameterIDs._Batch_Size:
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int(strTempData) ?? 0
                m_sParamData.iBatchSize = tempData/*Int(UInt32(ParameterDatas.chArrParameterVal));*/
                
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
        if var sParams:AutoSettlementParams = FileSystem.SeekRead(strFileName: FileNameConstants.AUTOSETTLEPARFILE, iOffset: 0){
            switch (ParameterDatas.ulParameterId) {
            case ParameterIDs._Auto_Settlement_Enabled:
                sParams.m_iAutoSettlementEnabledflag = (String(ParameterDatas.chArrParameterVal[0]) == "1") ? true : false;
                
            case ParameterIDs._Settlement_Start_Time:
                if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                {
                    sParams.m_strSettlementStartTime = bytes
                }
            
            case ParameterIDs._Settlement_Frequency:
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int(strTempData) ?? 0
                
                sParams.m_iSettlementFrequency = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal));*/
                
            case ParameterIDs._Settlement_Retry_Count:
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int(strTempData) ?? 0
                sParams.m_iSettlementRetryCount = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
                
                
            case ParameterIDs._Settlement_Retry_Interval:
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int(strTempData) ?? 0
                
                sParams.m_iSettlementRetryIntervalInSeconds = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
                
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
        if var sParams:[AutoGPRSNetworkParams] = FileSystem.ReadFile(strFileName: FileNameConstants.AUTOSETTLEPARFILE){
            switch (ParameterDatas.ulParameterId) {
            case ParameterIDs._Auto_Gprs_Always_On_Enabled:
                sParams[0].m_bIsAutoGPRSNetworkEnableFlag = (String(ParameterDatas.chArrParameterVal[0]) == "1") ? true : false;
                
            case ParameterIDs._Auto_Gprs_Always_On_Retry_Interval:
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int(strTempData) ?? 0
                sParams[0].m_iAutoGPRSNetworkRetryInterval = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
                
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
        if var sParams:AutoReversalParams = FileSystem.SeekRead(strFileName: FileNameConstants.AUTOREVERSALPARFILE, iOffset: 0){
            switch (ParameterDatas.ulParameterId) {
            case ParameterIDs._Auto_Reversal_Enabled:
                sParams.m_bIsAutoReversalEnableFlag = (String(ParameterDatas.chArrParameterVal[0]) == "1") ? true : false;
                
            case ParameterIDs._Auto_Reversal_First_Try_Interval:
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int(strTempData) ?? 0
                
                sParams.m_iAutoReversalFirstTryIntervalInSecs = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal));*/
                
            case ParameterIDs._Auto_Reversal_Retry_Interval:
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int(strTempData) ?? 0
                sParams.m_iAutoReversalRetryIntervalInSecs = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal));*/
                
            case ParameterIDs._Auto_Reversal_Max_Retry_Count:
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int(strTempData) ?? 0
                sParams.m_iAutoReversalMaxRetryCount = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
                
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
        if var sParams:[AutoPremiumServiceParams] = FileSystem.ReadFile(strFileName: FileNameConstants.AUTOPREMIUMSERVICEPARFILE){
            switch (ParameterDatas.ulParameterId) {
            case ParameterIDs._Auto_Premium_Service_Enabled:
                sParams[0].m_iAutoPremiumServiceEnableFlag = (String(ParameterDatas.chArrParameterVal[0]) == "1") ? true : false;
                
            case ParameterIDs._Auto_Premium_Service_Retry_Interval:
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int(strTempData) ?? 0
                
                sParams[0].m_iAutoPremiumServiceRetryIntervalInSeconds = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal));*/
                
            case ParameterIDs._Auto_Premium_Service_Start_Time:
                if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
                {
                    sParams[0].m_strAutoPremiumServiceStartTime = bytes
                }
                
            case ParameterIDs._Auto_Premium_Service_Frequency:
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int(strTempData) ?? 0
                sParams[0].m_iAutoPremiumServiceFrequency = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
                
            case ParameterIDs._Auto_Premium_Service_Retry_Count:
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int(strTempData) ?? 0
                sParams[0].m_iAutoPremiumServiceRetryCount = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
                
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
                        var firstCharTimeOut = 0
                        var tempData: Int = 0
                        let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                        tempData = Int(strTempData) ?? 0
                        firstCharTimeOut = tempData
                        //let firstCharTimeOut = Int(UInt32(ParameterDatas.chArrParameterVal));
                        if (firstCharTimeOut > 90 || firstCharTimeOut < 15) {
                            m_sMasterParamData?.m_iOnlinePinFirstCharTimeout = 60;
                        } else {
                            m_sMasterParamData?.m_iOnlinePinFirstCharTimeout = firstCharTimeOut;
                        }
                       
                   case ParameterIDs._Online_Pin_Interchar_Timeout:
                        var interCharTimeOut = 0
                        var tempData: Int = 0
                        let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                        tempData = Int(strTempData) ?? 0
                        interCharTimeOut = tempData
                
                        //let interCharTimeOut = Int(UInt32(ParameterDatas.chArrParameterVal));
                        if (interCharTimeOut > 60 || interCharTimeOut < 30) {
                            m_sMasterParamData?.m_iOnlinePinInterCharTimeout = 30;
                        } else {
                            m_sMasterParamData?.m_iOnlinePinInterCharTimeout = interCharTimeOut;
                        }

                   case ParameterIDs._Min_Pin_Length:
                        var minPinLength = 0
                        var tempData: Int = 0
                        let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                        tempData = Int(strTempData) ?? 0
                        minPinLength = tempData
                        //let minPinLength = Int(UInt32(ParameterDatas.chArrParameterVal));
                       if (minPinLength < 4) {
                           m_sMasterParamData?.m_iMinPinLength = 4;
                       } else {
                           m_sMasterParamData?.m_iMinPinLength = minPinLength;
                       }
                       

                   case ParameterIDs._Max_Pin_Length:
                        var maxPinLength = 0
                        var tempData: Int = 0
                        let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                        tempData = Int(strTempData) ?? 0
                        maxPinLength = tempData
                        
                       //let maxPinLength = Int(UInt32(ParameterDatas.chArrParameterVal));
                       if (maxPinLength > 12) {
                           m_sMasterParamData?.m_iMaxPinLength = 12;
                       } else {
                           m_sMasterParamData?.m_iMaxPinLength = maxPinLength;
                       }
                       

                   case ParameterIDs._Display_Menu_Timeout:
                        var DisplayMenuTimeout = 0
                        var tempData: Int = 0
                        let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                        tempData = Int(strTempData) ?? 0
                        DisplayMenuTimeout = tempData
        
                        //let DisplayMenuTimeout = Int(UInt32(ParameterDatas.chArrParameterVal));
                        if (DisplayMenuTimeout < 10 || DisplayMenuTimeout > 1200) {
                            m_sMasterParamData?.m_iDisplayMenuTimeout = 40;
                        } else {
                            m_sMasterParamData?.m_iDisplayMenuTimeout = DisplayMenuTimeout;
                        }
                       

                   case ParameterIDs._Display_Message_Timeout:
                        var DisplayMessageTimeout = 0
                        var tempData: Int = 0
                        let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                        tempData = Int(strTempData) ?? 0
                        DisplayMessageTimeout = tempData
                    
                        //let DisplayMessageTimeout = Int(UInt32(ParameterDatas.chArrParameterVal));
                        if (DisplayMessageTimeout < 1 || DisplayMessageTimeout > 60) {
                            m_sMasterParamData?.m_iDisplayMessasgeTimeout = 2;
                        } else {
                            m_sMasterParamData?.m_iDisplayMessasgeTimeout = DisplayMessageTimeout;
                        }

                   case ParameterIDs._HotKey_Confirmation_Timeout:
                        var HotKeyConfirmationTimeout = 0
                        var tempData: Int = 0
                        let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                        tempData = Int(strTempData) ?? 0
                        HotKeyConfirmationTimeout = tempData
                        
                        //let HotKeyConfirmationTimeout = Int(UInt32(ParameterDatas.chArrParameterVal));
                        if (HotKeyConfirmationTimeout < 5 || HotKeyConfirmationTimeout > 60) {
                            m_sMasterParamData?.m_iHotKeyConfirmationTimeout = 10;
                        } else {
                            m_sMasterParamData?.m_iHotKeyConfirmationTimeout = HotKeyConfirmationTimeout;
                        }
                       
                   case ParameterIDs._Is_Pin_Required_Service_Code_6:
                        var iVal = 0
                        var tempData: Int = 0
                        let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                        tempData = Int(strTempData) ?? 0
                        iVal = tempData
                    
                        //let iVal = Int(UInt32(ParameterDatas.chArrParameterVal));
                        if (0 == iVal) {
                            m_sMasterParamData?.m_bIsAskPInForServiceCode6 = false;
                        } else {
                            m_sMasterParamData?.m_bIsAskPInForServiceCode6 = true;
                        }
                     
                   case ParameterIDs._Is_Pin_Bypass_Service_Code_6:
                        var iVal = 0
                        var tempData: Int = 0
                        let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                        tempData = Int(strTempData) ?? 0
                        iVal = tempData
                        
                        //let iVal = Int(UInt32(ParameterDatas.chArrParameterVal));
                        if (0 == iVal) {
                            m_sMasterParamData?.m_bIsPinBypassForServiceCode6 = false;
                        } else {
                            m_sMasterParamData?.m_bIsPinBypassForServiceCode6 = true;
                        }

                   case ParameterIDs._Ignore_Integrated_TXN_Amount_EMV_TXN:
                        var iVal = 0
                        var tempData: Int = 0
                        let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                        tempData = Int(strTempData) ?? 0
                        iVal = tempData
                        
                        //let iVal = Int(UInt32(ParameterDatas.chArrParameterVal));
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
                
                let tempArray: [Byte] = Array(chArrAsciiParamData[0 ..< iLenParamData])
                m_sMasterParamData?.m_uchArrBitmap320CentralChangeNumber = tempArray
                
                //m_sMasterParamData?.m_uchArrBitmap320CentralChangeNumber.append(contentsOf: "0x00".bytes)
                let centralChangeNumberArray = m_sMasterParamData?.m_uchArrBitmap320CentralChangeNumber
                if let wrappedValue = centralChangeNumberArray?[0 ..< iLenParamData]
                {
                    chArrAsciiParamData[0..<iLenParamData] = wrappedValue
                }
            }
            
        case ParameterIDs._Initialization_Parameter_Enabled_HUB:
            if ((ParameterDatas.ulParameterLen / 2) == AppConstant.LEN_INITIALIZATION_BITMAP) {
                chArrAsciiParamData = CUtil.a2bcd(s: ParameterDatas.chArrParameterVal);
                iLenParamData = ParameterDatas.ulParameterLen / 2;
                
                let tempArray: [Byte] = Array(chArrAsciiParamData[0 ..< iLenParamData])
                m_sMasterParamData?.m_uchArrBitmap320HUBChangeNumber = tempArray
                
                //m_sMasterParamData?.m_uchArrBitmap320HUBChangeNumber.append(contentsOf: "0x00".bytes)
                let centralChangeNumberArray = m_sMasterParamData?.m_uchArrBitmap320HUBChangeNumber
                if let wrappedValue = centralChangeNumberArray?[0..<iLenParamData]
                {
                    chArrAsciiParamData[0..<iLenParamData] = wrappedValue
                }
            }
            
        case ParameterIDs._Packet_Send_320:
            if (ParameterDatas.ulParameterLen == AppConstant.LEN_BITMAP_PACKET * 2) {
                chArrAsciiParamData = CUtil.a2bcd(s:ParameterDatas.chArrParameterVal)
                iLenParamData = ParameterDatas.ulParameterLen / 2
                
                let tempArray: [Byte] = Array(chArrAsciiParamData[0 ..< iLenParamData])
                m_sMasterParamData?.m_uchArrBitmap320ActiveHost = tempArray
                
                let centralChangeNumberArray = m_sMasterParamData?.m_uchArrBitmap320ActiveHost
                if let wrappedValue = centralChangeNumberArray?[0 ..< iLenParamData]
                {
                    chArrAsciiParamData[0 ..< iLenParamData] = wrappedValue
                }
                m_sMasterParamData?.bIsBitmap320ActiveHostSet = true;
                
                
            }
            
        case ParameterIDs._Packet_Send_440:
            if (ParameterDatas.ulParameterLen == AppConstant.LEN_BITMAP_PACKET * 2) {
                chArrAsciiParamData = CUtil.a2bcd(s:ParameterDatas.chArrParameterVal);
                iLenParamData = ParameterDatas.ulParameterLen / 2;
                
                let tempArray: [Byte] = Array(chArrAsciiParamData[0 ..< iLenParamData])
                m_sMasterParamData?.m_uchArrBitmap440ActiveHost = tempArray
                
                //m_sMasterParamData?.m_uchArrBitmap440ActiveHost.append(contentsOf: "0x00".bytes)
                let centralChangeNumberArray = m_sMasterParamData?.m_uchArrBitmap440ActiveHost
                if let wrappedValue = centralChangeNumberArray?[0 ..< iLenParamData]
                {
                    chArrAsciiParamData[0 ..< iLenParamData] = wrappedValue
                }
                m_sMasterParamData?.bIsBitmap440ActiveHostSet = true;
            }
            
        case ParameterIDs._Packet_Send_500:
            if (ParameterDatas.ulParameterLen == AppConstant.LEN_BITMAP_PACKET * 2) {
                chArrAsciiParamData = CUtil.a2bcd(s:ParameterDatas.chArrParameterVal);
                iLenParamData = ParameterDatas.ulParameterLen / 2;
                

                let tempArray: [Byte] = Array(chArrAsciiParamData[0 ..< iLenParamData])
                m_sMasterParamData?.m_uchArrBitmap500ActiveHost = tempArray
                
                //m_sMasterParamData?.m_uchArrBitmap500ActiveHost.append(contentsOf: "0x00".bytes)
                let centralChangeNumberArray = m_sMasterParamData?.m_uchArrBitmap500ActiveHost
                if let wrappedValue = centralChangeNumberArray?[0 ..< iLenParamData]
                {
                    chArrAsciiParamData[0 ..< iLenParamData] = wrappedValue
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
                var tempData: Int64 = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int64(strTempData) ?? 0
                
                m_sMasterParamData?.m_lHSMPrimaryPort = tempData/*Int64(UInt32(ParameterDatas.chArrParameterVal));*/
            }
            
        case ParameterIDs._HSM_Secondary_IP:
            if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)
            {
                m_sMasterParamData?.m_strHSMSecondaryIP = bytes
            }
            
        case ParameterIDs._HSM_Secondary_Port:
            if (ParameterDatas.chArrParameterVal.count < AppConstant.MAX_ISO_PORT_LEN) {
                var tempData: Int64 = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int64(strTempData) ?? 0
                
                m_sMasterParamData?.m_lHSMSecondaryPort = tempData /*Int64(UInt32(ParameterDatas.chArrParameterVal));*/
            }
            
        case ParameterIDs._HSM_Retry_Count:
            var tempData: Int = 0
            let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
            tempData = Int(strTempData) ?? 0
            
            m_sMasterParamData?.m_iHSMRetryCount = tempData /*Int(Int64(UInt32(ParameterDatas.chArrParameterVal)));*/
            
        //Use Pine Encryption Key
        case ParameterIDs._Use_Pine_Key_Encryption:
            let iEarlierUsePineEncryptionKeys = m_sMasterParamData?.m_iUsePineEncryptionKeys;
            
            var tempData: Int = 0
            let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
            tempData = Int(strTempData) ?? 0
            
            m_sMasterParamData?.m_iUsePineEncryptionKeys = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
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
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int(strTempData) ?? 0
                
                m_sParamData.m_SecondaryIPMaxRetryCount = tempData /*Int(UInt32(ParameterDatas.chArrParameterVal))*/
                
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
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.AUTOSETTLEPARFILE, with: listAutoSettleParams);
        }catch
        {
            
        }
        return true;
    }
    
    func UpdateAutoPremiumServiceParamFile(newParams:AutoPremiumServiceParams) -> Bool {
        var listParams = [AutoPremiumServiceParams]();
        listParams.append(newParams);
        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.AUTOPREMIUMSERVICEPARFILE, with: listParams);
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
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.AUTOREVERSALPARFILE, with: listAutoReversalParams);
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
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.AUTOGPRSALWAYSONPARFILE, with: listParams)
            m_sAutoGprsParams = newParams;
        }catch
        {
            
        }
        return true;
    }
    
    public func UpdateSignUploadchksizeOnParameters(ParameterDatas:ParameterData) {
        //var iHostID = ParameterDatas.uiHostID;
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
    
    static func  ReadContentServerParamFile() -> ContentServerParamData? {
        if let t_contentServerParamData:ContentServerParamData = FileSystem.SeekRead(strFileName: FileNameConstants.CONTENT_SERVER_PARAM_FILE, iOffset: 0)
        {
            return t_contentServerParamData;
        }
        return nil
    }
    
    static func WriteContentServerParamFile(tContentServerParamData:ContentServerParamData) -> Bool{
        var listOfObjects = [ContentServerParamData]();
        listOfObjects.append(tContentServerParamData);
        do{
            _  =  try FileSystem.ReWriteFile(strFileName: FileNameConstants.CONTENT_SERVER_PARAM_FILE, with: listOfObjects)
        }
        catch{
            fatalError("ReWriteFile: WriteContentServerParamFile")
        }
        return true;
    }
    
    
   public func UpdateClessDefPreProcessingParameters(ParameterDatas:ParameterData) {
    _  = ParameterDatas.uiHostID;
    var ulAmount:Int64 = 0
     if var m_sParamData:TerminalParamData = ReadParamFile(){
            switch (ParameterDatas.ulParameterId) {
                case ParameterIDs._Cless_PreProcessing_Amount:
                    var tempData: Int64 = 0
                    let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                    tempData = Int64(strTempData) ?? 0
                    ulAmount = tempData
                    //ulAmount = Int64(UInt32(ParameterDatas.chArrParameterVal));
                    
             case ParameterIDs._Cless_PreProcessing_TxnType:
                   m_sParamData.bArrClessDefPreProcessTxnType[0] = ParameterDatas.chArrParameterVal[0];
                
             case ParameterIDs._Cless_MaxIntegration_TxnAmt:
                var tempData: Int64 = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int64(strTempData) ?? 0
                ulAmount = tempData
                //ulAmount = Int64(UInt32(ParameterDatas.chArrParameterVal));
             
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
                var iIsPasswordRequiredForSettlement: Bool = false
                
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!
                tempData = Int(strTempData) ?? 0
                
                if (tempData/*Int(UInt32(ParameterDatas.chArrParameterVal))*/ > 0) {
                    iIsPasswordRequiredForSettlement = true;
                } else {
                    iIsPasswordRequiredForSettlement = false;
                }
                _ =  WriteParamFile(listParamData: m_sParamData)
                
            case ParameterIDs._IS_PASSWORD_NEEDED_FOR_SPECIFIC_TXNS:
                var iIsPasswdNeededForSpecificTxns: Bool = false
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!
                tempData = Int(strTempData) ?? 0
                
                if (tempData/*Int(UInt32(ParameterDatas.chArrParameterVal))*/  > 0) {
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

        _ = ParameterDatas.uiHostID
        var iIsBiometricEnabled:Int = 0x00
        if var m_sParamData:TerminalParamData = ReadParamFile(){
            switch (ParameterDatas.ulParameterId) {
            case ParameterIDs._IS_BIOMETRIC_ENABLED:
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!
                tempData = Int(strTempData) ?? 0
                
                iIsBiometricEnabled = tempData/*Int(UInt32(ParameterDatas.chArrParameterVal))*/
                m_sParamData.m_iIsBiometricEnabled = iIsBiometricEnabled
                
            default:
                return
            }
            _ = WriteParamFile(listParamData: m_sParamData)
        }
    }
    
    public func UpdateEMVParameters(ParameterDatas:ParameterData) {
        _ = ParameterDatas.uiHostID;
        let iIsBiometricEnabled:Int = 0x00;
        if var m_sParamData:TerminalParamData = ReadParamFile(){
            switch (ParameterDatas.ulParameterId) {
            case ParameterIDs._EMVFallbackChipRetryCounter:
                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!
                tempData = Int(strTempData) ?? 0

                m_sParamData.m_EMVChipRetryCount = tempData/*Int(UInt32(ParameterDatas.chArrParameterVal));*/
                m_sParamData.m_iIsBiometricEnabled = iIsBiometricEnabled
                
            case ParameterIDs._EMV_MERCHANT_CATEGORY_CODE:
                if (ParameterDatas.chArrParameterVal.count > 0) {
                    if let bytes = String(data: Data(ParameterDatas.chArrParameterVal), encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
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
        var _ = ParameterDatas.uiHostID;
        var _:Int = 0x00;
        if var m_sParamData:TerminalParamData = ReadParamFile(){
            switch (ParameterDatas.ulParameterId) {
            case ParameterIDs._IS_CRIS_SUPPORTED:

                var tempData: Int = 0
                let strTempData = String(bytes: ParameterDatas.chArrParameterVal, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)
                tempData = Int(strTempData) ?? 0
                
                let iIsRISEnabled = tempData/*Int(UInt32(ParameterDatas.chArrParameterVal));*/
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
        if (true == FileSystem.IsFileExist(strFileName: FileNameConstants.BINRANGEFILE)) {
            if let listBinRange:[StBINRange] = FileSystem.ReadFile(strFileName: FileNameConstants.BINRANGEFILE) {
                let sortedArray = listBinRange.sorted {
                    (obj1, obj2) -> Bool in
                    return obj1.ulBinLow > obj2.ulBinLow
                }
                do{
                    _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.BINRANGEFILE, with: sortedArray);
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
    
    public func setFullSerialNumber(_ fullSerialNumberInput:String) {
        fullSerialNumber = fullSerialNumberInput
    }
    
    
    public static func GetTimeIntervalLeftInSecondsAccToFrequency(strEventStartTime:String, iFrequencyInSeconds:Int) -> Int64 {
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
    public static func GetTimeIntervalLeftInSeconds(strEventStartTime:String) -> Int64 {
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
    
    //MARK:- updateCustomProgressDialog(msg: String)
    static public func updateCustomProgressDialog(msg: String) {
        //              CStateMachine.m_context_activity.runOnUiThread(new Runnable() {
        //                  @Override
        //                  public void run() {
        //                     /* if(MainActivity.progressDialog != null)
        //                      {
        //                          MainActivity.progressDialog.setMessage(msg);
        //                      }*/
        //                      UIutils.getInstance().upDateCustomProgress(MainActivity.customProgressDialog, msg);
        //                  }
        //              });
        //          } catch (Exception e) {
        //          }
    }
    
    // MARK:- updateConnectionDataChangedFlag
    func UpdateConnectionDataChangedFlag(bFlag: Bool) -> Int {
        if var listTerminalConxData:[TerminalConxData] = FileSystem.ReadFile(strFileName: FileNameConstants.CONNECTIONDATAFILENAME){
            let numberOfTerminalConxData = listTerminalConxData.count;
            if numberOfTerminalConxData > 0 {
                for _ in 0 ..< numberOfTerminalConxData {
                    listTerminalConxData[0].bIsDataChanged = bFlag;
                }
                do{
                    _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.CONNECTIONDATAFILENAME, with: listTerminalConxData);
                }catch
                {
                    fatalError("Rewrite: UpdateConnectionDataChangedFlag")
                }
            }
        }
        return AppConstant.TRUE;
    }
    
    // MARK:-updateParamDataChangedFlag
    func UpdateParamDataChangedFlag(bFlag: Bool) -> Int {
        if var tData:TerminalParamData = ReadParamFile() {
            tData.m_bIsDataChanged = bFlag;
            _ = WriteParamFile(listParamData:tData);
        }
        return AppConstant.TRUE;
    }
    
    // MARK:-UpdateMasterParamDataChangedFlag
    
    func UpdateMasterParamDataChangedFlag(bFlag: Bool) -> Int {
        
        _ =  ReadMasterParamFile()
        m_sMasterParamData?.bIsDataChanged = bFlag;
        _ = WriteMasterParamFile();
        return AppConstant.TRUE;
    }
    
    
    // MARK:-UpdateAutoSettlementDataChangedFlag
    func UpdateAutoSettlementDataChangedFlag(bFlag: Bool) -> Int {
        if var m_sAutoSettleParams:AutoSettlementParams =  ReadAutoSettleParams(){
            
            m_sAutoSettleParams.m_bIsDataChanged = ((bFlag != false ) ? true : false)
            var listAutoSettlementParams = [AutoSettlementParams]()
            listAutoSettlementParams.append(m_sAutoSettleParams)
            do{
                _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.AUTOSETTLEPARFILE, with: listAutoSettlementParams)
            }catch
            {
                fatalError("Rewrite: UpdateAutoSettlementDataChangedFlag")
            }
            
        }
        return AppConstant.TRUE;
    }
    // MARK:-ReadAutoSettleParams
    func ReadAutoSettleParams() -> AutoSettlementParams?{
        var readParams:AutoSettlementParams?;
        if false == FileSystem.IsFileExist(strFileName: FileNameConstants.AUTOSETTLEPARFILE) {
            return readParams;
        }
        readParams = FileSystem.SeekRead(strFileName: FileNameConstants.AUTOSETTLEPARFILE, iOffset: 0);
        return readParams;
        
    }
    
    //MARK:- binarySearchMess(FileName: String,key: Int) -> Int
    func binarySearchMess(FileName: String, key: Int64) -> Int {
        let retIndex = -1;
        var objStructMessageId =   StructMESSAGEID()
        objStructMessageId.lmessageId = key;
        if let ItemList:[StructMESSAGEID] = FileSystem.ReadFile(strFileName: FileName){
            
            _ = ItemList.sorted {
                (obj1, obj2) -> Bool in
                return obj1.lmessageId > obj2.lmessageId
            }
        }
        return retIndex;
    }
    
    //MARK:- getMessage(id: Int64) -> Bool
    func GetMessage(id: Int64) -> [Byte]? {
        var objStructMessageId = StructMESSAGEID()
        objStructMessageId.lmessageId = id
        var retIndex = -1
        retIndex = binarySearchMess(FileName: FileNameConstants.MASTERMESFILE, key: id)
        if (retIndex >= 0) {
            if let objStructMessageId:StructMESSAGEID = FileSystem.SeekRead(strFileName: FileNameConstants.MASTERMESFILE, iOffset: retIndex){
                let bArrMessage = objStructMessageId.strArrMessage.bytes
                return bArrMessage
            } else {
                return nil
            }
        }
        return nil
    }
    
    
    /***************************
     * Name     :  FirstInitialize
     * Function :  Initialize the global data/ This function must be called for
     * initailizing global data and Communication data
     * Parameter:
     * Return   :
     ***************************/
    public func FirstInitialize() {
        
        //Create MasterCGFile
        _ = CreateMasterCGFile();
        
        //Create MasterIMFile
        _ = CreateMasterIMFile();
        
        //Create MasterCLRDIMFile
        _ = CreateMasterCLRDIMFile();
        
        //create MaterFCGfile
        _ = CreateMasterCFGFile();
        
        //create MaterFONTfile
        _ = CreateMasterFONTFile();//FOR UNICODE FONT FILE
        
        //create MaterLIbfile
        _ = CreateMasterLIBFile();//FOR Library FILE
        
        //create CIMB minipvm file
        _ = CreateMasterMINIPVMFile();
        
        //Create ParamFile
        _ = CreateParamFile();
        
        //Create UserAccountInfo File
        _ = CreateUserAccountFile();
        
        //Create UserInfo File
        _ = CreateMasterParamFile();
        
        _ = CreateAdServerHTLFile();
        
        //Create Conx File
        _ = createConnectionFile();
        
        _ = createConnectionFile();
        
        _ = GlobalData.CreateSignatureParamFile();
        
        _ = GlobalData.createDeviceStateFile();
        
        _ = CreateLogShippingFile();
        
        //Save default Auto Settle params
        if (false == FileSystem.IsFileExist(strFileName: FileNameConstants.AUTOSETTLEPARFILE)) {
            _ =  WriteDefaultAutoSettleParams();
        }
        
        //Save default Auto Reversal params
        if (false == FileSystem.IsFileExist(strFileName:FileNameConstants.AUTOREVERSALPARFILE)) {
            _ =  WriteDefaultAutoReversalParams();
        }
        
        //Save default Auto Gprs params
        if (false == FileSystem.IsFileExist(strFileName:FileNameConstants.AUTOGPRSALWAYSONPARFILE)) {
            _ =  WriteDefaultAutoGprsParams();
        }
        
        //Save default Auto Premium Service params
        if (false == FileSystem.IsFileExist(strFileName:FileNameConstants.AUTOPREMIUMSERVICEPARFILE)) {
            _ =  WriteDefaultAutoPremiumServiceParams();
        }
        //return retVal;
    }
    
    
    public func WriteDefaultAutoSettleParams() -> Bool {
        var defaultparams =  AutoSettlementParams();
        defaultparams.m_iAutoSettlementEnabledflag = false;
        defaultparams.m_strSettlementStartTime = "233000";
        defaultparams.m_iSettlementFrequency = 1;
        defaultparams.m_iSettlementRetryCount = 5;
        defaultparams.m_iSettlementRetryIntervalInSeconds = 120;
        defaultparams.m_bIsDataChanged = true;
        
        //Write the file
        var listAutoSettleParams = [AutoSettlementParams]();
        listAutoSettleParams.append(defaultparams);
        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.AUTOSETTLEPARFILE, with: listAutoSettleParams);
        }catch{
            fatalError("Rewrite Function: WriteDefaultAutoSettleParams")
        }
        
        //Populate the updated params
        m_sAutoSettleParams = defaultparams;
        return true;
    }
    
    /********* AUTO REVERSAL PARAMS ***********/
    public func WriteDefaultAutoReversalParams() -> Bool {
        var defaultparams =  AutoReversalParams();
        defaultparams.m_bIsAutoReversalEnableFlag = false;
        defaultparams.m_iAutoReversalFirstTryIntervalInSecs = 600;
        defaultparams.m_iAutoReversalRetryIntervalInSecs = 60;
        defaultparams.m_iAutoReversalMaxRetryCount = 5;
        defaultparams.m_bIsDataChanged = true;
        
        //Write the file
        var listAutoSettleParams = [AutoReversalParams]();
        listAutoSettleParams.append(defaultparams);
        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.AUTOREVERSALPARFILE, with: listAutoSettleParams);
        }catch{
            fatalError("Rewrite Function: WriteDefaultAutoSettleParams")
        }
        
        //Populate the updated params
        m_sAutoReversalParams = defaultparams;
        return true;
    }
    
    /********* AUTO GPRS PARAMS ***********/
    public func WriteDefaultAutoGprsParams() -> Bool {
        var defaultparams =  AutoGPRSNetworkParams();
        defaultparams.m_bIsAutoGPRSNetworkEnableFlag = false;
        defaultparams.m_iAutoGPRSNetworkRetryInterval = 60;
        defaultparams.m_bIsDataChanged = true;
        
        //Write the file
        var listAutoSettleParams = [AutoGPRSNetworkParams]();
        listAutoSettleParams.append(defaultparams);
        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.AUTOGPRSALWAYSONPARFILE, with: listAutoSettleParams);
        }catch{
            fatalError("Rewrite Function: WriteDefaultAutoSettleParams")
        }
        
        //Populate the updated params
        m_sAutoGprsParams = defaultparams;
        return true;
    }
    
    
    /********* AUTO Premium Service PARAMS ***********/
    public func WriteDefaultAutoPremiumServiceParams() -> Bool {
        var defaultparams =  AutoPremiumServiceParams();
        defaultparams.m_iAutoPremiumServiceEnableFlag = false;
        defaultparams.m_strAutoPremiumServiceStartTime = "230000";
        defaultparams.m_iAutoPremiumServiceFrequency = 1;
        defaultparams.m_iAutoPremiumServiceRetryCount = 5;
        defaultparams.m_iAutoPremiumServiceRetryIntervalInSeconds = 120;
        defaultparams.m_bIsDataChanged = true;
        //Write the file
        var listAutoSettleParams = [AutoPremiumServiceParams]();
        listAutoSettleParams.append(defaultparams);
        do{
            _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.AUTOPREMIUMSERVICEPARFILE, with: listAutoSettleParams);
        }catch{
            fatalError("Rewrite Function: WriteDefaultAutoSettleParams")
        }
        
        //Populate the updated params
        m_sAutoPremiumServiceParams = defaultparams;
        return true;
    }
    
    func UpdateMessageFile() -> Bool {
        if (FileSystem.IsFileExist(strFileName: FileNameConstants.DELETEMSGLIST)) {
            //          var numberOfItemtoDelete = FileSystem.NumberOfRows(DELETEMSGLIST);
            let numberOfItemtoDelete = 0;
            for _ in 0..<numberOfItemtoDelete {
                // MARK:- Neeed to complete this statement
                //        objmessageIdToDelete = CFileSystem.ReadRecord(m_context, LONG[].class, DELETEMSGLIST, i);
                let objmessageIdToDelete:Long?
                // if let unwrappedobjmessageIdToDelete = objmessageIdToDelete{
                //_ = DeleteMessageFromFile(messageIdToDelete: unwrappedobjmessageIdToDelete);
                //}
            }
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DELETEMSGLIST)
        }
        
        if (FileSystem.IsFileExist(strFileName: FileNameConstants.ADDMSGLIST)) {
            //var numberOfItemtoAdd = FileSystem.NumberOfRows(ADDMSGLIST);
            let numberOfItemtoAdd = 0
            for _ in 0..<numberOfItemtoAdd {
                let objmessageId:[StructMESSAGEID]?
                //objmessageId = FileSystem.ReadRecord(AppConstant.ADDMSGLIST, i)
                /*if let unwrappedobjmessageId  = objmessageId{
                 do{
                 _ = try FileSystem.AppendFile(strFileName: FileNameConstants.MASTERMESFILE, with: unwrappedobjmessageId);
                 }
                 catch{
                 print("AppendFile: UpdateMessageFile")
                 }
                 _ =  FileSystem.DeleteFileComplete(strFileName: FileNameConstants.ADDMSGLIST)
                 } else {
                 return true
                 }*/
            }
        }
        _ = SortMessageFile();
        return true;
    }
    
    func DeleteMessageFromFile(messageIdToDelete:Long) -> Bool {
        if var messageIdlisobj:[StructMESSAGEID] = FileSystem.ReadFile(strFileName: FileNameConstants.MASTERMESFILE){
            if (!messageIdlisobj.isEmpty) {
                for i in 0..<messageIdlisobj.count
                {
                    if (messageIdlisobj[i].lmessageId == messageIdToDelete.value) {
                        messageIdlisobj.remove(at:i)
                        break;
                    }
                }
            }
            do {
                _ = try FileSystem.ReWriteFile(strFileName: FileNameConstants.MASTERMESFILE, with: messageIdlisobj);
            }catch{
                debugPrint("ReWriteFile: DeleteMessageFromFile " )
            }
        }
        return true;
    }
    
    public func SortMessageFile() -> Bool {
        if let ItemList:[StructMESSAGEID] = FileSystem.ReadFile(strFileName: FileNameConstants.MASTERMESFILE){
            if ((ItemList.count > 0)) {
                let sortedArray = ItemList.sorted {
                    (obj1, obj2) -> Bool in
                    return obj1.lmessageId > obj2.lmessageId
                }
                do {
                    _ =  try FileSystem.ReWriteFile(strFileName: FileNameConstants.MASTERMESFILE, with: sortedArray);
                }catch{
                    debugPrint("SortMessageFile");
                }
            }
        }
        return true
    }
    
    public func  UpdateMasterCTFile() -> Bool{
        if ((FileSystem.IsFileExist(strFileName: FileNameConstants.ADDCTLIST)) || (FileSystem.IsFileExist(strFileName: FileNameConstants.DELETECTLIST)))
        {
            _ = SyncFiles(MasterFile: FileNameConstants.MASTERCGFILE, AddListFile: FileNameConstants.ADDCTLIST, DeleteListFile: FileNameConstants.DELETECTLIST);
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.ADDCTLIST);
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DELETECTLIST);
        }
        return true;
    }
    
    public func UpdateMasterIMFile() -> Bool {
        if ((FileSystem.IsFileExist(strFileName: FileNameConstants.ADDIMLIST)) || (FileSystem.IsFileExist(strFileName: FileNameConstants.DELETEIMLIST))) {
            SyncFiles(MasterFile: FileNameConstants.MASTERIMFILE, AddListFile: FileNameConstants.ADDIMLIST, DeleteListFile: FileNameConstants.DELETEIMLIST);
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.ADDIMLIST);
            
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DELETEIMLIST);
            
        }
        return true;
    }
    
    public func UpdateMasterCLRDIMFile() -> Bool {
        
        if ((FileSystem.IsFileExist(strFileName: FileNameConstants.ADDCLRDIMLIST)) || (FileSystem.IsFileExist(strFileName: FileNameConstants.DELETECLRDIMLIST))) {
            
            SyncFiles(MasterFile: FileNameConstants.MASTERCLRDIMFILE, AddListFile: FileNameConstants.ADDCLRDIMLIST, DeleteListFile: FileNameConstants.DELETECLRDIMLIST);
            
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.ADDCLRDIMLIST);
            
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DELETECLRDIMLIST);
            
        }
        
        return true;
        
    }
    
    //for dynamic chargeslip
    public func UpdateMasterFCGFile() -> Bool {
        if ((FileSystem.IsFileExist(strFileName: FileNameConstants.ADDFCTLIST)) || (FileSystem.IsFileExist(strFileName: FileNameConstants.DELETEFCTLIST))) {
            
            SyncFiles(MasterFile: FileNameConstants.MASTERFCGFILE, AddListFile: FileNameConstants.ADDFCTLIST, DeleteListFile: FileNameConstants.DELETEFCTLIST);
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.ADDFCTLIST);
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DELETEFCTLIST);
        }
        return true
    }
    
    //for UniCode Font File download
    public func UpdateMasterFONTFile() -> Bool{
        if ((FileSystem.IsFileExist(strFileName: FileNameConstants.ADDFONTLIST)) || (FileSystem.IsFileExist(strFileName: FileNameConstants.DELETEFONTLIST))) {
            
            SyncFiles(MasterFile: FileNameConstants.MASTERFONTFILE, AddListFile: FileNameConstants.ADDFONTLIST, DeleteListFile: FileNameConstants.DELETEFONTLIST);
            
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.ADDFONTLIST);
            
            _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DELETEFONTLIST);
            
        }
        return true
    }
    
    func SyncFiles(MasterFile:String, AddListFile:String, DeleteListFile:String)
    {
        var listItem:[Long]?
        var DeleteListData:[Long]?
        var AddListData:[Long]?
        var numberOfItems = 0;
        
        if (FileSystem.IsFileExist(strFileName:MasterFile)) {
            if (FileSystem.IsFileExist(strFileName: DeleteListFile)) {
                listItem = FileSystem.ReadFile(strFileName: MasterFile);
                if var list = listItem {
                    if(list.count>0){
                        numberOfItems = list.count;
                    }
                    
                    var numberOfItemtoDelete:Int64 = 0;
                    
                    DeleteListData = FileSystem.ReadFile(strFileName: DeleteListFile)
                    if let DeleteList =  DeleteListData{
                        if (!DeleteList.isEmpty) {
                            numberOfItemtoDelete = Int64(DeleteList.count);
                        }
                        
                        for _ in  0..<numberOfItemtoDelete{
                            for i in 0..<list.count{
                                if(list[i].value == DeleteList[i].value) {
                                    list.remove(at: i);
                                    break;
                                }
                            }
                        }
                        
                        if ((list.count > 0)) {
                            let sortedArray = list.sorted {
                                (obj1, obj2) -> Bool in
                                return obj1.value > obj2.value
                            }
                            do {
                                _ = try  FileSystem.ReWriteFile(strFileName: MasterFile, with: sortedArray);
                                
                            }catch{
                                fatalError("ReWriteFile")
                            }
                        }
                    }
                }
                
                if (FileSystem.IsFileExist(strFileName: AddListFile)) {
                    numberOfItems = 0;
                    listItem = FileSystem.ReadFile(strFileName: MasterFile)
                    
                    if var list = listItem{
                        if(!(list.isEmpty)) {
                            numberOfItems = list.count;
                        }
                        var numberOfItemtoAdd = 0;
                        AddListData = FileSystem.ReadFile(strFileName: AddListFile)
                        if let AddList = AddListData{
                            if (!AddList.isEmpty) {
                                numberOfItemtoAdd = AddList.count;
                            }
                            
                            for i in  0..<numberOfItemtoAdd {
                                if (numberOfItems <= 100) {
                                    if (list == nil) {
                                        list = [Long]();
                                    }
                                    list.append(AddList[i]);
                                    numberOfItems += 1;
                                }
                            }
                            
                            if (list.count > 0) {
                                let sortedArray = list.sorted {
                                    (obj1, obj2) -> Bool in
                                    return obj1.value > obj2.value
                                }
                                do {
                                    _ = try  FileSystem.ReWriteFile(strFileName: MasterFile, with: sortedArray);
                                }catch{
                                    print("ReWriteFile")
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //for LIBrary File download
    func UpdateMasterLIBFile() -> Bool {
        if let libUpgrade:[Byte] = FileSystem.ReadFile(strFileName: FileNameConstants.EDCLIBSTATUS){
            if (libUpgrade[0] == 1) {
                _ =  FileSystem.DeleteFileComplete(strFileName: FileNameConstants.EDCLIBSTATUS);
                
                if ((FileSystem.IsFileExist(strFileName: FileNameConstants.ADDLIBLIST)) || (FileSystem.IsFileExist( strFileName: FileNameConstants.DELETELIBLIST))) {
                    
                    SyncLibFiles(MasterFile: FileNameConstants.MASTERLIBFILE, AddListFile: FileNameConstants.ADDLIBLIST, DeleteListFile: FileNameConstants.DELETELIBLIST);
                    
                    _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.ADDLIBLIST);
                    
                    _ = FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DELETELIBLIST);
                    
                }
            }
        }
        return true;
    }
    
    func UpdateMasterMINIPVMFile() -> Bool {
        if ((FileSystem.IsFileExist(strFileName: FileNameConstants.ADDMINIPVMLIST)) || (FileSystem.IsFileExist(strFileName: FileNameConstants.DELETEMINIPVMLIST))) {
            
            SyncFiles(MasterFile: FileNameConstants.MASTERMINIPVMFILE, AddListFile: FileNameConstants.ADDMINIPVMLIST, DeleteListFile: FileNameConstants.DELETEMINIPVMLIST);
            
            _ =  FileSystem.DeleteFileComplete(strFileName: FileNameConstants.ADDMINIPVMLIST);
            
            _ =  FileSystem.DeleteFileComplete(strFileName: FileNameConstants.DELETEMINIPVMLIST);
            
        }
        return true
    }
    
    
    func SyncLibFiles(MasterFile:String, AddListFile:String, DeleteListFile:String)
    {
        var listItem:[LIBStruct]?
        var DeleteListData:[LIBStruct]?
        var AddListData:[LIBStruct]?
        var numberOfItems = 0
        
        if (FileSystem.IsFileExist(strFileName:MasterFile)) {
            if (FileSystem.IsFileExist(strFileName: DeleteListFile)) {
                listItem = FileSystem.ReadFile(strFileName:MasterFile);
                if var list = listItem {
                    if(list.count>0){
                        numberOfItems = list.count;
                    }
                    var numberOfItemtoDelete:Int64 = 0;
                    
                    DeleteListData = FileSystem.ReadFile(strFileName: DeleteListFile)
                    if let DeleteList =  DeleteListData{
                        if (!DeleteList.isEmpty) {
                            numberOfItemtoDelete = Int64(DeleteList.count);
                        }
                        
                        for _ in  0..<numberOfItemtoDelete{
                            for i in 0..<list.count{
                                if(list[i].id == DeleteList[i].id) {
                                    list.remove(at: i);
                                    break;
                                }
                            }
                        }
                        
                        if ((list.count > 0)) {
                            let sortedArray = list.sorted{
                                (obj1, obj2) -> Bool in
                                return obj1.id > obj2.id
                            }
                            do {
                                _ = try  FileSystem.ReWriteFile(strFileName: MasterFile, with: sortedArray);
                            }catch{
                                fatalError("ReWriteFile")
                            }
                        }
                    }
                }
                
                if (FileSystem.IsFileExist(strFileName: AddListFile)) {
                    numberOfItems = 0;
                    listItem = FileSystem.ReadFile(strFileName: MasterFile)
                    if var list = listItem{
                        if(!(list.isEmpty)) {
                            numberOfItems = list.count;
                        }
                        var numberOfItemtoAdd = 0;
                        AddListData = FileSystem.ReadFile(strFileName: AddListFile)
                        
                        if let AddList = AddListData{
                            if (!AddList.isEmpty) {
                                numberOfItemtoAdd = AddList.count
                            }
                            
                            for i in  0..<numberOfItemtoAdd {
                                if (numberOfItems <= 100) {
                                    if (list == nil) {
                                        list = [LIBStruct]();
                                    }
                                    list.append(AddList[i]);
                                    numberOfItems += 1;
                                }
                            }
                            
                            if (list.count > 0) {
                                let sortedArray = list.sorted {
                                    (obj1, obj2) -> Bool in
                                    return obj1.id > obj2.id
                                }
                                
                                do {
                                    _ = try  FileSystem.ReWriteFile(strFileName: MasterFile, with: sortedArray);
                                }catch{
                                    debugPrint("ReWriteFile")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func SetSSLMode(isON:Bool) -> Int {
        m_bIsSSL = isON;
        return AppConstant.TRUE;
    }
    
    
    public func SetSignCapMode(isON:Bool) -> Int {
        m_bIsSignCapture = isON;
        return AppConstant.TRUE;
    }
    
    public func InitializeTxnTlvData() -> Bool {
        CStateMachine.stateMachine.m_bIS_TLE_TXN = false;
        m_ptrCSVDATA.bsendData = false;
        m_iEMVTxnType = EMVTxnType.NOT_EMV;
        _ = SetSSLMode(isON: false);
        _ = SetSignCapMode(isON: false);
        m_bIsSignAsked = false;
        
        m_sNewTxnData = TerminalTransactionData();
        
        m_sTxnTlvData = TxnTLVData();
        m_sTxnTlvData.iTLVindex = 0;
        for i in 0..<AppConstant.MAX_TXN_STEPS_WITH_TLV_DATA {
            m_sTxnTlvData.objTLV[i].uiTag = AppConstant.INVALID_TAG;
            m_sTxnTlvData.objTLV[i].uiTagValLen = AppConstant.INVALID_TAG_LEN;
            m_sTxnTlvData.objTLV[i].chArrTagVal = "0000".bytes;
        }
        
        return true
    }
    
    public func GetSerialPort() ->Int {
        var ComPort = AppConstant.COM0;
        if let listTerminalConxData:[TerminalConxData] = FileSystem.ReadFile(strFileName: FileNameConstants.CONNECTIONDATAFILENAME){
            if (listTerminalConxData.count > 0) {
                for i in 0..<listTerminalConxData.count {
                    let tData = listTerminalConxData[i];
                    if (tData != nil) {
                        if (ConnectionTypes.DIALUP_SERIAL == tData.iConnType) {
                            var iComPort:Int = tData.iComPort;
                            switch (iComPort) {
                            case 0:
                                ComPort = AppConstant.COM0;
                                break;
                            case 10:
                                ComPort = AppConstant.COM5;
                                break
                            case 20:
                                ComPort = AppConstant.COM_EXT;
                                break;
                            default:
                                break;
                            }
                        }
                    }
                }
            }
        }
        return ComPort;
        
    }
    
    func GetSerialSendReceiveTimeout() ->Int{
        var tData:TerminalConxData?;
        var iSendReceiveTimeout:Int = 30;
        
        if let listTerminalConxData:[TerminalConxData] = FileSystem.ReadFile(strFileName: FileNameConstants.CONNECTIONDATAFILENAME){
            if (listTerminalConxData.count > 0) {
                for i in 0..<listTerminalConxData.count {
                    tData = listTerminalConxData[i];
                    if (tData != nil) {
                        let iConnType = tData?.iConnType;
                        if (ConnectionTypes.DIALUP_SERIAL == iConnType) {
                            iSendReceiveTimeout = tData?.iSendRecTimeout ?? 0;
                        }
                    }
                }
            }
        }
        return iSendReceiveTimeout;
    }
    
    
}
