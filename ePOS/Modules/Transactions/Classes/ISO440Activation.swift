//
//  ISO440Activation.swift
//  ePOS
//
//  Created by Naveen Goyal on 05/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit
import Foundation

class ISO440Activation : ISOMessage
{
        var m_sClientID: String = ""
        var m_sGUID: String = ""
        
        
        func ISO440C()
        {
            //super.CISOMsgC()
        }
        
    
    func Test()
    {
        
    }
        
    override func packIt(sendee bArrSendDataToHost: inout[Byte]) -> Int
        {
            
            /*    ***************************************************************************
             FEILD 0 ::Message Type
             ***************************************************************************/
            msgno = [Byte](ProcessingCodeConstants.ACTIVATIONREQ.utf8)
            //TODO check to write this function in PlatformUtils
//            var bArrHardwareConfig = PlatformUtils.GetHardwareConfiguration()
//            if (bArrHardwareConfig !=null)
//            {
//                _ = addLLLCHARData(IsoFieldConstant.ISO_FIELD_62, bArrHardwareConfig, bArrHardwareConfig.length)
//            }
            return packItHost(sendee: &bArrSendDataToHost)
        }
        
        func SetActivationRequestData()
        {
            /*
             * FEILD 3 ::Processing Code
             */
           _ =  addField(bitno:ISOFieldConstants.ISO_FIELD_3,
                         data1:[Byte](ProcessingCodeConstants.PC_ONLINE_TRANSACTION_REQ.utf8),
                         bcd:true)
            
            vFnSetTerminalActivationFlag(bTerminalActivationFlag:true)
        }
        
        
        func bFnGetTokenDataForHUB() -> Bool
        {
            do
            {
                debugPrint("Inside bFnGetTokenDataForHUB ")
                let globalData = GlobalData.singleton
                var terminalParamData = globalData.ReadParamFile()
                
                
                //Update hardware serial number of TerminalMasterParamData with 49th field
                if bitmap[49 - 1]{
                    let ilenSerialNumber = len[49 - 1]
                    if ilenSerialNumber > 1 {
                        let bArrHardwareSerialNumber = Array(data[49 - 1][0...ilenSerialNumber-1])
                        terminalParamData?.m_strHardwareSerialNumber = String(bytes: bArrHardwareSerialNumber, encoding: String.Encoding.ascii)!
                        debugPrint("Hardware Serial Number[\(bArrHardwareSerialNumber)] Hardware serial number length = [\(ilenSerialNumber)]")
                    }
                }
                // Get Client ID and Security Token
                if (bitmap[47 - 1])
                {
                    let ilenField47Data = len[47 - 1]
                    let bArrField47Data = Array(data[47 - 1][0..<ilenField47Data])
                    
                    var iOffset = 0
                    
                    if (ilenField47Data < 2) {
                        return false
                    }
                    
                    //Parsing ClientID
                    let ilenClientID = Int(bArrField47Data[iOffset])
                    iOffset += 1
                    if ilenClientID>0
                    {
                        let bArrClientID = Array(bArrField47Data[iOffset..<iOffset+ilenClientID])
                        iOffset += ilenClientID
                        terminalParamData?.m_strClientId = String(bytes: bArrClientID, encoding: String.Encoding.ascii)!
                        m_sClientID = terminalParamData!.m_strClientId 
                        debugPrint("ClientID[\(m_sClientID)] ClientID Length = [\(ilenClientID)]")
                    }
                    
                    let ilenSecurityToken = Int(bArrField47Data[iOffset])
                    iOffset += 1
                    if ilenSecurityToken>0
                    {
                        let bArrSecurityToken = Array(bArrField47Data[iOffset..<iOffset+ilenSecurityToken])
                        iOffset += ilenSecurityToken
                        terminalParamData?.m_strSecurityToken = String(bytes: bArrSecurityToken, encoding: String.Encoding.ascii)!
                        
                        iOffset += Int(ilenSecurityToken)
                        debugPrint("SecurityToken[\(String(describing: terminalParamData?.m_strSecurityToken))] Security token Length = [\(ilenSecurityToken)]")
                    }
                }
                else
                {
                    debugPrint("Client ID Security Token Not Present")
                    return false
                }
                
                // Get Secret GUID
                if (bitmap[51 - 1])
                {
                    let ilenGUID = len[51 - 1]
                    if ilenGUID>0
                    {
                        terminalParamData?.m_strGUID = String(bytes: data[51 - 1],encoding: String.Encoding.ascii)!
                        m_sGUID = terminalParamData!.m_strGUID
                        
                        debugPrint("Guid[\(m_sClientID)] ClientID Length = [\(ilenGUID)]")
                    }
                }
                else {
                    debugPrint("Secret GUID not present")
                    return false
                }
                
                _ = globalData.WriteParamFile(listParamData:terminalParamData)
                vFnSetTerminalActivationFlag(bTerminalActivationFlag: false)
                return true
            }
            catch
            {
                fatalError("Exception in bFnGetTokenDataForHUB()")
                return false
            }
            
        }
        
    }
