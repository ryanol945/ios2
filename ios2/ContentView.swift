import SwiftUI
import Combine

struct ContentView: View {
    let contentModel = ContentModel(
        bubbleColours: ["red", "pink", "green", "blue", "black"]
    )
    
    @State private var startCountdown = 3
    @State private var gameStarted = false
    
    @ObservedObject var settings: SettingsModel
    
    @State private var bubbles: [BubbleModel] = []
    @State private var timeLeft: Int = 0
    @State private var score: Int = 0
    
    @State private var gameOver = false
    
    @State private var tickCount: Int = 0
    @State private var totalTime: Int = 1
    
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @State var lastBubble: String = ""
    
    let db = ScoreDatabase()
    
    func popBubble(_ bubble: BubbleModel) {
        if let index = bubbles.firstIndex(where: { $0.id == bubble.id }) {
            withAnimation(.easeIn(duration: 0.2)) {
                bubbles[index].scale = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                bubbles.removeAll { $0.id == bubble.id }
            }
            
            score += calcScore(bubble: bubble)
            
            if (bubble.opacity < 1) {
                timeLeft += 2
            }
        }
    }

    func calcScore(bubble: BubbleModel) -> Int {
        var add = 0
        
        if bubble.colourName == lastBubble {
            add = Int((Double(bubble.pointValue) * 1.5).rounded())
        } else {
            add = bubble.pointValue
        }

        lastBubble = bubble.colourName
        
        return add
    }
    
    var topScore: ScoreEntry? {
        db.load().first
    }
    
    var progress: CGFloat {
        let elapsed = CGFloat(totalTime - timeLeft)
        return min(1.0, elapsed / CGFloat(totalTime))
    }
    
    var currentSpeedMultiplier: CGFloat {
        1.0 + (progress * 1.5)
    }
    
    var body: some View {
        GeometryReader { geo in
            
            let topPadding: CGFloat = 20
            let bottomPadding: CGFloat = 20
            
            let playableHeight = geo.size.height - topPadding - bottomPadding
            
            ZStack {
                Color.white.ignoresSafeArea()
                
                if !gameStarted {
                    Text("\(startCountdown)")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.black)
                }
                
                ForEach(bubbles) { bubble in
                    BubbleView(bubble: bubble)
                        .onTapGesture {
                            popBubble(bubble)
                        }
                }
                
                VStack {
                    Text("Time: \(timeLeft)")
                        .font(.title2)
                        .padding()
                    
                    Spacer()
                    
                    HStack() {
                        Text("Score: \(score)")
                            .font(.title)
                            .padding()
                        
                        if let top = topScore {
                            Text("Top: \(top.score)")
                                .font(.title3)
                        }
                    }
          
                }
            }
            .onAppear {
                timeLeft = Int(settings.gameDuration)
                totalTime = timeLeft
                
                startCountdown = 3
                gameStarted = false
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    if startCountdown > 1 {
                        startCountdown -= 1
                    } else {
                        startCountdown = 0
                        gameStarted = true
                        timer.invalidate()
                    }
                }
            }
            .onReceive(timer) { _ in
                guard gameStarted else { return }
                tickCount += 1
                
                if timeLeft > 0 {
                    if tickCount % 100 != 0 {
                        //Move
                        
                        //Walls
                        for i in bubbles.indices {
                            let speed = currentSpeedMultiplier

                            bubbles[i].x += bubbles[i].dx * speed
                            bubbles[i].y += bubbles[i].dy * speed

                            let minY = topPadding
                            let maxY = geo.size.height - bottomPadding
                            let maxX = geo.size.width
                            
                            let radius: CGFloat = bubbles[i].size / 2

                            if bubbles[i].x < radius {
                                bubbles[i].x = radius
                                bubbles[i].dx *= -1
                            }

                            if bubbles[i].x > maxX - radius {
                                bubbles[i].x = maxX - radius
                                bubbles[i].dx *= -1
                            }

                            if bubbles[i].y < minY + radius {
                                bubbles[i].y = minY + radius
                                bubbles[i].dy *= -1
                            }

                            if bubbles[i].y > maxY - radius {
                                bubbles[i].y = maxY - radius
                                bubbles[i].dy *= -1
                            }
                        }
                        
                        //Other Bubbles
                        for i in 0..<bubbles.count {
                            for j in i+1..<bubbles.count {
                                
                                let a = bubbles[i]
                                let b = bubbles[j]
                                
                                let dx = a.x - b.x
                                let dy = a.y - b.y
                                let distance = sqrt(dx*dx + dy*dy)
                                
                                let minDistance: CGFloat = 60 //col. radius
                                
                                if distance < minDistance && distance > 0 {
                                    //normal vector
                                    let nx = dx / distance
                                    let ny = dy / distance
    
                                    //faked elasticity
                                    let tempDx = bubbles[i].dx
                                    let tempDy = bubbles[i].dy
                                    
                                    bubbles[i].dx = bubbles[j].dx
                                    bubbles[i].dy = bubbles[j].dy
                                    
                                    bubbles[j].dx = tempDx
                                    bubbles[j].dy = tempDy
                                    
                                    let overlap = minDistance - distance
                                    
                                    bubbles[i].x += nx * overlap / 2
                                    bubbles[i].y += ny * overlap / 2
                                    
                                    bubbles[j].x -= nx * overlap / 2
                                    bubbles[j].y -= ny * overlap / 2
                                }
                            }
                        }
                    }
                    else {
                        timeLeft -= 1
                        
                        //Remove
                        let removeCount = Int.random(in: 0...min(2, bubbles.count))
                        
                        for _ in 0..<removeCount {
                            if let random = bubbles.randomElement(),
                               let index = bubbles.firstIndex(where: { $0.id == random.id }) {
                                
                                withAnimation(.easeIn(duration: 0.2)) {
                                    bubbles[index].scale = 0
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    bubbles.removeAll { $0.id == random.id }
                                }
                            }
                        }
                        
                        //Add
                        let remainingCapacity = settings.maxBubbles - bubbles.count
                        if remainingCapacity > 0 {
                            let addCount = Int.random(in: 1...remainingCapacity)
                            
                            let newBubbles = contentModel.generateBubbles(
                                screenSize: CGSize(width: geo.size.width, height: geo.size.height),
                                yOffset: topPadding,
                                count: addCount,
                                existing: bubbles
                            )
                            
                            bubbles.append(contentsOf: newBubbles)
                        }
                    }
                } else {
                    gameOver = true
                }
            }
            .onChange(of: gameOver) { oldValue, newValue in
                if newValue {
                    let entry = ScoreEntry(
                        playerName: settings.playerName,
                        score: score,
                        time: Int(settings.gameDuration)
                    )

                    db.add(entry)
                }
            }
            .navigationDestination(isPresented: $gameOver) {
                let entry = ScoreEntry(
                    playerName: settings.playerName,
                    score: score,
                    time: Int(settings.gameDuration)
                )
     
                EndView(score: entry)
            }
        }
    }
}
