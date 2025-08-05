import SwiftUI

struct ScoreCounterView: View {
    @EnvironmentObject var gameManager: GameManager
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height * 0.01) {
                // Header
                Text("PADEL SCORE")
                    .font(.system(size: geometry.size.width * 0.1))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.top, geometry.size.height * 0.0001)
                
                // Team labels with serving indicator
                HStack {
                    HStack(spacing: geometry.size.width * 0.02) {
                        Text("Team 1")
                            .font(.system(size: geometry.size.width * 0.075))
                            .foregroundColor(.gray)
                        if gameManager.servingTeam == 1 {
                            PadelBallView(size: geometry.size.width * 0.06)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: geometry.size.width * 0.02) {
                        if gameManager.servingTeam == 2 {
                            PadelBallView(size: geometry.size.width * 0.06)
                        }
                        Text("Team 2")
                            .font(.system(size: geometry.size.width * 0.075))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, geometry.size.width * 0.02)
                
                // Score buttons - MASSIVE SIZE WITH MINIMAL SPACING
                HStack(spacing: geometry.size.width * 0.03) {
                    TeamScoreView(
                        scoreDisplay: gameManager.getScoreDisplay(
                            index: gameManager.team1ScoreIndex,
                            otherIndex: gameManager.team2ScoreIndex
                        ),
                        games: gameManager.team1Games,
                        sets: gameManager.team1Sets,
                        teamColor: .blue,
                        isAdvantage: gameManager.team1ScoreIndex == 4,
                        showWinAnimation: gameManager.showWinAnimation == 1,
                        buttonsDisabled: gameManager.buttonsDisabled, // Add this line
                        onScoreIncrement: { gameManager.handleTeam1Score() },
                        geometry: geometry
                    )
                    
                    TeamScoreView(
                        scoreDisplay: gameManager.getScoreDisplay(
                            index: gameManager.team2ScoreIndex,
                            otherIndex: gameManager.team1ScoreIndex
                        ),
                        games: gameManager.team2Games,
                        sets: gameManager.team2Sets,
                        teamColor: .green,
                        isAdvantage: gameManager.team2ScoreIndex == 4,
                        showWinAnimation: gameManager.showWinAnimation == 2,
                        buttonsDisabled: gameManager.buttonsDisabled, // Add this line
                        onScoreIncrement: { gameManager.handleTeam2Score() },
                        geometry: geometry
                    )
                }
                .padding(.horizontal, geometry.size.width * 0.005)
                
                // Undo button - BIGGER
                if gameManager.previousState != nil {
                    Button(action: gameManager.undoLastAction) {
                        HStack(spacing: geometry.size.width * 0.025) {
                            Image(systemName: "arrow.uturn.backward")
                                .font(.system(size: geometry.size.width * 0.065))
                            Text("Undo")
                                .font(.system(size: geometry.size.width * 0.065, weight: .semibold))
                        }
                        .foregroundColor(.orange)
                        .padding(.horizontal, geometry.size.width * 0.08)
                        .padding(.vertical, geometry.size.height * 0.02)
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(geometry.size.width * 0.06)
                        .overlay(
                            RoundedRectangle(cornerRadius: geometry.size.width * 0.06)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, geometry.size.height * 0.005)
                }
                
                Spacer()
            }
            .background(Color.black)
            .overlay(
                // Enhanced confetti overlay
                Group {
                    if gameManager.showSetWinConfetti, let winningTeam = gameManager.setWinningTeam {
                        ConfettiView(geometry: geometry, winningTeam: winningTeam)
                            .allowsHitTesting(false)
                    }
                }
            )
        }
    }
}
