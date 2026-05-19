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
    let dataPoints: [HKDataPoint]
    
    var body: some View {
        if dataPoints.isEmpty {
            ContentUnavailableView("No Data", systemImage: "waveform.slash")
        } else {
            List(dataPoints, id: \.timestamp) { point in
                HStack {
                    Label("\(Int(point.preferredDoubleValue())) \(dataPoints[0].unitString)", systemImage: systemImage)
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
        DataPointListView(title: "Heart Rate Samples", systemImage: "heart", dataPoints: hrSamples)
    }else {
        DataPointListView(title: "Heart Rate Samples", systemImage: "heart", dataPoints: [])
    }
}
