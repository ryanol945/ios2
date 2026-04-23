//
//  BubbleModel.swift
//  ios_ass2
//
//  Created by Ryan Nolan on 15/4/2026.
//

import SwiftUI
import Foundation
import CoreGraphics

public class BubbleModel: ObservableObject, Identifiable {
    public let id = UUID()
    let type: BubbleType
    
    var colourName: String { type.colourName }
    var pointValue: Int { type.pointValue }
    var probability: Int { type.probability }
    
    var opacity: Double = 1.0
    var colour: Color { type.colour.opacity(opacity) }
    
    @Published var scale: CGFloat = 0.0
    var size: CGFloat = 100
    
    @Published var x: CGFloat = 0
    @Published var y: CGFloat = 0
    
    var dx: CGFloat = CGFloat.random(in: -1.1...1.1)
    var dy: CGFloat = CGFloat.random(in: -1.1...1.1)
    var speed: CGFloat = 1.0
    
    init(colourName: String) {
        self.type = BubbleType(colourName: colourName)!
    }
}

enum BubbleType: String {
    case red, pink, green, blue, black
    
    init?(colourName: String) {
        switch colourName.lowercased() {
            case "red": self = .red
            case "pink": self = .pink
            case "green": self = .green
            case "blue": self = .blue
            case "black": self = .black
            default: return nil
        }
    }
    
    var colour: Color {
        switch self {
            case .red: return .red
            case .pink: return .orange
            case .green: return .green
            case .blue: return .blue
            case .black: return .black
        }
    }
    
    var pointValue: Int {
        switch self {
            case .red:   return 1
            case .pink:  return 2
            case .green: return 5
            case .blue:  return 8
            case .black: return 10
        }
    }
    
    var probability: Int {
        switch self {
            case .red:   return 40
            case .pink:  return 30
            case .green: return 15
            case .blue:  return 10
            case .black: return 5
        }
    }
    
    var colourName: String {
        return String(describing: self)
    }
}

struct MenuBubble: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var speed: CGFloat
    var direction: CGFloat
    var color: Color
}
