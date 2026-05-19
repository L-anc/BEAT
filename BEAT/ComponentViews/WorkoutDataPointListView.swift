//
//  WorkoutDataPointListView.swift
//  InsSense
//
//  Created by Controllab on 4/24/26.
//

import SwiftUI

struct WorkoutDataPointListView: View {
    let title = "Workout Samples"
    let systemImage = "figure.run"
    let unit = "min"
    let dataPoints: [WorkoutDataPoint]
    
    var body: some View {
        if dataPoints.isEmpty {
            ContentUnavailableView("No Data", systemImage: "waveform.slash")
        } else {
            List(dataPoints, id: \.timestamp) { point in
                HStack {
                    Label("\(Int(point.duration/60))", systemImage: point.systemImage)
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
    if let workoutSamples = DataPacket.sampleDecodedPacket.workoutSamples {
        WorkoutDataPointListView(dataPoints: workoutSamples)
    }else {
        WorkoutDataPointListView(dataPoints: [])
    }
}
