//
//  ChildClass.swift
//  ePOS
//
//  Created by Abhishek on 06/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public class ChildList {
    var index:Int;
    var this_node:CBaseNode?;
    var next_child:ChildList?;
    private var previous_child:ChildList?;
    
    // MARK:- init
    public init() {
        index = 0;
        next_child = nil;
        previous_child = nil;
    }
    
    public init(gIndex:Int) {
        index = gIndex;
        next_child = nil;
        previous_child = nil;
    }
    
    // MARK:-addChild
    func addChild(gIndex:Int,addThisNode:CBaseNode)
    {
        var tempNode:ChildList?, thisNode:ChildList?;
        thisNode = ChildList(gIndex: gIndex)
        thisNode?.index = gIndex
        tempNode = self;
        while (tempNode?.next_child != nil)
        {
            tempNode = tempNode?.next_child;
        }
        thisNode?.this_node = addThisNode;
        thisNode?.previous_child = tempNode;
        tempNode?.next_child = thisNode;
    }
    
    // MARK:-gotoindexedChild
    func gotoindexedChild(gIndex:Int) -> CBaseNode?
    {
        var currentNode:ChildList?;
        currentNode = self
        if (currentNode != nil) {
            var index = 1;
            while (index < gIndex) {
                currentNode = currentNode?.next_child;
                index = index+1;
            }
            return currentNode?.this_node;
        }
        return nil;
    }
    
}
