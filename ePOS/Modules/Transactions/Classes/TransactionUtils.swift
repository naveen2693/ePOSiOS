//
//  TransactionUtils.swift
//  ePOS
//
//  Created by Naveen Goyal on 14/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

public typealias Byte = UInt8
public typealias DataLong = Int64

class TransactionUtils
{
    //MARK:- a2bcd(_ buffer: [UInt8]) -> [UInt8]?
    static func a2bcd(_ buffer: [UInt8]) -> [UInt8]?
    {
        return HexArrayToByteArray(buffer)
    }
    
    //MARK:- bcd2a(_ buffer: [UInt8], ) -> [UInt8]?
    static func bcd2a(_ buffer: [Byte], _ length: Int) -> [UInt8]?
    {
        let tempBuffer: [Byte] = Array(buffer[0 ..< length])
        return ByteArrayToHexArray(tempBuffer)
    }
    
    //MARK:- bcd2a(_ buffer: [UInt8]) -> [UInt8]?
    static func bcd2a(_ buffer: [UInt8]) -> [UInt8]?
    {
        return ByteArrayToHexArray(buffer)
    }
    
    //MARK:- HexArrayToByteArray(_ buffer: [UInt8]) -> [UInt8]?
    public static func HexArrayToByteArray(_ buffer: [UInt8]) -> [UInt8]? {
        guard let string = String(bytes: buffer, encoding: String.Encoding.utf8) else { return nil }
        let byteArray = Array<UInt8>.init(hex: string)
        return byteArray
        
    }
    
    //MARK:- ByteArrayToHexArray(_ buffer: [UInt8]) -> [UInt8]?
    public static func ByteArrayToHexArray(_ buffer: [UInt8]) -> [UInt8]? {
        let string = buffer.toHexString()
        let hexArray = [UInt8](string.utf8)
        return hexArray
    }
    
    //MARK:- HexStringToByteArray(_ string: String) -> [UInt8]?
    public static func HexStringToByteArray(_ string: String) -> [UInt8]? {
        let byteArray = Array<UInt8>.init(hex: string)
        return byteArray
    }
    
    //MARK:- ByteArrayToHexString(_ buffer: [UInt8]) -> String?
    public static func ByteArrayToHexString(_ buffer: [UInt8]) -> String? {
        let string = buffer.toHexString()
        return string
    }
    
    //MARK:- byteArray2HexString(arr: [Byte]) -> String
    static func byteArray2HexString(arr: [Byte]) -> String {
        
        var sb: String = ""
        for anArr in arr {
            sb.append(String(format: "%02x", anArr).uppercased())
        }
        
        return sb
    }
    
    //MARK:- ByteArrayZeroPaddingtoLeft(to bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8>
    public static func ByteArrayZeroPaddingtoLeft(to bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
      let paddingCount = blockSize - (bytes.count % blockSize)
      if paddingCount > 0 {
        return Array<UInt8>(repeating: 0, count: paddingCount) + bytes
      }
      return bytes
    }

    //MARK:- ByteArrayZeroPaddingtoRight(to bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8>
    public static func ByteArrayZeroPaddingtoRight(to bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
      let paddingCount = blockSize - (bytes.count % blockSize)
      if paddingCount > 0 {
        return bytes + Array<UInt8>(repeating: 0, count: paddingCount)
      }
      return bytes
    }
    
    //MARK:- ByteArrayZeroCharacterPaddingtoLeft(to bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8>
    public static func ByteArrayZeroCharacterPaddingtoLeft(to bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
      let paddingCount = blockSize - (bytes.count % blockSize)
      if paddingCount > 0 {
        let padchar = [UInt8]("0".utf8)
        return Array<UInt8>(repeating: padchar[0], count: paddingCount) + bytes
      }
      return bytes
    }
    
