//
//  StandardUnits.swift
//  InsSense
//
//  Created by Controllab on 4/21/26.
//
//  Defines the standard SI units to store datapoints in
//

import HealthKit

enum UnitSystem: String, CaseIterable {
    case metric     = "Metric"
    case imperial   = "Imperial"
}

extension HKDataPoint {
    
    static func preferredUnit(for identifier: HKQuantityTypeIdentifier) -> HKUnit {
        let system = UnitSystem(rawValue: UserDefaults.standard.string(forKey: "unitSystem") ?? "") ?? .metric
        switch system {
        case .imperial: return imperialUnit(for: identifier)
        case .metric: return siUnit(for: identifier)
        }
    }
    
    static func imperialUnit(for identifier: HKQuantityTypeIdentifier) -> HKUnit {
        switch identifier {
        case .activeEnergyBurned:               return .largeCalorie()
        case .bodyTemperature,
             .appleSleepingWristTemperature:    return .degreeFahrenheit()
        case .bloodGlucose:                     return .gramUnit(with: .milli).unitDivided(by: .literUnit(with: .deci))
        default:                                return siUnit(for: identifier)
        }
    }
        
    static func siUnit(for identifier: HKQuantityTypeIdentifier) -> HKUnit {
        switch identifier {
        case .heartRate:                             return .count().unitDivided(by: .minute())
        case .heartRateVariabilitySDNN:              return .secondUnit(with: .milli)
        case .respiratoryRate:                       return .count().unitDivided(by: .minute())
        case .activeEnergyBurned:                    return .kilocalorie()
        case .appleExerciseTime:                     return .minute()
        case .bodyTemperature,
             .appleSleepingWristTemperature:         return .degreeCelsius()
        case .bloodGlucose:                          return .moleUnit(with: .milli, molarMass: HKUnitMolarMassBloodGlucose).unitDivided(by: .liter())
        case .insulinDelivery:                       return .internationalUnit()
        default:                                     return .count()
        }
    }
    
    // MARK: - String overloads so we dont have to do funky conversions in HKDatapoint
    static func siUnit(for identifier: String) -> HKUnit {
        siUnit(for: HKQuantityTypeIdentifier(rawValue: identifier))
    }
    
    static func imperialUnit(for identifier: String) -> HKUnit {
        imperialUnit(for: HKQuantityTypeIdentifier(rawValue: identifier))
    }
}
