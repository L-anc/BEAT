//
//  GraphView.swift
//  InsSense
//
//  Created by Controllab on 3/31/26.
//

import SwiftUI
import Charts

struct TimeSeriesChart<DataPoint: Identifiable>: View {

    let data: [DataPoint]

    let title: String
    let xValue: (DataPoint) -> Date
    let yValue: (DataPoint) -> Double
    let yAxisLabel: String

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(title)
                .font(.headline)

            Chart(data) { point in

                LineMark(
                    x: .value("Time", xValue(point)),
                    y: .value(yAxisLabel, yValue(point))
                )

                PointMark(
                    x: .value("Time", xValue(point)),
                    y: .value(yAxisLabel, yValue(point))
                )
            }
            .frame(height: 220)
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(12)
    }
}
