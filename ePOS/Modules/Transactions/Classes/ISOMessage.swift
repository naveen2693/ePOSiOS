//
//  ISOMessage.swift
//  ePOS
//
//  Created by Naveen Goyal on 06/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class ISOMessage{
    
    var ISO_LEN: Int = 64
    
    var data = [[Byte]](repeating:withUnsafeBytes(of: 0x00, Array.init), count: AppConstant.ISO_LEN)
    
    var msgno = [Byte](repeating: 0x00, count: AppConstant.ISO_LEN_MTI)
    
    var bitmap = [Bool](repeating: false, count: AppConstant.ISO_LEN)
    
    var encryptedFieldBitmap =  [Bool](repeating: false, count: AppConstant.ISO_LEN)
    
    var len = [Int](repeating: -1, count: 64)

    var m_TPDU = [Byte](repeating: 0x00, count: AppConstant.MAX_LEN_TPDU)

    var m_chArrHardwareSerialNumber = [Byte](repeating: 0x00, count: AppConstant.MAX_LEN_HARDWARE_SERIAL_NUMBER)
    
    var m_chArrISOPacketDate = [Byte](repeating: 0x00, count: AppConstant.MAX_LEN_DATE_TIME)
    
    var m_bIsTerminalActivationPacket: Bool = false
    
    var m_bField7PrintPAD: Bool = false
    
    //MARK:- CISOMsgC()
    func CISOMsgC()
    {
        for i in 0 ..< AppConstant.ISO_LEN
        {
            data[i] = [0x00]
            bitmap[i] = false
            encryptedFieldBitmap[i] = false
            len[i] = -1
        }
    }
    
    //MARK:- CISOMsgD()
    func CISOMsgD() {
        debugPrint("Inside CISOMsgD");
        for i in 0 ..< AppConstant.ISO_LEN {
             if (nil != self.data[i]) {
                 self.data[i] = [0x00]
             }
             self.data[i] = [0x00]
             self.len[i] = 0
             self.bitmap[i] = false
             self.encryptedFieldBitmap[i] = false
         }
     }
    
    //MARK:- vFnSetPEDHardwareSerialNumer()
    func vFnSetPEDHardwareSerialNumer() {
        do {
            debugPrint("Inside vFnSetPEDHardwareSerialNumer")
            guard let bArrHarwareSerialNumber = PlatFormUtils.GetHardWareSerialNumber()
            else{
                return
            }
            var iLenHardwareSerialNum: Int = bArrHarwareSerialNumber.count

            if (iLenHardwareSerialNum <= AppConstant.MAX_LEN_HARDWARE_SERIAL_NUMBER) {
                //Array Sliced assign new one
                 m_chArrHardwareSerialNumber = Array(bArrHarwareSerialNumber[0 ..< iLenHardwareSerialNum])
              } else {
                m_chArrHardwareSerialNumber = Array(bArrHarwareSerialNumber[0 ..< AppConstant.MAX_LEN_HARDWARE_SERIAL_NUMBER])
                iLenHardwareSerialNum = AppConstant.MAX_LEN_HARDWARE_SERIAL_NUMBER
              }
              /**ADD to feild 49 PED HADRWARE SERIAL NUMBER **/
            let buffer = m_chArrHardwareSerialNumber
            _ = self.addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_49, data1: buffer, length: buffer.count)
            debugPrint("Field 49 (m_chArrHardwareSerialNumber) \(m_chArrHardwareSerialNumber)")
        } catch {
            debugPrint("Exception Occurred : \(error)")
        }
    }
    
    //MARK:- vFnSetHardwareSerialNumber()
    func vFnSetHardwareSerialNumber() {
        do {
            debugPrint("Insert vFnSetHardwareSerialNumber")
            var buffer = [Byte](repeating: 0x00, count: 150)
            var iOffset: Int = 0x00;
            
            guard var bArrHardwareSerialNumber = PlatFormUtils.getFullSerialNumber() else {return}
            
            var iLenHardwareSerialNum: Int = bArrHardwareSerialNumber.count

            if (iLenHardwareSerialNum > AppConstant.MAX_LEN_HARDWARE_SERIAL_NUMBER) {
                bArrHardwareSerialNumber = Array(bArrHardwareSerialNumber[0 ..< AppConstant.MAX_LEN_HARDWARE_SERIAL_NUMBER])
                iLenHardwareSerialNum = AppConstant.MAX_LEN_HARDWARE_SERIAL_NUMBER
            }
            
            /**ADD to feild 59 HADRWARE SERIAL NUMBER **/
            buffer[iOffset] = (Byte)(iLenHardwareSerialNum & 0x000000ff)
            iOffset = iOffset + 1
            
            buffer[iOffset..<iOffset+iLenHardwareSerialNum] = bArrHardwareSerialNumber[0 ..< iLenHardwareSerialNum]
            
            iOffset += iLenHardwareSerialNum
            
            debugPrint("SET->Field 59 (HardwareSerialNum)[\(String(describing: String(bytes: bArrHardwareSerialNumber, encoding: String.Encoding.utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)))]")
            
            

            /** PVM VERSION **/
            /*****************************************************************
            *  If pvm.txt does not exist on the file system then set pvm version as 0000.
            * ****************************************************************/
            var ulPvmVersion: Int64 = 0
            if (true == FileSystem.IsFileExist(strFileName: FileNameConstants.PVMFILE)) {
                let globalData: GlobalData = GlobalData.singleton
                _ = globalData.ReadMasterParamFile()
                
                if (globalData.m_sMasterParamData!.ulPvmVersion >= 0) {
                    ulPvmVersion = globalData.m_sMasterParamData!.ulPvmVersion
                }
            }
            
            let strPVMVersion: String = NSString(format: "%04d", ulPvmVersion) as String
            let iPvmVersionLen: Int = strPVMVersion.count
            let bArrPVMersion = [Byte](strPVMVersion.utf8)
            
            buffer[iOffset] = (Byte)(iPvmVersionLen)
            iOffset = iOffset + 1
            buffer[iOffset..<iOffset+iPvmVersionLen] = bArrPVMersion[0 ..< iPvmVersionLen]
            iOffset += iPvmVersionLen

            //Add data (hardware serial number and PVM version) to feild 59
            _ = self.addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_59, data1: buffer, length: iOffset);
            debugPrint("SET->Field 59(PVMversion)[\(strPVMVersion)]")
            } catch {
            debugPrint("Exception Occurred: \(error)")
        }

    }
    
    //MARK:- vFnSetIsoPacketDate()
    func vFnSetIsoPacketDate() {
          m_chArrISOPacketDate = TransactionUtils.GetCurrentDateTime()
          let strISOPacketDate = String(bytes: m_chArrISOPacketDate, encoding: String.Encoding.utf8)
        debugPrint("SET->FIELD 12(CurrentTime) \(String(describing: strISOPacketDate))")
        //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "SET->Field 12(CurrentTime)[%s]", new String(m_chArrISOPacketDate).trim());
        _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_12, data1: m_chArrISOPacketDate, bcd: true)
      }
    
    //MARK:- vFnSetTerminalActivationFlag(bTerminalActivationFlag: Bool)
    func vFnSetTerminalActivationFlag(bTerminalActivationFlag: Bool) {
        m_bIsTerminalActivationPacket = bTerminalActivationFlag
    }
    
    //MARK:-  packIt(sendee: inout [Byte]) -> Int
    func packIt(sendee: inout [Byte]) -> Int {
         /*We used this function for HostID=1 currently we are not using HostID=1 in this application so this function will be no use.
          We have removed code for this function
          Currently we have not removed this function because we are calling this function from many places.
        * */
        return 0
    }

    //MARK:- packItHost(sendee: inout [Byte]) -> Int
    func packItHost(sendee: inout [Byte]) -> Int {
        do {
            
            debugPrint("Inside method packItHost")
            var buffer =  [Byte](repeating: 0x00, count: 64)
            let globalData = GlobalData.singleton
            var iOffset = 0;

            /* ***************************************************************************
            FIELD 6 :: Terminal Type
            ***************************************************************************/
            let TerminalType = TransactionUtils.GetHardwareType();
            _ = addField(bitno: ISOFieldConstants.ISO_FIELD_6, data1: TerminalType, bcd: true);
            debugPrint("packItHost SET Field 6(TerminalType) \(AppConstant.TERMINAL_TYPE.trimmingCharacters(in: .whitespacesAndNewlines))")
            /* ***************************************************************************
            FIELD 12 :: Current Time and Date
            ***************************************************************************/
            vFnSetIsoPacketDate();

            /* ***************************************************************************
            FIELD 38 :: Application Version
            ***************************************************************************/
            let chArr2: [Byte] = [Byte](TransactionUtils.getAppVersion().utf8)
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_38, data1: chArr2, bcd: false);
            debugPrint("SET->Field 38(App Version) \(TransactionUtils.getAppVersion().trimmingCharacters(in: .whitespacesAndNewlines))")

            /* ***************************************************************************
            FIELD 47 :: Client ID + Security Token
            ***************************************************************************/
            iOffset = 0;
            let m_sParamData: TerminalParamData? = globalData.ReadParamFile()
            let iLenClientID: Int = m_sParamData!.m_strClientId.count
            let iLenSecurityToken: Int = m_sParamData!.m_strSecurityToken.count
            
            var bArrField47Data = [Byte](repeating: 0x00, count: 2+iLenClientID+iLenSecurityToken)
                      
            bArrField47Data[iOffset] = (Byte)(iLenClientID & 0x000000FF)
            iOffset = iOffset + 1

            if (iLenClientID > 0) {
                let strClientId: [Byte] = [Byte](m_sParamData!.m_strClientId.utf8)
                bArrField47Data[iOffset..<(iOffset+iLenClientID)] = strClientId[0 ..< iLenClientID]
                iOffset += iLenClientID;
            }

            bArrField47Data[iOffset] = (Byte)(iLenSecurityToken & 0x000000FF)
            iOffset = iOffset + 1

            if (iLenSecurityToken > 0) {
                let strSecurityToken: [Byte] = [Byte](m_sParamData!.m_strSecurityToken.utf8)
                bArrField47Data[iOffset..<(iOffset+iLenSecurityToken)] = strSecurityToken[0 ..< iLenSecurityToken]
                iOffset += iLenSecurityToken;
            }

            _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_47, data1: bArrField47Data, length: iOffset)

            /* ***************************************************************************
            FIELD 49 ::PED Hardware Serial Number
            *
            ***************************************************************************/
            self.vFnSetPEDHardwareSerialNumer();
            /* ***************************************************************************
            FIELD 50 :: User ID Send
            ***************************************************************************/
            if (globalData.m_bIsLoggedIn != false) {
                    
                    if (globalData.m_objCurrentLoggedInAccount != nil)
                    {
                        let strUserID: String = globalData.m_objCurrentLoggedInAccount!.m_strUserID;
                        let strUserPIN: String = globalData.m_strCurrentLoggedInUserPIN

                        let iLenUserID: Int = strUserID.count
                        let iLenUserPIN: Int = strUserPIN.count

                        iOffset = 0
                        var bArrBuffer = [Byte](repeating: 0, count: 2+iLenUserID+iLenUserPIN)
                        
                        //UserID
                        buffer[iOffset] = (Byte)(iLenUserID)
                        iOffset = iOffset + 1
                        let bArrUserID = [Byte](strUserID.utf8)
                        bArrBuffer[iOffset..<iOffset+iLenUserID] = bArrUserID[0..<iLenUserID]
                        iOffset += iLenUserID;

                        //User PIN
                        buffer[iOffset] = (Byte)(iLenUserPIN)
                        iOffset = iOffset + 1
                        let bArrUserPIN = [Byte](strUserPIN.utf8)
                        bArrBuffer[iOffset..<iOffset+iLenUserPIN] = bArrUserPIN[0..<iLenUserPIN]
                        iOffset += iLenUserPIN;
                        
                        _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_50, data1: bArrBuffer, length: iOffset);
                       
                        debugPrint("SET->FIELD 50(UserId) \(String(describing: String(bytes: buffer, encoding: String.Encoding.utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)))")
                        
                    }
                }

            /* ***************************************************************************
            FIELD 59 ::Hardware Serial Number/PVM Version
            *This must be set before Generating Autherisation Token
            ***************************************************************************/
            self.vFnSetHardwareSerialNumber()
            /* ***************************************************************************
            FIELD 51 :: Autherised token / Data Encrypted under GUID
            ***************************************************************************/
            if (!m_bIsTerminalActivationPacket) {
                guard let bArrGUIDAuthTokenEncrypted = bFnGetGUIDAuthToken() else {return 0}
                _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_51, data1: bArrGUIDAuthTokenEncrypted, length: bArrGUIDAuthTokenEncrypted.count);
                
                debugPrint("SET->Field 51(Auth Token)[\(TransactionUtils.byteArray2HexString(arr: bArrGUIDAuthTokenEncrypted))]")
            }
            /* ***************************************************************************
            FIELD 5 :: Encrypted bitmap
            ***************************************************************************/
            var enBmap = [Byte](repeating: 0x00, count: ISO_LEN / 8)
            var charenBmap = [Byte](repeating: 0x00, count: ISO_LEN / 8)

            var bToSet:Bool = false
                
            for i in 0 ..< ISO_LEN
            {
                if(encryptedFieldBitmap[i])
                {
                    enBmap[i / 8] |= (Byte)(0x80 >> (i % 8))
                    bToSet = true
                }
                
            }
            
            if(bToSet)
            {
                charenBmap = TransactionUtils.bcd2a(enBmap, ISO_LEN / 8)!
                _ = addField(bitno: ISOFieldConstants.ISO_FIELD_5, data1: charenBmap, bcd: true);
                debugPrint("SET->Field 5 (encrypted bitmap) charenBmap [\(String(describing: String(bytes: charenBmap, encoding: String.Encoding.utf8)))] len[\(charenBmap.count)]")
                
            }
            /* ***************************************************************************
            FEILD 64 ::MAC
            ***************************************************************************/
                debugPrint("PACKING DATA")
                //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "PACKING DATA");
                var iOffsetSendPacket: Int = 0;

                // First tag the message number
                let out: [Byte] = TransactionUtils.a2bcd(msgno)!
                //byte[] out = CUtils.a2bcd(msgno);
                
                //sendee = Array(out[0 ..< out.count])
                sendee[iOffsetSendPacket..<out.count] = out[0 ..< out.count]
                //System.arraycopy(out, 0, sendee, offset, out.length);
                iOffsetSendPacket += 2;

            
                self.bitmap[64 - 1] = true
                var bmap = [Byte](repeating: 0x00, count: AppConstant.ISO_LEN / 8)
                    

                //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Setting Bitmap");
                debugPrint("Setting Bitmap")
                
                for i in 0 ..< AppConstant.ISO_LEN
                {
                    if(self.bitmap[i])
                    {
                        bmap[i / 8] |= (Byte) (0x80 >> (i % 8))
                    }
                }
                
                sendee[iOffsetSendPacket..<iOffsetSendPacket+AppConstant.ISO_LEN] = bmap[0 ..< AppConstant.ISO_LEN / 8]
                iOffsetSendPacket += AppConstant.ISO_LEN / 8

                //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Packing Fields");
                debugPrint("Packing Fields")
                
                for i in 0 ..< AppConstant.ISO_LEN
                {
                    if(!self.bitmap[i]){
                        continue
                    }
                    
                    if(i != (64 - 1))
                    {
                        debugPrint("Packing Field \(i + 1) Len \(String(describing: len[i])) data ")
                        let length = self.len[i]
                        sendee[iOffsetSendPacket..<iOffsetSendPacket+length] = data[i][0..<length]
                        iOffsetSendPacket += length
                    }
                    
                }
         
                debugPrint("Computing MAC")
            
                let tempOffset: Int = iOffsetSendPacket
                let iLenCRC: Int = 8
                
                let toCRC = Array(sendee[0 ..< tempOffset])
            
                let crc32 = CryptoHandler.GetCRC32(toCRC)
                var strCRC = String(format: "%llX", crc32).lowercased()
                strCRC =  TransactionUtils.StrLeftPad(data: strCRC, length: iLenCRC, padChar: "0")
            
                let bArrCRC = [Byte](strCRC.utf8)
                sendee[iOffsetSendPacket..<iOffsetSendPacket+iLenCRC] = bArrCRC[0..<iLenCRC]
            
                iOffsetSendPacket += iLenCRC;

                //Destruct ISO Packet
                //CISOMsgD();

                return iOffsetSendPacket;
            } catch {
                debugPrint("Exception Occurred : \(error)")
                return 0
            }
        }
    
    //Overriden Function
    //MARK:- addField(bitno: Int, data1: [Byte], bcd: Bool) -> Bool
    func addField(bitno: Int, data1: [Byte], bcd: Bool) -> Bool {
            
            self.bitmap[bitno - 1] = true;
            if (bcd == true) {
                self.len[bitno - 1] = (data1.count) / 2
                guard let result = TransactionUtils.a2bcd(data1) else {
                    debugPrint("addField got null data from TransactionUtils.a2bcd")
                    return false}
                data[bitno - 1] = result
            }
            else {
                self.len[bitno - 1] = (data1).count
                data[bitno - 1] = [Byte](repeating:0x00, count: len[bitno - 1])
                data[bitno - 1] = Array(data1[0 ..< data1.count])
            }
            return true
        }


    //MARK:- DisplayFeild58()
    func DisplayFeild58() {
        do {
            debugPrint("Inside DisplayField58")
            let globalData: GlobalData = GlobalData.singleton
            globalData.mFinalMsgDisplayField58 = ""

            var iAction: Int = 0x00;
                if (self.bitmap[58 - 1] == true) {
                    if (self.len[58 - 1] > 0) {
                        let iDisplayLen: Int = self.len[58 - 1]
                        let bArrField58Data = self.data[58 - 1]
                        
                        var iOffset: Int = 0x00;
                        var bArrDisplayMessage = [Byte](repeating: 0x00, count: 0)
                     
                        repeat {
                            iAction = Int(bArrField58Data[iOffset])
                            iOffset = iOffset + 1
                            
                            if (iAction == DisplayMessageMode.ASCII_DUMP.rawValue) {
                                var iLocalDataLen: Int = 0x00
                    
                                iLocalDataLen = Int((Byte)(bArrField58Data[iOffset] & 0x000000FF))
                                iOffset = iOffset + 1
                                iLocalDataLen <<= 8
                                iLocalDataLen |= Int((Byte)(bArrField58Data[iOffset] & 0x000000FF))
                                iOffset = iOffset + 1

                                
                                let bArrTemp = Array(bArrField58Data[iOffset..<iOffset+iLocalDataLen])
                                bArrDisplayMessage.append(contentsOf:bArrTemp)
                                
                                iOffset += iLocalDataLen;
                                globalData.mFinalMsgDisplayField58 = (String(bytes: bArrDisplayMessage, encoding: String.Encoding.ascii)?.trimmingCharacters(in: .whitespacesAndNewlines))!
                                
                            } else if (iAction == DisplayMessageMode.MESSAGE_ID_DUMP.rawValue) {
                                //parse message id carry out look up concatenate in chArrDisplayMessage
                                //move the len by 4 bytes
                                //var bArrMessageLength = [Byte](repeating: 0x00, count: 4)
                                let bArrMessageLength = TransactionUtils.bcd2a(Array(bArrField58Data[iOffset ..< iOffset + 4]))!
                                let lMessageId:Int64 = TransactionUtils.bytesToLong(bytes: bArrMessageLength)
                                iOffset = iOffset + 4
                                
                                //TODO check vishal GetMessage->BinarySearchMess() method to get message from file
                                guard let bArrTemp = globalData.GetMessage(id: lMessageId) else {continue}
                                
                                bArrDisplayMessage.append(contentsOf:bArrTemp)
                                globalData.mFinalMsgDisplayField58 = (String(bytes: bArrDisplayMessage, encoding: String.Encoding.utf8)?.trimmingCharacters(in: .whitespacesAndNewlines))!
                            }
                            else {
                                break
                            }
                        } while (iOffset < iDisplayLen)
                    }
                } else {
                    debugPrint("DisplayFeild58 bitmap not set of field 58 ")
                }
            } catch  {
                debugPrint("Exception occurred: \(error)")
            }
        }

    //MARK:- unPackHostDirect(bArrSource: [Byte]) -> Bool
    func unPackHostDirect(bArrSource: [Byte]) -> Bool {
        do {
            debugPrint("Inside unPackHostDirect")
            CISOMsgC()

            let headerLength: Int = 7

            let bArrMsgNo = Array(bArrSource[headerLength ..< headerLength + 2])
            msgno = TransactionUtils.bcd2a(bArrMsgNo, 2)!

            let iSkipLength: Int = (headerLength + 2 + AppConstant.ISO_LEN / 8)
            
            let bArrtemp = Array(bArrSource[iSkipLength ..< bArrSource.count])
            
            
            var iOffset:Int = 0
            var length: Int = 0                        // Lenght of bytes to read for a field.
            var bcd: Bool = true
            var totalLength = 2 + AppConstant.ISO_LEN / 8; // MAC

            for i in 0 ..< AppConstant.ISO_LEN
            {
                var bResult: Byte = bArrSource[headerLength + 2 + i / 8]
                bResult &= (0x80 >> (i % 8))
                
               if (bResult != 0x00) {
                
                    bcd = true
                    length = 0
                    bitmap[i] = true
                
                switch (i + 1) {
                    case 2:
                        length = 4
                    case 3:
                        length = 3
                    case 4: fallthrough
                    case 5:
                        length = 8
                    case 6:
                        length = 1
                    case 7:
                        length = 1
                    case 11:
                        length = 2
                    case 12:
                        length = 6
                    case 20:
                        length = 1
                    case 21:
                        length = 1
                    case 22:
                        length = 5
                    case 24:
                        length = 2
                    case 25:
                        length = 2
                    case 26:
                        length = 3
                    case 27:
                        length = 1
                    case 37:
                        length = 2
                    case 38:
                        length = 6;
                        bcd = false
                    case 39:
                        length = 2
                    case 40:
                        length = 2
                    case 41:
                        length = 5
                    case 42:
                        length = 5
                    case 43:
                        length = 6
                    case 44:
                        length = 6;
                        bcd = false
                    case 45:
                        length = 3
                    case 47: fallthrough
                    case 48: fallthrough
                    case 49: fallthrough
                    case 50: fallthrough
                    case 51: fallthrough
                    case 52: fallthrough
                    case 53: fallthrough
                    case 54: fallthrough
                    case 55: fallthrough
                    case 56: fallthrough
                    case 57: fallthrough
                    case 58: fallthrough
                    case 59: fallthrough
                    case 60: fallthrough
                    case 61: fallthrough
                    case 62: fallthrough
                    case 63:

                        //highly custom code written to handle the limitation of
                        //j8583 lib at the host.
                        //Calculate length packed in BCD
                        
                        var iValue1: Int = Int(((bArrtemp[iOffset]) >> 4) & 0x0F)
                        iValue1 = iValue1 * 1000
                        
                        var iValue2: Int = Int(bArrtemp[iOffset] & 0x0F)
                        iValue2 = iValue2 * 100
                        length = iValue1 + iValue2;
                        
                        iValue1 = Int(((bArrtemp[iOffset+1]) >> 4) & 0x0F)
                        iValue1 = iValue1 * 10
                        
                        iValue2 = Int(bArrtemp[iOffset+1] & 0x0F)
                        length += iValue1 + iValue2
                    
                        
                        totalLength += 2
                        iOffset += 2
                        bcd = false
                    case 64:
                        length = 8
                        bcd = false

                    default:
                    break
                }    // end switch
             
                if (bcd) {
                    data[i] = TransactionUtils.bcd2a(Array(bArrtemp[iOffset..<iOffset+length]))!
                    len[i] = 2 * length
                    iOffset += length
                    debugPrint("field[\(i + 1)], length[\(len[i])], Data[\(String(describing: TransactionUtils.ByteArrayToHexString(data[i])))]")
                } else {
                    data[i] = Array(bArrtemp[iOffset ..< iOffset+length])
                    len[i] = length
                    iOffset += length
                    debugPrint("field[\(i + 1)], length[\(len[i]), Data[\(String(describing: TransactionUtils.ByteArrayToHexString(data[i])))]")
                }
                totalLength += length; //  For MAC

                }//end if

            }    // end for loop

            if (bitmap[44 - 1]) {
                debugPrint("field 44 length = \(len[44 - 1]), data = \(String(describing: TransactionUtils.ByteArrayToHexString(data[44 - 1]))))")
            }

            if (bitmap[45 - 1]) {
                debugPrint("field 44 length = \(len[45 - 1]), data = \(String(describing: TransactionUtils.ByteArrayToHexString(data[45 - 1]))))")
            }


            if (bitmap[58 - 1]) {
                DisplayFeild58();
            }


            if (!bitmap[64 - 1]) {
                return true;
            }
        
            let iLenCRC: Int = 8
            //  buffer for crc calculation is allocated here
            let bArrToCRC = Array(bArrSource[headerLength ..< headerLength + totalLength - 8])

            let crc32 = CryptoHandler.GetCRC32(bArrToCRC)
            var strOutCRC = String(format: "%llX", crc32).lowercased()
            strOutCRC =  TransactionUtils.StrLeftPad(data: strOutCRC, length: iLenCRC, padChar: "0")
            
            
            let strTheirCRC: String = (String(bytes: data[64 - 1], encoding: String.Encoding.utf8)?.trimmingCharacters(in: .whitespacesAndNewlines))!

            debugPrint("Their MAC is \(strTheirCRC), Our MAC is \(strOutCRC)")

            if (strOutCRC != strTheirCRC) {
                debugPrint("MAC MISMATCH")
                return false;
            }
            debugPrint("MAC OK")
            return true
        } catch {
            debugPrint("Exception Occured \(error)")
            return false;
        }

    }

    //MARK:- addLLLCHARData(bitno: Int, data1: [Byte], length: Int) -> Bool
    func addLLLCHARData(bitno: Int, data1: [Byte], length: Int) -> Bool{
          do {
            if (!data[bitno - 1].isEmpty) {
                 data[bitno - 1] = []
            }
              //Set the Bitmap for the corresponding ISO field in the class variable
              self.bitmap[bitno - 1] = true

              //Set the length for the corresponding ISO field in the class variable
              //Length  = 2 bytes of length field + Length of the data
              self.len[bitno - 1] = 2 + length

              //Allocate Memory for Data to be put into
              //self.data[bitno - 1] = withUnsafeBytes(of: self.len[bitno - 1].bigEndian, Array.init)
            
              var tempBuffer = [Byte](repeating: 0, count: self.len[bitno - 1])

              //The unsigned long  length is to be converted in BCD
              // i.e. if length is 123 bytes in packet it will go like 0x01 0x23
              var strVal = "\(length)"
              strVal = TransactionUtils.StrLeftPad(data: strVal, length: 4, padChar: "0")
             
              guard let tempLength = TransactionUtils.a2bcd([Byte](strVal.utf8)) else {return false}
            
              //Copy the length to the data feild in bcd format
              tempBuffer[0] = tempLength[0]
              tempBuffer[1] = tempLength[1]
            
              tempBuffer[2..<tempBuffer.count] = data1[0 ..< length]
              data[bitno - 1] = tempBuffer
              
              return true
          } catch {
            debugPrint("Exception Occured \(error)")
              return false
          }
      }

    //MARK:- IsOK() -> Bool
    func IsOK() -> Bool {
        do {
            debugPrint("IsOk bitmap[\(bitmap[39 - 1])]");
            if (self.bitmap[39 - 1]) {
                debugPrint("IsOk bitmap[\(bitmap[39 - 1])], ErrorCode[\(String(bytes: data[39 - 1], encoding: .utf8)!)]");
                guard let strRespCode: String = String(bytes: data[39 - 1], encoding: .utf8) else{return false}
                
                GlobalData.responseCode = strRespCode
                if (strRespCode.caseInsensitiveCompare(AppConstant.AC_PARTIAL_SETTLEMENT) == ComparisonResult.orderedSame) {
                    return false;
                } else if (strRespCode.caseInsensitiveCompare(AppConstant.STR_AC_SUCCESS) != ComparisonResult.orderedSame) {
                    GlobalData.m_bIsTxnDeclined = true;
                    return false;
                }
            }
            return true
        } catch {
            debugPrint("Exception: \(error )")
            return false;
        }
    }
    
    //MARK:- IsReward() -> Bool
    func IsReward() -> Bool {
         do {
             debugPrint("IsReward[\(bitmap[40 - 1])]")
             if (self.bitmap[40 - 1]) {
                debugPrint("IsReward data[\(String(describing: TransactionUtils.ByteArrayToHexString(data[40 - 1])))]")
                
                let strRespCode: String = String(bytes: data[40 - 1], encoding: .utf8)!
                
                 if (strRespCode.caseInsensitiveCompare(AppConstant.STR_AC_SUCCESS) != ComparisonResult.orderedSame) {
                     GlobalData.m_bIsTxnDeclined = true;
                     return false;
                 } else {
                     return true;
                 }
             }
             return false;
         } catch {
             debugPrint("Exception: \(error )")
             return false;
         }
     }
    
    
    //MARK:- addEncryptedLLLCHARData(bitno: Int, data1: [Byte], length: Int) -> Bool
    func addEncryptedLLLCHARData(bitno: Int, data1: [Byte], length: Int) -> Bool {
        do {
            if (!data[bitno - 1].isEmpty) {
                  data[bitno - 1] = []
              }
            
            //Set the Bitmap for the corresponding ISO field in the class variable
            self.bitmap[bitno - 1] = true
            self.encryptedFieldBitmap[bitno - 1] = true

            //Set the length for the corresponding ISO field in the class variable
            //Length  = 2 bytes of length feild + Length of the data
            self.len[bitno - 1] = 2 + length

            var tempBuffer = [Byte](repeating: 0, count: self.len[bitno - 1])
    
            guard let encData = CryptoHandler.XOREncrypt(data1, XOREncryptionType.USER_DATA_ENCRYPTION) else {return false}
            
            //length in bcd packing
            var strVal = "\(length)"
            strVal = CryptoHandler.padLeft(data: strVal, length: 4, padChar: "0");
            
            let tempLength: [Byte] = TransactionUtils.a2bcd([Byte](strVal.utf8))!

            //Copy the length to the data field in bcd format
            tempBuffer[0] = tempLength[0];
            tempBuffer[1] = tempLength[1];

            tempBuffer[2..<tempBuffer.count] = encData[0 ..< length]
            self.data[bitno-1] = tempBuffer
            
            return true;
          } catch {
            debugPrint("Exception Occurred \(error)")
              return false;
          }

      }
    
    //MARK:- bFnGetGUIDAuthToken() -> [Byte]?
    func bFnGetGUIDAuthToken() -> [Byte]? {

        do {
            debugPrint("Inside bFnGetGUIDAuthToken")
            
            var iOffset: Int = 0

            var bArrGUIDPlainData = [Byte](repeating: 0x00, count: 0)
            
            bArrGUIDPlainData.append(contentsOf: Array(m_chArrISOPacketDate[0 ..< m_chArrISOPacketDate.count]))
            iOffset += (m_chArrISOPacketDate).count;

            bArrGUIDPlainData.append(contentsOf: Array(m_chArrHardwareSerialNumber[0 ..< m_chArrHardwareSerialNumber.count]))
            
            iOffset += (m_chArrHardwareSerialNumber).count;

            debugPrint("GUID Auth token plain data len[\(iOffset)], bArrGUIDPlainData[\(TransactionUtils.byteArray2HexString(arr: bArrGUIDPlainData))]")
            
            
            var bArrKey = [Byte](repeating: 0x00, count: 0)
            
            let globalData: GlobalData = GlobalData.singleton
            guard let m_sParamData: TerminalParamData = globalData.ReadParamFile() else {return nil}

            let iLenGUID: Int = (m_sParamData.m_strGUID).count

            if (iLenGUID <= 16) {

                let bArrGUID = [Byte](m_sParamData.m_strGUID.utf8)
                bArrKey.append(contentsOf: bArrGUID)
            } else {
                let bArrGUID = [Byte](m_sParamData.m_strGUID.utf8)
                bArrKey.append(contentsOf: Array(bArrGUID[0 ..< 16]))
            }

            debugPrint("m_strGUID[\(m_sParamData.m_strGUID)]")
            
            guard let bArrGUIDAuthTokenEncrypted: [Byte] = CryptoHandler.tripleDesEncrypt(bArrGUIDPlainData, bArrKey) else{return nil}
            
            return bArrGUIDAuthTokenEncrypted;
        } catch {
            debugPrint("Exception Occurred : \(error)")
            
        }
    }
    
}
