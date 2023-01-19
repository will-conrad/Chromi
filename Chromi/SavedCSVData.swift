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
        SavedCSVData.pantoneCSV = CSVParser(path: "/Users/willconrad/Downloads/Data/Pantone.csv", separator: ",").data
        SavedCSVData.roscoCSV = CSVParser(path: "/Users/willconrad/Downloads/Data/Rosco.csv", separator: ",").data
    }
}
