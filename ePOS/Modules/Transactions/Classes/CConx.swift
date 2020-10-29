//
//  CConx.swift
//  ePOS
//
//  Created by Vishal Rathore on 24/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CConx {

    var m_iConnType: Int
    var m_iConnIndex: Int
    var m_bConnected: Bool

    
    var TotalSent: Int = 0
    var TotalReceived: Int = 0
    
    private init()
    {
          m_iConnType = 0
          m_iConnIndex = -1
          m_bConnected = false

          //Have to define instance of CCommunication
          // m_Connection = CCommunication.GetInstance();
          // m_SerialConn = new CSerialProtocol();
          // m_ethernetProtocol = new EthernetProtocol();
    }
    
    private static var _shared: CConx?
    
    public static var singleton: CConx {
         get {
             if _shared == nil {
                 DispatchQueue.global().sync(flags: .barrier) {
                     if _shared == nil {
                         _shared = CConx()
                     }
                 }
             }
             return _shared!
         }
    }
    
    //MARK:- isSerial() -> Bool
    static func isSerial() -> Bool
    {
          let serialconx = CConx.singleton
          return serialconx.m_iConnType == AppConstant.DIALUP_SERIAL
    }
    
    //MARK:- disconnect() -> Bool
    func disconnect() -> Bool
    {
        do {
            debugPrint("Inside disconnect, m_bConnected[m_bConnected]")
            if (m_bConnected) {
                
                //TODO: Commuincation and Serial needed
                /*if (m_iConnType == ConnectionTypes.DIALUP_SERIAL && (true == m_SerialConn.m_bSessionOpened)) {
                    m_SerialConn.CloseOnlineSession();

                } else {
                    m_Connection.Disconnect();
                }*/
                debugPrint("disconnected")
            }
            m_bConnected = false;
            return true;
        }
        catch
        {
            debugPrint("Exception Occurred : \(error)")
            return false;
        }
    }
    
}
