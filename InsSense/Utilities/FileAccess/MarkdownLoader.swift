//
//  MarkdownLoader.swift
//  ChatPrototype
//
//  Created by Controllab on 3/29/26.
//

import Foundation

struct MarkdownLoader {

    static func load(
        _ filename: String
    ) throws -> String {
        
        // Attempt to retrieve resource file
        guard let url = Bundle.main.url(
            forResource: filename,
            withExtension: "md"
        ) else {
            throw FileError.fileNotFound(filename)
        }
        
        // Attempt to retrieve raw text from resource file
        do {
            return try String(contentsOf: url, encoding: .utf8)
        }
        catch {
            throw FileError.fileUnreadable(error)
        }
    }
}
