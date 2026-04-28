//
//  DetailRow.swift
//  InsSense
//
//  Created by Controllab on 4/18/26.
//

import SwiftUI

struct DetailRow: View {
    let labelText: String
    let systemImage: String
    let summaryData: String
    let dataPoints: [HKDataPoint]
    
    //MARK: - Overloads
    
    // Double optional with summaryData dependent NavLink
    init(labelText: String, systemImage: String, summaryData: [HKDataPoint]?, operation: ArrayDisplay) {
        self.labelText = labelText
        self.systemImage = systemImage
                
        // Catch case where summaryData is nil
        if let data = summaryData {
            var dataSummary: Double?
            
            switch operation {
            case .Sum:
                dataSummary = data.preferredSum
            case .Mean:
                dataSummary = data.preferredMean
            }
            
            // Unwrap data Summary. There should only be non N/A text if dataSummary returns non nil val
            if let dataSummary {
                self.dataPoints = data
                self.summaryData = "\(Int(dataSummary)) \(dataPoints[0].unitString)"
            } else {
                self.summaryData = ""
                self.dataPoints = []
            }
            
        } else {
            self.summaryData = ""
            self.dataPoints = []
        }
    }
    
    
    // Date
    init(labelText: String, systemImage: String, summaryData: String) {
        self.labelText = labelText
        self.systemImage = systemImage
        self.summaryData = summaryData
        self.dataPoints = []
    }
    
    var body: some View {
        if dataPoints.isEmpty {
            if summaryData != "" {
                HStack {
                    Label(labelText, systemImage: systemImage)
                    Spacer()
                    Text(summaryData)
                }
                .accessibilityElement(children: .combine)
            }
        } else {
            NavigationLink(destination: DataPointListView(title: labelText, systemImage: systemImage, dataPoints: dataPoints)){
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
    DetailRow(labelText: "Avg Heart Rate Variation:", systemImage: "heart", summaryData: DataPacket.sampleDecodedPacket.hrvSamples, operation: .Mean)
}
