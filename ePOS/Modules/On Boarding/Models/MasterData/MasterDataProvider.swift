//
//  MasterDataProvider.swift
//  ePOS
//
//  Created by Matra Sharma on 26/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class MasterDataProvider {
    
    func saveMasterDataPlistFile(with masterDataWrapper: MasterDataWrapper) throws {
        let encoder = PropertyListEncoder()
        let finalPlistData = try encoder.encode(masterDataWrapper)
        do {
            try finalPlistData.write(to: masterDataPlistURL)
        } catch {
            throw error
        }
    }
    
    func searchMasterData(with text: String, completion:@escaping (([MasterCodeData]) -> Void)) {

        let masterDataArray = fetchMasterDataList()

        guard !text.isEmpty else {
            DispatchQueue.main.async {
                completion(masterDataArray)
            }
            return
        }

        let filteredRecents = masterDataArray.filter { $0.isMatching(with: text) }
        DispatchQueue.main.async {
            completion(filteredRecents)
        }
    }
    
    func fetchMasterDataList() -> [MasterCodeData] {
        do {
            let data = try Data(contentsOf: masterDataPlistURL)
            let plistDecoder = PropertyListDecoder()
            let masterDataWrapper = try plistDecoder.decode(MasterDataWrapper.self, from: data)
            return masterDataWrapper.masterData
        } catch {
            return [MasterCodeData]()
        }
    }
    
    var masterDataPlistURL: URL {
        let plistURL = Util.masterDataDirectoryURL.appendingPathComponent("MasterData").appendingPathExtension("plist")
        if !FileManager.default.fileExists(atPath: plistURL.path) {
            let recentsWrapper = MasterDataWrapper(masterData: [MasterCodeData]())
            let encoder = PropertyListEncoder()
            do {
                let initialPlistData = try encoder.encode(recentsWrapper)
                try initialPlistData.write(to: plistURL)
                _ = FileManager.default.createFile(atPath: plistURL.path, contents: initialPlistData, attributes: nil)
            } catch {
                debugPrint("Error Occured in Creating initial MasterData Plist")
            }
        }
        return plistURL
    }
}
//MARK: - dropdown's data
extension MasterDataProvider {
    func getDropdownDataFor(_ type: MasterDataType, completion:@escaping (([CodeData]) -> Void)) {
        searchMasterData(with: type.rawValue) { data in
            let codeDataArray = data.first?.masterCode ?? [CodeData]()
            completion(codeDataArray)
        }
    }
}
