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

extension Array where Element == HKDataPoint {
    var mean: Double? {
        guard !isEmpty else { return nil }
        return map { $0.value }.reduce(0, +) / Double(count)
    }
    
    var sum: Double? {
        guard !isEmpty else { return nil }
        return map { $0.value }.reduce(0, +)
    }
}
