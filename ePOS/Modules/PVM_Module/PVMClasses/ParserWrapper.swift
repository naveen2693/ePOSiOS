//
//  XMLParser.swift
//  ePOS
//
//  Created by Abhishek on 02/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public class ParserWrapper {
    private class CStackNode {
        var this_node:CBaseNode?;
        var  next_node:CStackNode?;
        
        private init() {
            this_node = nil;
            next_node = nil;
        }
        
        // MARK:- TopNode
        private static func TopNode() -> CStackNode? {
            return TopofStack;
        }
        
        // MARK:- PushNode
        internal static func  PushNode(addThisNode:CBaseNode) -> CStackNode? {
            let tmpNode = CStackNode();
            tmpNode.next_node = TopofStack;
            tmpNode.this_node = addThisNode;
            TopofStack = tmpNode;
            return TopofStack;
        }
        
        // MARK:- PopNode
        internal static func  PopNode() -> CStackNode? {
            if var tmpNode:ParserWrapper.CStackNode? = TopNode(){
                TopofStack = tmpNode?.next_node;
                tmpNode = nil;
                return TopofStack;
            }
        }
    }
    
    private static var TopofStack:CStackNode?;
    private var pnDepth = 0 ;
    private var currentNode:CBaseNode?;
    private var parenNode:CBaseNode?;
    
    // MARK:- PushNewnode
    private func PushNewnode(icurrentNode:CBaseNode) {
       _ = CStackNode.PushNode(addThisNode: icurrentNode)
    }
    
    // MARK:- PopNode
    public func PopNode() {
            pnDepth = pnDepth-1;
        
    }
    
    // MARK:- AddNewNode
    public func AddNewNode(szAttributeName:[String],szAttributeValue:[String], nTotal:Int) {
        var nParsedAttributes = 0;
        var newNode:CBaseNode?;
        var tagAttribute =  XMLATTRIBUTE();
        nParsedAttributes = ParseNodeAttributes(tagAttributeValue: tagAttribute, szAttributeName: szAttributeName, szAttributeValue: szAttributeValue, nTotal: nTotal);
        parenNode = currentNode;
        /** CREATE NEW NODE BASED ON THE NODE TYPE **/
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
        case PvmNodeTypes.Invalid_node:
            break;
        default:
            break;
        }
        
        if (parenNode != nil) {
            tagAttribute.parenNode = parenNode;
        }
        newNode?.AddParameters(tagAttribute: tagAttribute, nTotal: nTotal);
        
        if let node = newNode{
            PushNewnode(icurrentNode: node);
            pnDepth += 1;
            
            var currentParentNode:CBaseNode?;
            if (ParserWrapper.TopofStack?.next_node != nil) {
                currentParentNode = ParserWrapper.TopofStack?.next_node?.this_node;
                _ = currentParentNode?.AddChild(addThisNode: node);
                if let currentPNode = currentParentNode{
                    _ = node.AddParent(cparentNode: currentPNode);
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
    }
    
    // MARK:- SaveRootNode
    func SaveRootNode()
    {
        if let node = currentNode{
            CStateMachine.stateMachine.SetRootNode(currentNode: node);
        }
    }
    
    // MARK:- ParseNodeAttributes
    func ParseNodeAttributes(tagAttributeValue:XMLATTRIBUTE,szAttributeName:[String],  szAttributeValue:[String],nTotal:Int) -> Int {
        var nParsedAtt = 0;
        var qrCode = [QRCodeData]();
        var itemCountQC = 0;
        var printData = [PrintData]();
        var itemCountPC = 0;
        var tagAttribute =  tagAttributeValue
        tagAttribute.qrCodeParsingData =  QRCodeParsingData();
        for var nIndex in 0..<nTotal {
            if (szAttributeName[nIndex].elementsEqual("nt")) {
                nParsedAtt += 1
                tagAttribute.node_type = Int(szAttributeValue[nIndex]) ?? 0;
            }
            if (szAttributeName[nIndex].elementsEqual("vc")) {
                nParsedAtt += 1
                tagAttribute.ListViewcode = Int(szAttributeValue[nIndex]) ?? 0;
            }
            if (szAttributeName[nIndex].elementsEqual("sdtr")) {
                nParsedAtt += 1
                tagAttribute.soundTrack = szAttributeValue[nIndex];
            }
            if (szAttributeName[nIndex].elementsEqual("nm")) {
                nParsedAtt += 1
                tagAttribute.iName = szAttributeValue[nIndex];
            }
            
            if (szAttributeName[nIndex].elementsEqual("img")) {
                nParsedAtt += 1
                tagAttribute.iNameImage = szAttributeValue[nIndex];
            }
            if (szAttributeName[nIndex].elementsEqual("cas")) {
                nParsedAtt += 1
                tagAttribute.cascading = Int(szAttributeValue[nIndex]) ?? 0;
                
            }
            if (szAttributeName[nIndex].elementsEqual("to")) {
                nParsedAtt += 1
                tagAttribute.Timeout = Int(szAttributeValue[nIndex])  ?? 0;
            }
            
            if (szAttributeName[nIndex].elementsEqual("brlv")) {
                nParsedAtt += 1;
                tagAttribute.brightnessLevel = Int(szAttributeValue[nIndex])  ?? 0;
            }
            if (szAttributeName[nIndex].elementsEqual("gtor")) {
                nParsedAtt += 1;
                tagAttribute.goToOrignalBrightness = Int(szAttributeValue[nIndex])  ?? 0;
            }
            if (szAttributeName[nIndex].elementsEqual("isLatLong")) {
                nParsedAtt += 1;
                tagAttribute.IsLatLong = Int(szAttributeValue[nIndex]) == 1 ? true : false;
            }
            if (szAttributeName[nIndex].elementsEqual("ok")) {
                nParsedAtt += 1;
                if (szAttributeValue[nIndex].elementsEqual("Next")) {
                    tagAttribute.onOk = PvmNodeActions.gotoChild;
                } else if (szAttributeValue[nIndex].elementsEqual("bk")) {
                    tagAttribute.onOk = PvmNodeActions.goBack;
                } else if (szAttributeValue[nIndex].elementsEqual("ext")) {
                    tagAttribute.onOk = PvmNodeActions.gotoRoot;
                } else if (szAttributeValue[nIndex].elementsEqual("et")) {
                    tagAttribute.onOk = PvmNodeActions.gotoRoot;
                } else if (szAttributeValue[nIndex].elementsEqual("go")) {
                    tagAttribute.onOk = PvmNodeActions.goOnline;
                }
            }
            if (szAttributeName[nIndex].elementsEqual("can")) {
                nParsedAtt += 1;
                if (szAttributeValue[nIndex].elementsEqual("Next")) {
                    tagAttribute.onCancel = PvmNodeActions.gotoChild;
                } else if (szAttributeValue[nIndex].elementsEqual("bk")) {
                    tagAttribute.onCancel = PvmNodeActions.goBack;
                } else if (szAttributeValue[nIndex].elementsEqual("ext")) {
                    tagAttribute.onCancel = PvmNodeActions.gotoRoot;
                } else if (szAttributeValue[nIndex].elementsEqual("et")) {
                    tagAttribute.onCancel = PvmNodeActions.gotoRoot;
                } else if (szAttributeValue[nIndex].elementsEqual("go")) {
                    tagAttribute.onCancel = PvmNodeActions.goOnline;
                }
            }
            if (szAttributeName[nIndex].elementsEqual("oto")) {
                nParsedAtt += 1;
                if (szAttributeValue[nIndex].elementsEqual("Next")) {
                    tagAttribute.onTimeout = PvmNodeActions.gotoChild;
                } else if (szAttributeValue[nIndex].elementsEqual("bk")) {
                    tagAttribute.onTimeout = PvmNodeActions.goBack;
                } else if (szAttributeValue[nIndex].elementsEqual("ext")) {
                    tagAttribute.onTimeout = PvmNodeActions.gotoRoot;
                } else if (szAttributeValue[nIndex].elementsEqual("et")) {
                    tagAttribute.onOk = PvmNodeActions.gotoRoot;
                } else if (szAttributeValue[nIndex].elementsEqual("go")) {
                    tagAttribute.onTimeout = PvmNodeActions.goOnline;
                }
            }
            if (szAttributeName[nIndex].elementsEqual("Onet")) {
                nParsedAtt += 1;
                if (szAttributeValue[nIndex].elementsEqual("Next")) {
                    tagAttribute.onExit = PvmNodeActions.gotoChild;
                } else if (szAttributeValue[nIndex].elementsEqual("bk")) {
                    tagAttribute.onExit = PvmNodeActions.goBack;
                } else if (szAttributeValue[nIndex].elementsEqual("ext")) {
                    tagAttribute.onExit = PvmNodeActions.exitPvm;
                } else if (szAttributeValue[nIndex].elementsEqual("go")) {
                    tagAttribute.onExit = PvmNodeActions.goOnline;
                }
            }
            if (szAttributeName[nIndex].elementsEqual("htl")) {
                nParsedAtt += 1;
                var hostTag = CUtil.a2bcd(s: szAttributeValue[nIndex].bytes);
                tagAttribute.HostTlvtag = Int(hostTag[0]<<8) & 0x0000FF00;
                tagAttribute.HostTlvtag |= Int((hostTag[1])) & 0x000000FF;
            }
            if (szAttributeName[nIndex].elementsEqual("hat")) {
                nParsedAtt += 1;
                var hostTag = CUtil.a2bcd(s: szAttributeValue[nIndex].bytes);
                tagAttribute.HostTlvtag = Int(hostTag[0]<<8) & 0x0000FF00;
                tagAttribute.HostTlvtag |= Int((hostTag[1])) & 0x000000FF;
            }
            if (szAttributeName[nIndex].elementsEqual("isSignCap")) {
                nParsedAtt += 1;
                tagAttribute.IsSignCapture = Int(szAttributeValue[nIndex]) == 1 ? true : false;
            }
            if (szAttributeName[nIndex].elementsEqual("isFontId")) {
                nParsedAtt += 1;
                tagAttribute.fontId = Int(szAttributeValue[nIndex]) ?? 0;
            }
            if (szAttributeName[nIndex].elementsEqual("ISOType")) {
                nParsedAtt += 1;
                tagAttribute.ISOType = Int(szAttributeValue[nIndex]) ?? 0;
            }
            if (szAttributeName[nIndex].elementsEqual("rtc")) {
                nParsedAtt += 1;
                tagAttribute.RetryCount = Int(szAttributeValue[nIndex]) ?? 0;
            }
            if (szAttributeName[nIndex].elementsEqual("rtcto")) {
                nParsedAtt += 1;
                tagAttribute.RetryCountTimeOut = Int(szAttributeValue[nIndex]) ?? 0;
            }
            
            if (szAttributeName[nIndex].elementsEqual("htt")) {
                nParsedAtt += 1;
                tagAttribute.iHostType = Int(szAttributeValue[nIndex]) ?? 0;
            }
            if (szAttributeName[nIndex].elementsEqual("vt")) {
                nParsedAtt += 1;
                tagAttribute.viewType = szAttributeValue[nIndex];
            }
            if (szAttributeName[nIndex].elementsEqual("fn")) {
                nParsedAtt += 1;
                tagAttribute.fileName = szAttributeValue[nIndex];
            }
            if (szAttributeName[nIndex].elementsEqual("iss")) {
                nParsedAtt += 1;
                tagAttribute.IsOnSSL = Int(szAttributeValue[nIndex]) ?? 0;
            }
            if (szAttributeName[nIndex].elementsEqual("isUTF8")) {
                nParsedAtt += 1;
                tagAttribute.IsUTF8 = Int(szAttributeValue[nIndex]) == 1 ? true : false;
            }
            if (szAttributeName[nIndex].elementsEqual("amt")) {
                nParsedAtt += 1;
                tagAttribute.chAmount = szAttributeValue[nIndex];
            }
            if (szAttributeName[nIndex].elementsEqual("cur")) {
                nParsedAtt += 1;
                tagAttribute.chCurrencyCode = szAttributeValue[nIndex];
            }
            if (szAttributeName[nIndex].elementsEqual("ti")) {
                nParsedAtt += 1;
                tagAttribute.Title = szAttributeValue[nIndex];
            }
            if (szAttributeName[nIndex].elementsEqual("name")) {
                nParsedAtt += 1;
                tagAttribute.Title = tagAttribute.iName;
            }
            if (szAttributeName[nIndex].elementsEqual("ix")) {
                nParsedAtt += 1;
                tagAttribute.ItemIndex = Int(szAttributeValue[nIndex]) ?? 0;
            }
            if (szAttributeName[nIndex].elementsEqual("scntyp")) {
                nParsedAtt += 1;
                tagAttribute.ScanType = szAttributeValue[nIndex];
            }
            if (szAttributeName[nIndex].elementsEqual("dm")) {
                // For UniCode UTF8 display messages
                if (tagAttribute.IsUTF8) {
                    let utf16len:Int = 0;
                    _ = (szAttributeValue[nIndex], szAttributeValue[nIndex].count, tagAttribute.DisplayMessage, utf16len);
                    tagAttribute.DisplayMessagelen = utf16len;
                    nParsedAtt += 1;
                } else {
                    nParsedAtt += 1;
                    let szattributeString = szAttributeValue[nIndex]
                    tagAttribute.DisplayMessage = szattributeString.replacingOccurrences(of: "\\", with:"\n")
                }
            }
            if (szAttributeName[nIndex].elementsEqual("dm2")) {
                if (tagAttribute.IsUTF8) {
                     tagAttribute.DisplayMessageLine2len = szAttributeValue[nIndex].count;
                    nParsedAtt += 1;
                } else {
                    tagAttribute.DisplayMessageLine2 = szAttributeValue[nIndex];
                    nParsedAtt += 1;
                }
            }
            
            if (szAttributeName[nIndex].elementsEqual("dm3")) {
                if (tagAttribute.IsUTF8) {
                    tagAttribute.DisplayMessageLine3len = szAttributeValue[nIndex].count;
                    nParsedAtt += 1;
                } else {
                    tagAttribute.DisplayMessageLine3 = szAttributeValue[nIndex];
                    nParsedAtt += 1;
                }
            }
            
            if (szAttributeName[nIndex].elementsEqual("dm4")) {
                if (tagAttribute.IsUTF8) {
                    tagAttribute.DisplayMessageLine4len = szAttributeValue[nIndex].count;
                    nParsedAtt += 1;
                } else {
                    tagAttribute.DisplayMessageLine4 = szAttributeValue[nIndex];
                    nParsedAtt += 1;
                }
            }
            if (szAttributeName[nIndex].elementsEqual("ide")) {
                nParsedAtt += 1;
                tagAttribute.isIdeFlagEnabled = Int(szAttributeValue[nIndex]) == 1;
            }
            
            if (szAttributeName[nIndex].elementsEqual("totc")) {
                nParsedAtt += 1;
                tagAttribute.numberOFItems = Int(szAttributeValue[nIndex]) ?? 0;
                if (tagAttribute.numberOFItems > 0) {
                    tagAttribute.pvmListParser = Array<PvmListParserVO>();
                    var isvaluepresent = false;
                    var itemCount:Int = 0;
                    for _ in 0..<tagAttribute.numberOFItems {
                        isvaluepresent = false;
                        var pvmListParserVO = PvmListParserVO();
                        var cIndex = 0;
                        while ((cIndex < nTotal) ) {
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
                            
                            if (szAttributeName[cIndex].elementsEqual(itemal)) {
                                pvmListParserVO.MaxLen = Int(szAttributeValue[cIndex]) ?? 0
                                isvaluepresent = true;
                            }
                            if (szAttributeName[cIndex].elementsEqual(itemil)) {
                                pvmListParserVO.MinLen = Int(szAttributeValue[cIndex]) ?? 0;
                                isvaluepresent = true;
                            }
                            if (szAttributeName[cIndex].elementsEqual(itedm)) {
                                pvmListParserVO.DM = (szAttributeValue[cIndex]);
                                isvaluepresent = true;
                            }
                            if (szAttributeName[cIndex].elementsEqual(itedcn)) {
                                pvmListParserVO.CurrencyName = (szAttributeValue[cIndex]);
                                isvaluepresent = true;
                            }
                            if(szAttributeName[cIndex].elementsEqual(itedec)) {
                                pvmListParserVO.Decimals = (Int(szAttributeValue[cIndex]) ?? 0);
                                isvaluepresent = true;
                            }
                            if(szAttributeName[cIndex].elementsEqual(itetxtye)) {
                                pvmListParserVO.txtye = (szAttributeValue[cIndex]);
                                isvaluepresent = true;
                            }
                            if(szAttributeName[cIndex].elementsEqual(iteregx)) {
                                pvmListParserVO.regx = (szAttributeValue[cIndex]);
                                isvaluepresent = true;
                            }
                            if(szAttributeName[cIndex].elementsEqual(itedval)) {
                                pvmListParserVO.defaultValue = (szAttributeValue[cIndex]);
                                isvaluepresent = true;
                            }
                            if (szAttributeName[cIndex].elementsEqual(itehtl)) {
                                
                                if var hostTag = TransactionUtils.a2bcd(szAttributeValue[cIndex].bytes){
                                    var HTLTag = Int(hostTag[0]<<8) & 0x0000FF00;
                                    HTLTag |= Int(hostTag[1]) & 0x000000FF;
                                    pvmListParserVO.HTL = HTLTag;
                                    isvaluepresent = true;
                                }
                            }
                            if (szAttributeName[cIndex].elementsEqual(itein)) {
                                
                                if (szAttributeValue[cIndex].elementsEqual("num")) {
                                    pvmListParserVO.InputMethod = enum_InputMethod.NUMERIC_ENTRY;
                                } else if (szAttributeValue[cIndex].elementsEqual("aln")) {
                                    pvmListParserVO.InputMethod = enum_InputMethod.ALPHANUMERIC_ENTRY;
                                }
                                isvaluepresent = true;
                            }
                            cIndex += 1;
                        }
                        if (isvaluepresent){
                            nParsedAtt += 1;
                            tagAttribute.pvmListParser?.append(pvmListParserVO);
                            itemCount += 1;
                            nIndex += 1;
                        }
                    }
                }
            }
            
            /********** Multiple QRCode **************/
            if (szAttributeName[nIndex].elementsEqual("tqrc")) {
                nParsedAtt += 1;
                //                    tagAttribute.numberOFItems = Int(szAttrib(uteValue[nIndex])! = nil)           // if total items is more than 0 fill the items here only
                if (tagAttribute.numberOFItems > 0) {
                    // allocate memory for list items to be freed after PVM nodes copied the items
                    tagAttribute.qrcodescanningListParser =  Array<QRCodeScanningParserVO>();
                    var isvaluepresent = false;
                    // have to parse whole node for items
                    var itemCount = 0;
                    for _ in 0..<tagAttribute.numberOFItems {
                        isvaluepresent = false;
                        var qrCodeScanningParserVO = QRCodeScanningParserVO();
                        var cIndex = 0;
                        while ((cIndex < nTotal) ) {
                            let itemal = "mal" + String(itemCount + 1);
                            let itemil = "mil" + String(itemCount + 1);
                            let itedcn = "dcn" + String(itemCount + 1);
                            let itedec = "dec" + String(itemCount + 1);
                            let itein = "in" + String(itemCount + 1);
                            let itedm = "dm" + String(itemCount + 1);
                            let itescntyp = "scntyp" + String(itemCount + 1);
                            let itehtl = "htl" + String(itemCount + 1);
                            
                            
                            if (szAttributeName[cIndex].elementsEqual(itemal)) {
                                qrCodeScanningParserVO.MaxLen = (Int(szAttributeValue[cIndex])) ?? 0;
                                isvaluepresent = true;
                            }
                            
                            if (szAttributeName[cIndex].elementsEqual(itemil)) {
                                qrCodeScanningParserVO.MinLen = (Int(szAttributeValue[cIndex])) ?? 0;
                                isvaluepresent = true;
                            }
                            
                            if (szAttributeName[cIndex].elementsEqual(itedm)) {
                                qrCodeScanningParserVO.DM = (szAttributeValue[cIndex]);
                                isvaluepresent = true;
                            }
                            
                            if (szAttributeName[cIndex].elementsEqual(itedcn)) {
                                qrCodeScanningParserVO.CurrencyName = (szAttributeValue[cIndex]);
                                isvaluepresent = true;
                            }
                            if (szAttributeName[cIndex].elementsEqual(itedec)) {
                                qrCodeScanningParserVO.Decimals = (Int(szAttributeValue[cIndex])) ?? 0;
                                isvaluepresent = true;
                            }
                            if (szAttributeName[cIndex].elementsEqual(itehtl)) {
                                if let hostTag:[Byte] = TransactionUtils.a2bcd(szAttributeValue[cIndex].bytes){
                                    var HTLTag = Int(hostTag[0]<<8) & 0x0000FF00;
                                    HTLTag |= Int(hostTag[1]) & 0x000000FF;
                                    
                                    qrCodeScanningParserVO.HTL = (HTLTag);
                                    isvaluepresent =  true;
                                }
                            }
                            if (szAttributeName[cIndex].elementsEqual(itein)) {
                                
                                if (szAttributeValue[cIndex].elementsEqual("num")) {
                                    qrCodeScanningParserVO.InputMethod = (enum_InputMethod.NUMERIC_ENTRY);
                                } else if (szAttributeValue[cIndex].elementsEqual("aln")) {
                                    qrCodeScanningParserVO.InputMethod = (enum_InputMethod.ALPHANUMERIC_ENTRY);
                                }
                                isvaluepresent = true;
                            }
                            if (szAttributeName[cIndex].elementsEqual(itescntyp)) {
                                qrCodeScanningParserVO.scantype = (szAttributeValue[cIndex]);
                                isvaluepresent = true;
                            }
                            
                            cIndex += 1;
                        }
                        if (isvaluepresent){
                            nParsedAtt += 1;
                            tagAttribute.qrcodescanningListParser?.append(qrCodeScanningParserVO);
                            itemCount += 1;
                            nIndex += 1;
                        }
                        
                    }
                }
            }
            if (szAttributeName[nIndex].elementsEqual("mal")) {
                nParsedAtt += 1;
                tagAttribute.MaxLen = Int16(Int(szAttributeValue[nIndex]) ?? 0) ;
            }
            if (szAttributeName[nIndex].elementsEqual("mil")) {
                nParsedAtt += 1;
                tagAttribute.MinLen = Int16(Int(szAttributeValue[nIndex]) ?? 0) ;
            }
            if (szAttributeName[nIndex].elementsEqual("dcn")) {
                nParsedAtt += 1;
                tagAttribute.CurrencyName = szAttributeValue[nIndex];
            }
            if (szAttributeName[nIndex].elementsEqual("dec")) {
                nParsedAtt += 1;
                tagAttribute.Decimals = Int16(Int(szAttributeValue[nIndex]) ?? 0) ;
            }
            if (szAttributeName[nIndex].elementsEqual("in")) {
                if (szAttributeValue[nIndex].elementsEqual("num")) {
                    tagAttribute.InputMethod = enum_InputMethod.NUMERIC_ENTRY;
                } else if (szAttributeValue[nIndex].elementsEqual("aln")) {
                    tagAttribute.InputMethod = enum_InputMethod.ALPHANUMERIC_ENTRY;
                }
                nParsedAtt += 1;
            }
            if (szAttributeName[nIndex].elementsEqual("regx")) {
                tagAttribute.regx = szAttributeValue[nIndex];
                nParsedAtt += 1;
            }
            if (szAttributeName[nIndex].elementsEqual("txtye")) {
                tagAttribute.txtye = szAttributeValue[nIndex];
                nParsedAtt += 1;
            }
            if (szAttributeName[nIndex].elementsEqual("dval")) {
                tagAttribute.dval = szAttributeValue[nIndex];
                nParsedAtt += 1;
            }
            
            /********** CONFIRMATION ************/
            if (szAttributeName[nIndex].elementsEqual("Key_F1")) {
                let strKey_F1 = szAttributeValue[nIndex].split(separator: ",");
                if(strKey_F1.count == 2){
                    let chAction = strKey_F1[0];
                    let chDisplay = strKey_F1[1];
                    tagAttribute.KEY_F1 = PvmNodeActions.gotoRoot;
                    tagAttribute.KeyF1 = String(chDisplay);
                    nParsedAtt += 1;
                    if (chAction.elementsEqual("Next")) {
                        tagAttribute.KEY_F1 = PvmNodeActions.gotoChild;
                    } else if (chAction.elementsEqual("bk")) {
                        tagAttribute.KEY_F1 = PvmNodeActions.goBack;
                    } else if (chAction.elementsEqual("ext")) {
                        tagAttribute.KEY_F1 = PvmNodeActions.gotoRoot;
                    } else if (chAction.elementsEqual("go")) {
                        tagAttribute.KEY_F1 = PvmNodeActions.goOnline;
                    }
                }
            }
            
            if (szAttributeName[nIndex].elementsEqual("Key_F2")) {
                let strKey_F2 = szAttributeValue[nIndex].split(separator: ",");
                if(strKey_F2.count == 2){
                    let chAction = strKey_F2[0];
                    let chDisplay = strKey_F2[1];
                    tagAttribute.KEY_F2 = PvmNodeActions.gotoRoot;
                    tagAttribute.KeyF2 = String(chDisplay);
                    nParsedAtt += 1;
                    if (chAction.elementsEqual("Next")) {
                        tagAttribute.KEY_F2 = PvmNodeActions.gotoChild;
                    } else if (chAction.elementsEqual("bk")) {
                        tagAttribute.KEY_F2 = PvmNodeActions.goBack;
                    } else if (chAction.elementsEqual("ext")) {
                        tagAttribute.KEY_F2 = PvmNodeActions.gotoRoot;
                    } else if (chAction.elementsEqual("go")) {
                        tagAttribute.KEY_F2 = PvmNodeActions.goOnline;
                    }
                }
            }
            
            if (szAttributeName[nIndex].elementsEqual("Key_F3")) {
                let strKey_F3 = szAttributeValue[nIndex].split(separator: ",");
                if (strKey_F3.count == 2) {
                    let chAction = strKey_F3[0];
                    let chDisplay = strKey_F3[1];
                    tagAttribute.KEY_F3 = PvmNodeActions.gotoRoot;
                    tagAttribute.KeyF3 = String(chDisplay);
                    nParsedAtt += 1;
                    if (chAction.elementsEqual("Next")) {
                        tagAttribute.KEY_F3 = PvmNodeActions.gotoChild;
                    } else if (chAction.elementsEqual("bk")) {
                        tagAttribute.KEY_F3 = PvmNodeActions.goBack;
                    } else if (chAction.elementsEqual("ext")) {
                        tagAttribute.KEY_F3 = PvmNodeActions.gotoRoot;
                    } else if (chAction.elementsEqual("go")) {
                        tagAttribute.KEY_F3 = PvmNodeActions.goOnline;
                    }
                }
            }
            
            if (szAttributeName[nIndex].elementsEqual("Key_F4")) {
                let  strKey_F4 = szAttributeValue[nIndex].split(separator: ",");
                if(strKey_F4.count == 2){
                    let chAction = strKey_F4[0];
                    let chDisplay = strKey_F4[1];
                    
                    tagAttribute.KEY_F4 = PvmNodeActions.gotoRoot;
                    tagAttribute.KeyF4 = String(chDisplay);
                    nParsedAtt += 1;
                    if (chAction.elementsEqual("Next")) {
                        tagAttribute.KEY_F4 = PvmNodeActions.gotoChild;
                    } else if (chAction.elementsEqual("bk")) {
                        tagAttribute.KEY_F4 = PvmNodeActions.goBack;
                    } else if (chAction.elementsEqual("ext")) {
                        tagAttribute.KEY_F4 = PvmNodeActions.gotoRoot;
                    } else if (chAction.elementsEqual("go")) {
                        tagAttribute.KEY_F4 = PvmNodeActions.goOnline;
                    }
                }
            }
            
            if (szAttributeName[nIndex].elementsEqual("Key_Enter")) {
                nParsedAtt += 1;
                if (szAttributeValue[nIndex].elementsEqual("Next")) {
                    tagAttribute.KEY_ENTER = PvmNodeActions.gotoChild;
                } else if (szAttributeValue[nIndex].elementsEqual("bk")) {
                    tagAttribute.KEY_ENTER = PvmNodeActions.goBack;
                } else if (szAttributeValue[nIndex].elementsEqual("ext")) {
                    tagAttribute.KEY_ENTER = PvmNodeActions.gotoRoot;
                }
            }
            if (szAttributeName[nIndex].elementsEqual("Key_Cancel")) {
                nParsedAtt += 1;
                if (szAttributeValue[nIndex].elementsEqual("Next")) {
                    tagAttribute.KEY_CANCEL = PvmNodeActions.gotoChild;
                } else if (szAttributeValue[nIndex].elementsEqual("bk")) {
                    tagAttribute.KEY_CANCEL = PvmNodeActions.goBack;
                } else if (szAttributeValue[nIndex].elementsEqual("ext")) {
                    tagAttribute.KEY_CANCEL = PvmNodeActions.gotoRoot;
                }
            }
            
            if (szAttributeName[nIndex].elementsEqual("em")) {
                let _:[Byte] = [Byte](repeating: 0, count: 3);
                nParsedAtt += 1;
                let szAtrribute:String  =  szAttributeValue[nIndex];
                if (!(szAtrribute.starts(with:"0x"))) {
                    if var tempEventMask=TransactionUtils.a2bcd(szAtrribute.bytes){
                        tagAttribute.IsExtendedEventMask = (tempEventMask[0] & 0x80) == 0x80 ? true: false;
                        if (tagAttribute.IsExtendedEventMask) {
                            tempEventMask[0...2] = tagAttribute.ExtendedEventMask[0...2]
                        }
                    }
                }
                else {
                    let byte: UInt8 = Array(String(szAtrribute).utf8)[0]
                    tagAttribute.EventMask = byte
                }
                
            }
            
            /* *************MENU_LIST_NODE************************************** */
            
            // Check for total number of count
            if (szAttributeName[nIndex].elementsEqual("itc")) {
                nParsedAtt += 1;
                tagAttribute.numberOFItemsInMenuList = Int(szAttributeValue[nIndex]) ?? 0;
                
                // if total items is more than 0 fill the items here only
                if (tagAttribute.numberOFItemsInMenuList > 0) {
                    // allocate memory for list items to be freed after PVM nodes copied the items
                    tagAttribute.ItemList = [String](repeating:"", count:tagAttribute.numberOFItemsInMenuList);
                    
                    // have to parse whole node for items
                    var cIndex = 0, itemCount = 0;
                    while ((cIndex < nTotal) && (itemCount < tagAttribute.numberOFItemsInMenuList)) {
                        let itemno = "it" + String(itemCount + 1);
                        var ItemList =  tagAttribute.ItemList?[itemCount]
                        ItemList = nil;
                        if (szAttributeName[cIndex].elementsEqual(itemno)) {
                            nParsedAtt += 1;
                            tagAttribute.ItemList?[itemCount] = szAttributeValue[cIndex];
                            itemCount += 1 ;
                            nIndex = nIndex+1;
                        }
                        cIndex += 1;
                    }
                }
            }
            
            if (szAttributeName[nIndex].elementsEqual("imgc")) {
                nParsedAtt += 1;
                tagAttribute.numberOFImages = Int(szAttributeValue[nIndex]) ?? 0;
                
                // if total items is more than 0 fill the items here only
                if (tagAttribute.numberOFImages > 0) {
                    // allocate memory for list items to be freed after PVM nodes copied the items
                    tagAttribute.ItemListImages = Array<ImageListParserModel>();
                    
                    // have to parse whole node for items
                    var cIndex = 0, itemCount = 0;
                    while ((cIndex < nTotal) && (itemCount < tagAttribute.numberOFImages)) {
                        for _ in 0..<tagAttribute.numberOFImages{
                            let itemno = "img";
                            var imageListParserModel = ImageListParserModel();
                            if (szAttributeName[nParsedAtt].starts(with: itemno) && !szAttributeName[cIndex].contains("c")) {
                                imageListParserModel.tagName = (szAttributeName[nParsedAtt]);
                                imageListParserModel.tagValue = (szAttributeValue[nParsedAtt]);
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
            
            /*
             *  *************SEC_PIN_ENTRY_NODE***********************************
             * ***
             */
            if (szAttributeName[nIndex].elementsEqual("sk")) {
                //System.arraycopy(szAttributeValue[nIndex], 0, tagAttribute.SessionKey, 0, szAttributeValue[nIndex].length());
                tagAttribute.SessionKey = szAttributeValue[nIndex].bytes;
                nParsedAtt += 1;
            }
            if (szAttributeName[nIndex].elementsEqual("ks")) {
                tagAttribute.iKeySlot = Int(szAttributeValue[nIndex]) ?? 0;
                nParsedAtt += 1;
            }
            if (szAttributeName[nIndex].elementsEqual("usehtl")) {
                tagAttribute.useHtlForTag = Int(szAttributeValue[nIndex]) == 1 ? true : false;
                nParsedAtt += 1;
            }
            
            if (szAttributeName[nIndex].elementsEqual("PadChar")) {
                //tagAttribute.chPadChar = Byte.parseByte(szAttributeValue[nIndex]);
                if(!szAttributeValue[nIndex].isEmpty) {
                    let szAttributeValue =  szAttributeValue[nIndex]
                    tagAttribute.chPadChar =  Array(String(szAttributeValue.charAt(at: 0)).utf8)[0]
                }
                nParsedAtt += 1;
            }
            if (szAttributeName[nIndex].elementsEqual("Padstyle")) // 0(Left)/1(Right)
            {
                let PADStyle = Int(szAttributeValue[nIndex]) ?? 0;
                tagAttribute.iPadStyle = Byte((PADStyle == 0) ? AppConstant._LEFT_PAD: AppConstant._RIGHT_PAD);
                nParsedAtt += 1;
            }
            if (szAttributeName[nIndex].elementsEqual("TLEEnabled")) {
                tagAttribute.iTleEnabled = Int(szAttributeValue[nIndex]) == 1 ? true : false;
                nParsedAtt += 1;
            }
            
            if (szAttributeName[nIndex].elementsEqual("iris")) {
                tagAttribute.iIsIris = Int(szAttributeValue[nIndex]) == 1 ? true : false;
                nParsedAtt += 1;
            }
            
            if (szAttributeName[nIndex].elementsEqual("grp")) {
                tagAttribute.multipleCardPinGrpId = Int(szAttributeValue[nIndex]) ?? 0;
                nParsedAtt += 1;
            }
            
            if (szAttributeName[nIndex].elementsEqual("qcc")) {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData?.qcc = (Int(szAttributeValue[nIndex])) ?? 0 ;
            }
            
            let itemqc = "qc" + String(itemCountQC + 1);
            if (szAttributeName[nIndex].elementsEqual(itemqc)) {
                var qrCodeData =  QRCodeData();
                qrCodeData.qc = (szAttributeValue[nIndex].substring(from: 0, to: 2));
                qrCode.append(qrCodeData);
                itemCountQC += 1;
            }
            
            if (qrCode.count > 0) {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData?.qc = (qrCode);
            }
            
            if (szAttributeName[nIndex].elementsEqual("prdc")) {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData?.qcc = (Int(szAttributeValue[nIndex])) ?? 0;
                
            }
            
            let itempc = "prdc" + String(itemCountPC + 1);
            if (szAttributeName[nIndex].elementsEqual(itempc)) {
                var printd =  PrintData();
                printd.prd = (szAttributeValue[nIndex].substring(from: 0, to: 2));
                printData.append(printd);
                itemCountPC += 1;
            }
            
            if (printData.count > 0) {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData?.prd = printData;
            }
            if (szAttributeName[nIndex].elementsEqual("pod")) {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData?.pod = Int(szAttributeValue[nIndex]) ?? 0;
            }
            if (szAttributeName[nIndex].elementsEqual("qsn")) {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData?.qsn = (Int(szAttributeValue[nIndex])) ?? 0;
            }
            if (szAttributeName[nIndex].elementsEqual("qclen")) {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData?.qclen = Int(szAttributeValue[nIndex]) ?? 0;
            }
            
            if (szAttributeName[nIndex].elementsEqual("dmh")) {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData?.dmh = (szAttributeValue[nIndex]);
            }
            if (szAttributeName[nIndex].elementsEqual("dmf")) {
                nParsedAtt += 1;
                tagAttribute.qrCodeParsingData?.dmf = (szAttributeValue[nIndex]);
            }
        }
        return nParsedAtt;
    }
    
//    private func utf8_to_utf16(utf8:String,len:Int,out:String,lenOut:Int) -> Bool  {
//        var bRet = false;
//        let data = utf8.data(using:.utf16)!
//        if String(data: data, encoding: .utf8) != nil{
//            bRet = true;
//        }
//        return bRet
//    }
    
}

