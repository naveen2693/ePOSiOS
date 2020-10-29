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
        
        
    override func packIt(sendee bArrSendDataToHost: inout[Byte])->Int
        {
            
            /*    ***************************************************************************
             FEILD 0 ::Message Type
             ***************************************************************************/
            //msgno = AppConst.ACTIVATIONREQ.getBytes();
            //var bArrHardwareConfig = PlatformUtils.GetHardwareConfiguration();
            //            if (bArrHardwareConfig !=null)
            //            {
            //                addLLLCHARData(IsoFieldConstant.ISO_FIELD_62, bArrHardwareConfig, bArrHardwareConfig.length);
            //            }
            //
            return packItHost(sendee: &bArrSendDataToHost);
        }
        
        func SetActivationRequestData()
        {
            /*
             * FEILD 3 ::Processing Code
             */
            //addField(ISOFieldConstants.ISO_FIELD_3,AppConst.PC_ONLINE_TRANSACTION_REQ.getBytes(), true);
            //vFnSetTerminalActivationFlag(true);
        }
        
        
        func bFnGetTokenDataForHUB() -> Bool
        {
            do
            {
                debugPrint("nside bFnGetTokenDataForHUB ");
                let globalData = GlobalData.singleton
                var terminalParamData = globalData.ReadParamFile();
                
                
                //Update hardware serial number of TerminalMasterParamData with 49th field
                if bitmap[49 - 1]{
                    let ilenSerialNumber = len[49 - 1]
                    if ilenSerialNumber > 1 {
                        //var bSerialNumber = new byte[iHardwareSerialNumberLength];
                        var bArrHardwareSerialNumber = [Byte](repeating:0,count:ilenSerialNumber)
                        //                    System.arraycopy(data[49 - 1],0,bSerialNumber,0,iHardwareSerialNumberLength);
                        bArrHardwareSerialNumber[0...ilenSerialNumber-1] = data[49 - 1][0...ilenSerialNumber-1]
                        
                        terminalParamData?.m_strHardwareSerialNumber = String(bytes: bArrHardwareSerialNumber, encoding: String.Encoding.ascii)!
                        debugPrint("Hardware Serial Number[\(bArrHardwareSerialNumber)] Hardware serial number length = [\(ilenSerialNumber)]")
                    }
                }
                // Get Client ID and Security Token
                if (bitmap[47 - 1])
                {
                    let ilenField47Data = len[47 - 1];
                    var bArrField47Data = [Byte](repeating: 0, count: ilenField47Data);
                    
                    //arraycopy
                    bArrField47Data[0...ilenField47Data-1] = data[49 - 1][0...ilenField47Data-1]
                    
                    var iOffset = 0;
                    
                    if (ilenField47Data < 2) {
                        return false;
                    }
                    
                    //Parsing ClientID
                    let ilenClientID = bArrField47Data[iOffset]
                    iOffset+=1
                    if ilenClientID>0
                    {
                        terminalParamData?.m_strClientId = String(bytes: bArrField47Data, encoding: String.Encoding.ascii)!
                        m_sClientID = terminalParamData!.m_strClientId ;
                        iOffset += Int(ilenClientID);
                        debugPrint("ClientID[\(m_sClientID)] ClientID Length = [\(ilenClientID)]")
                    }
                    
                    let ilenSecurityToken = bArrField47Data[iOffset];
                    iOffset += 1
                    if ilenSecurityToken>0
                    {
                        terminalParamData?.m_strSecurityToken = String(bytes: bArrField47Data, encoding: String.Encoding.ascii)!
                        
                        iOffset += Int(ilenSecurityToken);
                        debugPrint("SecurityToken[\(String(describing: terminalParamData?.m_strSecurityToken))] Security token Length = [\(ilenSecurityToken)]")
                    }
                }
                else
                {
                    debugPrint("Client ID Security Token Not Present")
                    return false;
                }
                
                // Get Secret GUID
                if (bitmap[51 - 1])
                {
                    let ilenGUID = len[51 - 1];
                    if ilenGUID>0
                    {
                        terminalParamData?.m_strGUID = String(bytes: data[51 - 1],encoding: String.Encoding.ascii)!
                        m_sGUID = terminalParamData!.m_strGUID;
                        
                        debugPrint("Guid[\(m_sClientID)] ClientID Length = [\(ilenGUID)]")
                    }
                }
                else {
                    debugPrint("Secret GUID not present")
                    return false;
                }
                
                _ = globalData.WriteParamFile(listParamData:terminalParamData);
                //vFnSetTerminalActivationFlag(false);
                return true;
            }
            catch
            {
                fatalError()
                return false
            }
            
        }
        
    }
