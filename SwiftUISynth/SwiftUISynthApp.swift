//
//  SwiftUISynthApp.swift
//  SwiftUISynth
//
//  Created by James Baxter on 24/07/2022.
//

import SwiftUI

@main
struct SwiftUISynthApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentView.ViewModel(synth: Synth()))
        }
    }
}
