//
//  ios2App.swift
//  ios2
//
//  Created by Ryan Nolan on 22/4/2026.
//

import SwiftUI

@main
struct ios2App: App {
    init() {
        //clearUserDefaults()
    }

    var body: some Scene {
        WindowGroup {
            MenuView()
        }
    }
}

func clearUserDefaults() {
    if let bundleID = Bundle.main.bundleIdentifier {
        UserDefaults.standard.removePersistentDomain(forName: bundleID)
        UserDefaults.standard.synchronize()
    }
}
