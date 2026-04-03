//
//  InsSenseApp.swift
//  InsSense
//
//  Created by Controllab on 3/29/26.
//

import SwiftUI
import SwiftData

@main
struct InsSenseApp: App {
    
    init(){
        #if DEBUG
        UserDefaults.standard.removeObject(forKey: "firstLaunch")
        #endif
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
