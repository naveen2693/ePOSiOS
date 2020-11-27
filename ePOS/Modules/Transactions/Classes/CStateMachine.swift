//
//  CStateMachine.swift
//  XMLParser
//
//  Created by Abhishek on 05/11/20.
//  Copyright © 2020 WG. All rights reserved.
//

import Foundation
public class CStateMachine {
//    //Take context for use --- Test code
//
//    static Activity m_context_activity = null;
//    public static int CONNECTION_TYPE = ConnectionTypes.DIALUP_WIFI;
//
//    private static final int MAX_MINIPVM_COUNT = 5;
//    private static final int MAX_PAN_LEN = 128;
//    private static final int MAX_SERVICE_CODE_LEN = 10;
//
//    private static final int ADMIN_USER_INDEX = 2;
//    private static CStateMachine Singleton = null;        //Class instance
//    private boolean m_bIsPVMLoaded;                    //Check for Is PVM loaded
//    public CBaseNode gRootNode;                        //Variable to store root node
//    public CBaseNode parentNode;                        //Variable to store root node
    static var currentNode:CBaseNode?;
    static var REQUEST_CODE = 2;
     var m_bIS_TLE_TXN = false;
    static var CANCEL = -1;
    static var BACK_PRESSED = -1;
    var gRootNode:CBaseNode?;
    static var GO = 1;
    static var TIME_OUT = 0;
//    private CBaseNode gTestPVMRootNode;                //Variable to store test root node
//
//    public CBaseNode gMainPVMRootNodeForCache = null;
//
//    private CBaseNode[] gMiniPvmNode = new CBaseNode[MAX_MINIPVM_COUNT];    //variable to store miniPVM root Node
//
//    public boolean bRunMiniPVm;                        //flag to differentiate miniPVM execution
//    public int m_iMiniPVMCounter;
//
//    private boolean bLocalPVM;                        //flag to differentiate TEST PVM execution
//    private boolean bTestLocalMiniPVM;                //flag to differentiate TEST MINIPVM
//    private boolean m_bMiniPVMexecutionOK;            //flag to store miniPVM execution
//    public boolean m_bMiniPVMexecutionCompleted;   //flag to store miniPVM execution
//    public boolean m_bMiniPvmExecute;
//
//    public boolean m_ResetTerminal;                //Flag which prompt user to reboot device
//    //    public boolean             m_bCHIP_INPUT;
//    //     public boolean             m_bCLESS_INPUT;                    // Sunder S: Added for CLESS EMV: 17-05-2015
//    public boolean m_bIS_TLE_TXN;                  //FLAG to be used for EMV transaction TLE Enabled mode
//    public static boolean m_bIsInterruptedByBackgroundThread;
//    public static boolean m_ApplicationBusy;
//
//    public byte[] m_chTxnPAN = new byte[MAX_PAN_LEN];
//    public byte[] m_chTxnServiceCode = new byte[MAX_SERVICE_CODE_LEN];
//
//    public boolean g_DissconnectFromMenu;
//    public static int REQUEST_CODE = 2;
//    public static int CANCEL = -1;
//    public static int BACK_PRESSED = -1;
//    public static int GO = 1;
//    public static int TIME_OUT = 0;
//
//    //Content Server Changes Starts
//    static private File m_fSerialImageVersionFile = null;
//    static private File m_urlFile = null;
//    static private File m_upload_urlFile = null;
//    static private File m_contentSyncPermFile = null;
//    //Content Server Changes Ends
//
//    public CBaseNode cascadingParentNode;
//    public boolean isCascadingParentNode = false;
//    //    public  static String oldMiImagValue;
//    public PlutusRemoteAppHandler.OnActivityResultCallback resultCallback;
//
//    /*------------------Transaction History-------------------*/
//    public String origBatchId;
//    public String origRoc;
//    public boolean isResendLink;
//    private CGlobalData cGlobalData;
//
    private static var _shared: CStateMachine?
    public static var stateMachine: CStateMachine {
            get {
                if _shared == nil {
                    DispatchQueue.global().sync(flags: .barrier) {
                        if _shared == nil {
                            _shared = CStateMachine()
                        }
                    }
                }
                return _shared!
            }
        }


//
//    public CStateMachine() {
//        if (Singleton != null) {
//            CStateMachine StateMachine = CStateMachine.GetInstance();
//            cGlobalData = CGlobalData.GetInstance();
//            m_bIsPVMLoaded = StateMachine.m_bIsPVMLoaded;
//            gRootNode = StateMachine.gRootNode;
//            gTestPVMRootNode = StateMachine.gTestPVMRootNode;
//            bRunMiniPVm = StateMachine.bRunMiniPVm;
//            bLocalPVM = StateMachine.bLocalPVM;
//            ;
//            bTestLocalMiniPVM = StateMachine.bTestLocalMiniPVM;
//            m_bMiniPVMexecutionOK = StateMachine.m_bMiniPVMexecutionOK;
//            m_bMiniPVMexecutionCompleted = StateMachine.m_bMiniPVMexecutionCompleted;
//            m_ResetTerminal = StateMachine.m_ResetTerminal;
////            m_bCHIP_INPUT = StateMachine.m_bCHIP_INPUT;
////            m_bCLESS_INPUT = StateMachine.m_bCLESS_INPUT;        // Sunder S: Added for CLESS EMV: 17-05-2015
//            m_bIS_TLE_TXN = StateMachine.m_bIS_TLE_TXN;
//            m_bIsInterruptedByBackgroundThread = StateMachine.m_bIsInterruptedByBackgroundThread;
//            m_ApplicationBusy = StateMachine.m_ApplicationBusy;
//            m_iMiniPVMCounter = StateMachine.m_iMiniPVMCounter;
//            m_bMiniPvmExecute = StateMachine.m_bMiniPvmExecute;
//
//            for (int i = 0; i < MAX_MINIPVM_COUNT; i++) {
//                gMiniPvmNode[i] = StateMachine.gMiniPvmNode[i];
//            }
//            g_DissconnectFromMenu = StateMachine.g_DissconnectFromMenu;
//        } else {
//            cGlobalData = CGlobalData.GetInstance();
//            cGlobalData.deviceState = S_INITIAL;
//            m_bIsPVMLoaded = false;
//            gRootNode = null;
//            gTestPVMRootNode = null;
//            bRunMiniPVm = false;
//            bLocalPVM = false;
//            bTestLocalMiniPVM = false;
//            m_bMiniPVMexecutionOK = false;
//            m_bMiniPVMexecutionCompleted = false;
//            m_ResetTerminal = false;
////            m_bCHIP_INPUT = false;
////            m_bCLESS_INPUT = false;        // Sunder S: Added for CLESS EMV: 17-05-2015
//            m_bIS_TLE_TXN = false;
//            m_bIsInterruptedByBackgroundThread = false;
//            m_ApplicationBusy = false;
//            m_iMiniPVMCounter = 0;
//            m_bMiniPvmExecute = false;
////    {
//            for (int i = 0; i < MAX_MINIPVM_COUNT; i++) {
//                gMiniPvmNode[i] = null;
//            }
//            g_DissconnectFromMenu = false;
//        }
//    }
//
//    public static CStateMachine GetInstance() {
//        if (null == Singleton) {
//            Singleton = new CStateMachine();
//        }
//        return Singleton;
//    }
//
//
     func SetRootNode(currentNode:CBaseNode) {
         gRootNode = currentNode
         if let rootNode = gRootNode{
         gRootNode?.AddParent(rootNode)
        }
    }