    //MARK:- ByteArrayZeroCharacterPaddingtoRight(to bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8>
    public static func ByteArrayZeroCharacterPaddingtoRight(to bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
      let paddingCount = blockSize - (bytes.count % blockSize)
      if paddingCount > 0 {
        let padchar = [UInt8]("0".utf8)
        return bytes + Array<UInt8>(repeating: padchar[0], count: paddingCount)
      }
      return bytes
    }
 
    //MARK:- StrRightPad(data: String, length: Int, padChar: Character) -> String
    static func StrRightPad(data: String, length: Int, padChar: Character) -> String {
        let remaining: Int = length - data.count
        var newData: String = data
           
        for _ in 0..<remaining
        {
            newData = newData + String(padChar)
        }
        return newData
    }
    
    //MARK:- StrLeftPad(data: String, length: Int, padChar: Character) -> String
    static func StrLeftPad(data: String, length: Int, padChar: Character) -> String {
        let remaining = length - data.count
        var newData = data
       
        for _ in 0 ..< remaining
        {
            newData = String(padChar) + newData
            // padChar + newData
        }
        return newData
    }
    
    //MARK:- GetHardwareType() -> [Byte]
    static func GetHardwareType() -> [Byte]
     {
         let strHardwareType: String = AppConstant.TERMINAL_TYPE
         return [Byte](strHardwareType.utf8)
     }
    
    //MARK:- SetCurrentDateTime(buff: [Byte])
    static func SetCurrentDateTime(buff: [Byte]) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyHHmmss"
        let date = dateFormatter.date(from: String(bytes: buff, encoding: .utf8)!)
        
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.string(from: date!)
        
    }
    
    //MARK:- GetCurrentDateTime() -> [Byte]
    static func GetCurrentDateTime() -> [Byte]
    {
        let currentDate = Date()
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "ddMMyyHHmmss"
        let convertedDate: String = dateFormatter.string(from: currentDate)
        
        //String formattedDate = new SimpleDateFormat("ddMMyyHHmmss").format(Calendar.getInstance().getTime())
        return [Byte](convertedDate.utf8)
    }
    
    //MARK:- getAppVersion() -> String
    static func getAppVersion() -> String
    {
        return AppConstant.APP_VERSION
    }
 
    //MARK:- bytesToLong(bytes: [Byte]) -> Int64 
    static func bytesToLong(bytes: [Byte]) -> Int64 {
        
        var value : Int64 = 0
        
        for byte in bytes {
            value = value << 8
            value = value | Int64(byte)
        }

        return value
    }
 
    //MARK:- strlenByteArray(_ ByteArr: [Byte]) -> Int
    static func strlenByteArray(_ ByteArr: [Byte]) -> Int
    {
        var len: Int = 0
        while(len < ByteArr.count && ByteArr[len] != 0)
        {
            len += 1
        }
        return len
    }
    
    //MARK:- ReplaceStringPatterninBuffer(_ bInput: [Byte], _ bOutput: [Byte], _ strPattern: String, _ bReplacmentString: Byte) -> Bool
    static func ReplaceStringPatterninBuffer(_ bInput: [Byte], _ bOutput: inout [Byte], _ strPattern: String, _ bReplacmentString: [Byte]) -> Bool
    {
        let strInput = String(bytes: bInput, encoding: .ascii)
        if(!strInput!.contains(strPattern))
        {
            debugPrint("ReplaceStringPatterninBuffer pattern not found!!!")
            return false
        }
        let strOutput = strInput!.replaceFirst(of: strPattern, with: String(bytes: bReplacmentString, encoding: .ascii)!.trimmingCharacters(in: .whitespacesAndNewlines)).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let bTemp: [Byte] = [Byte](strOutput.utf8)
        bOutput = [Byte](bTemp[0 ..< strOutput.count])
        //System.arraycopy(strOutput.getBytes(), 0, bOutput, 0, strOutput.length())
        //bOutput = strOutput.getBytes()
        return true
    }
    
    //MARK:- objectToByteArray<T>(obj: T) -> [Byte]
    static func objectToByteArray<T>(obj: T) -> [Byte] {
        let bytes: [Byte] = []
        
        /*  ByteArrayOutputStream bos = null
        ObjectOutputStream oos = null
        try {
            bos = new ByteArrayOutputStream()
            oos = new ObjectOutputStream(bos)
            oos.writeObject(obj)
            oos.flush()
            bytes = bos.toByteArray()
        }
        catch (Exception e) {
            CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR,"Exception Occurred : " + Log.getStackTraceString(e))
        }
        finally {
            try {
                if (oos != null) {
                    oos.close()
                }
                if (bos != null) {
                    bos.close()
                }
            }
            catch (Exception e) {
                CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR,"Exception Occurred : " + Log.getStackTraceString(e))
            }
        } */
        
        return bytes
    }
    
