//
//  LeaderboardView.swift
//  ios2
//
//  Created by Ryan Nolan on 23/4/2026.
//

import Foundation


import SwiftUI

struct LeaderboardView: View {
    private let db = ScoreDatabase()
    
    @State private var scores: [ScoreEntry] = []
    
    var body: some View {
        NavigationStack {
            VStack() {
                Text("Leaderboard")
                    .font(.title)
                    .bold()
                    
                List(scores) { entry in
                    HStack {
                        Text(entry.playerName)
                        Spacer()
                        Text("\(entry.score)")
                    }
                }
            }
        }
        .onAppear {
            scores = db.load()
        }
    }
}
