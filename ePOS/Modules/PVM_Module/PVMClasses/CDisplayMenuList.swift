//
//  CDisplayMenuList.swift
//  ePOS
//
//  Created by Vishal Rathore on 11/12/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CDisplayMenuList: CBaseNode {
    
    private var m_Title: String
    private var m_sel_index: Int
    
    override init() {
        m_Title = ""
        m_sel_index = 0
        super.init()
        numberOFItemsInMenuList = 0
        numberOFImages = 0
        listViewcode = 2
        ItemList = nil
        
    }

    public override func AddPrivateParameters(tagAttribute: XMLATTRIBUTE, nTotal: Int) -> Int {
        let retVal = RetVal.RET_OK
        numberOFItemsInMenuList = tagAttribute.numberOFItemsInMenuList
        numberOFImages  = tagAttribute.numberOFItemsInMenuList

        ItemList = [ITEMVAL?](repeating: nil, count: numberOFItemsInMenuList) as? [ITEMVAL]
        ItemListImages = [ImageListParserModel]()

        // Check for all items in menu from (numberOFItemsInMenuList) and copy only those in which some value is present.
        for itemnu in 0 ..< numberOFItemsInMenuList {
            if (tagAttribute.ItemList != nil && tagAttribute.ItemList![itemnu] != nil) {
                ItemList![itemnu] = ITEMVAL()
                self.ParseItems(ItemList: tagAttribute.ItemList![itemnu], item: &ItemList![itemnu])
            }
            let itemno = "img" + "\(itemnu + 1)"
            if (nil != tagAttribute.ItemListImages) {
                for img in 0 ..< tagAttribute.ItemListImages!.count {
                    if (tagAttribute.ItemListImages![img] != nil && tagAttribute.ItemListImages![img].getTagName() == itemno) {
                        ItemListImages?.append(tagAttribute.ItemListImages![img])
                    }
                }
            }
            if (ItemListImages != nil && (ItemListImages!.count != itemnu + 1 || ItemListImages!.count == 0)) {
                var imageListParserModel = ImageListParserModel()
                imageListParserModel.setTagName("")
                imageListParserModel.setTagValue("")
                ItemListImages?.append(imageListParserModel)
            }
        }

        // copy m_Title
        m_Title = tagAttribute.Title;
        listViewcode = tagAttribute.ListViewcode;
        return retVal;
    }

    public override func prepareTimer(time: Int) {

    }

    public override func startTimer() {

    }
    
    public override func cancelTimer() {

    }

    public override func onExecuted() {

    }

    public override func execute() -> Int {
        debugPrint("Inside execute")
        var retVal = getExecutionResult(iResult: iResult)
        if(retVal == ExecutionResult._OK) {
            m_sel_index = iPos;
            if (nil != ItemList && ItemList!.count > 0) {
                if (ItemList![m_sel_index].ItemVal != nil) {
                    AddTLVData(Data: ItemList![m_sel_index].ItemVal.bytes, length: ItemList![m_sel_index].ItemVal.count)
                    retVal = ExecutionResult._OK
                }
            }
            //If amount is present in XML add to TLV node
            AddAmountFromXmlinTlV()
            //if currency code present in XML, set the value in EMV Module
            SetCurrencyCodeInEMVModule()
        }
        reset();
        return retVal;
    }

    private func ParseItems(ItemList: String, item: inout ITEMVAL) {
        let splitString: [String] = ItemList.split(separator: ",").map{String($0)}
        if (splitString.count == 2) {
            item.ItemName = splitString[0]
            item.ItemVal = splitString[1]
        }
    }

    
}
