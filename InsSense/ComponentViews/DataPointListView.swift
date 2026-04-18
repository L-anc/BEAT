//
//  DataPointListView.swift
//  InsSense
//
//  Created by Controllab on 4/17/26.
//

import SwiftUI

struct DataPointListView: View {
    let title: String
    let systemImage: String
    let unit: String
    let dataPoints: [HKDataPoint]

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .medium
        return f
    }()

    var body: some View {
        if dataPoints.isEmpty {
            ContentUnavailableView("No Data", systemImage: "waveform.slash")
        } else {
            List(dataPoints, id: \.timestamp) { point in
                HStack {
                    Label("\(Int(point.value))", systemImage: systemImage)
                    Spacer()
                    Text("\(point.timestamp.formatted(.dateTime.hour().minute()))")
                        .foregroundColor(.secondary)
                }
                .listRowBackground(Color.gray.opacity(0.2))
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    if let hrSamples = DataPacket.sampleDecodedPacket.heartRateSamples {
        DataPointListView(title: "Heart Rate Samples", systemImage: "heart", unit: "bpm", dataPoints: hrSamples)
    }else {
        DataPointListView(title: "Heart Rate Samples", systemImage: "heart", unit: "bpm", dataPoints: [])
    }
}
