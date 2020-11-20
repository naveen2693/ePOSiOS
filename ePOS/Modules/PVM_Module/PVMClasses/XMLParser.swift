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
    var objParserWrapper:ParserWrapper = ParserWrapper();
    var szAttributeName = [String]()
    var szAttributeValue = [String]()
    var currentDepth = 0
    var attributesLength = 0
    
    // MARK:- parsePVM
    func parsePVM(xmlType:Int)
    {
        switch (xmlType)
        {
        case XMLPVM:
            if let path = Bundle.main.path(forResource: "COD", ofType: "xml"),
                let str = try? String.init(contentsOfFile: path)
            {
                if let node = XMLNode.node(str)
                {
                    for (key,value) in node.attributes
                    {
                        szAttributeName.append(key)
                        szAttributeValue.append(value)
                    }
                    attributesLength = node.attributes.count
                    objParserWrapper.AddNewNode(szAttributeName: szAttributeName, szAttributeValue: szAttributeValue, nTotal:attributesLength);
                    objParserWrapper.SaveRootNode();
                    buildXMLTree(nodeList:node.children)
                }
            }
        case XMLCHARGESLIP:
            break;
        default:
            break
        }
    }
    
    // MARK:- buildXMLTree
    private func buildXMLTree(nodeList:[XMLNode])
    {
        for index in 0..<nodeList.count
        {
            for (key,value) in nodeList[index].attributes
            {
                szAttributeName.append(key)
                szAttributeValue.append(value)
            }
            attributesLength = nodeList[index].attributes.count
            objParserWrapper.AddNewNode(szAttributeName: szAttributeName, szAttributeValue: szAttributeValue, nTotal:attributesLength);
            if nodeList[index].children != nil
            {
                buildXMLTree(nodeList: nodeList[index].children);
            }
            else
            {
                break;
            }
            currentDepth += 1;
            objParserWrapper.PopNode();
            CurrentDepth -= 1;
        }
    }
    
}
