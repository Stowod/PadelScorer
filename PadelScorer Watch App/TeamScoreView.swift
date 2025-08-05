import SwiftUI

struct TeamScoreView: View {
    let scoreDisplay: String
    let games: Int
    let sets: Int
    let teamColor: Color
    let isAdvantage: Bool
    let showWinAnimation: Bool
    let buttonsDisabled: Bool // Add this parameter
    let onScoreIncrement: () -> Void
    let geometry: GeometryProxy
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: geometry.size.height * 0.01) {
            // Score button - MASSIVE SIZE!!!
            Button(action: onScoreIncrement) {
                Text(scoreDisplay)
                    .font(.system(size: geometry.size.width * 0.15, weight: .bold))
                    .foregroundColor(.white)
                    .frame(
                        width: geometry.size.width * 0.47,
                        height: geometry.size.height * 0.6
                    )
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [teamColor, teamColor.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(geometry.size.width * 0.08)
                    .overlay(
                        RoundedRectangle(cornerRadius: geometry.size.width * 0.08)
                            .stroke(isAdvantage ? Color.yellow : Color.white.opacity(0.1), lineWidth: isAdvantage ? 3 : 1)
                            .opacity(isAdvantage ? 0.9 : 0.3)
                    )
                    .shadow(color: teamColor.opacity(0.3), radius: 4, x: 0, y: 2)
                    .scaleEffect(showWinAnimation ? 1.05 : (isPressed ? 0.98 : 1.0))
                    .opacity(buttonsDisabled ? 0.6 : (showWinAnimation ? 0.9 : (isPressed ? 0.85 : 1.0)))
                    .animation(.easeInOut(duration: 0.1), value: isPressed)
                    .animation(.easeInOut(duration: 0.3), value: showWinAnimation)
                    .animation(.easeInOut(duration: 0.2), value: buttonsDisabled)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(buttonsDisabled) // Disable the button when needed
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                if !buttonsDisabled {
                    isPressed = pressing
                }
            }, perform: {})
            
            // Games and Sets display
            HStack(spacing: geometry.size.width * 0.01) {
                Text("G: \(games)")
                    .font(.system(size: geometry.size.width * 0.055, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, geometry.size.width * 0.03)
                    .padding(.vertical, geometry.size.height * 0.005)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(geometry.size.width * 0.02)
                
                Text("S: \(sets)")
                    .font(.system(size: geometry.size.width * 0.055, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, geometry.size.width * 0.03)
                    .padding(.vertical, geometry.size.height * 0.005)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(geometry.size.width * 0.02)
            }.padding(.vertical, geometry.size.height * 0.002)
        }
    }
}
