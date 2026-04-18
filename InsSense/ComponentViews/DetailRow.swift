//
//  DetailRow.swift
//  InsSense
//
//  Created by Controllab on 4/18/26.
//

import SwiftUI

enum ArrayDisplay {
    case Sum
    case Mean
}

struct DetailRow: View {
    let labelText: String
    let systemImage: String
    let summaryData: String
    let dataPoints: [HKDataPoint]
    let unit: String
    
    //MARK: Overloads
    // Double optional with summaryData dependent NavLink
    init(labelText: String, systemImage: String, summaryData: [HKDataPoint]?, operation: ArrayDisplay, unit: String) {
        self.labelText = labelText
        self.systemImage = systemImage
        self.unit = unit
                
        // Catch case where summaryData is nil
        if let data = summaryData {
            var dataSummary: Double?
            
            switch operation {
            case .Sum:
                dataSummary = data.sum
            case .Mean:
                dataSummary = data.mean
            }
            
            // Unwrap data Summary. There should only be non N/A text if dataSummary returns non nil val
            if let dataSummary {
                self.summaryData = "\(Int(dataSummary)) \(unit)"
                self.dataPoints = data
            } else {
                self.summaryData = "N/A"
                self.dataPoints = []
            }
            
        } else {
            self.summaryData = "N/A"
            self.dataPoints = []
        }
    }
    
    // Date
    init(labelText: String, systemImage: String, summaryData: String) {
        self.labelText = labelText
        self.systemImage = systemImage
        self.summaryData = summaryData
        self.dataPoints = []
        self.unit = ""
    }
    
    var body: some View {
        if dataPoints.isEmpty {
            HStack {
                Label(labelText, systemImage: systemImage)
                Spacer()
                Text(summaryData)
            }
            .accessibilityElement(children: .combine)
        } else {
            NavigationLink(destination: DataPointListView(title: labelText, systemImage: systemImage, unit: unit, dataPoints: dataPoints)){
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
    DetailRow(labelText: "Avg Heart Rate Variation:", systemImage: "heart", summaryData: DataPacket.sampleDecodedPacket.hrvSamples, operation: .Mean, unit: "ms")
}
