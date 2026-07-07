//
//  PacketUploader.swift
//  BEAT
//
//  Created by Controllab on 7/2/26.
//

import Foundation

// The upload endpoint and API key live in Config.swift (gitignored,
// per-environment — see Config.swift.example)

// JSON body sent to the server. Mirrors DecodedPacket plus a stable
// per-install device ID so MongoDB can group packets by device.
nonisolated struct PacketPayload: Codable {
    let id: UUID
    let deviceId: String
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

    init(from packet: DecodedPacket, deviceId: String) {
        self.id = packet.id
        self.deviceId = deviceId
        self.startDate = packet.startDate
        self.endDate = packet.endDate
        self.status = packet.status
        self.heartRateSamples = packet.heartRateSamples
        self.hrvSamples = packet.hrvSamples
        self.activeEnergySamples = packet.activeEnergySamples
        self.exerciseTimeSamples = packet.exerciseTimeSamples
        self.bodyTemperatureSamples = packet.bodyTemperatureSamples
        self.wristTemperatureSamples = packet.wristTemperatureSamples
        self.respiratoryRateSamples = packet.respiratoryRateSamples
        self.sleepSamples = packet.sleepSamples
        self.workoutSamples = packet.workoutSamples
        self.bloodGlucoseSamples = packet.bloodGlucoseSamples
        self.insulinSamples = packet.insulinSamples
    }
}

// POSTs each new packet to the server. Failed uploads are kept in an
// in-memory queue and retried the next time a packet is uploaded.
actor PacketUploader {
    private var pendingPayloads: [PacketPayload] = []

    // Bounds retry memory; oldest packets are dropped first, matching the
    // app's rolling local storage window
    private let maxPending = 50

    // Stable ID for this install, generated once. UserDefaults is thread-safe,
    // so this is safe to read from the actor
    nonisolated static var deviceId: String {
        if let existing = UserDefaults.standard.string(forKey: "BEATDeviceID") {
            return existing
        }
        let newId = UUID().uuidString
        UserDefaults.standard.set(newId, forKey: "BEATDeviceID")
        return newId
    }

    func upload(_ packet: DecodedPacket) async {
        pendingPayloads.append( PacketPayload(from: packet, deviceId: Self.deviceId))
        if pendingPayloads.count > maxPending {
            pendingPayloads.removeFirst(pendingPayloads.count - maxPending)
        }
        await flush()
    }

    // Attempts to send everything in the queue, stopping at the first failure
    func flush() async {
        while let payload = pendingPayloads.first {
            do {
                try await send(payload)
                pendingPayloads.removeFirst()
                print("Uploaded packet \(payload.id)")
            } catch {
                print("Upload failed (\(pendingPayloads.count) queued): \(error)")
                return
            }
        }
    }

    private func send(_ payload: PacketPayload) async throws {
        var request = URLRequest(url: UploadEndpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let key = UploadAPIKey {
            request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(payload)

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