//    public static func atoi(_ str: [Byte]) -> Int {
//        var res: Int = 0 // Initialize result
//        // Iterate through all characters of input string and
//        // update result
//        for i in 0 ..< str.count where (str[i] != 0x00) && (str[i] != "\0") {
//            if (str[i] < 48 && str[i] > 57) {
//                return -1
//            }
//            res = res * 10 + str[i] - "0"
//        }
//        return res
//    }
    
}

class DateUtil {

    static let SERVER_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss.SSS"
    static let DATE_FORMAT = "yyyy-MM-dd"
    static let DD_MMM_YYYY_HH_MM_A = "dd MMM yyyy hh:mm a"
    static let DD_MMM_YYYY = "dd MMM yyyy"
    static let DD_MMM_YYYY_SLASH = "dd/MMM/yyyy"
    static let HH_MM_A = "hh:mm a"

    /**
     * Get date.
     */
    static func getDate(_ date: Date, _ expectedFormat: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = expectedFormat
        
        return dateFormatter.string(from: date)
    }

    /**
     * Get current time.
     */
    static func getCurrentTime(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }

    static func parseDateInString(_ format: String, _ date: String) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current

        let Date = dateFormatter.date(from: date)
        
        return dateFormatter.string(from: Date!)
    }

    static func getParsedDate(_ date: String, _ format: String) -> Date {
        do {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            dateFormatter.locale = Locale(identifier: "en_US")
            
            let date = dateFormatter.date(from: date)
            
            return date!
        } catch {
            debugPrint("error occured \(error)")
        }
        return Date()
    }

    static func getParsedDate(_ time: Int64, _ format: String) -> String {
        if (time != 0) {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            dateFormatter.locale = Locale(identifier: "en_US")
                
            
            let date = Date(timeIntervalSince1970: (TimeInterval(time) / 1000))
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }

    /**
     * Method is used to convert date from one format to another.
     * If any exception occoured then it will return current date.
     *
     * @param inputDate    inputDate
     * @param inputFormat  inputFormat
     * @param outputFormat outputFormat
     * @return date in String with required format.
     */
    static func convertDateOneFormatToOther(_ inputDate: String, _ inputFormat: String, _ outputFormat: String) -> String {
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = inputFormat
            
            let date = dateFormatter.date(from: inputDate)
            
            dateFormatter.dateFormat = outputFormat
            
            return dateFormatter.string(from: date!)
        } catch {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = outputFormat
            return dateFormatter.string(from: Date())
        }

    }
}

extension String{
    
    public func replaceFirst(of pattern:String,
                             with replacement:String) -> String {
      if let range = self.range(of: pattern){
        return self.replacingCharacters(in: range, with: replacement)
      }else{
        return self
      }
    }
    
    public func replaceAll(of pattern:String,
                           with replacement:String,
                           options: NSRegularExpression.Options = []) -> String{
      do{
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(0..<self.utf16.count)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: range, withTemplate: replacement)
      }catch{
        NSLog("replaceAll error: \(error)")
        return self
      }
    }
}
