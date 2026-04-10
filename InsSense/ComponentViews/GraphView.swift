//
//  GraphView.swift
//  InsSense
//
//  Created by Controllab on 3/31/26.
//

import SwiftUI
import Charts

struct TimeSeriesChart: View {
    let data: [HKDataPoint]
    let title: String
    let yAxisLabel: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            Chart(data, id: \.timestamp) { point in
                LineMark(
                    x: .value("Time", point.timestamp),
                    y: .value(yAxisLabel, point.value)
                )
                PointMark(
                    x: .value("Time", point.timestamp),
                    y: .value(yAxisLabel, point.value)
                )
            }
            .frame(height: 220)
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(12)
    }
}
