//
//  CBaseNode.swift
//  ePOS
//
//  Created by Abhishek on 03/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
class CBaseNode {
    var iName = "";
    var iNameImage = "";
    var fileName = "";
    var viewType = "";
    var node_type = 0;
    var InputMethod:enum_InputMethod?;
    var regx = "";
    var txtye = "";
    var maxLen = 0;
    var minLen = 0;
    var Child:ChildClass?;
    var numberOfChild = 0;
    var Timeout:Int = 0;
    var cascading = 0;
    var brightnessLevel = -1;
    var goToOrignalBrightness = 0;
    var HostTlvtag = 0;
    internal var HostActiontag = 0;
    internal var iHostType = 0;
    internal var m_iIsLatLong = false;
    internal var Parent:CBaseNode?;
    var m_bIsUnicodeBase = false;
    internal var onOk = PvmNodeActions.gotoChild;
    internal var onCancel = PvmNodeActions.goBack;
    internal var onExit = PvmNodeActions.exitPvm;
    internal var onTimeout = PvmNodeActions.exitPvm;
    internal var onSSL = 0;
    public var m_chArrAmount:String = "";
    internal var m_bIsAmountUsingXMl = false;
    public var m_chPadChar:Byte = 0;
    public var m_iPadStyle:Int = AppConstant._LEFT_PAD;
    public var m_iTleEnabled = false;
    public var m_iIsIRIS = false;
    internal var m_chArrCurrencyCode = "";
    var m_bIsCurrencyCodeUsingXMl = false;
    var m_iIsSignCapture = false;
    public var ItemList:[ITEMVAL]?;
    public var ItemListImages:[ImageListParserModel]?;
    var iResult = -1;
    var iPos = -1;
    var iBuffer:String?;
    static let I_RESULT_OK = 0;
    static let I_RESULT_TIME_OUT = 1;
    static let I_RESULT_BACK_PRESSED = -1;
    let numberOFItemsInMenuList = 0;
    let numberOFImages = 0;
    var listViewcode = 0;
    var soundTrack = "";
    public var KEY_F1 = 0;
    public var KEY_F2 = 0;
    public var KEY_F3 = 0;
    public var KEY_F4 = 0;
    public var KEY_ENTER = 0;
    public var KEY_CANCEL = 0;
    public var KeyF1 = "";
    public var KeyF2 = "";
    public var KeyF3 = "";
    public var KeyF4 = "";
    public var ScanType = "";
    public var DisplayMessage = "";
    public var DisplayMessageLine2 = "";
    public var DisplayMessageLine3 = "";
    public var DisplayMessageLine4 = "";
    public var pvmListParser:[PvmListParserVO]?;
    public var qrcodescanningListParser:[QRCodeScanningParserVO]?;
    public var qrCodeParsingData:QRCodeParsingData?;
    public var m_bundle:[String:String]?;
    public var parenNode:CBaseNode?;
    
    public init()
    {
        
    }
    
    //    private func setScreenBrightness(screenBrightnessValue:Int) {
    //            var brightness = screenBrightnessValue * 255 / 100;
    //            Settings.System.putInt(PlutusApplication.getContext().getContentResolver(), Settings.System.SCREEN_BRIGHTNESS_MODE, Settings.System.SCREEN_BRIGHTNESS_MODE_MANUAL);
    //            Settings.System.putInt(PlutusApplication.getContext().getContentResolver(), Settings.System.SCREEN_BRIGHTNESS, brightness);
    //        } catch (Exception e) {
    //            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(e));
    //        }
    //    }
    
