//
//  XMLParser.swift
//  ePOS
//
//  Created by Abhishek on 06/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public class XmlParser {
    var objParserWrapper:ParserWrapper = ParserWrapper()
    var attributesLength = 0
    
//    func synchronousAppend(_ strArrAttributeName: inout [String], _ strArrAttributeValue: inout [String], _ key: String, _ value: String, completion:  @escaping (Bool) -> Void)
//    {
//        strArrAttributeName.append(key)
//        strArrAttributeValue.append(value)
//        completion(true)
//    }
    
    func parsePVM(_ strData:String)
    {
        
        
        guard let node = XMLNode.node(strData) else {return}
        
        var strArrAttributeName = [String]()
        var strArrAttributeValue = [String]()
        
        
        for (key,value) in node.attributes{
            strArrAttributeName.append(key)
            strArrAttributeValue.append(value)
        }
        
        attributesLength = node.attributes.count
        objParserWrapper.AddNewNode(strArrAttributeName,strArrAttributeValue,attributesLength)
        objParserWrapper.SaveRootNode()
        if(node.children.count>0){
        buildXMLTree(nodeList:node.children)
        }
        objParserWrapper.PopNode();  //popped root node
        //TODO Uncomment below line Added for to check data
        CStateMachine.currentNode = CStateMachine.stateMachine.GetRootNode()
    }
    
    
    // MARK:- buildXMLTree
    private func buildXMLTree(nodeList:[XMLNode])
    {
        for index in 0..<nodeList.count
        {
            var strArrAttributeName = [String]()
            var strArrAttributeValue = [String]()
            for (key,value) in nodeList[index].attributes
            {
                strArrAttributeName.append(key)
                strArrAttributeValue.append(value)
            }
            attributesLength = nodeList[index].attributes.count
            objParserWrapper.AddNewNode(strArrAttributeName,strArrAttributeValue,attributesLength)
            if nodeList[index].children.count>0
            {
                buildXMLTree(nodeList: nodeList[index].children);
            }
            objParserWrapper.PopNode();
        }
    }
}
