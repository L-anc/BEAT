//
//  HealthKitManager.swift
//  InsSense
//
//  Created by Controllab on 4/3/26.
//

import HealthKit
import Combine
import SwiftData

extension HKWorkoutActivityType {
    var name: String {
        switch self {
        case .running: return "Running"
        case .walking: return "Walking"
        case .cycling: return "Cycling"
        case .swimming: return "Swimming"
        case .yoga: return "Yoga"
        case .functionalStrengthTraining: return "Strength Training"
        case .highIntensityIntervalTraining: return "HIIT"
        default: return "Other"
        }
    }
}

class HealthKitManager: ObservableObject {
    let store = HKHealthStore() // Read only access to Apple Health Data
    private var observerQueries: [HKObserverQuery] = []
    private var context: ModelContext // Full access to app database
    
    private var packetStore: PacketStore // The packetStore abstraction
        
    init(context: ModelContext, packetStore: PacketStore) {
        self.context = context
        self.packetStore = packetStore
    }
    
    //Stores date when health data was last synced as double of seconds since 1970
    private var lastFetchDate: Date {
            get {
                let timestamp = UserDefaults.standard.double(forKey: "HKLastFetchDate")
                // Default is 0 when HKLastFetchDate has not been set
                return Date(timeIntervalSince1970: timestamp)
            }
            set {
                UserDefaults.standard.set(newValue.timeIntervalSince1970, forKey: "HKLastFetchDate")
            }
        }
    