    func GetRootNode() ->CBaseNode? {
        return gRootNode;
    }
//
//    int RunMiniPvm() {
//        int retVal = 0;
//        gRootNode = null;
//        CStateMachine.GetInstance().cascadingParentNode = null;
//        CStateMachine.GetInstance().isCascadingParentNode = false;
//        bRunMiniPVm = true;
//        m_iMiniPVMCounter++;
//        try {
//            LoadPVM(0);
//            CStateMachine.currentNode = gRootNode;
//            if (gRootNode != null) {
//                m_bMiniPVMexecutionOK = false;
//                m_bMiniPVMexecutionCompleted = false;
//                return 1;
//            } else {
//                return 0;
//            }
//
////            while (runningNode != null) {
////                if (runningNode != null) {
////                    CLogger.TraceLog(TRACE_DEBUG, "Before minirun Node NodeType[%d]", runningNode.node_type);
////                } else {
////                    CLogger.TraceLog(TRACE_DEBUG, "Before minirun Node NodeType is NULL");
////                }
////
////                CStateMachine.currentNode = runningNode;
////
////                if (CStateMachine.currentNode != null && CStateMachine.currentNode.getClass() == CDisplayEventReceived.class) {
////                    CStateMachine.currentNode = CStateMachine.currentNode.run();
////                }
////                else if (CStateMachine.currentNode != null && CStateMachine.currentNode.getClass() == CDisplayMenuItem.class) {
////                    CStateMachine.currentNode = CStateMachine.currentNode.run();
////                }
////                else if (CStateMachine.currentNode != null) {
////                    retVal=1;
////                    break;
////                }
////                runningNode = CStateMachine.currentNode;
////
////                if (runningNode != null) {
////                    CLogger.TraceLog(TRACE_DEBUG, "After minirun Node NodeType[%d]", runningNode.node_type);
////                } else {
////                    CLogger.TraceLog(TRACE_DEBUG, "After minirun Node NodeType is NULL");
////                }
////            }
//        } catch (Exception ex) {
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(ex));
//        }
//        return retVal;
//    }
//
//
//    public int TestConnection(int iSelectionResult) {
//
//        int retrnVal = RetVal.RET_NOT_OK;
//        CGlobalData GlobalData = CGlobalData.GetInstance();
//        CConx conx = CConx.GetInstance();
//
//        int iHostID = DEFAULT_HOSTID;
//
//        if (cGlobalData.deviceState == S_INITIAL) {
//            GlobalData.m_sMasterParamData.totalCTids = 0;
//            GlobalData.m_sMasterParamData.totalImageIds = 0;
//        }
//
//        // check for active connections
//        if (GlobalData.GetActiveConnections(iHostID) == 0) {
//            CGlobalData.csFinalMsgTestConnection = "Connection Not Active";
//            return RetVal.RET_NOT_OK;
//        }
//
//        boolean bRetTestConnection = false;
//        switch (iSelectionResult) {
//            case 0:
//                bRetTestConnection = conx.TestConnections(AppConst.SERIAL_LINK, iHostID);
//                break;
//            case 1:
//                bRetTestConnection = conx.TestConnections(GlobalData.m_sConxData.m_bArrConnIndex.CON_SerialIp.index, iHostID);
//                break;
//            case 2:
//                bRetTestConnection = TestPosPrinting();
//                break;
//            case 3:
//                bRetTestConnection = TestPrintLinuxPOS();
//                break;
//            case 4:
//                bRetTestConnection = conx.TestConnections(GlobalData.m_sConxData.m_bArrConnIndex.CON_GPRS.index, iHostID);
//                break;
//            case 5:
//                bRetTestConnection = conx.TestConnections(GlobalData.m_sConxData.m_bArrConnIndex.CON_ETHERNET.index, iHostID);
//                break;
//            case 6:
//                bRetTestConnection = conx.TestConnections(GlobalData.m_sConxData.m_bArrConnIndex.CON_WIFI.index, iHostID);
//                break;
//            default:
//                break;
//        }
//
//        if (bRetTestConnection) {
//            retrnVal = RET_OK;
//        } else {
//            retrnVal = RetVal.RET_NOT_OK;
//        }
//        return retrnVal;
//    }
//
//    public int ActivateApplication(int iHostID, Context m_context) {
//        int retVal = RET_OK;
//        CIsoProcessor isopr = new CIsoProcessor();
//
//        isopr.SetCommunicationParam(true, iHostID);
//
//        int iRetVal = FALSE;
//        if (iHostID == AppConst.DEFAULT_HOSTID) {
//            iRetVal = isopr.DoHUBActivation(iHostID, m_context);
//        }
//
//        if (TRUE != iRetVal)// change for review comments
//        {
//            retVal = RetVal.RET_NOT_OK;
//        }
//
//        return retVal;
//    }
//
//
//    public int InitializeApplication(boolean disconnectFlag, int iHostID, Context context) {
//        int retVal = RET_OK;
//        CIsoProcessor isopr = new CIsoProcessor();
//
//        CGlobalData GlobalData = CGlobalData.GetInstance();
//        GlobalData.UpdateMasterCTFile();
//        GlobalData.UpdateMasterIMFile();
//        GlobalData.UpdateMasterCLRDIMFile();
//        GlobalData.UpdateMasterFCGFile();
//        GlobalData.UpdateMasterFONTFile();
//        GlobalData.UpdateMasterLIBFile();
//        GlobalData.UpdateMasterMINIPVMFile();
//
//        isopr.SetCommunicationParam(disconnectFlag, iHostID);
//
//        int iInitResponse = RetVal.RET_NOT_OK;
//        if (AppConst.DEFAULT_HOSTID == iHostID) {
//            CLogger.TraceLog(TRACE_DEBUG, "before DoHUBInitialization");
//            iInitResponse = isopr.DoHUBInitialization(iHostID, context);
//        }
//
//        if (iInitResponse == RET_OK) {
//            if (!CConx.isSerial()) {
//                ContentServerParamData t_contentServerParamData = CGlobalData.ReadContentServerParamFile();
//                if (t_contentServerParamData != null) {
//                    if (t_contentServerParamData.m_bIsContentSyncEnabled) {
//                        ContentServer contentServer = ContentServer.GetInstance();
//                        CGlobalData.updateCustomProgressDialog("Content Server Content Sync !!");
//                        if (!contentServer.DoSecureContentServerSync()) {
//                            CGlobalData.m_csFinalMsgDoHubInitialization = "Content Server Sync Failed!!!";
//                            CGlobalData.updateCustomProgressDialog("Content Server  Sync Failed");
//                            try {
//                                //Thread.sleep(5);
//                            } catch (Exception e) {
//                                CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(e));
//                            }
//                            //iInitResponse = RetVal.RET_NOT_OK;
//                        }
//                        contentServer.m_bsync_finished = false;
//                    }
//                }
//            }
//        }
//
//        switch (iInitResponse) {
//            case RET_OK:
//                retVal = RET_OK;
//                break;
//            case RET_CONX_FAILED:
//                retVal = RetVal.RET_CONX_FAILED;
//                break;
//            default:
//                retVal = RetVal.RET_NOT_OK;
//                break;
//        }
//
//        //Update master CT file and master IM
//        //CUIHelper.SetMessage("PROCESSING");
//        GlobalData.UpdateMessageFile();
//        GlobalData.UpdateMasterCTFile();
//        GlobalData.UpdateMasterIMFile();
//        GlobalData.UpdateMasterCLRDIMFile();
//        GlobalData.UpdateMasterFCGFile();
//        GlobalData.UpdateMasterFONTFile();
//        GlobalData.UpdateMasterLIBFile();
//        GlobalData.UpdateMasterMINIPVMFile();
//
//        return retVal;
//    }
//
//    public void GoOnline(int iHostID, Context m_context) {
//        CGlobalData objGlobalData = CGlobalData.GetInstance();
//        if (!objGlobalData.IsTxnAllowed(AppConst.DEFAULT_HOSTID)) {
//            CGlobalData.m_csFinalMsgDoHubOnlineTxn = "BATCH SIZE FULL\n Please settle this batch";
//            //TransactionHUB.getInstance().sendMessage(REQUEST_FOR_SHOW_DIALOG,-1,-1,CGlobalData.m_csFinalMsgDoHubOnlineTxn);
//            TransactionHUB.getInstance().finishTransactionHubActivity(CGlobalData.m_csFinalMsgDoHubOnlineTxn);
//            return;
//        } else {
//            new BackGroundGoOnline(m_context).execute();
//        }
//    }
//
//
//    public void remoteBackgroundGetStatus(int iHostID) {
//        //after Do Online processed
//        CGlobalData objGlobalData = CGlobalData.GetInstance();
//        if (!objGlobalData.IsTxnAllowed(AppConst.DEFAULT_HOSTID)) {
//            CGlobalData.m_csFinalMsgDoHubOnlineTxn = "BATCH SIZE FULL\n Please settle this batch";
//            //TOdo callback with error
//            return;
//        } else {
//            CIsoProcessor isopr = new CIsoProcessor();
//            TransactionHUB.getInstance().m_isoProcessor = isopr;
//
//            int iRes = isopr.SetCommunicationParam(true, DEFAULT_HOSTID);
//            int status;
//            status = isopr.DoHubOnlineTxn(DEFAULT_HOSTID);
//            //reset Pay by mobile related flag when dialog hides
//            CGlobalData.GetInstance().isPayByMobileEnabled = false;
//            if (status == 1) {
//                CGlobalData.m_bIsDoHubOnlineTxnSuccessfullyRun = true;
//                System.out.println("Online Transaction successfully run");
//            } else {
//                CGlobalData.m_bIsDoHubOnlineTxnSuccessfullyRun = false;
//                System.out.println("Online Transaction Failed");
//            }
//
//
//            CGlobalData globalData = CGlobalData.GetInstance();
//            if (CGlobalData.IsMiniPVMPresent) {
//                /*if(AppConst.FALSE  == RunMiniPvm()) {
//                    CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "RunMiniPvm Failed:ONLINE_REQUEST_TXN_ERR_TERMINATED");
//                    CGlobalData.IsMiniPVMPresent = false;
//                    //TransactionHUB.getInstance().sendMessage(REQUEST_FOR_SHOW_DIALOG,-1,-1,AppConst.TRANSACTION_DECLINED_MESSAGE);
//                    TransactionHUB.getInstance().finishTransactionHubActivity(AppConst.TRANSACTION_DECLINED_MESSAGE);
//                } else {
//                    transactionHUB.goToNode(CStateMachine.currentNode);
//                }*/
//                //Todo minipvm can not process right now
//            } else {
//                CStateMachine.m_ApplicationBusy = false;
//                if (CGlobalData.m_bIsDoHubOnlineTxnSuccessfullyRun) {
//                    boolean sendCallback = true;
//                    if (!CGlobalData.m_bIsTxnDeclined && !CGlobalData.m_bIsFiled58Absent) {
//                        if (globalData.m_bIsToCaptureSignature && (!globalData.m_bIsOnlinePinRequired) && (!globalData.m_bIsSignAsked)) {
//                            globalData.m_bIsSignAsked = true;
//                            sendCallback = false;
//                        }
//                    }
//
//                    if (sendCallback) {
//                        int iResponseCode = TransactionUtils.getResponseCode(globalData.iRequestCode);
//                        byte[] CSVResponse = TransactionUtils.fillCSVResponse(globalData.iRequestCode, iResponseCode);
//                        ThirdPartyAppSession.destroyInstance();
//                        Bundle data = new Bundle();
//                        data.putByteArray("RESPONSE_TEXT", CSVResponse);
//                        Intent intent = new Intent();
//                        intent.putExtras(data);
//                        if (CStateMachine.GetInstance().resultCallback != null) {
//                            CStateMachine.GetInstance().resultCallback.dataHandler(iResponseCode, intent);
//                        }
//                    }
//                }else {
//                    int iResponseCode = TransactionUtils.getResponseCode(globalData.iRequestCode);
//                    if (CStateMachine.GetInstance().resultCallback != null) {
//                        CStateMachine.GetInstance().resultCallback.dataHandler(iResponseCode, null);
//                    }
//                }
//
//                CGlobalData.bIsToCaptureSign = true;
//                CGlobalData.m_bIsOnlinePinRequired = false;
//                //EMV data reset for mini PVM
//                CGlobalData GlobalData = CGlobalData.GetInstance();
//                CCLessModule emvintsance1 = CCLessModule.GetInstance();
//                GlobalData.m_sEMVDATA = null;
//                emvintsance1 = null;
//            }
//        }
//    }
//
//
//    public class BackGroundGoOnline extends AsyncTask<String, String, Integer> {
//        UIutils uIutils;
//        Context m_context;
//
//        public BackGroundGoOnline(Context m_context) {
//            this.m_context = m_context;
//        }
//
//        @Override
//        protected void onPreExecute() {
//            super.onPreExecute();
////            MainActivity.progressDialog.show();
//            uIutils = UIutils.getInstance();
//            if (CGlobalData.GetInstance().isPayByMobileEnabled) {
//                MainActivity.customProgressDialog = uIutils.showCustomProgressDialog(TransactionHUB.getInstance().getContext(), "Pay by Mobile App");
//            } else {
//                MainActivity.customProgressDialog = uIutils.showCustomProgressDialog(TransactionHUB.getInstance().getContext(), "Going Online");
//            }
//            MainActivity.customProgressDialog.setCancelable(false);
//        }
//
//        @Override
//        protected Integer doInBackground(String... params) {
//            CIsoProcessor isopr;
//            if (TransactionHUB.getInstance().m_isoProcessor != null) {
//                isopr = TransactionHUB.getInstance().m_isoProcessor;
//            } else {
//                isopr = new CIsoProcessor();
//                TransactionHUB.getInstance().m_isoProcessor = isopr;
//            }
//            int iRes = isopr.SetCommunicationParam(true, DEFAULT_HOSTID);
//            int status = 0;
//            status = isopr.DoHubOnlineTxn(DEFAULT_HOSTID);
//            //reset Pay by mobile related flag when dialog hides
//            CGlobalData.GetInstance().isPayByMobileEnabled = false;
//
//            if (status == 1) {
//                CGlobalData.m_bIsDoHubOnlineTxnSuccessfullyRun = true;
//                System.out.println("Online Transaction successfully run");
//            } else {
//                CGlobalData.m_bIsDoHubOnlineTxnSuccessfullyRun = false;
//                System.out.println("Online Transaction Failed");
//            }
//            return status;
//        }
//
//        @Override
//        protected void onPostExecute(Integer status) {
//            super.onPostExecute(status);
////            MainActivity.progressDialog.dismiss();
//            uIutils.hideCustomProgressDialog(MainActivity.customProgressDialog);
//            TransactionHUB transactionHUB = TransactionHUB.getInstance();
//            CGlobalData globalData = CGlobalData.GetInstance();
//
//            if (CGlobalData.IsMiniPVMPresent) {
//                if (AppConst.FALSE == RunMiniPvm()) {
//                    CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "RunMiniPvm Failed:ONLINE_REQUEST_TXN_ERR_TERMINATED");
//                    CGlobalData.IsMiniPVMPresent = false;
//                    //TransactionHUB.getInstance().sendMessage(REQUEST_FOR_SHOW_DIALOG,-1,-1,AppConst.TRANSACTION_DECLINED_MESSAGE);
//                    TransactionHUB.getInstance().finishTransactionHubActivity(AppConst.TRANSACTION_DECLINED_MESSAGE);
//                } else {
//                    transactionHUB.goToNode(CStateMachine.currentNode);
//                }
//            } else {
//                CStateMachine.m_ApplicationBusy = false;
//                if (!CGlobalData.m_bIsTxnDeclined && !CGlobalData.m_bIsFiled58Absent && CGlobalData.m_bIsDoHubOnlineTxnSuccessfullyRun) {
//                    if (globalData.m_bIsToCaptureSignature && (!globalData.m_bIsOnlinePinRequired) && (!globalData.m_bIsSignAsked)) {
//                        Intent intent = new Intent(PlutusApplication.getContext(), CSignatureCapture.class);
//                        MainActivity.m_context.startActivity(intent);
//                        globalData.m_bIsSignAsked = true;
//                    } else {
//                        //if(!globalData.isPayByQRCodeEnabled) {
//                        TransactionHUB.getInstance().sendMessage(REQUEST_FOR_PRINT_SLIP, globalData.m_iPrintLen, -1, globalData.m_bPrinterData);//in this case iresult is for length og printing data
//                        //}
//                    }
//                } else {
//                    //CUIHelper.ShowCustomDialog(CGlobalData.m_csFinalMsgDoHubOnlineTxn, m_context);
//                    if (status == 1) {
//                        //successful online transaction
//                        //check CSV received or not
//                        if (globalData.m_ptrCSVDATA.bCSVreceived) {
//                            TransactionHUB.getInstance().sendMessage(REQUEST_FOR_PRINT_SLIP, globalData.m_iPrintLen, -1, globalData.m_bPrinterData);//in this case iresult is for length og printing data
//                        } else {
//                            TransactionHUB.getInstance().finishTransactionHubActivity(CGlobalData.m_csFinalMsgDoHubOnlineTxn);
//                        }
//                    } else {
//                        TransactionHUB.getInstance().finishTransactionHubActivity(CGlobalData.m_csFinalMsgDoHubOnlineTxn);
//                    }
//                }
//                //TODO start changed as per plutus for qrcode Bug 88053
//                if (QRCodeActivity.m_context != null) {
//                    ((Activity) QRCodeActivity.m_context).finish();
//                    QRCodeActivity.m_context = null;
//                }
//                //TODO end
//                CGlobalData.bIsToCaptureSign = true;
//                CGlobalData.m_bIsOnlinePinRequired = false;
//                //EMV data reset for mini PVM
//                CGlobalData GlobalData = CGlobalData.GetInstance();
//                CCLessModule emvintsance1 = CCLessModule.GetInstance();
//                GlobalData.m_sEMVDATA = null;
//                emvintsance1 = null;
//            }
//        }
//    }
//
//
//    public int DoBatchSettlement(int iHostID, boolean disconnectFlag, Context m_context) {
//        CLogger.TraceLog(TRACE_DEBUG, "Inside DoBatchSettlement");
//        int retVal = RET_OK;
//        CGlobalData GlobalData = CGlobalData.GetInstance();
//
//        GlobalData.SetSSLMode(true);
//        if (GlobalData.GetActiveConnections(iHostID) == 0) {
//            CGlobalData.m_csFinalMsgBatchSettlement = "No Connection Active!";
//            return RetVal.RET_NOT_OK;
//        }
//
//        retVal = SettleBatch(disconnectFlag, iHostID, m_context);
//        CLogger.TraceLog(TRACE_DEBUG, "SettleBatch retVal[%d]", retVal);
//
//        if (RET_OK == retVal) {
//            TerminalParamData m_sParamData;
//            m_sParamData = GlobalData.ReadParamFile(iHostID);
//            if (BATCH_EMPTY != m_sParamData.m_iBatchState) {
//                CLogger.TraceLog(TRACE_DEBUG, "Batch Settled");
//            }
//        }
//        return retVal;
//    }
//
//
//    int SettleBatch(boolean disconnectFlag, int iHostID, Context m_context) {
//        try {
//            int retVal = RetVal.RET_NOT_OK;
//            CIsoProcessor isopr = new CIsoProcessor();
//
//            isopr.SetCommunicationParam(disconnectFlag, iHostID);
//
//            int iSettlementResponse = 0;
//            if (iHostID == AppConst.DEFAULT_HOSTID) {
//                iSettlementResponse = isopr.DoHubSettlement(iHostID, m_context);
//                CLogger.TraceLog(TRACE_DEBUG, "iSettlementResponse[%d]", iSettlementResponse);
//            }
//
//            CGlobalData.m_bIsSettleBatchSuccessfullyRun = false;
//            if (iSettlementResponse == TRUE) {
//                CGlobalData.m_bIsSettleBatchSuccessfullyRun = true;
//                retVal = RET_OK;
//            } else {
//                CGlobalData.m_bIsSettleBatchSuccessfullyRun = false;
//                retVal = RetVal.RET_NOT_OK;
//            }
//            return retVal;
//        } catch (Exception ex) {
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(ex));
//            return RetVal.RET_NOT_OK;
//        }
//    }
//
//    public void LoadPVM(long ulMiniPVMID) {
//        CLogger.TraceLog(TRACE_DEBUG, "bRunMiniPVm[%s], bTestLocalMiniPVM[%s]", bRunMiniPVm, bTestLocalMiniPVM);
//
//        if (bRunMiniPVm && bTestLocalMiniPVM) {
//            //CPlatformUtils.LoadLocalMiniPVM();
//            bTestLocalMiniPVM = false;
//        } else {
//            if (ulMiniPVMID > 0) {
//                //CPlatformUtils.LoadPVM(bRunMiniPVm, ulMiniPVMID);
//            } else {
//                LoadPVM(bRunMiniPVm, 0);
//            }
//        }
//    }
//
//    public void LoadPVM(boolean isMiniPVm, long ulMiniPVMID) {
//        InputStream inputFile = null;
//        try {
//            if (isMiniPVm) {
//                byte[] bArrMiniPvm = CFileSystem.ReadByteFile(PlutusApplication.getContext(), AppConst.MINIPVM);
//                String strMiniPVMData = new String(bArrMiniPvm);
//                strMiniPVMData = strMiniPVMData.trim();
//                String strMiniPVM = strMiniPVMData.replaceAll("&", "&amp;");
//                inputFile = new ByteArrayInputStream(strMiniPVM.getBytes());
//            } else {
//                byte[] bPVMData = CFileSystem.ReadByteFile(PlutusApplication.getContext(), AppConst.PVMFILE);
//                if (bPVMData != null) {
//                    String strPVMData = new String(bPVMData);
//                    String strPVM = strPVMData.trim().replaceAll("&", "&amp;");
//                    inputFile = new ByteArrayInputStream(strPVM.getBytes());
//                } else {
//                    inputFile = MainActivity.m_context.getAssets().open("newXML.xml");
//                }
//            }
//        } catch (Exception e) {
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(e));
//        }
//        XmlParser.ParsePvm(inputFile, 1);
//    }
//
//    public void UpdateState(int state, Context context) {
//        String strState = String.valueOf(state);
//        CFileSystem.WriteToFile(context, AppConst.DEVICE_STATE, strState);
//    }
//
//    public int GetState() {
//        if (true == CFileSystem.IsFileExist(m_context, DEVICE_STATE)) {
//            String strState = CFileSystem.ReadFromFile(m_context, DEVICE_STATE);
//            cGlobalData.deviceState = Integer.parseInt(strState);
//        } else {
//            cGlobalData.deviceState = S_INITIAL;
//        }
//        return cGlobalData.deviceState;
//    }
//
//    public void ApplicationFirstInitialization(Context context) {
//        CGlobalData GlobalData = CGlobalData.GetInstance();
//        CGlobalData.m_context = context;
//        CStateMachine.m_context = context;
//        MainActivity.m_context = context;
//        if (!CGlobalData.isApplicationFirstInitialized) {
//            //Initialize Global variables
//            GlobalData.FirstInitialize(context);
//            GlobalData.InitializeFromDatabase(AppConst.DEFAULT_HOSTID, context);//Default Host id
//            CGlobalData.isApplicationFirstInitialized = true;
//            MainActivityFxnsMovedInsideBase();
//        }
//    }
//
//    public void ApplicationFirstInitialization(Activity activity) {
//        CGlobalData.m_context = activity.getApplicationContext();
//        CStateMachine.m_context = activity.getApplicationContext();
//        CStateMachine.m_context_activity = activity;
//        MainActivity.m_context = activity.getApplicationContext();
//        CGlobalData GlobalData = CGlobalData.GetInstance();
//        if (!CGlobalData.isApplicationFirstInitialized) {
//            //Initialize Global variables
//            GlobalData.FirstInitialize(activity);
//            GlobalData.InitializeFromDatabase(AppConst.DEFAULT_HOSTID, activity);//Default Host id
//            CGlobalData.isApplicationFirstInitialized = true;
//            MainActivityFxnsMovedInsideBase();
//        }
//    }
//
//    public void MainActivityFxnsMovedInsideBase() {
//        CSecureLib.SaveRootKey();
//        CFileSystem.CreateExternalDirectory();
//        CStateMachine.CreateContentSyncFolders();
//        CGlobalData.createContentParamDataFile();
//    }
//
//
//    /**
//     * ClearReversal
//     *
//     * @return
//     * @details Clear Reversal Flag for current transaction
//     */
//    int ClearReversal(int iHostID) {
//
//        CLogger.TraceLog(TRACE_DEBUG, "ClearReversal");
//        CGlobalData GlobalData = CGlobalData.GetInstance();
//        TerminalTransactionData nsLastTxnData = new TerminalTransactionData();
//
//        nsLastTxnData = GlobalData.ReadLastTxnEntry(iHostID);
//
//        if (nsLastTxnData == null) {
//            return AppConst.FALSE;
//        } else {
//            CLogger.TraceLog(TRACE_DEBUG, "LAST TXN  ROC = %d BatchID =%d bIsReversalPending =%d",
//                    nsLastTxnData.ulROC, nsLastTxnData.ulBatchId, nsLastTxnData.bIsReversalPending);
//
//            nsLastTxnData.bIsReversalPending = false/*FALSE*/;
//            GlobalData.UpDateLastTxnEntry(nsLastTxnData, iHostID);
//
//            CLogger.TraceLog(TRACE_DEBUG, "UPDATED TXN  ROC = %d BatchID =%d bIsReversalPending =%d",
//                    nsLastTxnData.ulROC, nsLastTxnData.ulBatchId, nsLastTxnData.bIsReversalPending);
//
//            return AppConst.TRUE;
//        }
//    }
//
//    static int ProcessPrintDump(String DumpFileName) {
//        return AppConst.TRUE;
//    }
//
//    public int PADControllerPrintDump(String DumpFileName) {
//        CLogger.TraceLog(TRACE_DEBUG, "PADControllerPrintDump");
//        if (CFileSystem.IsFileExist(PlutusApplication.getContext(), DumpFileName)) {
//            CLogger.TraceLog(TRACE_DEBUG, "Found PAD Print dump file: %s", DumpFileName);
//            byte[] bArrDataToPrint = CFileSystem.ReadByteFile(PlutusApplication.getContext(), DumpFileName);
//
//            CCSVTxnOverPadController ccsvHandler = new CCSVTxnOverPadController();
//            return ccsvHandler.sendReceivePrintDump(bArrDataToPrint, bArrDataToPrint.length, (byte) 0x01);
//        }
//        return AppConst.TRUE;
//    }
//
//    boolean TestPosPrinting() {
//        try {
//            CLogger.TraceLog(TRACE_DEBUG, "TestPosPrinting");
//            boolean retVal = false;
//            CCSVTxnOverPadController objSerial = new CCSVTxnOverPadController();
//            retVal = objSerial.sendReceiveTestPrint();
//            if (retVal == true) {
//                CGlobalData.csFinalMsgTestConnection = "Test Connection Success";
//            } else {
//                CGlobalData.csFinalMsgTestConnection = "Test Connection Failed";
//            }
//            CLogger.TraceLog(TRACE_DEBUG, "retVal[%d]", retVal);
//            return retVal;
//        } catch (Exception ex) {
//            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(ex));
//            return false;
//        }
//
//    }
//
//    boolean TestPrintLinuxPOS() {
//
//        CLogger.TraceLog(TRACE_DEBUG, "TestPrintLinuxPOS");
//        boolean retVal = false;
//        CCSVTxnOverPadController objSerial = new CCSVTxnOverPadController();
//        retVal = objSerial.sendReceiveTestPrintLinux();
//
//        CLogger.TraceLog(TRACE_DEBUG, "retVal[%d]", retVal);
//        if (true == retVal) {
//            CGlobalData.m_bIsTestPrintLinuxPOS = true;
//            CGlobalData.csFinalMsgTestConnection = "Test Connection Success";
//        } else {
//            CGlobalData.m_bIsTestPrintLinuxPOS = false;
//            CGlobalData.csFinalMsgTestConnection = "Test Connection Failed";
//        }
//
//        return retVal;
//
//    }
//
//    //Content Server Changes Starts
//
//    public static boolean CreateContentSyncFolders() {
//        CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Inside CreateContentSyncFolders");
//        boolean retVal = true;
//        String dir_name = null;
//        dir_name = AppConst.IMAGE;
//        String temp_dir = Environment.getExternalStorageDirectory().getAbsolutePath() + File.separator + dir_name;
//        File file_dir = new File(temp_dir);
//        if (!file_dir.exists()) {
//            if (file_dir.mkdir()) {
//                CLogger.TraceLog(TRACE_DEBUG, "Directory is created! = %s", temp_dir);
//            } else {
//                CLogger.TraceLog(TRACE_ERROR, "Failed to create directory! = %s", temp_dir);
//                retVal = false;
//            }
//        }
//        dir_name = AppConst.GIF;
//        temp_dir = Environment.getExternalStorageDirectory().getAbsolutePath() + File.separator + dir_name;
//        file_dir = new File(temp_dir);
//        if (!file_dir.exists()) {
//            if (file_dir.mkdir()) {
//                CLogger.TraceLog(TRACE_DEBUG, "Directory is created! = %s", temp_dir);
//            } else {
//                CLogger.TraceLog(TRACE_ERROR, "Failed to create directory! = %s", temp_dir);
//                retVal = false;
//            }
//        }
//        dir_name = AppConst.VIDEO;
//        temp_dir = Environment.getExternalStorageDirectory().getAbsolutePath() + File.separator + dir_name;
//        file_dir = new File(temp_dir);
//        if (!file_dir.exists()) {
//            if (file_dir.mkdir()) {
//                CLogger.TraceLog(TRACE_DEBUG, "Directory is created! = %s", temp_dir);
//            } else {
//                CLogger.TraceLog(TRACE_ERROR, "Failed to create directory! = %s", temp_dir);
//                retVal = false;
//            }
//        }
//        dir_name = AppConst.DOCUMENT;
//        temp_dir = Environment.getExternalStorageDirectory().getAbsolutePath() + File.separator + dir_name;
//        file_dir = new File(temp_dir);
//        if (!file_dir.exists()) {
//            if (file_dir.mkdir()) {
//                CLogger.TraceLog(TRACE_DEBUG, "Directory is created! = %s", temp_dir);
//            } else {
//                CLogger.TraceLog(TRACE_ERROR, "Failed to create directory! = %s", temp_dir);
//                retVal = false;
//            }
//        }
//        dir_name = AppConst.MUSIC;
//        temp_dir = Environment.getExternalStorageDirectory().getAbsolutePath() + File.separator + dir_name;
//        file_dir = new File(temp_dir);
//        if (!file_dir.exists()) {
//            if (file_dir.mkdir()) {
//                CLogger.TraceLog(TRACE_DEBUG, "Directory is created! = %s", temp_dir);
//            } else {
//                CLogger.TraceLog(TRACE_ERROR, "Failed to create directory! = %s", temp_dir);
//                retVal = false;
//            }
//        }
//        dir_name = AppConst.THEME;
//        temp_dir = Environment.getExternalStorageDirectory().getAbsolutePath() + File.separator + dir_name;
//        file_dir = new File(temp_dir);
//        if (!file_dir.exists()) {
//            if (file_dir.mkdir()) {
//                CLogger.TraceLog(TRACE_DEBUG, "Directory is created! = %s", temp_dir);
//            } else {
//                CLogger.TraceLog(TRACE_ERROR, "Failed to create directory! = %s", temp_dir);
//                retVal = false;
//            }
//        }
//        dir_name = AppConst.FONT;
//        temp_dir = Environment.getExternalStorageDirectory().getAbsolutePath() + File.separator + dir_name;
//        file_dir = new File(temp_dir);
//        if (!file_dir.exists()) {
//            if (file_dir.mkdir()) {
//                CLogger.TraceLog(TRACE_DEBUG, "Directory is created! = %s", temp_dir);
//            } else {
//                CLogger.TraceLog(TRACE_ERROR, "Failed to create directory! = %s", temp_dir);
//                retVal = false;
//            }
//        }
//        dir_name = AppConst.UKNOWN_CONTENT_TYPE;
//        temp_dir = Environment.getExternalStorageDirectory().getAbsolutePath() + File.separator + dir_name;
//        file_dir = new File(temp_dir);
//        if (!file_dir.exists()) {
//            if (file_dir.mkdir()) {
//                CLogger.TraceLog(TRACE_DEBUG, "Directory is created! = %s", temp_dir);
//            } else {
//                CLogger.TraceLog(TRACE_ERROR, "Failed to create directory! = %s", temp_dir);
//                retVal = false;
//            }
//        }
//        return retVal;
//    }
//
//    //Content Server Changes Ends
//
//    public void AppReset(Context context) {
//        char key = 0;
//        int iHostID = DEFAULT_HOSTID;
//
//        //If Pin entry is obtained successfully
//
//        CGlobalData GlobalData = CGlobalData.GetInstance();
//
//        String chTxnFileName = String.format("%s%d.txt", TRANSACTIONFILENAME, iHostID);
//        if (CFileSystem.IsFileExist(chTxnFileName))
//            CFileSystem.DeleteFile(chTxnFileName);
//
//        if (CFileSystem.IsFileExist(SETTLEMENTPRINT))
//            CFileSystem.DeleteFile(SETTLEMENTPRINT);
//
//        String chTxnField62Name = String.format("%s%d.txt", TXNFEILD62NAME, iHostID);
//        if (CFileSystem.IsFileExist(chTxnField62Name))
//            CFileSystem.DeleteFile(chTxnField62Name);
//
//        if (CFileSystem.IsFileExist(MASTERMESFILE))
//            CFileSystem.DeleteFile(MASTERMESFILE);
//
//        if (CFileSystem.IsFileExist(PVMFILE))
//            CFileSystem.DeleteFile(PVMFILE);
//        //amitesh : For EDC application download
//
//        if (CFileSystem.IsFileExist(MASTERIMFILE))
//            CFileSystem.DeleteFile(MASTERIMFILE);
//
//        if (CFileSystem.IsFileExist(MASTERCLRDIMFILE))
//            CFileSystem.DeleteFile(MASTERCLRDIMFILE);
//
//        if (CFileSystem.IsFileExist(MASTERCGFILE))
//            CFileSystem.DeleteFile(MASTERCGFILE);
//
//        if (CFileSystem.IsFileExist(MASTERFCGFILE))
//            CFileSystem.DeleteFile(MASTERFCGFILE);
//
//        GlobalData.CreateMasterCGFile();
//
//        GlobalData.CreateMasterIMFile();
//        GlobalData.CreateMasterCLRDIMFile();
//
//        GlobalData.CreateMasterCFGFile();
//        GlobalData.CreateMasterLIBFile();
//
//        TerminalParamData m_sParamData = GlobalData.ReadParamFile(iHostID);
//
//        m_sParamData.m_iBatchState = BATCH_EMPTY;
//        m_sParamData.TotalTransactionsOfBatch = 0;
//        GlobalData.m_sMasterParamData.ulPvmVersion = 0;
//        GlobalData.WriteParamFile(iHostID, m_sParamData, context);
//
//        int State = S_INITIAL;
//        UpdateState(State, context);
//    }
//
//    public void remoteBackgroundGetStatus(String batchId, String roc, String txnType, String amount) {
//        remoteBackgroundGetStatus(DEFAULT_HOSTID);
//        if (txnType == null) {
//            return;
//        }
//        int hostActionTag_pgatpos = Integer.parseInt(txnType);
//        setActionCode(hostActionTag_pgatpos);
//        setHostType(2);
//        byte[] batchIdData = batchId.getBytes();
//        byte[] amtData = null;
//        if (amount != null) {
//            amtData = amount.getBytes();
//        }
//        if (batchIdData != null) {
//            addTLVData(batchIdData, batchIdData.length, AppConst.HTL_TAG_BATCH_ID);
//            byte[] rocData = roc.getBytes();
//            if (rocData != null) {
//                addTLVData(rocData, rocData.length, AppConst.HTL_TAG_ROC);
//                //set original batchid and roc
//                origBatchId = batchId;
//                origRoc = roc;
//
//                if (amtData != null) {
//                    //for void transactions
//                    addTLVData(amtData, amtData.length, AppConst.HTL_TAG_AMT);
//                }
//                remoteBackgroundGetStatus(DEFAULT_HOSTID);
//            }
//        }
//    }
//
//    void getStatusTransaction(String batchId, String roc, String txnType, String amount, Context context) {
//        if (txnType == null) {
//            return;
//        }
//        int hostActionTag_pgatpos = Integer.parseInt(txnType);
//        setActionCode(hostActionTag_pgatpos);
//        setHostType(2);
//        byte[] batchIdData = batchId.getBytes();
//        byte[] amtData = null;
//        if (amount != null) {
//            amtData = amount.getBytes();
//        }
//        if (batchIdData != null) {
//            addTLVData(batchIdData, batchIdData.length, AppConst.HTL_TAG_BATCH_ID);
//            byte[] rocData = roc.getBytes();
//            if (rocData != null) {
//                addTLVData(rocData, rocData.length, AppConst.HTL_TAG_ROC);
//                //set original batchid and roc
//                origBatchId = batchId;
//                origRoc = roc;
//
//                if (amtData != null) {
//                    //for void transactions
//                    addTLVData(amtData, amtData.length, AppConst.HTL_TAG_AMT);
//                }
//                CStateMachine.GetInstance().GoOnline(DEFAULT_HOSTID, context);
//            }
//        }
//    }
//
//    void addTLVData(byte[] Data, int length, int HostTlvtag) {
//        CGlobalData GlobalData = CGlobalData.GetInstance();
//        if ((length > 0) && (HostTlvtag > 0) && (GlobalData.m_sTxnTlvData.iTLVindex < AppConst.MAX_TXN_STEPS_WITH_TLV_DATA)) {
//            GlobalData.m_sTxnTlvData.objTLV[GlobalData.m_sTxnTlvData.iTLVindex] = new TLVTxData();
//            GlobalData.m_sTxnTlvData.objTLV[GlobalData.m_sTxnTlvData.iTLVindex].uiTag = HostTlvtag;
//            GlobalData.m_sTxnTlvData.objTLV[GlobalData.m_sTxnTlvData.iTLVindex].uiTagValLen = length;
//            GlobalData.m_sTxnTlvData.objTLV[GlobalData.m_sTxnTlvData.iTLVindex].chArrTagVal = new byte[length];
//            System.arraycopy(Data, 0, GlobalData.m_sTxnTlvData.objTLV[GlobalData.m_sTxnTlvData.iTLVindex].chArrTagVal, 0, length);
//            GlobalData.m_sTxnTlvData.iTLVindex++;
//            CLogger.TraceLog(TRACE_DEBUG, "ADDED TLVData: len[%d], Hosttag[0x%x], data[%s]", length, HostTlvtag, BytesUtil.byteArray2HexString(Data));
//        }
//    }
//
//    void setActionCode(int HostActiontag) {
//
//        CGlobalData GlobalData = CGlobalData.GetInstance();
//        if (HostActiontag > 0) {
//            GlobalData.m_sNewTxnData.uiTransactionType = HostActiontag;
//
//            TerminalParamData m_sParamData;
//            m_sParamData = GlobalData.ReadParamFile(DEFAULT_HUB_HOSTID);
//            if (m_sParamData == null) {
//                CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "TerminalParamData doest not exist");
//                return;
//            }
//            if (m_sParamData.m_iIsPasswdNeededForSpecificTxns && (CPlatformUtils.isPasswordRequiredForSpecificTransaction(GlobalData.m_iHostIndicator) != 0)) {
//                TransactionHUB.getInstance().isPasswordRequiredForSpecificTransaction = true;
//            }
//        }
//    }
//
//    void setHostType(int iHostType) {
//        if (iHostType > 0) {
//            CGlobalData GlobalData = CGlobalData.GetInstance();
//            GlobalData.m_iHostIndicator = iHostType;
//        }
//    }


    
}
