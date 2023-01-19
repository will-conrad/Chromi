//
//  CSVParser.swift
//  Chromi
//
//  Created by Will Conrad on 1/19/23.
//

import Foundation

enum FileError: Error {
  case fileNotFound
}
class CSVParser {
    var path: String
    var data: [[String]]
    
    init(path: String, separator: String) {
        self.path = path
        self.data = [[String]]()
        
        let fileURL = NSURL.fileURL(withPath: path)
        do {
            let fileData = try String(contentsOfFile: path)
            let lines = fileData.components(separatedBy: "\r\n")
            for line in lines {
                if line != "" {
                    self.data.append(line.components(separatedBy: separator))
                }
            }
        } catch {
            data = [[""]]
        }
    
    }
}
