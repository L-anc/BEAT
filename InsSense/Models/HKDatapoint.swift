//
//  HKDatapoint.swift
//  InsSense
//
//  Created by Controllab on 4/8/26.
//

import Foundation
import HealthKit

// Encodes a biometric point reading and its timestamp
// Works for standard non-exercise, non-sleep readings
struct HKDataPoint: Codable {
    let timestamp: Date
    let value: Double
    let unitString: String  // Uses standard SI units
    
    // Initialize
    init(sample: HKQuantitySample) {
        self.timestamp = sample.startDate
        self.unitString = sample.quantityType.identifier
        
        // Handle getting the SI value from the HKQuantitySample
        let identifier = HKQuantityTypeIdentifier(rawValue: unitString)
        let unit = HKDataPoint.siUnit(for: identifier)
        self.value = sample.quantity.doubleValue(for: unit)
    }
    
    #if DEBUG
    // Way to initialize HKDataPoint for sample testing
    init(timestamp: Date, value: Double){
        self.timestamp = timestamp
        self.value = value
        self.unitString = ""
    }
    #endif
    
    // Reconstruct an HKQuantity on demand
    var quantity: HKQuantity {
        HKQuantity(unit: HKUnit(from: unitString), doubleValue: value)
    }
    
    // Convert to any compatible unit at read time
    func doubleValue(for unit: HKUnit) -> Double {
        quantity.doubleValue(for: unit)
    }
    
    func preferredDoubleValue() -> Double {
        doubleValue(for: HKUnit(from: self.unitString))
    }
}

// Specialized struct for sleep data
struct SleepDataPoint: Codable {
    let timestamp: Date
    let stage: String
    let duration: Double
    
    init(sample: HKCategorySample) {
        self.timestamp = sample.startDate
        self.duration = sample.endDate.timeIntervalSince(sample.startDate)
        
        // Encode sleep stages as strings
        let stage: String
        switch HKCategoryValueSleepAnalysis(rawValue: sample.value) {
            case .asleepCore: stage = "core"
            case .asleepDeep: stage = "deep"
            case .asleepREM: stage = "rem"
            case .awake: stage = "awake"
            default: stage = "unknown"
        }
        self.stage = stage
    }
    
    #if DEBUG
    // Way to initialize SleepDataPoint for sample testing
    init(timestamp: Date, stage: String, duration: Double){
        self.timestamp = timestamp
        self.stage = stage
        self.duration = duration
    }
    #endif
}

struct WorkoutDataPoint: Codable {
    let timestamp: Date
    let type: String
    let duration: Double
    let energy: Double
    
    init(sample: HKWorkout) {
        self.timestamp = sample.startDate
        self.type = sample.workoutActivityType.name
        self.duration = sample.duration
        self.energy = sample.statistics(for: HKQuantityType(.activeEnergyBurned))?
            .sumQuantity()?
            .doubleValue(for: .kilocalorie()) ?? 0
    }
    
    #if DEBUG
    // Way to initialize WorkoutDataPoint for sample testing
    init(timestamp: Date, type: String, duration: Double, energy: Double){
        self.timestamp = timestamp
        self.type = type
        self.duration = duration
        self.energy = energy
    }
    #endif
}

// MARK: - Codable Helper

private func encode<T: Codable>(_ value: T?) -> Data? {
    try? JSONEncoder().encode(value)
}

private func decode<T: Codable>(_ data: Data?) -> T? {
    guard let data else { return nil }
    return try? JSONDecoder().decode(T.self, from: data)
}