    let readTypes: Set<HKObjectType> = [
        // Body Metrics
        HKObjectType.quantityType(forIdentifier: .bodyMass)!,
        HKObjectType.quantityType(forIdentifier: .height)!,
        
        // Heart
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
        
        // Activity
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
        
        // Temperature
        HKObjectType.quantityType(forIdentifier: .bodyTemperature)!,
        HKObjectType.quantityType(forIdentifier: .appleSleepingWristTemperature)!,
        
        // Sleep
        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
        
        // Workout
        HKObjectType.workoutType()
        
        // Glucose can be used for monitors that connect to health app
//        HKObjectType.bloodGlucose()
    ]
    
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        try await store.requestAuthorization(toShare: [], read: readTypes)
        try await enableBackgroundDelivery()
    }
    
    //MARK: - Enables Running App in the Background
    private func enableBackgroundDelivery() async throws {
        let typesToObserve: [HKSampleType] = [
            HKQuantityType(.heartRate),
            HKQuantityType(.heartRateVariabilitySDNN),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.appleExerciseTime),
            HKQuantityType(.bodyTemperature),
            HKQuantityType(.appleSleepingWristTemperature),
            HKQuantityType(.respiratoryRate),
            HKCategoryType(.sleepAnalysis),
            HKWorkoutType.workoutType()
        ]
        
        for type in typesToObserve {
            try await store.enableBackgroundDelivery(for: type, frequency: .immediate)
        }
    }
    
    // MARK: - Fetchers
        
    // Fetches the most recent sample of a quantity type
    private func fetchLatestQuantity(
        for identifier: HKQuantityTypeIdentifier,
        unit: HKUnit
    ) async throws -> Double? {
        let type = HKQuantityType(identifier)
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sort]) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                let value = (samples?.first as? HKQuantitySample)?.quantity.doubleValue(for: unit)
                continuation.resume(returning: value)
            }
            store.execute(query)
        }
    }
    
    // Fetches quantity samples within a date range
    private func fetchQuantitySamples(
        for identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        from start: Date,
        to end: Date
    ) async throws -> [HKDataPoint] {
        let type = HKQuantityType(identifier)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sort]) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                let values = (samples as? [HKQuantitySample])?.map {HKDataPoint(timestamp: $0.startDate, value: $0.quantity.doubleValue(for: unit))} ?? []
                continuation.resume(returning: values)
            }
            store.execute(query)
        }
    }
    
    // MARK: - Body Metrics
    
    func fetchBodyMass() async throws -> Double? {
        try await fetchLatestQuantity(for: .bodyMass, unit: .gramUnit(with: .kilo))
    }
    
    func fetchHeight() async throws -> Double? {
        try await fetchLatestQuantity(for: .height, unit: .meterUnit(with: .centi))
    }
    
    // MARK: - Sleep
    
    func fetchSleepSamples(from start: Date, to end: Date) async throws -> [SleepDataPoint] {
        let type = HKCategoryType(.sleepAnalysis)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sort]) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                
                let results = (samples as? [HKCategorySample])?.map { sample -> SleepDataPoint in
                    let stage: String
                    switch HKCategoryValueSleepAnalysis(rawValue: sample.value) {
                        case .asleepCore: stage = "core"
                        case .asleepDeep: stage = "deep"
                        case .asleepREM: stage = "rem"
                        case .awake: stage = "awake"
                        default: stage = "unknown"
                    }
                    return SleepDataPoint(
                        timestamp: sample.startDate,
                        stage: stage,
                        duration: sample.endDate.timeIntervalSince(sample.startDate)
                    )
                } ?? []
                
                continuation.resume(returning: results)
            }
            store.execute(query)
        }
    }
    
    // MARK: - Workouts
    
    func fetchWorkouts(from start: Date, to end: Date) async throws -> [WorkoutDataPoint] {
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sort]) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                
                let results = (samples as? [HKWorkout])?.map { workout -> WorkoutDataPoint in
                    WorkoutDataPoint(
                        timestamp: workout.startDate,
                        type: workout.workoutActivityType.name,
                        duration: workout.duration,
                        energy: workout.statistics(for: HKQuantityType(.activeEnergyBurned))?
                            .sumQuantity()?
                            .doubleValue(for: .kilocalorie()) ?? 0
                    )
                } ?? []
                
                continuation.resume(returning: results)
            }
            store.execute(query)
        }
    }
    
    
    // MARK: - Observer
    
    func startObserving() {
        // Try using Heart Rate as the trigger first. Simpler, most important, highest freq signal
//        let typesToObserve: [HKSampleType] = [
//            HKQuantityType(.heartRate),
//            HKQuantityType(.heartRateVariabilitySDNN),
//            HKQuantityType(.activeEnergyBurned),
//            HKQuantityType(.appleExerciseTime),
//            HKQuantityType(.bodyTemperature),
//            HKQuantityType(.appleSleepingWristTemperature),
//            HKQuantityType(.respiratoryRate),
//            HKQuantityType(.bloodGlucose),
//            HKQuantityType(.insulinDelivery),
//            HKCategoryType(.sleepAnalysis),
//            HKWorkoutType.workoutType()
//        ]
        
        let trigger = HKQuantityType(.heartRate)
            
            let query = HKObserverQuery(sampleType: trigger, predicate: nil) { [weak self] _, completionHandler, error in
                guard error == nil else {
                    completionHandler()
                    return
                }
                
                Task {
                    await self?.handleSync()
                    completionHandler()
                }
            }
            
            store.execute(query)
            observerQueries.append(query)
        }
    
    func stopObserving() {
        observerQueries.forEach { store.stop($0) }
        observerQueries.removeAll()
    }
    
    // MARK: - Sync Handling
    
    private func handleSync() async {
        let from = lastFetchDate
        let to = Date.now
        
        do {
            let packet = try await buildPacket(from: from, to: to)
            
            // Only continue if at least some data arrived
            guard packet.hasData else { return }
            
            // Update lastFetchDate
            lastFetchDate = to
            
            let summary = PacketSummary(from: packet)
            
            // Link summary to packet to enable cascade insert/delete
            packet.summary = summary
            
            await MainActor.run {
                // insert into SwiftData context
                print("New packet built: \(packet.startDate) → \(packet.endDate)")
                context.insert(packet)
                // Trim expired packets (3 hr window) from SwiftData
                try? packetStore.deleteExpiredPackets()
            }
        } catch {
            print("Sync failed: \(error)")
        }
    }
    
    // MARK: - Packet Builder
    
    private func buildPacket(from start: Date, to end: Date) async throws -> DataPacket {
        let bpmUnit = HKUnit.count().unitDivided(by: .minute())
        
        async let heartRate = try? fetchQuantitySamples(for: .heartRate, unit: bpmUnit, from: start, to: end)
        async let hrv = try? fetchQuantitySamples(for: .heartRateVariabilitySDNN, unit: .secondUnit(with: .milli), from: start, to: end)
        async let energy = try? fetchQuantitySamples(for: .activeEnergyBurned, unit: .kilocalorie(), from: start, to: end)
        async let exercise = try? fetchQuantitySamples(for: .appleExerciseTime, unit: .minute(), from: start, to: end)
        async let bodyTemp = try? fetchQuantitySamples(for: .bodyTemperature, unit: .degreeCelsius(), from: start, to: end)
        async let wristTemp = try? fetchQuantitySamples(for: .appleSleepingWristTemperature, unit: .degreeCelsius(), from: start, to: end)
        async let respiratory = try? fetchQuantitySamples(for: .respiratoryRate, unit: bpmUnit, from: start, to: end)
        async let glucose = try? fetchQuantitySamples(for: .bloodGlucose, unit: .moleUnit(with: .milli, molarMass: HKUnitMolarMassBloodGlucose).unitDivided(by: .liter()), from: start, to: end)
        async let insulin = try? fetchQuantitySamples(for: .insulinDelivery, unit: .internationalUnit(), from: start, to: end)
        async let sleep = try? fetchSleepSamples(from: start, to: end)
        async let workouts = try? fetchWorkouts(from: start, to: end)

        return DataPacket(
            startDate: start,
            endDate: end,
            heartRateSamples: await heartRate,
            hrvSamples: await hrv,
            activeEnergySamples: await energy,
            exerciseTimeSamples: await exercise,
            bodyTemperatureSamples: await bodyTemp,
            wristTemperatureSamples: await wristTemp,
            respiratoryRateSamples: await respiratory,
            sleepSamples: await sleep,
            workoutSamples: await workouts,
            bloodGlucoseSamples: await glucose,
            insulinSamples: await insulin
        )
    }
}
