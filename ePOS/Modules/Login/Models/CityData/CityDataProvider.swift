//
//  CityDataProvider.swift
//  ePOS
//
//  Created by Matra Sharma on 26/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import Foundation

class CityDataProvider {
    
    func saveSateDataPlistFile(with stateDataWrapper: StateData) throws {
        let encoder = PropertyListEncoder()
        let finalPlistData = try encoder.encode(stateDataWrapper)
        do {
            try finalPlistData.write(to: stateDataPlistURL)
        } catch {
            throw error
        }
    }
    
    func searchStateData(with text: String, completion:@escaping (([State]) -> Void)) {

        let stateArray = fetchStateDataList()

        guard !text.isEmpty else {
            DispatchQueue.main.async {
                completion(stateArray)
            }
            return
        }

        let filteredRecents = stateArray.filter { $0.isMatching(with: text) }
        DispatchQueue.main.async {
            completion(filteredRecents)
        }
    }
    
    func updateLastModifiedDate(with date: Double) throws {
        var allStates = fetchAllStateData()
        allStates.lastModifiedDate = date
        let encoder = PropertyListEncoder()
        let finalPlistData = try encoder.encode(allStates)
        do {
            try finalPlistData.write(to: stateDataPlistURL)
        } catch {
            throw error
        }
    }
    
    func getLastModifiedDate() -> Double {
        let allStates = fetchAllStateData()
        return allStates.lastModifiedDate
    }
    
    func fetchStateDataList() -> [State] {
        let allStates = fetchAllStateData()
        return allStates.states
    }
    
    func fetchAllStateData() -> StateData {
        do {
            let data = try Data(contentsOf: stateDataPlistURL)
            let plistDecoder = PropertyListDecoder()
            let stateDataWrapper = try plistDecoder.decode(StateData.self, from: data)
            return stateDataWrapper
        } catch {
            return StateData(states: [State](), lastModifiedDate: 0)
        }
    }
    
    var stateDataPlistURL: URL {
        let plistURL = Util.masterDataDirectoryURL.appendingPathComponent("States").appendingPathExtension("plist")
        if !FileManager.default.fileExists(atPath: plistURL.path) {
            let recentsWrapper = StateData(states: [State](), lastModifiedDate: 0)
            let encoder = PropertyListEncoder()
            do {
                let initialPlistData = try encoder.encode(recentsWrapper)
                try initialPlistData.write(to: plistURL)
                _ = FileManager.default.createFile(atPath: plistURL.path, contents: initialPlistData, attributes: nil)
            } catch {
                debugPrint("Error Occured in Creating initial StateData Plist")
            }
        }
        return plistURL
    }
}
