//
//  LeaderboardModel.swift
//  ios2
//
//  Created by Ryan Nolan on 22/4/2026.
//

import Foundation

struct ScoreEntry: Identifiable, Codable { //saveable
    let id: UUID
    let playerName: String
    let rawScore: Int
    let score: Int
    let time: Int
    
    init(playerName: String, score: Int, time: Int) {
        self.id = UUID()
        self.playerName = playerName
        
        let calculated = Double(score) / Double(time)
        self.score = Int((calculated * 10).rounded())
        
        self.rawScore = score
        self.time = time
    }
}

class ScoreDatabase {
    
    private let key = "scores"
    
    func load() -> [ScoreEntry] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([ScoreEntry].self, from: data) else {
            return []
        }
        return decoded.sorted { $0.score > $1.score }
    }
    
    func save(_ scores: [ScoreEntry]) {
        let data = try? JSONEncoder().encode(scores)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func add(_ entry: ScoreEntry) {
        var current = load()
        
        if let index = current.firstIndex(where: { $0.playerName == entry.playerName }) {
            if entry.score > current[index].score {
                current[index] = entry
            }
        } else {
            current.append(entry)
        }
        
        save(current)
    }
}
