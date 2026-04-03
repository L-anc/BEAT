//
//  Demographics.swift
//  InsSense
//
//  Created by Controllab on 3/31/26.
//

import Foundation

// Enum that has associated string value, can be iterated over,
// has hashable unique id, and can be converted to JSON natively
enum BiologicalSex: String, CaseIterable, Identifiable, Codable {
    case male = "male"
    case female = "female"
    case intersex = "intersex"
    case preferNotToSay = "prefer not to say"
    
    var id: String { rawValue }
}

struct Demographics: Codable {
    var age: Int
    var sex: BiologicalSex
    var heightCm: Double
    var weightKg: Double
}
