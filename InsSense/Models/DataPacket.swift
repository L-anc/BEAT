//
//  DataPacket.swift
//  InsSense
//
//  Created by Controllab on 3/31/26.
//

import Foundation
import SwiftData
import HealthKit

enum PredictedStatus: String, Codable, CaseIterable {
    case processing = "Processing"
    case sedentary = "Sedentary"
    case exercising = "Exercising"
    case stressed = "Stressed"
    
    var systemImage: String {
        switch self {
        case .processing: return "progress.indicator"
        case .sedentary: return "figure.seated.side.right"
        case .exercising: return "figure.run"
        case .stressed: return "exclamationmark.circle"
        }
    }
}

@Model
class DataPacket {
    var id: UUID
    var startDate: Date
    var endDate: Date
    var status: PredictedStatus
    
    // Stored
    var heartRateData: Data?
    var hrvData: Data?
    var activeEnergyData: Data?
    var exerciseTimeData: Data?
    var bodyTemperatureData: Data?
    var wristTemperatureData: Data?
    var respiratoryRateData: Data?
    var sleepData: Data?
    var workoutData: Data?
    var bloodGlucoseData: Data?
    var insulinData: Data?
    var hasData : Bool
    
    init(
        id: UUID = UUID(),
        startDate: Date,
        endDate: Date,
        status: PredictedStatus = .processing,
        heartRateSamples: [HKDataPoint]? = nil,
        hrvSamples: [HKDataPoint]? = nil,
        activeEnergySamples: [HKDataPoint]? = nil,
        exerciseTimeSamples: [HKDataPoint]? = nil,
        bodyTemperatureSamples: [HKDataPoint]? = nil,
        wristTemperatureSamples: [HKDataPoint]? = nil,
        respiratoryRateSamples: [HKDataPoint]? = nil,
        sleepSamples: [SleepDataPoint]? = nil,
        workoutSamples: [WorkoutDataPoint]? = nil,
        bloodGlucoseSamples: [HKDataPoint]? = nil,
        insulinSamples: [HKDataPoint]? = nil
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.status = status
        self.hasData = false
        
        // Check all parameters before encoding
        let params: [[HKDataPoint]?] = [heartRateSamples, hrvSamples, activeEnergySamples, exerciseTimeSamples, bodyTemperatureSamples, wristTemperatureSamples, respiratoryRateSamples, bloodGlucoseSamples, insulinSamples]
        
        for param in params {
            if let arr = param {
                if !arr.isEmpty {
                    self.hasData = true
                    break
                }
            }
        }
        
        if let arr = sleepSamples {
            if !arr.isEmpty {
                self.hasData = true
            }
        }
        if let arr = workoutSamples {
            if !arr.isEmpty {
                self.hasData = true
            }
        }
        
        // Encode
        let encoder = JSONEncoder()
        self.heartRateData = try? encoder.encode(heartRateSamples)
        self.hrvData = try? encoder.encode(hrvSamples)
        self.activeEnergyData = try? encoder.encode(activeEnergySamples)
        self.exerciseTimeData = try? encoder.encode(exerciseTimeSamples)
        self.bodyTemperatureData = try? encoder.encode(bodyTemperatureSamples)
        self.wristTemperatureData = try? encoder.encode(wristTemperatureSamples)
        self.respiratoryRateData = try? encoder.encode(respiratoryRateSamples)
        self.sleepData = try? encoder.encode(sleepSamples)
        self.workoutData = try? encoder.encode(workoutSamples)
        self.bloodGlucoseData = try? encoder.encode(bloodGlucoseSamples)
        self.insulinData = try? encoder.encode(insulinSamples)
    }
    
    // Link each packet with its summary
    @Relationship(deleteRule: .cascade)
    var summary: PacketSummary?
    
    // Decode all fields at once into a clean struct
    func decoded() -> DecodedPacket {
        let decoder = JSONDecoder()
        return DecodedPacket(
            id: id,
            startDate: startDate,
            endDate: endDate,
            status: status,
            heartRateSamples: try? decoder.decode([HKDataPoint].self, from: heartRateData ?? Data()),
            hrvSamples: try? decoder.decode([HKDataPoint].self, from: hrvData ?? Data()),
            activeEnergySamples: try? decoder.decode([HKDataPoint].self, from: activeEnergyData ?? Data()),
            exerciseTimeSamples: try? decoder.decode([HKDataPoint].self, from: exerciseTimeData ?? Data()),
            bodyTemperatureSamples: try? decoder.decode([HKDataPoint].self, from: bodyTemperatureData ?? Data()),
            wristTemperatureSamples: try? decoder.decode([HKDataPoint].self, from: wristTemperatureData ?? Data()),
            respiratoryRateSamples: try? decoder.decode([HKDataPoint].self, from: respiratoryRateData ?? Data()),
            sleepSamples: try? decoder.decode([SleepDataPoint].self, from: sleepData ?? Data()),
            workoutSamples: try? decoder.decode([WorkoutDataPoint].self, from: workoutData ?? Data()),
            bloodGlucoseSamples: try? decoder.decode([HKDataPoint].self, from: bloodGlucoseData ?? Data()),
            insulinSamples: try? decoder.decode([HKDataPoint].self, from: insulinData ?? Data())
        )
    }	
    
    func updateStatus(_ newStatus: PredictedStatus) {
        self.status = newStatus
    }
}

// Clean read-only view of a decoded packet
// Used when raw HealthKit data must be accessed
struct DecodedPacket {
    let id: UUID
    let startDate: Date
    let endDate: Date
    let status: PredictedStatus
    let heartRateSamples: [HKDataPoint]?
    let hrvSamples: [HKDataPoint]?
    let activeEnergySamples: [HKDataPoint]?
    let exerciseTimeSamples: [HKDataPoint]?
    let bodyTemperatureSamples: [HKDataPoint]?
    let wristTemperatureSamples: [HKDataPoint]?
    let respiratoryRateSamples: [HKDataPoint]?
    let sleepSamples: [SleepDataPoint]?
    let workoutSamples: [WorkoutDataPoint]?
    let bloodGlucoseSamples: [HKDataPoint]?
    let insulinSamples: [HKDataPoint]?
}

// Lightweight summary model for views
@Model
class PacketSummary {
    var id: UUID
    var startDate: Date
    var endDate: Date
    var avgBPM: Double?
    var status: PredictedStatus
    
    // Back-reference to datapacket
    var packet: DataPacket?
    
    init(from packet: DataPacket) {
        let decodedData = packet.decoded()
        
        self.id = decodedData.id
        self.startDate = decodedData.startDate
        self.endDate = decodedData.endDate
        
        // Because heartRateSamples is optional, we must handle nil values
        self.avgBPM = decodedData.heartRateSamples?.mean
        self.status = decodedData.status
    }
}
