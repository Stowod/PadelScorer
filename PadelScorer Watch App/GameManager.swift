import SwiftUI
import WatchKit

class GameManager: ObservableObject {
    // Tennis score indices (0 = "0", 1 = "15", 2 = "30", 3 = "40", 4 = "Ad")
    @Published var team1ScoreIndex = 0
    @Published var team2ScoreIndex = 0
    @Published var team1Games = 0
    @Published var team2Games = 0
    @Published var team1Sets = 0
    @Published var team2Sets = 0
    @Published var showWinAnimation: Int? = nil
    @Published var servingTeam = 1
    @Published var previousState: GameState? = nil
    @Published var showSetWinConfetti = false
    @Published var setWinningTeam: Int? = nil // Add this to track which team won the set
    @Published var buttonsDisabled = false
    
    func resetGame() {
        team1ScoreIndex = 0
        team2ScoreIndex = 0
        team1Games = 0
        team2Games = 0
        team1Sets = 0
        team2Sets = 0
        servingTeam = 1
        previousState = nil
        showWinAnimation = nil
        showSetWinConfetti = false
        setWinningTeam = nil
        buttonsDisabled = false
    }
    
    func getScoreDisplay(index: Int, otherIndex: Int) -> String {
        let scores = ["0", "15", "30", "40"]
        
        // Handle deuce and advantage cases
        if index == 3 && otherIndex == 3 {
            return "40" // Deuce
        } else if index == 4 {
            return "Ad" // Advantage
        } else if index < 4 {
            return scores[index]
        }
        return ""
    }
    
    func saveCurrentState() {
        previousState = GameState(
            team1ScoreIndex: team1ScoreIndex,
            team2ScoreIndex: team2ScoreIndex,
            team1Games: team1Games,
            team2Games: team2Games,
            team1Sets: team1Sets,
            team2Sets: team2Sets,
            servingTeam: servingTeam
        )
    }
    
    func undoLastAction() {
        guard let previous = previousState else { return }
        
        WKInterfaceDevice.current().play(.click)
        
        team1ScoreIndex = previous.team1ScoreIndex
        team2ScoreIndex = previous.team2ScoreIndex
        team1Games = previous.team1Games
        team2Games = previous.team2Games
        team1Sets = previous.team1Sets
        team2Sets = previous.team2Sets
        servingTeam = previous.servingTeam
        
        previousState = nil
    }
    
    func handleTeam1Score() {
        // Don't allow button presses if disabled
        guard !buttonsDisabled else { return }
        
        // Save current state before making changes
        saveCurrentState()
        
        // Add haptic feedback
        WKInterfaceDevice.current().play(.click)
        
        // Deuce case (both at 40)
        if team1ScoreIndex == 3 && team2ScoreIndex == 3 {
            team1ScoreIndex = 4 // Give advantage
        }
        // Team 2 has advantage
        else if team2ScoreIndex == 4 {
            team2ScoreIndex = 3 // Back to deuce
        }
        // Team 1 has advantage or is at 40 and team 2 is less than 40
        else if team1ScoreIndex == 4 || (team1ScoreIndex == 3 && team2ScoreIndex < 3) {
            // Win the game
            showWinAnimation = 1
            WKInterfaceDevice.current().play(.success)
            
            // Disable buttons to prevent double-tapping
            buttonsDisabled = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.team1ScoreIndex = 0
                self.team2ScoreIndex = 0
                self.team1Games += 1
                // Switch serving team after a game is won
                self.servingTeam = self.servingTeam == 1 ? 2 : 1
                
                // Check if team won the set
                if self.team1Games >= 6 && self.team1Games - self.team2Games >= 2 {
                    self.team1Games = 0
                    self.team2Games = 0
                    self.team1Sets += 1
                    // Trigger confetti for set win with team info
                    self.setWinningTeam = 1
                    self.showSetWinConfetti = true
                }
                
                // Re-enable buttons after score reset
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.buttonsDisabled = false
                }
            }
        }
        // Normal score increment
        else {
            team1ScoreIndex += 1
        }
    }
    
    func handleTeam2Score() {
        // Don't allow button presses if disabled
        guard !buttonsDisabled else { return }
        
        // Save current state before making changes
        saveCurrentState()
        
        // Add haptic feedback
        WKInterfaceDevice.current().play(.click)
        
        // Deuce case (both at 40)
        if team1ScoreIndex == 3 && team2ScoreIndex == 3 {
            team2ScoreIndex = 4 // Give advantage
        }
        // Team 1 has advantage
        else if team1ScoreIndex == 4 {
            team1ScoreIndex = 3 // Back to deuce
        }
        // Team 2 has advantage or is at 40 and team 1 is less than 40
        else if team2ScoreIndex == 4 || (team2ScoreIndex == 3 && team1ScoreIndex < 3) {
            // Win the game
            showWinAnimation = 2
            WKInterfaceDevice.current().play(.success)
            
            // Disable buttons to prevent double-tapping
            buttonsDisabled = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.team1ScoreIndex = 0
                self.team2ScoreIndex = 0
                self.team2Games += 1
                // Switch serving team after a game is won
                self.servingTeam = self.servingTeam == 1 ? 2 : 1
                
                // Check if team won the set
                if self.team2Games >= 6 && self.team2Games - self.team1Games >= 2 {
                    self.team1Games = 0
                    self.team2Games = 0
                    self.team2Sets += 1
                    // Trigger confetti for set win with team info
                    self.setWinningTeam = 2
                    self.showSetWinConfetti = true
                }
                
                // Re-enable buttons after score reset
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.buttonsDisabled = false
                }
            }
        }
        // Normal score increment
        else {
            team2ScoreIndex += 1
        }
    }
}

struct GameState {
    var team1ScoreIndex: Int
    var team2ScoreIndex: Int
    var team1Games: Int
    var team2Games: Int
    var team1Sets: Int
    var team2Sets: Int
    var servingTeam: Int
}
