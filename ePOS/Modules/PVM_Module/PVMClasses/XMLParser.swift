//
//  XMLParser.swift
//  ePOS
//
//  Created by Abhishek on 06/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public class XmlParser {
   var XMLPVM = 1;
   var XMLCHARGESLIP = 2;
   var XMLS_OK = 0;
   var XMLS_ERROR_PARSING = -1;       
   var CurrentDepth = 0;
    var ParserWrapperObj:ParserWrapper?;
//
//    private func ParseXml() {
//        if let path = Bundle.main.path(forResource: "src", ofType: "xml"),
//        let str = try? String.init(contentsOfFile: path) {
//        if let node = XMLNode.node(str){
//            for index in node.count {
//            Node node = nodeList.item(index);
//            if (node.getNodeType() == Node.ELEMENT_NODE) {
//                if (node.hasAttributes()) {
//                    NamedNodeMap nodeMap = node.getAttributes();
//                    int nAttributesNumber = nodeMap.getLength();
//                    String[] szAttributeName = new String[nAttributesNumber];
//                    String[] szAttributeValue = new String[nAttributesNumber];
//                    for (int i = 0; i < nAttributesNumber; i++) {
//                        Node attribute = nodeMap.item(i);
//                        szAttributeName[i] = attribute.getNodeName();
//                        szAttributeValue[i] = attribute.getNodeValue();
//                    }
//                    ParserWrapperObj.AddNewNode(szAttributeName, szAttributeValue, nAttributesNumber);
//
//                    if(CurrentDepth == 0){
//                        ParserWrapperObj.SaveRootNode();                             // Save root node
//                    }
//                    CurrentDepth++;
//                }
//
//                if (node.hasChildNodes()) {
//                    buildXMLTree(node.getChildNodes());
//                }
//                ParserWrapperObj.PopNode();
//                CurrentDepth--;
//            }
//        }
//    }
//}
}
