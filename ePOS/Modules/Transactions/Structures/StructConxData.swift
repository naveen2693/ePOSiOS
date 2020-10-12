//
//  StructConxData.swift
//  ePOS
//
//  Created by Abhishek on 08/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation
public struct StructConxData
{
 var bConnectionChangedFlag = false;
 var LastTriedConnType = 0;
 var LastConnectedConnType = 0;
 var m_bArrConnIndex = StructConnIndex();
 var LastTriedIPType = 0;
}