    // MARK:- AddChild
    public func AddChild(addThisNode:CBaseNode) -> Int {
        var retVal:Int = RetVal.RET_OK;
        if (nil == Child) {
            Child = ChildClass();
            Child?.this_node = addThisNode;
            Child?.index = addThisNode.getIndex();
        } else {
            retVal = Child?.addChild(gIndex: addThisNode.getIndex(), addThisNode: addThisNode) ?? 0
        }
        numberOfChild = numberOfChild+1;
        return retVal;
    }
    // MARK:- AddParent
    public func AddParent(cparentNode:CBaseNode) -> Int {
        self.Parent = cparentNode;
        return RetVal.RET_OK;
    }
    // MARK:- run
    public func run() -> CBaseNode? {
        if (CStateMachine.currentNode?.goToOrignalBrightness == 1) {
        }
        let latitude = 0.0;
        let longitude = 0.0;
        let msg = "";
        SetActionCode();
        SetHostType();
        SetSSLMode();
        if let latLongValue = CStateMachine.currentNode?.m_iIsLatLong{
            setLatLong(isLatLongReq:latLongValue, lat: String(latitude), lng: String(longitude),msg: msg);
            SetSIGNCAPTURE();
            var _:String?;
            let val:Int=0
            switch (val) {
            case ExecutionResult._OK:
                if let nodeAfterExecuting = OnOk(){
                    return nodeAfterExecuting;
                }
            case ExecutionResult._CANCEL:
                if let nodeAfterExecuting = OnCancel(){
                    if (nodeAfterExecuting.getNodeType() == PvmNodeTypes.Event_Received_node) {
                        return nil;
                    }
                    return nodeAfterExecuting;
                }
            case ExecutionResult._EXIT:
                if let nodeAfterExecuting = OnExit(){
                    if ((nodeAfterExecuting.getNodeType() == PvmNodeTypes.Event_Received_node)) {
                        return nil;
                    }
                    return nodeAfterExecuting;
                }
            case ExecutionResult._TIMEOUT:
                if let nodeAfterExecuting = OnTimeOut(){
                    if ((nodeAfterExecuting.getNodeType() == PvmNodeTypes.Event_Received_node)) {
                        return nil;
                    }
                    return nodeAfterExecuting;
                }
            default:
                break;
            }
        }
        return nil;
    }
    
    // MARK:- setLatLong
    internal func setLatLong(isLatLongReq:Bool,lat:String,lng:String,msg:String) {
        
        let hatLat = 0x1162;
        let hatLng = 0x1163;
        _ = 0x1161;
        if (isLatLongReq) {
            var uchArrEncOutLAt = [Byte](repeating: 0, count: lat.bytes.count + 14);
            var iOffset = 0;
            uchArrEncOutLAt[iOffset] = 0; // TLE NOT USED
            iOffset += 1
            uchArrEncOutLAt[iOffset] = Byte(AppConstant.DEFAULT_BIN_KEYSLOTID & 0x000000FF);
            iOffset += 1
            uchArrEncOutLAt[iOffset] = (Byte)(m_chPadChar & 0x000000FF);
            iOffset += 1
            uchArrEncOutLAt[iOffset] = (Byte)(m_iPadStyle);
            iOffset += 1
            var latValue = lat.bytes;
            let length = latValue.count;
            latValue[0...length] = uchArrEncOutLAt[0...length]
            iOffset += latValue.count
            AddTLVDataWithTag(uiTag: hatLat, Data: uchArrEncOutLAt, length: iOffset);
            /*******add lng to tlv********/
            var uchArrEncOutLng = [Byte](repeating: 0, count: lng.bytes.count + 14);
            iOffset = 0;
            uchArrEncOutLng[iOffset] = Byte(AppConstant.DEFAULT_BIN_KEYSLOTID & 0x000000FF);
            iOffset += 1
            uchArrEncOutLng[iOffset] = (Byte)(m_chPadChar & 0x000000FF);
            iOffset += 1
            uchArrEncOutLng[iOffset] = (Byte)(m_iPadStyle);
            iOffset += 1
            var lagValue = lng.bytes;
            let lengthLag = latValue.count;
            lagValue[0...lengthLag] = uchArrEncOutLng[0...lengthLag]
            iOffset += lng.count;
            AddTLVDataWithTag(uiTag: hatLng, Data: uchArrEncOutLng, length: iOffset);
            
            /*******add msg to tlv********/
            var uchArrEncOutMsg = [Byte](repeating: 0, count: lng.bytes.count + 14);
            iOffset = 0;
            uchArrEncOutMsg[iOffset] = Byte(AppConstant.DEFAULT_BIN_KEYSLOTID & 0x000000FF);
            iOffset += 1
            uchArrEncOutMsg[iOffset] = (Byte)(m_chPadChar & 0x000000FF);
            iOffset += 1
            uchArrEncOutMsg[iOffset] = (Byte)(m_iPadStyle);
            iOffset += 1
            var msgValue = msg.bytes;
            let lengthMsg = latValue.count;
            msgValue[0...lengthMsg] = uchArrEncOutLAt[0...lengthMsg]
            iOffset += msgValue.count;
            AddTLVDataWithTag(uiTag: hatLng, Data: uchArrEncOutMsg, length: iOffset);
        }
        
    }
    
