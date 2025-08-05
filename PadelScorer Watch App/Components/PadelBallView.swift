import SwiftUI

struct PadelBallView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // Ball background with gradient
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.yellow.opacity(0.8), Color.green.opacity(0.6)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: size * 0.04)
                )
            
            // Tennis ball line
            Rectangle()
                .fill(Color.white)
                .frame(width: size, height: size * 0.04)
                .rotationEffect(.degrees(45))
        }
    }
}
