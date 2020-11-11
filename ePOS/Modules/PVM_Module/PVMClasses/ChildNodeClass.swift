//
//  ChildClass.swift
//  ePOS
//
//  Created by Abhishek on 06/11/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public class ChildClass {
    var index:Int;
    var this_node:CBaseNode?;
    var next_child:ChildClass?;
    private var previous_child:ChildClass?;
    
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
    
    func addChild(gIndex:Int,addThisNode:CBaseNode) -> Int {
        let retVal = RetVal.RET_OK;
        var tmpNode:ChildClass?, thisNode:ChildClass?;
        thisNode = ChildClass(gIndex: gIndex)
        thisNode?.index = gIndex
        tmpNode = self;
        while (tmpNode?.next_child != nil) {
            tmpNode = tmpNode?.next_child;
        }
        thisNode?.this_node = addThisNode;
        thisNode?.previous_child = tmpNode;
        tmpNode?.next_child = thisNode;
        return retVal;
    }
    
    func gotoindexedChild(gIndex:Int) -> CBaseNode? {
        var currentNode:ChildClass?;
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
    
    func gotopreviousChild() -> CBaseNode? {
        if(self.previous_child != nil) {
            return (self.previous_child?.this_node);
        } else {
            return nil;
        }
    }
}
