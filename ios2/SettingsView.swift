//
//  SettingsView.swift
//  ios_ass2
//
//  Created by Ryan Nolan on 15/4/2026.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: SettingsModel
    
    var body: some View {
        Form {
            
            Section(header: Text("Game Duration")) {
                Stepper(
                    "Duration: \(Int(settings.gameDuration)) sec",
                    value: $settings.gameDuration,
                    in: 5...300,
                    step: 5
                )
            }
            
            Section(header: Text("Max Bubbles")) {
                Stepper(
                    "Bubbles: \(settings.maxBubbles)",
                    value: $settings.maxBubbles,
                    in: 1...30,
                    step: 1
                )
            }
            
            Section(header: Text("Rules")) {
                Text("Pop (tap) on a bubble to recieve the associated point score")
                    .padding(.horizontal)
                
                Text("Pop the same bubble colour consecutively for bonus points (1.5x point multiplier)")
                    .padding(.horizontal)
                
                Text("Transparent bubbles add an extra 2 seconds of time")
                    .padding(.horizontal)
                
                Text("The bubbles with speed up as the game progresses")
                    .padding(.horizontal)
                
                Text("Your final score is calculated by: Points / Time x 10")
                    .padding(.horizontal)
            }
        }
        .navigationTitle("Settings")
    }
}
