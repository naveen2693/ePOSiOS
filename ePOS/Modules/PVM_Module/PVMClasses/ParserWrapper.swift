//
//  XMLParser.swift
//  ePOS
//
//  Created by Abhishek on 02/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public class ParserWrapper
{
    private class CStackNode
    {
        var this_node:CBaseNode?
        var next_node:CStackNode?
        
        private init()
        {
            this_node = nil
            next_node = nil
        }
        
        // MARK:- TopNode
        private static func TopNode() -> CStackNode?
        {
            return TopOfStack
        }
        
        // MARK:- PushNode
        internal static func PushNode(_ addThisNode:CBaseNode)
        {
            let tempNode = CStackNode()
            tempNode.next_node = TopOfStack
            tempNode.this_node = addThisNode
            TopOfStack = tempNode
        }
        
        // MARK:- PopNode
        internal static func PopNode()
        {
            guard let tempNode = TopNode() else {return}
            TopOfStack = tempNode.next_node
        }
    }
    
    private static var TopOfStack:CStackNode?
    private var currentNode:CBaseNode?
    private var parentNode:CBaseNode?
    
    // MARK:- PushNewnode
    private func PushNewnode(_ currentNode:CBaseNode)
    {
        CStackNode.PushNode(currentNode)
    }
    
    // MARK:- PopNode
    public func PopNode()
    {
        CStackNode.PopNode()
    }
    
    // MARK:- AddNewNode
    public func AddNewNode(_ strArrAttributeName:[String],_ strArrAttributeValue:[String], _ iLength:Int) {
        var newNode:CBaseNode?
        
        var tagAttribute =  ParseNodeAttributes(strArrAttributeName,strArrAttributeValue,iLength)
        
        parentNode = currentNode;
        switch (tagAttribute.node_type) {
        case PvmNodeTypes.Dispaly_message_node:
            newNode =  CDisplayMessage();
            currentNode = newNode;
        case PvmNodeTypes.Menu_node:
            newNode =  CDisplayMenu();
            currentNode = newNode;
        case PvmNodeTypes.Menu_item_node:
            newNode =  CDisplayMenuItem();
            currentNode = newNode;
        case PvmNodeTypes.Amount_entry_node:
            newNode =  CDisplayGetAmount();
            currentNode = newNode;
        case PvmNodeTypes.Data_entry_node:
            newNode =  CDisplayDataEntry();
            currentNode = newNode;
        case PvmNodeTypes.Invalid_node:
            break;
        default:
            return
        }
        
        if (parentNode != nil) {
            tagAttribute.parentNode = parentNode;
        }
        _ = newNode?.AddParameters(tagAttribute: tagAttribute, nTotal: iLength)
        
        guard let node = newNode else {
            debugPrint("New Node found nil")
            return }
        
        PushNewnode(node);
        
        var currentParentNode:CBaseNode?
        if (ParserWrapper.TopOfStack?.next_node != nil) {
            currentParentNode = ParserWrapper.TopOfStack?.next_node?.this_node
            currentParentNode?.AddChild(addThisNode: node)
            if let currentParentNode1 = currentParentNode{
                node.AddParent(currentParentNode1)
            }
        }
        for itemnu in 0..<tagAttribute.numberOFItemsInMenuList {
            if (tagAttribute.ItemList?[itemnu] != nil) {
                // tagAttribute.ItemList?[itemnu] = nil;
            }
        }
        
        if (tagAttribute.ItemList != nil) {
            tagAttribute.ItemList = nil;
        }
        
        for _ in 0..<tagAttribute.numberOFImages {
            if (tagAttribute.ItemListImages != nil) {
                tagAttribute.ItemListImages = nil;
            }
        }
        
        if (tagAttribute.ItemListImages != nil) {
            tagAttribute.ItemListImages = nil;
        }
        
    }
    
    // MARK:- SaveRootNode
    func SaveRootNode()
    {
        if let node = currentNode{
            CStateMachine.stateMachine.SetRootNode(currentNode: node);
        }
    }
    
    // MARK:- ParseNodeAttributes
    func ParseNodeAttributes(_ strArrAttributeName:[String],_ strArrAttributeValue:[String],_ nTotal:Int) -> XMLATTRIBUTE
    {
        var nParsedAtt = 0;
        var qrCode = [QRCodeData]();
        var itemCountQC = 0;
        var printData = [PrintData]();
        var itemCountPC = 0;
        var tagAttribute =  XMLATTRIBUTE()
        for var nIndex in 0..<nTotal
        {
            if (strArrAttributeName[nIndex].elementsEqual("nt"))
            {
                nParsedAtt += 1
                tagAttribute.node_type = Int(strArrAttributeValue[nIndex]) ?? 0;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("vc"))
            {
                nParsedAtt += 1
                tagAttribute.ListViewcode = Int(strArrAttributeValue[nIndex]) ?? 0;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("sdtr"))
            {
                nParsedAtt += 1
                tagAttribute.soundTrack = strArrAttributeValue[nIndex];
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("nm"))
            {
                nParsedAtt += 1
                tagAttribute.iName = strArrAttributeValue[nIndex];
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("img"))
            {
                nParsedAtt += 1
                tagAttribute.iNameImage = strArrAttributeValue[nIndex];
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("cas"))
            {
                nParsedAtt += 1
                tagAttribute.cascading = Int(strArrAttributeValue[nIndex]) ?? 0;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("to"))
            {
                nParsedAtt += 1
                tagAttribute.Timeout = Int(strArrAttributeValue[nIndex])  ?? 0;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("brlv"))
            {
                nParsedAtt += 1;
                tagAttribute.brightnessLevel = Int(strArrAttributeValue[nIndex])  ?? 0;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("gtor"))
            {
                nParsedAtt += 1;
                tagAttribute.goToOrignalBrightness = Int(strArrAttributeValue[nIndex])  ?? 0;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("isLatLong"))
            {
                nParsedAtt += 1;
                tagAttribute.IsLatLong = Int(strArrAttributeValue[nIndex]) == 1 ? true : false;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("ok"))
            {
                nParsedAtt += 1;
                if (strArrAttributeValue[nIndex].elementsEqual("Next")) {
                    tagAttribute.onOk = PvmNodeActions.gotoChild;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("bk"))
                {
                    tagAttribute.onOk = PvmNodeActions.goBack;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("ext"))
                {
                    tagAttribute.onOk = PvmNodeActions.gotoRoot;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("et"))
                {
                    tagAttribute.onOk = PvmNodeActions.gotoRoot;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("go"))
                {
                    tagAttribute.onOk = PvmNodeActions.goOnline;
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("can")) {
                nParsedAtt += 1;
                if (strArrAttributeValue[nIndex].elementsEqual("Next"))
                {
                    tagAttribute.onCancel = PvmNodeActions.gotoChild;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("bk"))
                {
                    tagAttribute.onCancel = PvmNodeActions.goBack;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("ext"))
                {
                    tagAttribute.onCancel = PvmNodeActions.gotoRoot;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("et"))
                {
                    tagAttribute.onCancel = PvmNodeActions.gotoRoot;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("go"))
                {
                    tagAttribute.onCancel = PvmNodeActions.goOnline;
                }
            }
            if (strArrAttributeName[nIndex].elementsEqual("oto"))
            {
                nParsedAtt += 1;
                if (strArrAttributeValue[nIndex].elementsEqual("Next"))
                {
                    tagAttribute.onTimeout = PvmNodeActions.gotoChild;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("bk"))
                {
                    tagAttribute.onTimeout = PvmNodeActions.goBack;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("ext"))
                {
                    tagAttribute.onTimeout = PvmNodeActions.gotoRoot;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("et"))
                {
                    tagAttribute.onOk = PvmNodeActions.gotoRoot;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("go"))
                {
                    tagAttribute.onTimeout = PvmNodeActions.goOnline;
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("Onet"))
            {
                nParsedAtt += 1;
                if (strArrAttributeValue[nIndex].elementsEqual("Next"))
                {
                    tagAttribute.onExit = PvmNodeActions.gotoChild;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("bk"))
                {
                    tagAttribute.onExit = PvmNodeActions.goBack;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("ext"))
                {
                    tagAttribute.onExit = PvmNodeActions.exitPvm;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("go"))
                {
                    tagAttribute.onExit = PvmNodeActions.goOnline;
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("htl"))
            {
                nParsedAtt += 1
                if let hostTag = TransactionUtils.a2bcd([Byte](strArrAttributeValue[nIndex].utf8)){
                    tagAttribute.HostTlvtag = (((Int)(hostTag[0]))<<8) & 0x0000FF00
                    tagAttribute.HostTlvtag |= Int((hostTag[1])) & 0x000000FF
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("hat"))
            {
                nParsedAtt += 1;
                if let hostTag = TransactionUtils.a2bcd([Byte](strArrAttributeValue[nIndex].utf8)){
                    tagAttribute.HostActiontag = (((Int)(hostTag[0]))<<8) & 0x0000FF00
                    tagAttribute.HostActiontag |= Int((hostTag[1])) & 0x000000FF
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("isSignCap"))
            {
                nParsedAtt += 1;
                tagAttribute.IsSignCapture = Int(strArrAttributeValue[nIndex]) == 1 ? true : false;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("isFontId"))
            {
                nParsedAtt += 1;
                tagAttribute.fontId = Int(strArrAttributeValue[nIndex]) ?? 0;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("ISOType"))
            {
                nParsedAtt += 1;
                tagAttribute.ISOType = Int(strArrAttributeValue[nIndex]) ?? 0;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("rtc"))
            {
                nParsedAtt += 1;
                tagAttribute.RetryCount = Int(strArrAttributeValue[nIndex]) ?? 0;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("rtcto"))
            {
                nParsedAtt += 1;
                tagAttribute.RetryCountTimeOut = Int(strArrAttributeValue[nIndex]) ?? 0;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("htt"))
            {
                nParsedAtt += 1;
                tagAttribute.iHostType = Int(strArrAttributeValue[nIndex]) ?? 0;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("vt"))
            {
                nParsedAtt += 1;
                tagAttribute.viewType = strArrAttributeValue[nIndex];
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("fn"))
            {
                nParsedAtt += 1;
                tagAttribute.fileName = strArrAttributeValue[nIndex];
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("iss"))
            {
                nParsedAtt += 1;
                tagAttribute.IsOnSSL = Int(strArrAttributeValue[nIndex]) ?? 0;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("isUTF8"))
            {
                nParsedAtt += 1;
                tagAttribute.IsUTF8 = Int(strArrAttributeValue[nIndex]) == 1 ? true : false;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("amt"))
            {
                nParsedAtt += 1;
                tagAttribute.chAmount = strArrAttributeValue[nIndex];
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("cur"))
            {
                nParsedAtt += 1;
                tagAttribute.chCurrencyCode = strArrAttributeValue[nIndex];
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("ti"))
            {
                nParsedAtt += 1;
                tagAttribute.Title = strArrAttributeValue[nIndex];
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("name"))
            {
                nParsedAtt += 1;
                tagAttribute.Title = tagAttribute.iName;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("ix"))
            {
                nParsedAtt += 1;
                tagAttribute.ItemIndex = Int(strArrAttributeValue[nIndex]) ?? 0;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("scntyp"))
            {
                nParsedAtt += 1;
                tagAttribute.ScanType = strArrAttributeValue[nIndex];
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("dm"))
            {
                // For UniCode UTF8 display messages
                if (tagAttribute.IsUTF8) {
                    let utf16len:Int = 0;
                    _ = (strArrAttributeValue[nIndex], strArrAttributeValue[nIndex].count, tagAttribute.DisplayMessage, utf16len);
                    tagAttribute.DisplayMessagelen = utf16len;
                    nParsedAtt += 1;
                } else {
                    nParsedAtt += 1;
                    let szattributeString = strArrAttributeValue[nIndex]
                    tagAttribute.DisplayMessage = szattributeString.replacingOccurrences(of: "\\", with:"\n")
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("dm2"))
            {
                if (tagAttribute.IsUTF8) {
                    tagAttribute.DisplayMessageLine2len = strArrAttributeValue[nIndex].count;
                    nParsedAtt += 1;
                } else {
                    tagAttribute.DisplayMessageLine2 = strArrAttributeValue[nIndex];
                    nParsedAtt += 1;
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("dm3"))
            {
                if (tagAttribute.IsUTF8) {
                    tagAttribute.DisplayMessageLine3len = strArrAttributeValue[nIndex].count;
                    nParsedAtt += 1;
                } else {
                    tagAttribute.DisplayMessageLine3 = strArrAttributeValue[nIndex];
                    nParsedAtt += 1;
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("dm4"))
            {
                if (tagAttribute.IsUTF8) {
                    tagAttribute.DisplayMessageLine4len = strArrAttributeValue[nIndex].count;
                    nParsedAtt += 1;
                }
                else
                {
                    tagAttribute.DisplayMessageLine4 = strArrAttributeValue[nIndex];
                    nParsedAtt += 1;
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("ide"))
            {
                nParsedAtt += 1;
                tagAttribute.isIdeFlagEnabled = Int(strArrAttributeValue[nIndex]) == 1;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("totc"))
            {
                nParsedAtt += 1;
                tagAttribute.numberOFItems = Int(strArrAttributeValue[nIndex]) ?? 0;
                if (tagAttribute.numberOFItems > 0) {
                    tagAttribute.pvmListParser = Array<PvmListParserVO>();
                    var isvaluepresent = false;
                    var itemCount:Int = 0;
                    for _ in 0..<tagAttribute.numberOFItems
                    {
                        isvaluepresent = false;
                        var pvmListParserVO = PvmListParserVO();
                        var cIndex = 0;
                        while ((cIndex < nTotal) )
                        {
                            let itemal = "mal" + String(itemCount + 1);
                            let itemil = "mil" + String(itemCount + 1);
                            let itedcn = "dcn" + String(itemCount + 1);
                            let itedec = "dec" + String(itemCount + 1);
                            let itein = "in" + String(itemCount + 1);
                            let itedm = "dm" + String(itemCount + 1);
                            let itetxtye = "txtye" + String(itemCount + 1);
                            let iteregx = "regx" + String(itemCount + 1);
                            let itehtl = "htl" + String(itemCount + 1);
                            let itedval = "dval" + String(itemCount + 1);
                            
                            if (strArrAttributeName[cIndex].elementsEqual(itemal))
                            {
                                pvmListParserVO.MaxLen = Int(strArrAttributeValue[cIndex]) ?? 0
                                isvaluepresent = true;
                            }
                            
                            if (strArrAttributeName[cIndex].elementsEqual(itemil))
                            {
                                pvmListParserVO.MinLen = Int(strArrAttributeValue[cIndex]) ?? 0;
                                isvaluepresent = true;
                            }
                            
                            if (strArrAttributeName[cIndex].elementsEqual(itedm))
                            {
                                pvmListParserVO.DM = (strArrAttributeValue[cIndex]);
                                isvaluepresent = true;
                            }
                            
                            if (strArrAttributeName[cIndex].elementsEqual(itedcn))
                            {
                                pvmListParserVO.CurrencyName = (strArrAttributeValue[cIndex]);
                                isvaluepresent = true;
                            }
                            
                            if(strArrAttributeName[cIndex].elementsEqual(itedec)) {
                                pvmListParserVO.Decimals = (Int(strArrAttributeValue[cIndex]) ?? 0);
                                isvaluepresent = true;
                            }
                            
                            if(strArrAttributeName[cIndex].elementsEqual(itetxtye))
                            {
                                pvmListParserVO.txtye = (strArrAttributeValue[cIndex]);
                                isvaluepresent = true;
                            }
                            
                            if(strArrAttributeName[cIndex].elementsEqual(iteregx))
                            {
                                pvmListParserVO.regx = (strArrAttributeValue[cIndex]);
                                isvaluepresent = true;
                            }
                            
                            if(strArrAttributeName[cIndex].elementsEqual(itedval))
                            {
                                pvmListParserVO.defaultValue = (strArrAttributeValue[cIndex]);
                                isvaluepresent = true;
                            }
                            
                            if (strArrAttributeName[cIndex].elementsEqual(itehtl))
                            {
                                
                                if var hostTag = TransactionUtils.a2bcd(strArrAttributeValue[cIndex].bytes)
                                {
                                    var HTLTag = Int(hostTag[0]<<8) & 0x0000FF00;
                                    HTLTag |= Int(hostTag[1]) & 0x000000FF;
                                    pvmListParserVO.HTL = HTLTag;
                                    isvaluepresent = true;
                                }
                            }
                            
                            if (strArrAttributeName[cIndex].elementsEqual(itein))
                            {
                                
                                if (strArrAttributeValue[cIndex].elementsEqual("num"))
                                {
                                    pvmListParserVO.InputMethod = enum_InputMethod.NUMERIC_ENTRY;
                                } else if (strArrAttributeValue[cIndex].elementsEqual("aln")) {
                                    pvmListParserVO.InputMethod = enum_InputMethod.ALPHANUMERIC_ENTRY;
                                }
                                isvaluepresent = true;
                            }
                            cIndex += 1;
                        }
                        
                        if (isvaluepresent)
                        {
                            nParsedAtt += 1;
                            tagAttribute.pvmListParser.append(pvmListParserVO);
                            itemCount += 1;
                            nIndex += 1;
                        }
                    }
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("tqrc"))
            {
                nParsedAtt += 1;
                if (tagAttribute.numberOFItems > 0) {
                    tagAttribute.qrcodescanningListParser =  Array<QRCodeScanningParserVO>();
                    var isvaluepresent = false;
                    var itemCount = 0;
                    for _ in 0..<tagAttribute.numberOFItems
                    {
                        isvaluepresent = false;
                        var qrCodeScanningParserVO = QRCodeScanningParserVO();
                        var cIndex = 0;
                        while ((cIndex < nTotal) )
                        {
                            let itemal = "mal" + String(itemCount + 1);
                            let itemil = "mil" + String(itemCount + 1);
                            let itedcn = "dcn" + String(itemCount + 1);
                            let itedec = "dec" + String(itemCount + 1);
                            let itein = "in" + String(itemCount + 1);
                            let itedm = "dm" + String(itemCount + 1);
                            let itescntyp = "scntyp" + String(itemCount + 1);
                            let itehtl = "htl" + String(itemCount + 1);
                            
                            
                            if (strArrAttributeName[cIndex].elementsEqual(itemal))
                            {
                                qrCodeScanningParserVO.MaxLen = (Int(strArrAttributeValue[cIndex])) ?? 0;
                                isvaluepresent = true;
                            }
                            
                            if (strArrAttributeName[cIndex].elementsEqual(itemil))
                            {
                                qrCodeScanningParserVO.MinLen = (Int(strArrAttributeValue[cIndex])) ?? 0;
                                isvaluepresent = true;
                            }
                            
                            if (strArrAttributeName[cIndex].elementsEqual(itedm))
                            {
                                qrCodeScanningParserVO.DM = (strArrAttributeValue[cIndex]);
                                isvaluepresent = true;
                            }
                            
                            if (strArrAttributeName[cIndex].elementsEqual(itedcn))
                            {
                                qrCodeScanningParserVO.CurrencyName = (strArrAttributeValue[cIndex]);
                                isvaluepresent = true;
                            }
                            
                            if (strArrAttributeName[cIndex].elementsEqual(itedec))
                            {
                                qrCodeScanningParserVO.Decimals = (Int(strArrAttributeValue[cIndex])) ?? 0;
                                isvaluepresent = true;
                            }
                            
                            if (strArrAttributeName[cIndex].elementsEqual(itehtl))
                            {
                                if let hostTag:[Byte] = TransactionUtils.a2bcd(strArrAttributeValue[cIndex].bytes)
                                {
                                    var HTLTag = Int(hostTag[0]<<8) & 0x0000FF00;
                                    HTLTag |= Int(hostTag[1]) & 0x000000FF;
                                    
                                    qrCodeScanningParserVO.HTL = (HTLTag);
                                    isvaluepresent =  true;
                                }
                            }
                            
                            if (strArrAttributeName[cIndex].elementsEqual(itein))
                            {
                                
                                if (strArrAttributeValue[cIndex].elementsEqual("num"))
                                {
                                    qrCodeScanningParserVO.InputMethod = (enum_InputMethod.NUMERIC_ENTRY);
                                } else if (strArrAttributeValue[cIndex].elementsEqual("aln")) {
                                    qrCodeScanningParserVO.InputMethod = (enum_InputMethod.ALPHANUMERIC_ENTRY);
                                }
                                isvaluepresent = true;
                            }
                            
                            if (strArrAttributeName[cIndex].elementsEqual(itescntyp))
                            {
                                qrCodeScanningParserVO.scantype = (strArrAttributeValue[cIndex]);
                                isvaluepresent = true;
                            }
                            
                            cIndex += 1;
                        }
                        
                        if (isvaluepresent)
                        {
                            nParsedAtt += 1;
                            tagAttribute.qrcodescanningListParser.append(qrCodeScanningParserVO);
                            itemCount += 1;
                            nIndex += 1;
                        }
                        
                    }
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("mal"))
            {
                nParsedAtt += 1;
                tagAttribute.MaxLen = Int16(Int(strArrAttributeValue[nIndex]) ?? 0) ;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("mil"))
            {
                nParsedAtt += 1;
                tagAttribute.MinLen = Int16(Int(strArrAttributeValue[nIndex]) ?? 0) ;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("dcn"))
            {
                nParsedAtt += 1;
                tagAttribute.CurrencyName = strArrAttributeValue[nIndex];
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("dec"))
            {
                nParsedAtt += 1;
                tagAttribute.Decimals = Int16(Int(strArrAttributeValue[nIndex]) ?? 0) ;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("in"))
            {
                if (strArrAttributeValue[nIndex].elementsEqual("num")) {
                    tagAttribute.InputMethod = enum_InputMethod.NUMERIC_ENTRY;
                } else if (strArrAttributeValue[nIndex].elementsEqual("aln")) {
                    tagAttribute.InputMethod = enum_InputMethod.ALPHANUMERIC_ENTRY;
                }
                nParsedAtt += 1;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("regx"))
            {
                tagAttribute.regx = strArrAttributeValue[nIndex];
                nParsedAtt += 1;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("txtye"))
            {
                tagAttribute.txtye = strArrAttributeValue[nIndex];
                nParsedAtt += 1;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("dval"))
            {
                tagAttribute.dval = strArrAttributeValue[nIndex];
                nParsedAtt += 1;
            }
            
            /********** CONFIRMATION ************/
            if (strArrAttributeName[nIndex].elementsEqual("Key_F1"))
            {
                let strKey_F1 = strArrAttributeValue[nIndex].split(separator: ",");
                if(strKey_F1.count == 2)
                {
                    let chAction = strKey_F1[0];
                    let chDisplay = strKey_F1[1];
                    tagAttribute.KEY_F1 = PvmNodeActions.gotoRoot;
                    tagAttribute.KeyF1 = String(chDisplay);
                    nParsedAtt += 1;
                    if (chAction.elementsEqual("Next"))
                    {
                        tagAttribute.KEY_F1 = PvmNodeActions.gotoChild;
                    }
                    else if (chAction.elementsEqual("bk"))
                    {
                        tagAttribute.KEY_F1 = PvmNodeActions.goBack;
                    }
                    else if (chAction.elementsEqual("ext"))
                    {
                        tagAttribute.KEY_F1 = PvmNodeActions.gotoRoot;
                    }
                    else if (chAction.elementsEqual("go"))
                    {
                        tagAttribute.KEY_F1 = PvmNodeActions.goOnline;
                    }
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("Key_F2"))
            {
                let strKey_F2 = strArrAttributeValue[nIndex].split(separator: ",");
                if(strKey_F2.count == 2)
                {
                    let chAction = strKey_F2[0];
                    let chDisplay = strKey_F2[1];
                    tagAttribute.KEY_F2 = PvmNodeActions.gotoRoot;
                    tagAttribute.KeyF2 = String(chDisplay);
                    nParsedAtt += 1;
                    if (chAction.elementsEqual("Next"))
                    {
                        tagAttribute.KEY_F2 = PvmNodeActions.gotoChild;
                    }
                    else if (chAction.elementsEqual("bk"))
                    {
                        tagAttribute.KEY_F2 = PvmNodeActions.goBack;
                    }
                    else if (chAction.elementsEqual("ext"))
                    {
                        tagAttribute.KEY_F2 = PvmNodeActions.gotoRoot;
                    }
                    else if (chAction.elementsEqual("go"))
                    {
                        tagAttribute.KEY_F2 = PvmNodeActions.goOnline;
                    }
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("Key_F3"))
            {
                let strKey_F3 = strArrAttributeValue[nIndex].split(separator: ",");
                if (strKey_F3.count == 2)
                {
                    let chAction = strKey_F3[0];
                    let chDisplay = strKey_F3[1];
                    tagAttribute.KEY_F3 = PvmNodeActions.gotoRoot;
                    tagAttribute.KeyF3 = String(chDisplay);
                    nParsedAtt += 1;
                    if (chAction.elementsEqual("Next"))
                    {
                        tagAttribute.KEY_F3 = PvmNodeActions.gotoChild;
                    }
                    else if (chAction.elementsEqual("bk"))
                    {
                        tagAttribute.KEY_F3 = PvmNodeActions.goBack;
                    }
                    else if (chAction.elementsEqual("ext"))
                    {
                        tagAttribute.KEY_F3 = PvmNodeActions.gotoRoot;
                    }
                    else if (chAction.elementsEqual("go"))
                    {
                        tagAttribute.KEY_F3 = PvmNodeActions.goOnline;
                    }
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("Key_F4"))
            {
                let  strKey_F4 = strArrAttributeValue[nIndex].split(separator: ",");
                if(strKey_F4.count == 2)
                {
                    let chAction = strKey_F4[0];
                    let chDisplay = strKey_F4[1];
                    
                    tagAttribute.KEY_F4 = PvmNodeActions.gotoRoot;
                    tagAttribute.KeyF4 = String(chDisplay);
                    nParsedAtt += 1;
                    if (chAction.elementsEqual("Next"))
                    {
                        tagAttribute.KEY_F4 = PvmNodeActions.gotoChild;
                    }
                    else if (chAction.elementsEqual("bk"))
                    {
                        tagAttribute.KEY_F4 = PvmNodeActions.goBack;
                    }
                    else if (chAction.elementsEqual("ext"))
                    {
                        tagAttribute.KEY_F4 = PvmNodeActions.gotoRoot;
                    }
                    else if (chAction.elementsEqual("go"))
                    {
                        tagAttribute.KEY_F4 = PvmNodeActions.goOnline;
                    }
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("Key_Enter"))
            {
                nParsedAtt += 1;
                if (strArrAttributeValue[nIndex].elementsEqual("Next"))
                {
                    tagAttribute.KEY_ENTER = PvmNodeActions.gotoChild;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("bk"))
                {
                    tagAttribute.KEY_ENTER = PvmNodeActions.goBack;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("ext"))
                {
                    tagAttribute.KEY_ENTER = PvmNodeActions.gotoRoot;
                }
            }
            if (strArrAttributeName[nIndex].elementsEqual("Key_Cancel"))
            {
                nParsedAtt += 1;
                if (strArrAttributeValue[nIndex].elementsEqual("Next"))
                {
                    tagAttribute.KEY_CANCEL = PvmNodeActions.gotoChild;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("bk"))
                {
                    tagAttribute.KEY_CANCEL = PvmNodeActions.goBack;
                }
                else if (strArrAttributeValue[nIndex].elementsEqual("ext"))
                {
                    tagAttribute.KEY_CANCEL = PvmNodeActions.gotoRoot;
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("em"))
            {
                let _:[Byte] = [Byte](repeating: 0, count: 3);
                nParsedAtt += 1;
                let szAtrribute:String  =  strArrAttributeValue[nIndex];
                if (!(szAtrribute.starts(with:"0x"))) {
                    if var tempEventMask=TransactionUtils.a2bcd(szAtrribute.bytes)
                    {
                        tagAttribute.IsExtendedEventMask = (tempEventMask[0] & 0x80) == 0x80 ? true: false;
                        if (tagAttribute.IsExtendedEventMask)
                        {
                            tempEventMask[0..<2] = tagAttribute.ExtendedEventMask[0..<2]
                        }
                    }
                }
                else
                {
                    let byte: UInt8 = Array(String(szAtrribute).utf8)[0]
                    tagAttribute.EventMask = byte
                }
                
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("itc")) {
                nParsedAtt += 1;
                tagAttribute.numberOFItemsInMenuList = Int(strArrAttributeValue[nIndex]) ?? 0;
                if (tagAttribute.numberOFItemsInMenuList > 0) {
                    tagAttribute.ItemList = [String](repeating:"", count:tagAttribute.numberOFItemsInMenuList);
                    var cIndex = 0, itemCount = 0;
                    while ((cIndex < nTotal) && (itemCount < tagAttribute.numberOFItemsInMenuList)) {
                        let itemno = "it" + String(itemCount + 1);
                        var ItemList =  tagAttribute.ItemList?[itemCount]
                        ItemList = nil;
                        if (strArrAttributeName[cIndex].elementsEqual(itemno)) {
                            nParsedAtt += 1;
                            tagAttribute.ItemList?[itemCount] = strArrAttributeValue[cIndex];
                            itemCount += 1 ;
                            nIndex = nIndex+1;
                        }
                        cIndex += 1;
                    }
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("imgc"))
            {
                nParsedAtt += 1;
                tagAttribute.numberOFImages = Int(strArrAttributeValue[nIndex]) ?? 0;
                if (tagAttribute.numberOFImages > 0) {
                    tagAttribute.ItemListImages = Array<ImageListParserModel>();
                    var cIndex = 0, itemCount = 0;
                    while ((cIndex < nTotal) && (itemCount < tagAttribute.numberOFImages))
                    {
                        for _ in 0..<tagAttribute.numberOFImages
                        {
                            let itemno = "img";
                            var imageListParserModel = ImageListParserModel();
                            if (strArrAttributeName[nParsedAtt].starts(with: itemno) && !strArrAttributeName[cIndex].contains("c"))
                            {
                                imageListParserModel.tagName = (strArrAttributeName[nParsedAtt]);
                                imageListParserModel.tagValue = (strArrAttributeValue[nParsedAtt]);
                                tagAttribute.ItemListImages?.append(imageListParserModel);
                                nParsedAtt += 1;
                                itemCount += 1;
                                nIndex += 1;
                            }
                        }
                        cIndex += 1;
                    }
                }
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("sk"))
            {
                //System.arraycopy(szAttributeValue[nIndex], 0, tagAttribute.SessionKey, 0, szAttributeValue[nIndex].length());
                tagAttribute.SessionKey = strArrAttributeValue[nIndex].bytes;
                nParsedAtt += 1;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("ks"))
            {
                tagAttribute.iKeySlot = Int(strArrAttributeValue[nIndex]) ?? 0;
                nParsedAtt += 1;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("usehtl"))
            {
                tagAttribute.useHtlForTag = Int(strArrAttributeValue[nIndex]) == 1 ? true : false;
                nParsedAtt += 1;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("PadChar"))
            {
                //tagAttribute.chPadChar = Byte.parseByte(szAttributeValue[nIndex]);
                if(!strArrAttributeValue[nIndex].isEmpty) {
                    let szAttributeValue =  strArrAttributeValue[nIndex]
                    tagAttribute.chPadChar =  Array(String(szAttributeValue.charAt(at: 0)).utf8)[0]
                }
                nParsedAtt += 1;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("Padstyle")) // 0(Left)/1(Right)
            {
                let PADStyle = Int(strArrAttributeValue[nIndex]) ?? 0;
                tagAttribute.iPadStyle = Byte((PADStyle == 0) ? AppConstant._LEFT_PAD: AppConstant._RIGHT_PAD);
                nParsedAtt += 1;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("TLEEnabled"))
            {
                tagAttribute.iTleEnabled = Int(strArrAttributeValue[nIndex]) == 1 ? true : false;
                nParsedAtt += 1;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("iris"))
            {
                tagAttribute.iIsIris = Int(strArrAttributeValue[nIndex]) == 1 ? true : false;
                nParsedAtt += 1;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("grp"))
            {
                tagAttribute.multipleCardPinGrpId = Int(strArrAttributeValue[nIndex]) ?? 0;
                nParsedAtt += 1;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("qcc"))
            {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData.qcc = (Int(strArrAttributeValue[nIndex])) ?? 0 ;
            }
            
            let itemqc = "qc" + String(itemCountQC + 1);
            if (strArrAttributeName[nIndex].elementsEqual(itemqc))
            {
                var qrCodeData =  QRCodeData();
                qrCodeData.qc = (strArrAttributeValue[nIndex].substring(from: 0, to: 2));
                qrCode.append(qrCodeData);
                itemCountQC += 1;
            }
            
            if (qrCode.count > 0)
            {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData.qc = (qrCode);
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("prdc")) {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData.qcc = (Int(strArrAttributeValue[nIndex])) ?? 0;
                
            }
            
            let itempc = "prdc" + String(itemCountPC + 1);
            if (strArrAttributeName[nIndex].elementsEqual(itempc))
            {
                var printd =  PrintData();
                printd.prd = (strArrAttributeValue[nIndex].substring(from: 0, to: 2));
                printData.append(printd);
                itemCountPC += 1;
            }
            
            if (printData.count > 0)
            {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData.prd = printData;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("pod"))
            {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData.pod = Int(strArrAttributeValue[nIndex]) ?? 0;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("qsn"))
            {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData.qsn = (Int(strArrAttributeValue[nIndex])) ?? 0;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("qclen"))
            {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData.qclen = Int(strArrAttributeValue[nIndex]) ?? 0;
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("dmh"))
            {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData.dmh = (strArrAttributeValue[nIndex]);
            }
            
            if (strArrAttributeName[nIndex].elementsEqual("dmf"))
            {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData.dmf = (strArrAttributeValue[nIndex]);
            }
        }
        return tagAttribute;
    }
}

