//
//  ArrayExtensions.swift
//  InsSense
//
//  Created by Controllab on 4/3/26.
//

extension Array where Element == Double {
    var mean: Double {
        return isEmpty ? 0.0 : reduce(0, +) / Double(count)
    }
}

// MARK: - Biometric Datapoint Extensions

enum ArrayDisplay {
    case Sum
    case Mean
}

/// HKDatapoint Array Extensions for quick view processing
extension Array where Element == HKDataPoint {
    var mean: Double? {
        guard !isEmpty else { return nil }
        return map { $0.value }.reduce(0, +) / Double(count)
    }
    
    var sum: Double? {
        guard !isEmpty else { return nil }
        return map { $0.value }.reduce(0, +)
    }
    
    var preferredMean: Double? {
        guard !isEmpty else { return nil }
        return map { $0.preferredDoubleValue() }.reduce(0, +) / Double(count)
    }
    
    var preferredSum: Double? {
        guard !isEmpty else { return nil }
        return map { $0.preferredDoubleValue() }.reduce(0, +)
    }
}

/// SleepDataPoint Array Extensions for quick view processing
extension Array where Element == SleepDataPoint {
    var mean: Double? {
        guard !isEmpty else { return nil }
        return map { $0.duration }.reduce(0, +) / Double(count)
    }
    
    var sum: Double? {
        guard !isEmpty else { return nil }
        return map { $0.duration }.reduce(0, +)
    }
}

/// WorkoutDataPoint Array Extensions for quick view processing
extension Array where Element == WorkoutDataPoint {
    var mean: Double? {
        guard !isEmpty else { return nil }
        return map { $0.duration }.reduce(0, +) / Double(count)
    }
    
    var sum: Double? {
        guard !isEmpty else { return nil }
        return map { $0.duration }.reduce(0, +)
    }
}
