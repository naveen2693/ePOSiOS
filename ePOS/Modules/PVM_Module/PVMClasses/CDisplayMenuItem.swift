//
//  CDisplayMenuItem.swift
//  ePOS
//
//  Created by Abhishek on 06/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
class CDisplayMenuItem : CBaseNode
{
    var m_bIsUnicodeDisplayMenuItem:Bool;
    var m_iFontId:Int;
    var ItemName:String;
    var imageName:String = "";
    var ItemIndex:Int = 0;
    
    // MARK:- getIndex
    public override func getIndex() -> Int
    {
        return ItemIndex;
    }
    
    public override init()
    {
        ItemIndex = 0;
        m_bIsUnicodeDisplayMenuItem = false;
        m_iFontId = 0;
        ItemName = "";
    }
    
    // MARK:- AddPrivateParameters
    public override func AddPrivateParameters(tagAttribute:XMLATTRIBUTE,nTotal:Int) -> Int
    {
        onOk = PvmNodeActions.gotoChild;
        ItemName = tagAttribute.ItemName;
        imageName = tagAttribute.iNameImage;
        ItemIndex = tagAttribute.ItemIndex;
        return RetVal.RET_OK;
    }
    
    // MARK:- execute
    public func execute() -> Int
    {
        AddAmountFromXmlinTlV();
        SetCurrencyCodeInEMVModule();
        return ExecutionResult._OK;
    }
    
    // MARK:- AddTLVData
    override func AddTLVData(Data:[Byte], length:Int)
    {
        if ((HostTlvtag > 0) && (GlobalData.singleton.m_sTxnTlvData.iTLVindex < AppConstant.MAX_TXN_STEPS_WITH_TLV_DATA))
        {
            GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex].uiTag = HostTlvtag;
            GlobalData.singleton.m_sTxnTlvData.objTLV[GlobalData.singleton.m_sTxnTlvData.iTLVindex].uiTagValLen = length;
            GlobalData.singleton.m_sTxnTlvData.iTLVindex = GlobalData.singleton.m_sTxnTlvData.iTLVindex+1 ;
        }
    }
    
    public override func prepareTimer(time:Int)
    {
    }
    public override func startTimer()
    {
        
    }
    public override func cancelTimer()
    {
        
    }
    public override func onExecuted()
    {
        
    }
}
