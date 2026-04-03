//
//  Welcome.swift
//  InsSense
//
//  Created by Controllab on 3/31/26.
//

import SwiftUI

struct WelcomeView: View {
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 32) {
                
                Spacer()
                
                Image(scheme == .dark ? "IITLogoDark" : "IITLogoLight")
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                VStack(spacing: 12) {
                    Text("Welcome")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("This app collects biometric data to help improve diabetes research.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 16) {
                    
                    FeatureRow(
                        icon: "heart.fill",
                        title: "Heart Rate Tracking",
                        description: "Collect BPM data from Apple Watch sensors"
                    )
                    
                    FeatureRow(
                        icon: "figure.run",
                        title: "Activity Monitoring",
                        description: "Identify sedentary and active states"
                    )
                    
                    FeatureRow(
                        icon: "lock.fill",
                        title: "Privacy First",
                        description: "Your data is stored securely, anonymized, and only used for research"
                    )
                }
                
                Spacer()
                
                NavigationLink("Get Started") {
                    DisclaimerView()
                }
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

#Preview {
    WelcomeView()
}
