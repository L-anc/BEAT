//
//  DataPacket.swift
//  InsSense
//
//  Created by Controllab on 3/31/26.
//

import Foundation
import SwiftData

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
    var date: Date
    var avgBPM: Int
    var avgMotion: Double
    var status: PredictedStatus
    
    init(id: UUID = UUID(), date: Date, avgBPM: Int, avgMotion: Double, status: PredictedStatus = .processing) {
        self.id = id
        self.date = date
        self.avgBPM = avgBPM
        self.avgMotion = avgMotion
        self.status = status
    }
    
    func updateStatus(newStatus: PredictedStatus) {
        self.status = newStatus
    }
    
    static var sampleData: [DataPacket] {[
        DataPacket(date: Date(timeIntervalSince1970: 1000), avgBPM: 72, avgMotion: 0.2, status: .sedentary),
        DataPacket(date: Date(timeIntervalSince1970: 2000), avgBPM: 110, avgMotion: 0.8, status: .exercising),
        DataPacket(date: Date(timeIntervalSince1970: 3000), avgBPM: 95, avgMotion: 0.1, status: .stressed),
        DataPacket(date: Date(timeIntervalSince1970: 3100), avgBPM: 70, avgMotion: 0.1, status: .sedentary),
        DataPacket(date: Date(timeIntervalSince1970: 3200), avgBPM: 160, avgMotion: 5, status: .exercising),
        DataPacket(date: Date(timeIntervalSince1970: 3250), avgBPM: 110,avgMotion: 0.1, status: .stressed),
        DataPacket(date: Date(timeIntervalSince1970: 3300), avgBPM: 110, avgMotion: 10),
        DataPacket(date: Date(timeIntervalSince1970: 3600), avgBPM: 110, avgMotion: 10),
        DataPacket(date: Date(timeIntervalSince1970: 3750), avgBPM: 110, avgMotion: 10)
    ]}
}
