//
//  FeatureRow.swift
//  InsSense
//
//  Created by Controllab on 3/31/26.
//

import SwiftUI

struct FeatureRow: View {

    let icon: String
    let title: String
    let description: String

    var body: some View {

        HStack(spacing: 16) {

            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 4) {

                Text(title)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }
}
