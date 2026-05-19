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

// Encode Demographics as a JSON object in UserDefaults
// Easy to access, unique, and easy to update
struct Demographics: Codable {
    var age: Int
    var sex: BiologicalSex
    var heightCm: Double
    var weightKg: Double
    
    static var current: Demographics {
        get {
            guard let data = UserDefaults.standard.data(forKey: "demographics"),
                  let decoded = try? JSONDecoder().decode(Demographics.self, from: data)
            else {
                return Demographics(age: 0, sex: .preferNotToSay, heightCm: 0, weightKg: 0)
            }
            return decoded
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: "demographics")
        }
    }
}
