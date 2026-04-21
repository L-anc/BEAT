//
//  UnitConverter.swift
//  InsSense
//
//  Created by Controllab on 4/21/26.
//

// UnitConverter.swift

import HealthKit

extension Demographics {
    
    // MARK: - Height
    // Stored as: cm
    
    static func heightDisplay(from cm: Double, system: UnitSystem) -> String {
        guard cm > 0 else { return "" }
        switch system {
        case .metric: return "\(Int(cm))"
        case .imperial:
            let totalInches = cm / 2.54
            let feet = Int(totalInches / 12)
            let inches = Int(totalInches.truncatingRemainder(dividingBy: 12))
            return "\(feet)'\(inches)\""
        }
    }
    
    static func heightCm(from text: String, system: UnitSystem) -> Double? {
        switch system {
        case .metric:
            return Double(text)
        case .imperial:
            let cleaned = text.filter { $0.isNumber || $0 == "'" }
            let parts = cleaned.split(separator: "'")
            guard let feet = Double(parts[0]) else { return nil }
            let inches = parts.count > 1 ? Double(parts[1]) ?? 0 : 0
            return (feet * 12 + inches) * 2.54
        }
    }
    
    // MARK: - Weight
    // Stored as: kg
    
    static func weightDisplay(from kg: Double, system: UnitSystem) -> String {
        guard kg > 0 else { return "" }
        switch system {
        case .metric:   return "\(Int(kg))"
        case .imperial: return "\(Int((kg * 2.20462).rounded()))"
        }
    }
    
    static func weightKg(from text: String, system: UnitSystem) -> Double? {
        guard let val = Double(text) else { return nil }
        switch system {
        case .metric:   return val
        case .imperial: return val / 2.20462
        }
    }
    
    
    // MARK: - Unit Labels (for field headers)
    
    static func heightUnit(for system: UnitSystem) -> String {
        system == .imperial ? "ft/in" : "cm"
    }
    
    static func weightUnit(for system: UnitSystem) -> String {
        system == .imperial ? "lbs" : "kg"
    }
    
}
