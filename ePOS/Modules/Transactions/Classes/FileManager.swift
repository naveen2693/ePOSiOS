//
//  FileManager.swift
//  ePOS
//
//  Created by Naveen Goyal on 05/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class FileSystem {
    
    //MARK:- ReWriteFile<T: Codable>(strFileName: String, with array: [T]) throws -> Bool
    static func ReWriteFile<T: Codable>(strFileName: String, with array: [T]) throws -> Bool  {
        var bRetval = false
        let encoder = PropertyListEncoder()
        
        do {
            let finalPlistData = try encoder.encode(array)
            let filePath = FilePlistURL(strFileName: strFileName, with: array)
            try finalPlistData.write(to: filePath)
            bRetval = true
            
        } catch {
            debugPrint("Exception Caught")
            throw error
        }
        
        return bRetval;
    }

    //MARK:- SeekRead<T: Codable>(strFileName: String, iOffset: Int) -> T?
    static func SeekRead<T: Codable>(strFileName: String, iOffset: Int) -> T?
    {
        var objResult: T?
        let result:[T] = ReadFile(strFileName: strFileName)!
        if (!result.isEmpty)
        {
            objResult = result[iOffset]
        }
        
        return objResult
    }
    
    //MARK:- SeekWrite<T: Codable>(strFileName: String, with Obj: T, iOffset: Int) -> Bool
    static func SeekWrite<T: Codable>(strFileName: String, with Obj: T, iOffset: Int) -> Bool
    {
        var bResult: Bool = false
        
        do{
            var result: [T] = ReadFile(strFileName: strFileName)!
        
            result[iOffset] = Obj
            
            bResult = try ReWriteFile(strFileName: strFileName, with: result)
                    
        }
        catch {
            debugPrint("Exception Caught")
        }
        return bResult
    }

    //MARK:- ReadFile<T: Codable>(strFileName: String) -> [T]?
    static func ReadFile<T: Codable>(strFileName: String) -> [T]?
    {
        let result:[T] = []
        
        do {
            let filePath = FileSystem.FilePlistURL(strFileName: strFileName, with: result)
            
            let data = try Data(contentsOf: filePath)
            let plistDecoder = PropertyListDecoder()
            let pListDataWrapper = try plistDecoder.decode([T].self, from: data)
            return pListDataWrapper
        } catch {
            return nil
        }
    }
    
    //MARK:- AppendFile<T: Codable>(strFileName: String, with object: T) throws -> Bool
    static func AppendFile<T: Codable>(strFileName: String, with array: [T]) throws -> Bool
    {
        var bRetval = false
        
        var result:[T] = []
        
        do {
            result = ReadFile(strFileName: strFileName)!
            result.append(contentsOf: array)
            
            bRetval = try ReWriteFile(strFileName: strFileName, with: result)
            
        }
        catch {
            debugPrint("Exception Caught")
            throw error
        }
        
        return bRetval
    }
    
    //MARK:- DeleteFile<T: Codable>(strFileName: String, with array: [T]) -> Bool
    static func DeleteFile<T: Codable>(strFileName: String, with array: [T]) -> Bool
    {
        let bRetval: Bool = false;
        do {
            let pathToPlist: String = try String(contentsOf: FilePlistURL(strFileName: strFileName, with: array))
            
             if FileManager.default.fileExists(atPath: pathToPlist) {
                   try FileManager.default.removeItem(atPath: pathToPlist)
            }
        }
        catch {
            debugPrint("Exception Occurred :  \(error)")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(e));
        } 
        return bRetval;
    }

    //MARK:-  DeleteFileComplete(strFileName: String) -> Bool
    static func DeleteFileComplete(strFileName: String) -> Bool
    {
        let bRetval: Bool = false;
        do {
        let plistURL = Util.masterDataDirectoryURL.appendingPathComponent(strFileName).appendingPathExtension("plist")
            
        if FileManager.default.fileExists(atPath: plistURL.path) {
            try FileManager.default.removeItem(atPath: plistURL.path)
            }
        }
        catch {
            debugPrint("Exception Occurred :  \(error)")
            //CLogger.TraceLog(CLogger.TRACE_TYPE.TRACE_ERROR, "Exception Occurred : " + Log.getStackTraceString(e));
        }
        return bRetval;
    }
    
    static func RenameFile(strNewFileName: String, strFileName: String) -> Bool
     {
        var bRenameSuccess = false
        
        if(!IsFileExist(strFileName: strFileName))
        {
            debugPrint("File Doesnt Exist: \(strFileName)")
        }
        
        let plistFileURL = Util.masterDataDirectoryURL.appendingPathComponent(strFileName).appendingPathExtension("plist")
        let plistNewFileURL = Util.masterDataDirectoryURL.appendingPathComponent(strNewFileName).appendingPathExtension("plist")
        
        do {
            try FileManager.default.moveItem(at: plistFileURL, to: plistNewFileURL)
            bRenameSuccess = true
        }
        catch let error as NSError {
            debugPrint("Exception Occurred \(error)")
        }
        
         return bRenameSuccess;
     }
      
    //MARK:- IsFileExist(strFileName: String) -> Bool
    static func IsFileExist(strFileName: String) -> Bool
    {
        let plistURL = Util.masterDataDirectoryURL.appendingPathComponent(strFileName).appendingPathExtension("plist")
        
        if FileManager.default.fileExists(atPath: plistURL.path) {
            return true
        }
        else
        {
            return false
        }
    }
    
    //MARK:- NumberOfRows<T: Codable>(obj: T, strFileName: String) -> Int
    static func NumberOfRows<T: Codable>(strFileName: String, obj: T.Type) -> Int {
        var iNumOfRows: Int = 0
        
        if(IsFileExist(strFileName: strFileName))
        {
            let listObj: [T] = ReadFile(strFileName: strFileName)!
        
            if(!listObj.isEmpty)
            {
                iNumOfRows = listObj.count
            }
        }
        
        return iNumOfRows
    }
    
    
    //MARK:- FilePlistURL<T: Codable>(strFileName: String, with array: [T]) -> URL
    private static func FilePlistURL<T: Codable>(strFileName: String, with array: [T]) -> URL{
        
        let plistURL = Util.masterDataDirectoryURL.appendingPathComponent(strFileName).appendingPathExtension("plist")

        
        if !FileManager.default.fileExists(atPath: plistURL.path) {
            let encoder = PropertyListEncoder()
            do {
                let initialPlistData = try encoder.encode(array)
                try initialPlistData.write(to: plistURL)
                _ = FileManager.default.createFile(atPath: plistURL.path, contents: initialPlistData, attributes: nil)
            } catch {
                debugPrint("Error Occured in Creating initial StateData Plist")
            }
        }
        return plistURL
    }
    
    //MARK:- GetSHA1ofFile(strFileName: String) -> [Byte]?
    static func GetSHA1ofFile(strFileName: String) -> [Byte]?
    {
        var buffer: [Byte] = []
        buffer = ReadFile(strFileName: strFileName)!
        let SHA1HexString = buffer.sha1().toHexString().uppercased()
        return [Byte](SHA1HexString.utf8)
    }
    
    
    /******************************************************************************************************
     Function  : ReadRecord
     Desciption: Function to Read single record at a given offset from the JSON file
     containing one or more records of Class type T.
     Return Value: Object of type T
     Sample Use:  MyClass obj = CFileSystem.ReadRecord(context, MyClass[].class, strFileName, iOffset);
     ******************************************************************************************************/
    static func ReadRecord<T: Codable>(strFileName: String, iOffset: Int) -> T?
    {
        //Function Similar to Seek Read. - Read Record at the given OffSet
        return SeekRead(strFileName: strFileName, iOffset: iOffset) ?? nil
    }
 
    
    
}
