//
//  CDisplayMenu.swift
//  ePOS
//
//  Created by Abhishek on 06/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
class CDisplayMenu : CBaseNode{
    
    //global variable
    var  m_title:String; // Title of the Menu window.
    var  m_sel_index:Int;
    var  m_listViewcode:Int;
    
    public override init() {
        self.m_sel_index = 0;
        self.m_listViewcode = 2;
        self.m_title = "";
    }
    
    public override func AddPrivateParameters(tagAttribute:XMLATTRIBUTE, nTotal:Int) -> Int {
        let retVal = RetVal.RET_OK;
        m_title = tagAttribute.Title;
        m_listViewcode = tagAttribute.ListViewcode;
        return retVal;
    }
    
    public func execute() -> Int {
        let retVal = getExecutionResult(iResult: iResult);
        if(retVal == ExecutionResult._OK) {
            m_sel_index = iPos + 1;
            AddAmountFromXmlinTlV();
            SetCurrencyCodeInEMVModule();
        }
        reset();
        return retVal;
    }
    
    public override func GotoChild() -> CBaseNode?{
        return GotoChild(index: m_sel_index);
    }
    
    
    public override func prepareTimer(time:Int) {
        
    }
    public override func startTimer() {
        
    }
    
    
    public override func cancelTimer() {
        
    }
    
    
    public override func onExecuted() {
        
    }
    
    override func GotoChild(index:Int) -> CBaseNode? {
        if (nil == Child) {
            return nil;
        } else {
            return (Child?.gotoindexedChild(gIndex: index));
        }
    }
}
