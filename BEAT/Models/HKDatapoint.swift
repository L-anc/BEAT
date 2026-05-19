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
    let value: Double // The datapoint value in standard SI units
    let identifier: String // Identifies the type of HealthKit data, necessary for unit conversions
    let unitString: String  // The SI units of the datapoint
    
    // Initialize
    init(sample: HKQuantitySample) {
        self.timestamp = sample.startDate
        
        // Handle getting the SI value from the HKQuantitySample
        self.identifier = sample.quantityType.identifier
        let unit = HKDataPoint.siUnit(for: identifier)
        self.unitString = unit.unitString
        self.value = sample.quantity.doubleValue(for: unit)
    }
    
    #if DEBUG
    // Way to initialize HKDataPoint for sample testing
    init(timestamp: Date, value: Double){
        self.timestamp = timestamp
        self.value = value
        self.unitString = ""
        self.identifier = ""
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
    
    // Return the double value in user preferred units
    func preferredDoubleValue() -> Double {
        guard let unitSystem = UserDefaults.standard.string(forKey: "unitSystem")
        else { return self.value} // Default to SI value when no preference is set
        
        if unitSystem == "metric"{
            return self.value
        }
        
        // Convert to metric
        let unit = HKDataPoint.imperialUnit(for: self.identifier)
        return doubleValue(for: unit)
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
    let systemImage: String
    
    init(sample: HKWorkout) {
        self.timestamp = sample.startDate
        self.type = sample.workoutActivityType.name
        self.duration = sample.duration
        self.energy = sample.statistics(for: HKQuantityType(.activeEnergyBurned))?
            .sumQuantity()?
            .doubleValue(for: .kilocalorie()) ?? 0
        self.systemImage = sample.workoutActivityType.systemImageName
    }
    
    #if DEBUG
    // Way to initialize WorkoutDataPoint for sample testing
    init(timestamp: Date, type: HKWorkoutActivityType, duration: Double, energy: Double){
        self.timestamp = timestamp
        self.type = type.name
        self.duration = duration
        self.energy = energy
        self.systemImage = type.systemImageName
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
