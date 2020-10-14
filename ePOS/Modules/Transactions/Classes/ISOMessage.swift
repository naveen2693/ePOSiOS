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
    
    var data = [[Byte]](repeating:withUnsafeBytes(of: 0, Array.init), count: 64)
    
    var msgno: [Byte] = []
    
    var bitmap = [Bool](repeating: false, count: 64)
    
    var encryptedFieldBitmap: [Bool] = []
    
    var len = [Int](repeating: 0, count: 64)
    
    var m_chArrHardwareSerialNumber: [Byte] = []
    
    var m_chArrISOPacketDate = [Byte](repeating: 0, count: AppConst.MAX_LEN_DATE_TIME)
    
    var m_bIsTerminalActivationPacket: Bool = false
    
    func vFnSetPEDHardwareSerialNumer() {
          do {
            
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_INFO, "Inside vFnSetPEDHardwareSerialNumer");
            debugPrint("Inside vFnSetPEDHardwareSerialNumer")
            var buffer = [Byte](repeating:0, count: 50)
            var iLocalOffset: Int = 0x00

            guard let chArrHarwareSerialNumber = PlatformUtils.GetHardWareSerialNumber()
            else
            {
                return
            }
            
            let iLenHardwareSerialNum: Int = chArrHarwareSerialNumber.count

              if (iLenHardwareSerialNum <= AppConst.MAX_LEN_HARDWARE_SERIAL_NUMBER) {
                  
                 m_chArrHardwareSerialNumber = [Byte](repeating: 0, count: iLenHardwareSerialNum)
                 m_chArrHardwareSerialNumber = Array(chArrHarwareSerialNumber[0 ..< iLenHardwareSerialNum])
                //System.arraycopy(chArrHarwareSerialNumber, 0, m_chArrHardwareSerialNumber, 0, iLenHardwareSerialNum);
              } else {
                
                m_chArrHardwareSerialNumber = [Byte](repeating: 0, count: iLenHardwareSerialNum)
                m_chArrHardwareSerialNumber = Array(chArrHarwareSerialNumber[0 ..< AppConst.MAX_LEN_HARDWARE_SERIAL_NUMBER])
                                 
              }

              /**ADD to feild 49 PED HADRWARE SERIAL NUMBER **/
            buffer = Array(m_chArrHardwareSerialNumber[0 ..< m_chArrHardwareSerialNumber.count])
            iLocalOffset += m_chArrHardwareSerialNumber.count

            _ = self.addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_49.rawValue, data1: buffer, length: iLocalOffset)
            debugPrint("Field 49 (m_chArrHardwareSerialNumber) \(m_chArrHardwareSerialNumber)")
            
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Field 49 (m_chArrHardwareSerialNumber)[%s]", new String(m_chArrHardwareSerialNumber));
          } catch {
            debugPrint("Exception Occurred : \(error)")
              //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(ex));
          }
      }
    
    func vFnSetHardwareSerialNumber() {
        do {
            var chArrHardwareSerialNumber: [Byte]
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_INFO, "Inside vFnSetHardwareSerialNumer");
            debugPrint("Insert vFnSetHardwareSerialNumber")
            var chArrHarwareSerialNumber: [Byte]
            var buffer = [Byte](repeating: 0x00, count: 50)
            var iLocalOffset: Int = 0x00;
            
            chArrHarwareSerialNumber = PlatformUtils.getFullSerialNumber()
            
            let iLenHardwareSerialNum: Int = chArrHarwareSerialNumber.count

            if (iLenHardwareSerialNum <= AppConst.MAX_LEN_HARDWARE_SERIAL_NUMBER) {
                chArrHardwareSerialNumber = [Byte](repeating: 0x00, count: iLenHardwareSerialNum)
                chArrHardwareSerialNumber = Array(chArrHarwareSerialNumber[0 ..< iLenHardwareSerialNum])
            } else {
                chArrHardwareSerialNumber = [Byte](repeating: 0x00, count: AppConst.MAX_LEN_HARDWARE_SERIAL_NUMBER)
                chArrHardwareSerialNumber = Array(chArrHarwareSerialNumber[0 ..< AppConst.MAX_LEN_HARDWARE_SERIAL_NUMBER])
            }


            /**ADD to feild 59 HADRWARE SERIAL NUMBER **/
            iLocalOffset = iLocalOffset + 1
            buffer[iLocalOffset] = (Byte)(iLenHardwareSerialNum & 0x000000ff)
            
            var restData:[Byte] = []
            restData = Array(chArrHardwareSerialNumber[0 ..< chArrHardwareSerialNumber.count])
            buffer.append(contentsOf: restData)
            
            debugPrint("SET->Field 59 (HardwareSerialNum)[\(String(describing: String(bytes: chArrHardwareSerialNumber, encoding: String.Encoding.ascii)?.trimmingCharacters(in: .whitespacesAndNewlines)))]")
            
            iLocalOffset += (chArrHardwareSerialNumber).count
            
            //System.arraycopy(chArrHardwareSerialNumber, 0, buffer, iLocalOffset, chArrHardwareSerialNumber.length);
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "SET->Field 59(HardwareSerialNum)[%s]", new String(chArrHardwareSerialNumber).trim());

            /** PVM VERSION **/
            /*****************************************************************
             *  If pvm.txt does not exist on the file system then set pvm version as 0000.
             * ****************************************************************/
            var ulPvmVersion: Int64 = 0
            if (true == FileSystem.IsFileExist(strFileName: AppConst.PVMFILE)) {
                let globalData: GlobalData = GlobalData.singleton
                _ = globalData.ReadMasterParamFile()
                
                if (globalData.m_sMasterParamData!.ulPvmVersion >= 0) {
                    ulPvmVersion = globalData.m_sMasterParamData!.ulPvmVersion
                }
            }
            
            let strPVMVersion: String = NSString(format: "%04d", ulPvmVersion) as String
            let iPvmVersionLen: Int = strPVMVersion.count
            iLocalOffset = iLocalOffset + 1
            buffer[iLocalOffset] = (Byte)(iPvmVersionLen)
            
            let bPVMersion = [Byte](strPVMVersion.utf8)
            restData = Array(bPVMersion[0 ..< iPvmVersionLen])
            buffer.append(contentsOf: restData)
            
            //System.arraycopy(strPVMVersion.getBytes(), 0, buffer, iLocalOffset, iPvmVersionLen);
            iLocalOffset += iPvmVersionLen;

            //Add data (hardware serial number and PVM version) to feild 59
            _ = self.addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_59.rawValue, data1: buffer, length: iLocalOffset);
            debugPrint("SET->Field 59(PVMversion)[\(strPVMVersion)]")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "SET->Field 59(PVMversion)[%s]", strPVMVersion);
        } catch {
            debugPrint("Exception Occurred: \(error)")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(ex));
        }

    }
    
    func vFnSetIsoPacketDate() {
          m_chArrISOPacketDate = Util.GetCurrentDateTime()
          let strISOPacketDate = String(bytes: m_chArrISOPacketDate, encoding: String.Encoding.ascii)
        debugPrint("SET->FIELD 12(CurrentTime) \(String(describing: strISOPacketDate))")
        //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "SET->Field 12(CurrentTime)[%s]", new String(m_chArrISOPacketDate).trim());
        _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_12.rawValue, data1: m_chArrISOPacketDate, bcd: true)
      }
    
    func packIt(sendee: inout [Byte]) -> Int {
         /*We used this function for HostID=1 currently we are not using HostID=1 in this application so this function will be no use.
          We have removed code for this function
          Currently we have not removed this function because we are calling this function from many places.
        * */
        return 0
    }

    func packItHost(sendee: inout [Byte]) -> Int {
        do {
                
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_INFO, "Inside method packItHost");
            var buffer =  [Byte](repeating: 0x00, count: 64)
            let globalData = GlobalData.singleton
            var iOffset = 0;

            /* ***************************************************************************
            FEILD 6 :: Terminal Type
            ***************************************************************************/
            let TerminalType = Util.GetHardwareType();
            _ = addField(bitno: ISOFieldConstants.ISO_FIELD_6.rawValue, data1: TerminalType, bcd: true);
            debugPrint("packItHost SET Field 6(TerminalType) \(AppConst.TERMINAL_TYPE.trimmingCharacters(in: .whitespacesAndNewlines))")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "packItHost SET Field 6(TerminalType)[%s]", new String(TerminalType).trim());

            /* ***************************************************************************
            FEILD 12 :: Current Time and Date
            ***************************************************************************/
            vFnSetIsoPacketDate();

            /* ***************************************************************************
            FEILD 38 :: Application Version
            ***************************************************************************/
            let chArr2: [Byte] = [Byte](Util.getAppVersion().utf8)
            _ = self.addField(bitno: ISOFieldConstants.ISO_FIELD_38.rawValue, data1: chArr2, bcd: false);
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "SET->Field 38(APP Version)[%s]", new String(chArr2).trim());
            debugPrint("SET->Field 38(App Version) \(Util.getAppVersion().trimmingCharacters(in: .whitespacesAndNewlines))")

            /* ***************************************************************************
            FEILD 47 :: Client ID + Security Token
            ***************************************************************************/
            iOffset = 0;
            var uchArrField47Data = [Byte](repeating: 0x00, count: 150)
            
            let m_sParamData: TerminalParamData? = globalData.ReadParamFile()


            let iLenClientID: Int = m_sParamData!.m_strClientId.count;
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "SET->Field 47(client id)[%s]", m_sParamData.m_strClientId);
            debugPrint("SET->Field 47(client id) \(m_sParamData!.m_strClientId)")
            iOffset = iOffset + 1
            uchArrField47Data[iOffset] = (Byte)(iLenClientID & 0x000000FF);

            if (iLenClientID > 0) {
                let strClientId: [Byte] = [Byte](m_sParamData!.m_strClientId.utf8)
                uchArrField47Data = Array(strClientId[0 ..< iLenClientID])
                //System.arraycopy(m_sParamData.m_strClientId.getBytes(), 0, uchArrField47Data, iOffset, iLenClientID);
                iOffset += iLenClientID;
            }

            let iLenSecurityToken: Int = m_sParamData!.m_strSecurityToken.count
            debugPrint("SET->Field 47(security token) \(m_sParamData!.m_strSecurityToken)")
           // CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "SET->Field 47(security token)[%s]", m_sParamData.m_strSecurityToken);

            iOffset = iOffset + 1
            uchArrField47Data[iOffset] = (Byte)(iLenSecurityToken & 0x000000FF)

            if (iLenSecurityToken > 0) {
                let strSecurityToken: [Byte] = [Byte](m_sParamData!.m_strSecurityToken.utf8)
                uchArrField47Data = Array(strSecurityToken[0 ..< iLenSecurityToken])
                
                //System.arraycopy(m_sParamData.m_strSecurityToken.getBytes(), 0, uchArrField47Data, iOffset, iLenSecurityToken);
                iOffset += iLenSecurityToken;
            }

            _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_47.rawValue, data1: uchArrField47Data, length: iOffset)

            /* ***************************************************************************
            FEILD 49 ::PED Hardware Serial Number
            *
            ***************************************************************************/
            self.vFnSetPEDHardwareSerialNumer();
            /* ***************************************************************************
            FEILD 50 :: User ID Send
            ***************************************************************************/
            if (globalData.m_bIsLoggedIn != false) {
                    
                    buffer = (0...buffer.count).map { _ in 0x00 }
                    var offset: Int = 0;

                    if (globalData.m_objCurrentLoggedInAccount != nil)
                    {
                        let strUserID: String = globalData.m_objCurrentLoggedInAccount!.m_strUserID;
                        let strPIN: String = globalData.m_strCurrentLoggedInUserPIN

                        let UserIDlen: Int = strUserID.count
                        let pinlen: Int = strPIN.count

                        offset = offset + 1
                        buffer[offset] = (Byte)(UserIDlen)
                        
                        var restData: [Byte] = []
                        let strUser = [Byte](strUserID.utf8)
                        restData = Array(strUser[0 ..< UserIDlen])
                        buffer.append(contentsOf: restData)
                                                
                        //System.arraycopy(strUserID.getBytes(), 0, buffer, offset, UserIDlen);
                        offset += UserIDlen;

                        offset = offset + 1
                        buffer[offset] = (Byte)(pinlen)
                        
                        let strPin = [Byte](strPIN.utf8)
                        restData = Array(strPin[0 ..< pinlen])
                        
                        buffer.append(contentsOf: restData)
                        //System.arraycopy(strPIN.getBytes(), 0, buffer, offset, pinlen);

                        offset += pinlen;
                        _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_50.rawValue, data1: buffer, length: offset);
                       
                        debugPrint("SET->FIELD 50(UserId) \(String(describing: String(bytes: buffer, encoding: String.Encoding.ascii)?.trimmingCharacters(in: .whitespacesAndNewlines)))")
                        
                        //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "SET->Field 50(UserId)[%s]", new String(buffer).trim());
                    }
                }

            /* ***************************************************************************
            FEILD 59 ::Hardware Serial Number/PVM Version
            *This must be set before Generating Autherisation Token
            ***************************************************************************/
            self.vFnSetHardwareSerialNumber()
            /* ***************************************************************************
            FEILD 51 :: Autherised token / Data Encrypted under GUID
            ***************************************************************************/

            if (!m_bIsTerminalActivationPacket) {
                
                var chTempGUIDAuthTokenArr = [Byte](repeating: 0x00, count: 51)
                var iGUIDAuthTokenLen: Int = 0
                
                chTempGUIDAuthTokenArr = bFnGetGUIDAuthToken(iGUIDAuthTokenLen: &iGUIDAuthTokenLen)!
                
                if (!chTempGUIDAuthTokenArr.isEmpty) {
                    
                    _ = addLLLCHARData(bitno: ISOFieldConstants.ISO_FIELD_51.rawValue, data1: chTempGUIDAuthTokenArr, length: iGUIDAuthTokenLen);
                    
                    debugPrint("SET->Field 51(Auth Token)[\(BytesUtil.byteArray2HexString(arr: chTempGUIDAuthTokenArr))]")
                    //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "SET->Field 51(Auth Token)[%s]", BytesUtil.byteArray2HexString(chTempGUIDAuthTokenArr));
                }
            }
                /*************************** NEWLY ADDED VARIABLES ************************/
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
                charenBmap = Util.bcd2a(s: enBmap, len: ISO_LEN / 8);
                _ = addField(bitno: ISOFieldConstants.ISO_FIELD_5.rawValue, data1: charenBmap, bcd: true);
                debugPrint("SET->Field 5 (encrypted bitmap) charenBmap [\(String(describing: String(bytes: charenBmap, encoding: String.Encoding.ascii)))] len[\(charenBmap.count)]")
                
            }
            /* ***************************************************************************
            FEILD 64 ::MAC
            ***************************************************************************/
                debugPrint("PACKING DATA")
                //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "PACKING DATA");
                var offset: Int = 0;

                // First tag the message number
                let out: [Byte] = Util.a2bcd(s: msgno)
                //byte[] out = CUtils.a2bcd(msgno);
                
                sendee = Array(out[0 ..< out.count])
                //System.arraycopy(out, 0, sendee, offset, out.length);
                offset += 2;


                let CRC_len: Int = 8
                self.bitmap[64 - 1] = true
                _ = [Byte](repeating: 0x00, count: CRC_len)
            
                var bmap = [Byte](repeating: 0x00, count: AppConst.ISO_LEN / 8)
                    

                //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Setting Bitmap");
                debugPrint("Setting Bitmap")
                
                for i in 0 ..< AppConst.ISO_LEN
                {
                    if(self.bitmap[i])
                    {
                        bmap[i / 8] |= (Byte) (0x80 >> (i % 8))
                    }
                }
                
                sendee = Array(bmap[0 ..< AppConst.ISO_LEN / 8])
                //System.arraycopy(bmap, 0, sendee, offset, AppConst.ISO_LEN / 8);
                offset += AppConst.ISO_LEN / 8;

                //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Packing Fields");
                debugPrint("Packing Fields")
                
            for i in 0 ..< AppConst.ISO_LEN
            {
                if(!self.bitmap[i]){
                    continue
                }
                
                if(i != (64 - 1))
                {
                    debugPrint("Packing Field \(i + 1) Len \(String(describing: len[i])) data ")
                    
                    var restData: [Byte] = []
                    let length = self.len[i]
                    restData = Array(data[i][0 ..< length])
                    
                    sendee.append(contentsOf: restData)
                    offset += len[i]
                }
                
            }
         
                debugPrint("Computing MAC")
         
                //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "Computing MAC");
            
                var toCRC = [Byte](repeating: 0x00, count: offset)
            
                let k: Int = offset
                var crc: Int64 = 0
                
                toCRC = Array(sendee[0 ..< k])
                //System.arraycopy(sendee, 0, toCRC, 0, k);

                let objCRC32: CRC32 = CRC32()
                objCRC32.update(buf: toCRC, off: 0, len: k)
                crc = objCRC32.GetValue()

                var strCRC = String(format: "%llX", crc)
                    
                strCRC =  CryptoHandler.padLeft(data: strCRC, length: CRC_len, padChar: "0")
            
                let bCRC = [Byte](strCRC.utf8)
                let restData: [Byte] = Array(bCRC[0 ..< CRC_len])
                sendee.append(contentsOf: restData)
            
                //System.arraycopy(strCRC.getBytes(), 0, sendee, offset, CRC_len);
                offset += CRC_len;

                //Destruct ISO Packet
                //CISOMsgD();

                return offset;
            } catch {
                debugPrint("Exception Occurred : \(error)")

                //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(ex));
                return 0
            }
        }
    
    //Overriden Function
    func addField(bitno: Int, data1: [Byte], bcd: Bool) -> Bool {
        do {
            
            self.bitmap[bitno - 1] = true;
            if (bcd) {
                self.len[bitno - 1] = (data1.count) / 2
                
                //TO DO: a2bcd naveen ->
                var result: String
                result = String(bytes: data1, encoding: String.Encoding.ascii)!
                
                data[bitno - 1] = [Byte](result.utf8)
//                if (data[bitno - 1] == nil)        //no memory check
//                {
//                    debugPrint("addField Got null data from Cutils.a2bcd")
//                    //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "addField Got null data from Cutils.a2bcd");
//                    return false;
//                }
            } else {
                self.len[bitno - 1] = (data1).count
                data[bitno - 1] = [Byte](repeating:0x00, count: len[bitno - 1])
                
//                if (data[bitno - 1] == nil)        //no memory check
//                {
//                    debugPrint("addField Got null data from Cutils.a2bcd")
//                    //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "addField Got null data from Cutils.a2bcd");
//                    return false;
//                }
                data[bitno - 1] = Array(data1[0 ..< data1.count])
                //System.arraycopy(data1, 0, data[bitno - 1], 0, data1.length)

            }
            return false
        }
        catch
        {
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(ex));
            return false
        }

    }
    
    func addLLLCHARData(bitno: Int, data1: [Byte], length: Int) -> Bool{
          do {
              //Set the Bitmap for the corresponding ISO field in the class variable
              self.bitmap[bitno - 1] = true

              //Set the length for the corresponding ISO field in the class variable
              //Length  = 2 bytes of length field + Length of the data
              self.len[bitno - 1] = 2 + length

              //Allocate Memory for Data to be put into
              self.data[bitno - 1] = withUnsafeBytes(of: self.len[bitno - 1].bigEndian, Array.init)

              //The unsigned long  length is to be converted in BCD
              // i.e. if length is 123 bytes in packet it will go like 0x01 0x23
              var strVal = "\(length)"
              strVal = CryptoHandler.padLeft(data: strVal, length: 4, padChar: "0")
                
              let temp = [Byte](strVal.utf8)
            
              //Copy the length to the data feild in bcd format
              self.data[bitno - 1][0] = temp[0]
              self.data[bitno - 1][1] = temp[1]

              var restData: [Byte]
              restData = Array(data1[0 ..< data1.count])
                
              data[bitno - 1].append(contentsOf: restData)
              
            //System.arraycopy(data1, 0, this.data[bitno - 1], 2, length)
              return true
          } catch {
            debugPrint("Exception Occured")
              //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(ex))
              return false
          }
      }

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

            //Allocate Memory for Data to be put into
            self.data[bitno - 1] = [Byte](repeating:0x00, count: len[bitno - 1])
            var encData = [Byte](repeating:0x00, count: len[bitno - 1])
        
            //Encrypt data
            let encLen: Int = 0;
            
            encData = CryptoHandler.XOREncrypt(rawdata: data1, cipherlen: length, encrypted: encData, lenBuff: encLen, uchDynamicInput: nil, DynamicInputLen: 0, encryptionType: CryptoHandler.EnXOREncryptionType.USER_DATA_ENCRYPTION.rawValue);

            //The unsigned long  length is to be converted in BCD
            // i.e. if length is 123 bytes in packet it will go like 0x01 0x23
            var strVal: String = "";
            strVal = String(format: "%d", length);

            strVal = CryptoHandler.padLeft(data: strVal, length: 4, padChar: "0");
            
            let bArrVal = [Byte](strVal.utf8)
            let temp: [Byte] = Util.a2bcd(s: bArrVal);

              //Copy the length to the data feild in bcd format
            self.data[bitno - 1][0] = temp[0];
            self.data[bitno - 1][1] = temp[1];

            debugPrint("Length[\(length)] temp[0][\(temp[0])] temp[0][\(temp[1])]")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "length[%d], temp[0][%x], temp[1][%x]", length.value, temp[0], temp[1]);

            let restData: [Byte] = Array(encData[0 ..< length])
            self.data[bitno - 1].append(contentsOf: [Byte](restData))
            
              //Now copy the data to the data feild after length has been added
              //System.arraycopy(encData, 0, this.data[bitno - 1], 2, length.value);
              return true;
          } catch {
            debugPrint("Exception Occurred \(error)")
              //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(ex));
              return false;
          }

      }
    
    func bFnGetGUIDAuthToken(iGUIDAuthTokenLen: inout Int) -> [Byte]? {

        do {
            debugPrint("Inside bFnGetGUIDAuthToken")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_INFO, "Inside bFnGetGUIDAuthToken");
            
            var uchArrKey = [Byte](repeating: 0x00, count: 16)
            var iOffset: Int = 0

            var uchArrTempData = [Byte](repeating: 0x00, count: m_chArrISOPacketDate.count + m_chArrHardwareSerialNumber.count)
            
            uchArrTempData.append(contentsOf: Array(m_chArrISOPacketDate[0 ..< m_chArrISOPacketDate.count]))
            
            //System.arraycopy(m_chArrISOPacketDate, 0, uchArrTempData, iOffset, m_chArrISOPacketDate.length);
            iOffset += (m_chArrISOPacketDate).count;

            uchArrTempData.append(contentsOf: Array(m_chArrHardwareSerialNumber[0 ..< m_chArrHardwareSerialNumber.count]))
            
            //System.arraycopy(m_chArrHardwareSerialNumber, 0, uchArrTempData, iOffset, m_chArrHardwareSerialNumber.length);
            iOffset += (m_chArrHardwareSerialNumber).count;

            debugPrint("GUID Auth topken plain data len[\(iOffset)], uchArrTempData[\(BytesUtil.byteArray2HexString(arr: uchArrTempData))]")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "GUID Auth token plain data len[%d], uchArrTempData[%s]", iOffset, BytesUtil.byteArray2HexString(uchArrTempData));

            let globalData: GlobalData = GlobalData.singleton
            let m_sParamData: TerminalParamData = globalData.ReadParamFile()!

            
            uchArrKey = [Byte](repeating: 0x00, count: m_sParamData.m_strGUID.count)
            
            let iLenGUID: Int = (m_sParamData.m_strGUID).count

            if (iLenGUID <= 16) {
                
                let bGUID = [Byte](m_sParamData.m_strGUID.utf8)
                let restData: [Byte] = Array(bGUID[0 ..< iLenGUID])
                
                uchArrKey.append(contentsOf: restData)
            } else {
                let bGUID = [Byte](m_sParamData.m_strGUID.utf8)
                let restData: [Byte] = Array(bGUID[0 ..< 16])
                
                uchArrKey.append(contentsOf: restData)
            }

            debugPrint("m_strGUID[\(m_sParamData.m_strGUID)]")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_DEBUG, "m_strGUID[%s]", m_sParamData.m_strGUID);

            let chGUIDAuthTokenVal: [Byte] = CryptoHandler.tripleDesEncrypt(masterKey: uchArrKey, Input: uchArrTempData, padChar: "0")!
            
            iGUIDAuthTokenLen = chGUIDAuthTokenVal.count
            return chGUIDAuthTokenVal;
        } catch {
            debugPrint("Exception Occurred : \(error)")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(ex));
        }
    }
    
}
