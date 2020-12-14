//
//  CDisplayMenu.swift
//  ePOS
//
//  Created by Abhishek on 06/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
class CDisplayMenu : CBaseNode
{
    
    var  m_title:String;
    var  m_sel_index:Int;
    var  m_listViewcode:Int;
    
    // MARK:-init
    public override init()
    {
        self.m_sel_index = 0;
        self.m_listViewcode = 2;
        self.m_title = "";
    }
    
    // MARK:-AddPrivateParameters
    public override func AddPrivateParameters(tagAttribute:XMLATTRIBUTE, nTotal:Int) -> Int
    {
        let retVal = RetVal.RET_OK;
        m_title = tagAttribute.Title;
        m_listViewcode = tagAttribute.ListViewcode;
        return retVal;
    }
    
    // MARK:-execute
    public override func execute() -> Int
    {
        let retVal = getExecutionResult(iResult: iResult);
        if(retVal == ExecutionResult._OK)
        {
            m_sel_index = iPos + 1;
            AddAmountFromXmlinTlV();
            SetCurrencyCodeInEMVModule();
        }
        reset();
        return retVal;
    }
    
    // MARK:-GotoChild
    public override func GotoChild() -> CBaseNode?{
        return GotoChild(index: m_sel_index);
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
    
    // MARK:-GotoChild
    override func GotoChild(index:Int) -> CBaseNode?
    {
        if (nil == Child)
        {
            return nil;
        }
        else
        {
            return (Child?.gotoindexedChild(gIndex: index));
        }
    }
}