    // MARK:- GotoChild
    public func GotoChild(index:Int) -> CBaseNode? {
        if (nil == Child) {
            return nil;
        } else {
            return (Child?.gotoindexedChild(gIndex: index));
        }
    }
    
    // MARK:- GotoChild
    internal func GotoChild() -> CBaseNode? {
        if (nil == Child) {
            return nil;
        } else {
            return (Child?.this_node);
        }
    }
    
    // MARK:- GotoParent
    public func GotoParent() -> CBaseNode? {
        /*if(MainActivity.bIsMainScreenRequest) {
         return null;
         }*/
        // Just for added safety
        if let cbaseNode = CStateMachine.stateMachine.GetRootNode(){
            if cbaseNode is CBaseNode {
                GlobalData.singleton.InitializeTxnTlvData();
                return nil;
            }
            if ((PvmNodeTypes.Menu_item_node == self.Parent?.node_type) || (PvmNodeTypes.Event_Received_node == self.Parent?.node_type)) {
                if let unwrappedparent1 = self.Parent{
                    clearTLVDataWithTag(currentNode: unwrappedparent1);
                    if let unwrappedparent2 = self.Parent?.Parent{
                        clearTLVDataWithTag(currentNode:unwrappedparent2);
                        if (unwrappedparent2 is CBaseNode){
                            return nil;
                        }
                        return (unwrappedparent2);
                    }
                }
            }
        }
        else {
            if let unwrappedparent1 = self.Parent{
                clearTLVDataWithTag(currentNode: unwrappedparent1);
            }
            return (self.Parent);
        }
    }
    
