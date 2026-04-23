//
//  SettingsModel.swift
//  ios_ass2
//
//  Created by Ryan Nolan on 15/4/2026.
//

import Combine
import Foundation

class SettingsModel: ObservableObject {
    
    private let nameKey = "playerName"
    private let durationKey = "gameDuration"
    private let maxKey = "maxBubbles"
    
    @Published var playerName: String {
        didSet {
            UserDefaults.standard.set(playerName, forKey: nameKey)
        }
    }
    
    @Published var gameDuration: Double {
        didSet {
            UserDefaults.standard.set(gameDuration, forKey: durationKey)
        }
    }
    
    @Published var maxBubbles: Int {
        didSet {
            UserDefaults.standard.set(maxBubbles, forKey: maxKey)
        }
    }
    
    init() {
        self.playerName = UserDefaults.standard.string(forKey: nameKey) ?? ""
        
        let savedDuration = UserDefaults.standard.double(forKey: durationKey)
        self.gameDuration = savedDuration == 0 ? 60 : savedDuration
        
        let savedMax = UserDefaults.standard.integer(forKey: maxKey)
        self.maxBubbles = savedMax == 0 ? 15 : savedMax
    }
}
