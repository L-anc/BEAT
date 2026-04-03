//
//  FileError.swift
//  InsSense
//
//  Created by Controllab on 3/29/26.
//

import Foundation

enum FileError: LocalizedError {
    
    case fileNotFound(String)
    case fileUnreadable(Error)
    
    var errorDescription: String? {
        
        switch self {
            
            case .fileNotFound(let filename):
                return """
                The document \"\(filename).md\" could not be found.
                """
                
            case .fileUnreadable:
                return """
                The document could not be opened.
                
                The file may be corrupted or missing from the app bundle.
                """
        }
    }
}
