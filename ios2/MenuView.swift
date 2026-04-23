//
//  MenuView.swift
//  ios_ass2
//
//  Created by Ryan Nolan on 15/4/2026.
//


import SwiftUI

struct MenuView: View {
    @StateObject var settings = SettingsModel()
    
    @State private var menuBubbles: [MenuBubble] = []
    let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            ZStack {
                //background bubbles
                ForEach(menuBubbles) { bubble in
                    Circle()
                        .fill(bubble.color.opacity(0.3))
                        .frame(width: bubble.size, height: bubble.size)
                        .position(x: bubble.x, y: bubble.y)
                }
                
                VStack(spacing: 25) {
                    
                    Spacer()
                    
                    Text("Bubble Pop")
                        .font(.largeTitle)
                        .bold()
                    
                    NavigationLink("Start Game") {
                        ContentView(settings: settings)
                    }
                    .font(.title2)
                    .padding()
                    .frame(width: 200)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    
                    HStack(spacing: 10) {
                        TextField("Name", text: $settings.playerName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 150)
                        
                        NavigationLink("Settings") {
                            SettingsView(settings: settings)
                        }
                        .font(.title3)
                    }
                    
                    Spacer()
                    
                    NavigationLink("Leaderboard") {
                        LeaderboardView()
                    }
                    .font(.title)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            menuBubbles = (0..<15).map { _ in
                MenuBubble(
                    x: CGFloat.random(in: 0...300),
                    y: CGFloat.random(in: 0...600),
                    size: CGFloat.random(in: 20...60),
                    speed: CGFloat.random(in: 0.2...1.0),
                    direction: Bool.random() ? 1 : -1,
                    color: [Color.blue, Color.pink, Color.green, Color.purple, Color.orange].randomElement()!
                )
            }
        }
        .onReceive(timer) { _ in
            for i in menuBubbles.indices {
                menuBubbles[i].y -= menuBubbles[i].speed
                menuBubbles[i].x += menuBubbles[i].direction * menuBubbles[i].speed * 0.5
                
                // reset when off screen
                if menuBubbles[i].y < -50 {
                    menuBubbles[i].y = 800
                    menuBubbles[i].x = CGFloat.random(in: 0...300)
                }
            }
        }
    }
}
#Preview {
    MenuView()
}
