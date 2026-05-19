//
//  SleepDetailRow.swift
//  InsSense
//
//  Created by Controllab on 4/24/26.
//

import SwiftUI


struct SleepDetailRow: View {
    let labelText = "Sleep:"
    let systemImage = "bed.double"
    let summaryData: String
    let dataPoints: [SleepDataPoint]
    let unit = "min"
    
    //MARK: - Overloads
    
    // Double optional with summaryData dependent NavLink
    init(summaryData: [SleepDataPoint]?) {
        // Catch case where summaryData is nil
        if let data = summaryData {
            var dataSummary: Double?
            
            dataSummary = data.sum
            
            // Unwrap data Summary. There should only be non N/A text if dataSummary returns non nil val
            if let dataSummary {
                self.summaryData = "\(Int(dataSummary/60)) \(unit)" // Divide by 60 because duration is in sec
                self.dataPoints = data
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
            NavigationLink(destination: SleepPieChartView(dataPoints: dataPoints)){
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
