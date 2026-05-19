//
//  RootView.swift
//  InsSense
//
//  Created by Controllab on 4/2/26.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @AppStorage("firstLaunch")
    private var firstLaunch: Bool = true

    var body: some View {
        Group{
            if firstLaunch {
                WelcomeView()
            } else {
                HomeView()
            }
        }.animation(.easeIn(duration: 1), value: firstLaunch)
    }
}

#Preview {
    RootView().withAppEnvironment()
}
