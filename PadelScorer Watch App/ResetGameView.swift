import SwiftUI
import WatchKit

struct ResetGameView: View {
    @EnvironmentObject var gameManager: GameManager
    @State private var showConfirmation = false
    @State private var gameReset = false
    @State private var pulseAnimation = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack(spacing: geometry.size.height * 0.04) {
                    // Header
                    Text("RESET GAME")
                        .font(.system(size: geometry.size.width * 0.08, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.top, geometry.size.height * 0.02)
                    
                    // Instruction text
                    Text("Swipe right to return to game")
                        .font(.system(size: geometry.size.width * 0.045))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, geometry.size.width * 0.02)
                    
                    Spacer()
                    
                    if !showConfirmation {
                        // Main reset button - better centered
                        Button(action: {
                            WKInterfaceDevice.current().play(.click)
                            showConfirmation = true
                        }) {
                            VStack(spacing: geometry.size.height * 0.02) {
                                Image(systemName: "arrow.clockwise.circle.fill")
                                    .font(.system(size: geometry.size.width * 0.18))
                                    .foregroundColor(.red)
                                    .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)
                                
                                Text("Reset Game")
                                    .font(.system(size: geometry.size.width * 0.07, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .frame(
                                width: geometry.size.width * 0.9,
                                height: geometry.size.height * 0.4
                            )
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.red.opacity(0.3), Color.red.opacity(0.1)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(geometry.size.width * 0.06)
                            .overlay(
                                RoundedRectangle(cornerRadius: geometry.size.width * 0.06)
                                    .stroke(Color.red.opacity(0.6), lineWidth: 1.5)
                            )
                            .shadow(color: Color.red.opacity(0.3), radius: 6, x: 0, y: 3)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onAppear {
                            pulseAnimation = true
                        }
                } else {
                    // Aesthetic confirmation screen
                    VStack(spacing: geometry.size.height * 0.04) {
                        // Warning icon with glow effect
                        ZStack {
                            Circle()
                                .fill(Color.red.opacity(0.2))
                                .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.25)
                                .blur(radius: 10)
                            
                            Circle()
                                .fill(Color.red.opacity(0.1))
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.2)
                            
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: geometry.size.width * 0.08))
                                .foregroundColor(.red)
                        }
                        
                        VStack(spacing: geometry.size.height * 0.02) {
                            Text("Reset Everything?")
                                .font(.system(size: geometry.size.width * 0.07, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("All scores, games, and sets will be lost")
                                .font(.system(size: geometry.size.width * 0.045))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, geometry.size.width * 0.03)
                        }
                        
                        // Stylish button pair - full width
                        VStack(spacing: geometry.size.height * 0.03) {
                            // Cancel button - full width design
                            Button(action: {
                                WKInterfaceDevice.current().play(.click)
                                showConfirmation = false
                            }) {
                                HStack(spacing: geometry.size.width * 0.03) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: geometry.size.width * 0.05, weight: .semibold))
                                    Text("Cancel")
                                        .font(.system(size: geometry.size.width * 0.055, weight: .medium))
                                }
                                .foregroundColor(.white)
                                .frame(
                                    width: geometry.size.width * 0.85,
                                    height: geometry.size.height * 0.12
                                )
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.2)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(geometry.size.width * 0.04)
                                .overlay(
                                    RoundedRectangle(cornerRadius: geometry.size.width * 0.04)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Confirm reset button - full width design
                            Button(action: {
                                WKInterfaceDevice.current().play(.success)
                                gameManager.resetGame()
                                gameReset = true
                                showConfirmation = false
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    gameReset = false
                                }
                            }) {
                                HStack(spacing: geometry.size.width * 0.03) {
                                    Image(systemName: "trash.fill")
                                        .font(.system(size: geometry.size.width * 0.05, weight: .semibold))
                                    Text("Reset Everything")
                                        .font(.system(size: geometry.size.width * 0.055, weight: .medium))
                                }
                                .foregroundColor(.white)
                                .frame(
                                    width: geometry.size.width * 0.85,
                                    height: geometry.size.height * 0.12
                                )
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.red, Color.red.opacity(0.7)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(geometry.size.width * 0.04)
                                .overlay(
                                    RoundedRectangle(cornerRadius: geometry.size.width * 0.04)
                                        .stroke(Color.red.opacity(0.5), lineWidth: 1)
                                )
                                .shadow(color: Color.red.opacity(0.4), radius: 4, x: 0, y: 2)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                // Enhanced reset confirmation message
                if gameReset {
                    VStack(spacing: geometry.size.height * 0.01) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: geometry.size.width * 0.08))
                            .foregroundColor(.green)
                        Text("Game Reset!")
                            .font(.system(size: geometry.size.width * 0.06, weight: .bold))
                            .foregroundColor(.green)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                    
                    Spacer()
                }
                Spacer()
            }
            .background(Color.black)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showConfirmation)
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: gameReset)
        }
    }
}
