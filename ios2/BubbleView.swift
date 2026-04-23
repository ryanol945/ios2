
//  BubbleView.swift
//  ios_ass2
//
//  Created by Ryan Nolan on 15/4/2026.
//
import SwiftUI

struct BubbleView: View {
    @ObservedObject var bubble: BubbleModel
    
    var body: some View {
        Circle()
            .fill(bubble.colour)
                     .frame(width: 60, height: 60)
                     .overlay(
                         Text("\(bubble.pointValue)")
                             .foregroundColor(.white)
                     )
                     .position(x: bubble.x, y: bubble.y)
                     .scaleEffect(bubble.scale)
                     .animation(.easeIn(duration: 0.2), value: bubble.scale)
                     .onAppear {
                         bubble.scale = 0
                         withAnimation(.interpolatingSpring(stiffness: 150, damping: 8)) {
                             bubble.scale = 1
                         }
                     }
    }
}
