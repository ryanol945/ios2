import CoreGraphics

public class ContentModel {
    
    private var bubbleProbability: [(bubble: BubbleModel, probability: Int)] = []
    
    init(bubbleColours: [String]) {
        for colour in bubbleColours {
            let bubble = BubbleModel(colourName: colour)
            bubbleProbability.append((bubble, bubble.probability))
        }
    }
    
    func generateBubbles(screenSize: CGSize, yOffset: CGFloat, count: Int, existing: [BubbleModel]) -> [BubbleModel] {
        
        var newBubbles: [BubbleModel] = []
        let bubbleCount = count
        let maxAttemptsPerBubble = 50
        
        for _ in 0..<bubbleCount {
            
            let roll = Int.random(in: 1...100)
            let colour = selectBubbleColour(probability: roll)
            
            let bubble = BubbleModel(colourName: colour)
            let radius = bubble.size / 2
            
            var placed = false
            var attempts = 0
            
            while !placed && attempts < maxAttemptsPerBubble {
                
                let x = CGFloat.random(in: radius...(screenSize.width - radius))
                let y = CGFloat.random(in: radius...(screenSize.height - radius)) + yOffset
                
                bubble.x = x
                bubble.y = y
                
                let overlaps = isOverlapping(
                    bubble,
                    with: newBubbles + existing
                )
                
                if !overlaps {
                    if CGFloat.random(in: 0...1) < 0.02 {
                        bubble.opacity = 0.45
                    }

                    newBubbles.append(bubble)
                    placed = true
                }
                                
                attempts += 1
            }
        }
        
        return newBubbles
    }
    
    private func isOverlapping(
        _ bubble: BubbleModel,
        with others: [BubbleModel]
    ) -> Bool {
        
        for other in others {
            let dx = other.x - bubble.x
            let dy = other.y - bubble.y
            let distance = sqrt(dx * dx + dy * dy)
            
            let minDistance = (other.size / 2) + (bubble.size / 2)
            
            if distance < minDistance {
                return true
            }
        }
        
        return false
    }
    
    private func selectBubbleColour(probability: Int) -> String {
        var total = 0
        
        for entry in bubbleProbability {
            total += entry.bubble.probability
            
            if probability <= total {
                return entry.bubble.colourName
            }
        }
        
        return bubbleProbability.last?.bubble.colourName ?? "red"
    }
}
