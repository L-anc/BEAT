//
//  RootView.swift
//  InsSense
//
//  Created by Controllab on 4/2/26.
//

import SwiftUI

struct RootView: View {
    @AppStorage("firstLaunch")
    private var firstLaunch: Bool = true

    var body: some View {
        Group{
            if firstLaunch {
                WelcomeView()
                    
            } else {
                HomeView(demographics: Demographics.sampleData, packets: DataPacket.sampleData)
            }
        }.animation(.easeIn(duration: 1), value: firstLaunch)
    }
}

#Preview {
    RootView()
}
