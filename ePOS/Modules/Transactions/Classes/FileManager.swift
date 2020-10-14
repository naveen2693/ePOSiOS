//
//  FileManager.swift
//  ePOS
//
//  Created by Naveen Goyal on 05/10/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class FileSystem {

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
   
    static func SeekRead<T: Codable>(strFileName: String, iOffset: Int) -> T?
    {
        let result:[T] = ReadFile(strFileName: strFileName)!
        let objResult = result[iOffset]
    
        return objResult
    
    }
    
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
    
    public static func IsFileExist(strFileName: String) -> Bool
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
    
}
