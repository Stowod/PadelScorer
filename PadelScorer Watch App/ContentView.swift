import SwiftUI

struct ContentView: View {
    @StateObject private var gameManager = GameManager()
    
    var body: some View {
        TabView {
            ScoreCounterView()
                .environmentObject(gameManager)
                .background(Color.black)
                .ignoresSafeArea()
                .tag(0)
            
            ResetGameView()
                .environmentObject(gameManager)
                .background(Color.black)
                .ignoresSafeArea()
                .tag(1)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .background(Color.black)
        .onChange(of: gameManager.showWinAnimation) {
            if gameManager.showWinAnimation != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    gameManager.showWinAnimation = nil
                }
            }
        }
        .onChange(of: gameManager.showSetWinConfetti) {
            if gameManager.showSetWinConfetti {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    gameManager.showSetWinConfetti = false
                    gameManager.setWinningTeam = nil // Clean up winning team info
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
