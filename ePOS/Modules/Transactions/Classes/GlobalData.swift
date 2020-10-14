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
    static var m_sTerminalParamData_Cache:TerminalParamData?
    var m_sMasterParamData: TerminalMasterParamData? = nil
    var m_objCurrentLoggedInAccount: LOGINACCOUNTS? = nil
    var m_strCurrentLoggedInUserPIN: String = ""
    var m_bIsLoggedIn: Bool = false
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
            _ = try FileSystem.AppendFile(strFileName: AppConstant.DEVICE_STATE, with: [deviceState])
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
}
    




    
