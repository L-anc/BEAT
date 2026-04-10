//
//  HKDatapoint.swift
//  InsSense
//
//  Created by Controllab on 4/8/26.
//

import Foundation

// Encodes a biometric point reading and its timestamp
// Works for standard non-exercise, non-sleep readings
struct HKDataPoint: Codable {
    let timestamp: Date
    let value: Double
}

// Specialized struct for sleep data
struct SleepDataPoint: Codable {
    let timestamp: Date
    let stage: String
    let duration: Double
}


struct WorkoutDataPoint: Codable {
    let timestamp: Date
    let type: String
    let duration: Double
    let energy: Double
}

// MARK: - Codable Helper

private func encode<T: Codable>(_ value: T?) -> Data? {
    try? JSONEncoder().encode(value)
}

private func decode<T: Codable>(_ data: Data?) -> T? {
    guard let data else { return nil }
    return try? JSONDecoder().decode(T.self, from: data)
}
