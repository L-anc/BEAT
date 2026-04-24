import Foundation
import HealthKit

extension DataPacket {
    static var sampleData: [DataPacket] {[
        DataPacket(
            id: UUID(uuidString: "A1B2C3D4-E5F6-7890-ABCD-EF1234567890")!,
            startDate: Date.now.addingTimeInterval(-7200), // 2hrs ago
            endDate: Date.now.addingTimeInterval(-6900),
            status: .sedentary,
            heartRateSamples: [
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1060), value: 72),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1120), value: 75),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1180), value: 71)
            ],
            hrvSamples: [
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1060), value: 45.2),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1120), value: 48.1),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1180), value: 44.8)
            ],
            activeEnergySamples: [
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1060), value: 1.2),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1120), value: 1.4),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1180), value: 1.1)
            ],
            exerciseTimeSamples: nil,
            bodyTemperatureSamples: nil,
            wristTemperatureSamples: nil,
            respiratoryRateSamples: nil,
            sleepSamples: nil,
            workoutSamples: nil,
            bloodGlucoseSamples: [
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1000), value: 5.2),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1150), value: 5.4),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1280), value: 5.1)
            ],
            insulinSamples: nil
        ),
        DataPacket(
            id: UUID(uuidString: "BAA7EE46-E39D-4119-AA00-07B6628F5DF0")!,
            startDate: Date.now.addingTimeInterval(-3600), // 1hr ago
            endDate: Date.now.addingTimeInterval(-3000),
            status: .exercising,
            heartRateSamples: [
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 2060), value: 110),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 2120), value: 118),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 2180), value: 122),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 2240), value: 115)
            ],
            hrvSamples: [
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 2060), value: 28.4),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 2120), value: 26.1),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 2180), value: 29.3)
            ],
            activeEnergySamples: [
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 2060), value: 8.2),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 2120), value: 9.1),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 2180), value: 8.8)
            ],
            exerciseTimeSamples: nil,
            bodyTemperatureSamples: nil,
            wristTemperatureSamples: nil,
            respiratoryRateSamples: nil,
            sleepSamples: nil,
            workoutSamples: [
                WorkoutDataPoint(
                    timestamp: Date(timeIntervalSince1970: 2000),
                    type: .running,
                    duration: 300,
                    energy: 280
                )
            ],
            bloodGlucoseSamples: [
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 2000), value: 6.1),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 2150), value: 5.8),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 2280), value: 5.5)
            ],
            insulinSamples: nil
        ),
        DataPacket(
            id: UUID(uuidString: "B1C7E16D-FDA9-44D5-8591-353917D8ECB3")!,
            startDate: Date.now.addingTimeInterval(-1800), // 30 min ago
            endDate: Date.now.addingTimeInterval(-1600),
            status: .sedentary,
            heartRateSamples: [
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 3060), value: 58),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 3120), value: 55),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 3180), value: 57)
            ],
            hrvSamples: [
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 3060), value: 62.1),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 3120), value: 65.4),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 3180), value: 60.8)
            ],
            activeEnergySamples: nil,
            exerciseTimeSamples: nil,
            bodyTemperatureSamples: nil,
            wristTemperatureSamples: [
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 3000), value: 35.8),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 3150), value: 35.6)
            ],
            respiratoryRateSamples: nil,
            sleepSamples: [
                SleepDataPoint(timestamp: Date(timeIntervalSince1970: 3000), stage: "deep", duration: 90 * 60),
                SleepDataPoint(timestamp: Date(timeIntervalSince1970: 3090), stage: "rem", duration: 60 * 60),
                SleepDataPoint(timestamp: Date(timeIntervalSince1970: 3150), stage: "core", duration: 50 * 60)
            ],
            workoutSamples: nil,
            bloodGlucoseSamples: nil,
            insulinSamples: nil
        )
    ]}
    
    static var sampleDecodedPacket: DecodedPacket{
        DecodedPacket(
            id: UUID(),
            startDate: Date.now.addingTimeInterval(-1000),
            endDate: Date.now.addingTimeInterval(-600),
            status: .sedentary,
            heartRateSamples: [
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1060), value: 72),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1120), value: 75),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1180), value: 71)
            ],
            hrvSamples: [
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1060), value: 45.2),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1120), value: 48.1),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1180), value: 44.8)
            ],
            activeEnergySamples: [
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1060), value: 1.2),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1120), value: 1.4),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1180), value: 1.1)
            ],
            exerciseTimeSamples: nil,
            bodyTemperatureSamples: nil,
            wristTemperatureSamples: nil,
            respiratoryRateSamples: nil,
            sleepSamples: nil,
            workoutSamples: nil,
            bloodGlucoseSamples: [
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1000), value: 5.2),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1150), value: 5.4),
                HKDataPoint(timestamp: Date(timeIntervalSince1970: 1280), value: 5.1)
            ],
            insulinSamples: nil
        )
    }
    
    static var sampleSummaries: [PacketSummary]{[
        PacketSummary(from: sampleData[0]),
        PacketSummary(from: sampleData[1]),
        PacketSummary(from: sampleData[2])
    ]}
}
