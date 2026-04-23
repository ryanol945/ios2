//
//  EndView.swift
//  ios_ass2
//
//  Created by Ryan Nolan on 22/4/2026.
//

import SwiftUI

struct EndView: View {
    
    let score: ScoreEntry
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                
                Spacer()
                
                Text("Game Over")
                    .font(.largeTitle)
                    .bold()
                
                Text(score.playerName)
                    .font(.title2)
                
                HStack(spacing: 30) {
                    Text("Points")
                        .font(.headline)
                    
                    Text("Time")
                        .font(.headline)
                }
                
                HStack(spacing: 30) {
                    Text("\(score.rawScore)")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                    
                    Text("\(score.time)")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text("Final Score")
                    .font(.largeTitle)
                
                Text("Points / Time x 10")
                    .font(.headline)
                
                Text("\(score.score)")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.blue)
                
                NavigationLink("Leaderboard") {
                    LeaderboardView()
                }
                .font(.title2)
                
                Spacer()
                
                NavigationLink("Back") {
                    MenuView()
                }
                .font(.title3)
                
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}
