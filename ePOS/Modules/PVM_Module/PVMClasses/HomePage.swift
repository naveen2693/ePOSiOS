//
//  HomePage.swift
//  ePOS
//
//  Created by Vishal Rathore on 14/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
class HomePage: CBaseNode{
    
    //global variable
    private var m_Title: String // Title of the Menu window.
    private var m_sel_index: Int
    private var m_listViewcode: Int


    public override func onExecuted() {

    }

    override init() {
        m_sel_index = 0
        m_listViewcode = 2
        m_Title = ""
    }

    public override func AddPrivateParameters(tagAttribute: XMLATTRIBUTE, nTotal: Int) -> Int {
        let retVal = RetVal.RET_OK
        m_Title = tagAttribute.Title
        m_listViewcode = tagAttribute.ListViewcode
        return retVal
    }

    public override func execute() -> Int {
        debugPrint("Inside execute")
        let retVal = getExecutionResult(iResult: iResult)
        if(retVal == ExecutionResult._OK) {
            m_sel_index = iPos + 1
            AddAmountFromXmlinTlV()
            SetCurrencyCodeInEMVModule()
        }
        reset()
        return retVal

    }

    public override func GotoChild() -> CBaseNode? {
        return GotoChild(index: m_sel_index);
    }

    public override func prepareTimer(time: Int) {

    }

    public override func startTimer() {

    }

    public override func cancelTimer() {

    }

    public override func GotoChild(index: Int) -> CBaseNode? {
        if (nil == Child) {
            return nil
        } else {
            return (Child!.gotoindexedChild(gIndex: index))
        }
    }


}