    // MARK:- clearTLVDataWithTag
    func  clearTLVDataWithTag(currentNode:CBaseNode) {
        if (GlobalData.singleton.m_sTxnTlvData.iTLVindex > 0) {
            if (currentNode.HostTlvtag == GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex - 1].uiTag) {
                GlobalData.singleton.m_sTxnTlvData.iTLVindex = GlobalData.singleton.m_sTxnTlvData.iTLVindex-1 ;
            }
        }
    }
    
    // MARK:- GotoRoot
    internal func  GotoRoot() -> CBaseNode? {
        return nil;
    }
    
    // MARK:- GoOnline
    func GoOnline() -> CBaseNode?{
        if m_iIsIRIS {
            _ = GlobalData.singleton.GetSerialPort();
            return (GotoRoot());
        }
        if (GlobalData.singleton.m_iHostIndicator <= 0) {
            GlobalData.singleton.m_iHostIndicator = AppConstant.DEFAULT_HOSTID;
        }
        
        GlobalData.singleton.IsGoOnline = true;
        return nil;
    }
    
    // MARK:- OnOk
    internal func OnOk() -> CBaseNode? {
        switch (self.onOk) {
        case PvmNodeActions.gotoChild:
            return (self.GotoChild());
        case PvmNodeActions.goBack:
            return (self.GotoParent());
        case PvmNodeActions.gotoRoot:
            return (self.GotoRoot());
        case PvmNodeActions.goOnline:
            return (self.GoOnline());
        case PvmNodeActions.exitPvm:
            return nil;
        default:
            break;
        }
        return nil;
    }
    
    // MARK:- OnCancel
    internal func OnCancel() -> CBaseNode? {
        if let rootNode = CStateMachine.stateMachine.GetRootNode(){
            if (rootNode is CBaseNode ) {
                _ =  GlobalData.singleton.InitializeTxnTlvData();
                return nil;
            }
            switch (self.onCancel) {
            case PvmNodeActions.gotoChild:
                return (self.GotoChild());
            case PvmNodeActions.goBack:
                return (self.GotoParent());
            case PvmNodeActions.gotoRoot:
                return (self.GotoRoot());
            case PvmNodeActions.goOnline:
                return (self.GoOnline());
            case PvmNodeActions.exitPvm:
                return nil;
            default:
                break;
            }
        }
        return nil;
    }
    
    // MARK:- OnExit
    internal func OnExit() -> CBaseNode? {
        // If current node is root node exit
        if let rootNode = CStateMachine.stateMachine.GetRootNode(){
            if (rootNode is CBaseNode ) {
                _ =  GlobalData.singleton.InitializeTxnTlvData();
                return nil;
            }
        }
        switch (self.onExit){
        case PvmNodeActions.exitPvm:
            return nil;
        case PvmNodeActions.gotoChild: break
        case PvmNodeActions.goBack: break
        case PvmNodeActions.gotoRoot: break
        default:
            return (self.GotoRoot());
        }
        return nil;
    }
    
    // MARK:- OnTimeOut
    internal func OnTimeOut() -> CBaseNode? {
        switch (self.onTimeout) {
        case PvmNodeActions.gotoChild:
            return (self.GotoChild());
        case PvmNodeActions.goBack:
            return (self.GotoParent());
        case PvmNodeActions.gotoRoot:
            return (self.GotoRoot());
        case PvmNodeActions.goOnline:
            return (self.GoOnline());
        case PvmNodeActions.exitPvm:
            return nil;
        default:
            break;
        }
        return nil;
    }
    
    // MARK:- AddParameters
    internal func AddParameters(tagAttribute:XMLATTRIBUTE, nTotal:Int) -> Int {
        var retVal  = RetVal.RET_OK;
        node_type = tagAttribute.node_type;
        iName = tagAttribute.iName;
        iNameImage = tagAttribute.iNameImage;
        fileName = tagAttribute.fileName;
        viewType = tagAttribute.viewType;
        Timeout = tagAttribute.Timeout;
        cascading = tagAttribute.cascading;
        brightnessLevel = tagAttribute.brightnessLevel;
        goToOrignalBrightness = tagAttribute.goToOrignalBrightness;
        listViewcode = tagAttribute.ListViewcode;
        soundTrack = tagAttribute.soundTrack;
        onOk = tagAttribute.onOk;
        onCancel = tagAttribute.onCancel;
        onTimeout = tagAttribute.onTimeout;
        HostActiontag = tagAttribute.HostActiontag;
        iHostType = tagAttribute.iHostType;
        HostTlvtag = tagAttribute.HostTlvtag;
        onSSL = tagAttribute.IsOnSSL;
        m_iIsLatLong = tagAttribute.IsLatLong;
        
        InputMethod = tagAttribute.InputMethod;
        txtye = tagAttribute.txtye;
        regx = tagAttribute.regx;
        maxLen = Int(tagAttribute.MaxLen);
        minLen = Int(tagAttribute.MinLen);
        
        if (tagAttribute.chAmount.count > 0) {
            m_chArrAmount = tagAttribute.chAmount;
        }
        
        if (tagAttribute.chCurrencyCode.count > 0) {
            m_chArrCurrencyCode = tagAttribute.chCurrencyCode;
            m_bIsCurrencyCodeUsingXMl = true;
        }
        
        m_chPadChar = tagAttribute.chPadChar;
        m_iPadStyle = Int(tagAttribute.iPadStyle);
        m_iTleEnabled = tagAttribute.iTleEnabled;
        m_iIsIRIS = tagAttribute.iIsIris;
        m_iIsSignCapture = tagAttribute.IsSignCapture;            // Amitesh:: for Signature capture mode
        pvmListParser = tagAttribute.pvmListParser;
        qrcodescanningListParser = tagAttribute.qrcodescanningListParser;
        qrCodeParsingData = tagAttribute.qrCodeParsingData;
        if tagAttribute.parenNode != nil{
            if (RetVal.RET_OK == retVal) {
                retVal = self.AddPrivateParameters(tagAttribute: tagAttribute, nTotal: nTotal);
            }
        }
        return retVal;
    }
    
    // MARK:- getIndex
    internal func getIndex() -> Int {
        return 0;
    }
    
    // MARK:- GetEventMask
    public func GetEventMask() -> Byte {
        return 0;
    }
    
    // MARK:- SetHardwareMask
    public func SetHardwareMask(HardWareMask:Int) -> Bool {
        return false;
    }
    
    // MARK:- GetKeyEntry
    func GetKeyEntry(keyreceved:Character) ->Int {
        return 0;
    }
    
    // MARK:- AddTLVData
    internal func AddTLVData(Data:[Byte],length:Int) {
        if ((length > 0) && (HostTlvtag > 0) && (GlobalData.singleton.m_sTxnTlvData.iTLVindex < AppConstant.MAX_TXN_STEPS_WITH_TLV_DATA)) {
            GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex] = TLVTxData();
            GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex].uiTag = HostTlvtag;
            GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex].uiTagValLen = length;
            GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex].chArrTagVal =  [Byte](repeating: 0, count: length);
            var data = Data;
            data[0...length] = GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex].chArrTagVal[0...length]
            
            GlobalData.singleton.m_sTxnTlvData.iTLVindex =  GlobalData.singleton.m_sTxnTlvData.iTLVindex + 1;
        }
    }
    
    // MARK:- AddTLVDataWithTag
    internal func AddTLVDataWithTag(uiTag:Int,Data:[Byte],length:Int) {
        if ((length > 0) && (uiTag > 0) && (GlobalData.singleton.m_sTxnTlvData.iTLVindex < AppConstant.MAX_TXN_STEPS_WITH_TLV_DATA)) {
            GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex] =  TLVTxData();
            GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex].uiTag = uiTag;
            GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex].uiTagValLen = length;
            GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex].chArrTagVal = [Byte](repeating: 0, count: length);
            var data = Data;
            data[0...length] = GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex].chArrTagVal[0...length]
            GlobalData.singleton.m_sTxnTlvData.iTLVindex =  GlobalData.singleton.m_sTxnTlvData.iTLVindex + 1;
            
        }
    }
    
    // MARK:- SetActionCode
    internal func SetActionCode() {
        if (HostActiontag > 0) {
            let cplatform = PlatFormUtils();
            GlobalData.singleton.m_sNewTxnData.uiTransactionType = HostActiontag;
            if let m_sParamData:TerminalParamData = GlobalData.singleton.ReadParamFile(){
                if (m_sParamData.m_iIsPasswdNeededForSpecificTxns && (PlatFormUtils.isPasswordRequiredForSpecificTransaction() != 0)) {
                    // TransactionHUB.getInstance().isPasswordRequiredForSpecificTransaction = true;
                }
            }
        }
    }
    
    // MARK:- SetHostType
    internal func SetHostType() {
        if (iHostType > 0) {
            GlobalData.singleton.m_iHostIndicator = iHostType;
        }
    }
    
    // MARK:- SetSSLMode
    internal func SetSSLMode() {
        if (1 == onSSL) {
            _ = GlobalData.singleton.SetSSLMode(isON: true);
        }
    }
    
    // MARK:- SetSIGNCAPTURE
    internal func SetSIGNCAPTURE() {
        if (true == m_iIsSignCapture) {
            _ = GlobalData.singleton.SetSignCapMode(isON: true);
            GlobalData.singleton.m_bIsToCaptureSignature = true;
        }
        
    }
    
    // MARK:- IsAmountAlreadyPresent
    internal func IsAmountAlreadyPresent() -> Int {
        var retIndex = 0;
        var tag = 0;
        
        for i in 0..<GlobalData.singleton.m_sTxnTlvData.iTLVindex {
            //CLogger.TraceLog(TRACE_DEBUG, "index[%d] tag[0x%x]", i, Global.m_sTxnTlvData.objTLV[i].uiTag);
            
            if (0x1004 == GlobalData.singleton.m_sTxnTlvData.objTLV[i].uiTag) {
                retIndex = i;
                tag = GlobalData.singleton.m_sTxnTlvData.objTLV[i].uiTag;
                break;
            }
            if (0x1021 == GlobalData.singleton.m_sTxnTlvData.objTLV[i].uiTag) {
                tag = GlobalData.singleton.m_sTxnTlvData.objTLV[i].uiTag;
                retIndex = i;
                break;
            }
        }
        return retIndex;
    }
    
    // MARK:- AddAmountFromXmlinTlV
    internal func AddAmountFromXmlinTlV() {
        if (GlobalData.singleton.m_sTxnTlvData.iTLVindex >= 0){
            GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex].chArrTagVal = [Byte](repeating: 0, count: AppConstant.MAX_TXN_TLV_DATA_LEN)
            let amtTag = 0x1021;
            var amtLen = 0;
            if (m_chArrAmount != nil) {
                amtLen = m_chArrAmount.count;
            }
            
            if ((amtLen > 0)) {
                var iTLVindex = 0;
                var bIsAmountAlreadyPresent = false;
                iTLVindex = IsAmountAlreadyPresent();
                if (0 == iTLVindex) {
                    iTLVindex = GlobalData.singleton.m_sTxnTlvData.iTLVindex;
                } else {
                    bIsAmountAlreadyPresent = true;
                }
                
                if (GlobalData.singleton.m_sTxnTlvData.iTLVindex < AppConstant.MAX_TXN_STEPS_WITH_TLV_DATA) {
                    if (!bIsAmountAlreadyPresent) {
                        GlobalData.singleton.m_sTxnTlvData.objTLV[iTLVindex].uiTag = amtTag;
                        GlobalData.singleton.m_sTxnTlvData.objTLV[iTLVindex].uiTagValLen = amtLen;
                        GlobalData.singleton.m_sTxnTlvData.objTLV[iTLVindex].chArrTagVal = [Byte](repeating: 0, count: amtLen);
                        var m_chArrAmountValue = m_chArrAmount.bytes
                        m_chArrAmountValue[0...amtLen] = GlobalData.singleton.m_sTxnTlvData.objTLV[iTLVindex].chArrTagVal[0...amtLen]
                        GlobalData.singleton.m_sTxnTlvData.iTLVindex = GlobalData.singleton.m_sTxnTlvData.iTLVindex+1 ;
                    } else {
                        GlobalData.singleton.m_sTxnTlvData.objTLV[iTLVindex].uiTagValLen = amtLen;//To fix the issue related reward and dcc
                        GlobalData.singleton.m_sTxnTlvData.objTLV[iTLVindex].chArrTagVal =  [Byte](repeating: 0, count: amtLen);
                        var m_chArrAmountValue = m_chArrAmount.bytes
                        m_chArrAmountValue[0...amtLen] = GlobalData.singleton.m_sTxnTlvData.objTLV[iTLVindex].chArrTagVal[0...amtLen]
                    }
                }
            }
        }
    }
    
    // MARK:- SetCurrencyCodeInEMVModule
    internal func SetCurrencyCodeInEMVModule() {
        var iCurrencyCodeLen = 0;
        if (m_chArrCurrencyCode != nil) {
            iCurrencyCodeLen = m_chArrCurrencyCode.count;
        }
        if (m_bIsCurrencyCodeUsingXMl && iCurrencyCodeLen > 0) {
        }
    }
    
    // MARK:- getName
    public func getName() -> String {
        return iName;
    }
    
    // MARK:- getNameImage
    public func  getNameImage() -> String  {
        return iNameImage;
    }
    
    // MARK:- getNumChild
    public func getNumChild() -> Int  {
        return self.numberOfChild;
        
    }
    
    // MARK:- getNodeType
    public func getNodeType() -> Int  {
        return node_type;
    }
    
    // MARK:- getExecutionResult
    public func getExecutionResult(iResult:Int) -> Int {
        var m_iRetVal = 0;
        if (iResult == CStateMachine.GO) {
            m_iRetVal = ExecutionResult._OK;
        } else if (iResult == CStateMachine.CANCEL) {
            m_iRetVal = ExecutionResult._CANCEL;
        } else if (iResult == CStateMachine.TIME_OUT) {
            m_iRetVal = ExecutionResult._TIMEOUT;
        } else if (iResult == CStateMachine.BACK_PRESSED) {
            m_iRetVal = ExecutionResult._EXIT;
        } else {
            m_iRetVal = ExecutionResult._EXIT;
        }
        return m_iRetVal;
    }
    
    func execute(){}
    func AddPrivateParameters(tagAttribute:XMLATTRIBUTE,nTotal:Int) -> Int {
        return 0
    }
    func prepareTimer(time:Int) {}
    func startTimer() {}
    func cancelTimer() {}
    func onExecuted() {}
    
    // MARK:- reset
    public func reset() {
        iBuffer = nil;
        iResult = -1;
        iPos = -1;
    }
}
