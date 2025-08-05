import SwiftUI

struct ConfettiView: View {
    let geometry: GeometryProxy
    let winningTeam: Int // 1 or 2 to know which button to explode from
    @State private var pieces: [ConfettiPiece] = []
    @State private var showWinnerPopup = false
    
    var body: some View {
        ZStack {
            // Confetti pieces
            ForEach(pieces, id: \.id) { piece in
                Circle()
                    .fill(piece.color)
                    .frame(width: piece.size, height: piece.size)
                    .position(x: piece.x, y: piece.y)
                    .rotationEffect(.degrees(piece.rotation))
                    .opacity(piece.opacity)
                    .scaleEffect(piece.scale)
            }
            
            // Winner popup
            if showWinnerPopup {
                VStack(spacing: geometry.size.height * 0.01) {
                    Text("🏆")
                        .font(.system(size: geometry.size.width * 0.12))
                    
                    Text("SET WINNER")
                        .font(.system(size: geometry.size.width * 0.06, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Team \(winningTeam)")
                        .font(.system(size: geometry.size.width * 0.08, weight: .heavy))
                        .foregroundColor(winningTeam == 1 ? .blue : .green)
                }
                .padding(.horizontal, geometry.size.width * 0.05)
                .padding(.vertical, geometry.size.height * 0.03)
                .background(
                    RoundedRectangle(cornerRadius: geometry.size.width * 0.04)
                        .fill(Color.black.opacity(0.9))
                        .overlay(
                            RoundedRectangle(cornerRadius: geometry.size.width * 0.04)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.5), radius: 8, x: 0, y: 4)
                )
                .scaleEffect(showWinnerPopup ? 1.0 : 0.5)
                .opacity(showWinnerPopup ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: showWinnerPopup)
            }
        }
        .onAppear {
            createExplosionConfetti()
            displayWinnerPopup()
        }
    }
    
    private func displayWinnerPopup() {
        // Show popup immediately
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            showWinnerPopup = true
        }
        
        // Hide popup after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut(duration: 0.3)) {
                showWinnerPopup = false
            }
        }
    }
    
    private func createExplosionConfetti() {
        let confettiColors: [Color] = [
            .red, .blue, .green, .yellow, .orange, .purple, .pink, .cyan, .white
        ]
        
        let screenWidth = geometry.size.width
        let screenHeight = geometry.size.height
        
        // Calculate explosion center based on winning team
        let explosionCenterX: CGFloat
        let explosionCenterY: CGFloat = screenHeight * 0.45 // Middle of the score buttons
        
        if winningTeam == 1 {
            explosionCenterX = screenWidth * 0.25 // Left button center
        } else {
            explosionCenterX = screenWidth * 0.75 // Right button center
        }
        
        // Create multiple waves of confetti
        for waveIndex in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(waveIndex) * 0.1) {
                createConfettiWave(
                    colors: confettiColors,
                    centerX: explosionCenterX,
                    centerY: explosionCenterY,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    waveIntensity: 3 - waveIndex // First wave is strongest
                )
            }
        }
        
        // Clean up after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            pieces.removeAll()
        }
    }
    
    private func createConfettiWave(colors: [Color], centerX: CGFloat, centerY: CGFloat, screenWidth: CGFloat, screenHeight: CGFloat, waveIntensity: Int) {
        let pieceCount = waveIntensity * 15 // More pieces for stronger waves
        
        for _ in 0..<pieceCount {
            let newPiece = ConfettiPiece(
                id: UUID(),
                x: centerX,
                y: centerY,
                size: CGFloat.random(in: 3...7),
                color: colors.randomElement()!,
                rotation: Double.random(in: 0...360),
                opacity: 1.0,
                scale: 1.0
            )
            
            pieces.append(newPiece)
            animateExplosion(piece: newPiece, centerX: centerX, centerY: centerY, screenWidth: screenWidth, screenHeight: screenHeight, intensity: waveIntensity)
        }
    }
    
    private func animateExplosion(piece: ConfettiPiece, centerX: CGFloat, centerY: CGFloat, screenWidth: CGFloat, screenHeight: CGFloat, intensity: Int) {
        // Random explosion direction and distance
        let angle = Double.random(in: 0...(2 * Double.pi))
        let explosionRadius = CGFloat.random(in: 80...200) * (CGFloat(intensity) / 3.0)
        
        let targetX = centerX + cos(angle) * explosionRadius
        let targetY = centerY + sin(angle) * explosionRadius
        
        // Add some gravity effect
        let gravityY = targetY + CGFloat.random(in: 50...150)
        
        let animationDuration = Double.random(in: 1.2...2.5)
        
        // Main explosion animation
        withAnimation(.easeOut(duration: animationDuration * 0.3)) {
            if let index = pieces.firstIndex(where: { $0.id == piece.id }) {
                pieces[index].x = targetX
                pieces[index].y = targetY
                pieces[index].scale = CGFloat.random(in: 0.8...1.5)
                pieces[index].rotation += Double.random(in: 180...360)
            }
        }
        
        // Gravity fall animation
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration * 0.3) {
            withAnimation(.easeIn(duration: animationDuration * 0.7)) {
                if let index = pieces.firstIndex(where: { $0.id == piece.id }) {
                    pieces[index].y = gravityY
                    pieces[index].rotation += Double.random(in: 180...540)
                }
            }
        }
        
        // Fade out animation
        withAnimation(.easeOut(duration: 0.8).delay(animationDuration * 0.6)) {
            if let index = pieces.firstIndex(where: { $0.id == piece.id }) {
                pieces[index].opacity = 0.0
                pieces[index].scale = 0.3
            }
        }
    }
}

struct ConfettiPiece {
    let id: UUID
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let color: Color
    var rotation: Double
    var opacity: Double
    var scale: CGFloat
}
