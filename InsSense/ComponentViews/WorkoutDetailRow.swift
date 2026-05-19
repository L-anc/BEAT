//
//  WorkoutDetailRow.swift
//  InsSense
//
//  Created by Controllab on 4/24/26.
//

//
//  SleepDetailRow.swift
//  InsSense
//
//  Created by Controllab on 4/24/26.
//

import SwiftUI


struct WorkoutDetailRow: View {
    let labelText = "Workouts:"
    let systemImage = "figure.run"
    let summaryData: String
    let dataPoints: [WorkoutDataPoint]
    let unit = "min"
    
    //MARK: - Overloads
    
    // Double optional with summaryData dependent NavLink
    init(summaryData: [WorkoutDataPoint]?) {
        // Catch case where summaryData is nil
        if let data = summaryData {
            var dataSummary: Double?
            
            dataSummary = data.sum
            
            // Unwrap data Summary. There should only be non N/A text if dataSummary returns non nil val
            if let dataSummary {
                let mins = Int(dataSummary)
                
                // Display workouts longer than an hour in hours
                if mins >= 60 {
                    let hrs = Double(mins/60)
                    self.summaryData = "\(hrs.formatted(.number.precision(.fractionLength(2)))) hrs"
                    self.dataPoints = data
                } else {
                    self.summaryData = "\(Int(dataSummary)) \(unit)"
                    self.dataPoints = data
                }
            } else {
                self.summaryData = ""
                self.dataPoints = []
            }
            
        } else {
            self.summaryData = ""
            self.dataPoints = []
        }
    }
    
    var body: some View {
        if !dataPoints.isEmpty {
            NavigationLink(destination: WorkoutDataPointListView(dataPoints: dataPoints)){
                HStack {
                    Label(labelText, systemImage: systemImage)
                    Spacer()
                    Text(summaryData)
                }
                .accessibilityElement(children: .combine)
            }
        }
    }
}

#Preview {
    SleepDetailRow(summaryData: DataPacket.sampleDecodedPacket.sleepSamples)
}
