//
//  SavedCSVData.swift
//  Chromi
//
//  Created by Will Conrad on 1/19/23.
//

import Foundation

class SavedCSVData {
    static var pantoneCSV = [[String]]()
    static var roscoCSV = [[String]]()
    init() {
        if let path = Bundle.main.path(forResource: "Pantone", ofType: "csv") {
            SavedCSVData.pantoneCSV = CSVParser(path: path, separator: ",").data
        }
        if let path = Bundle.main.path(forResource: "Rosco", ofType: "csv") {
            SavedCSVData.roscoCSV = CSVParser(path: path, separator: ",").data
        }
        
        
    }
}
