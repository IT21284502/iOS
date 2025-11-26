import Foundation
import CoreData
import SwiftUI
import Combine

final class GameState: ObservableObject {
    // Game runtime state
    @Published var score: Int = 0
    @Published var lives: Int = 3
    
    /// User-selected baseline difficulty (1–3)
    @Published var baseDifficulty: Double = 1.0
    
    /// Current difficulty (can be adjusted by "CoreML" logic)
    @Published var currentDifficulty: Double = 1.0
    
    /// Stats for this session
    @Published var totalOrbsCollected: Int = 0
    @Published var totalHazardHits: Int = 0
    @Published var sessionStartTime: Date? = nil

    
    func currentSessionDuration() -> TimeInterval {
        guard let start = sessionStartTime else { return 0 }
        return Date().timeIntervalSince(start)
    }

    func resetGame() {
        score = 0
        lives = 3
        
        // Use the base difficulty chosen in Settings
        currentDifficulty = baseDifficulty
        
        totalOrbsCollected = 0
        totalHazardHits = 0
        sessionStartTime = Date()
    }

    // MARK: - Core Data: Save High Score

    func saveHighScore(context: NSManagedObjectContext) {
        guard score > 0 else { return }

        let highScore = HighScore(context: context)
        highScore.id = UUID()
        highScore.score = Int64(score)
        highScore.date = Date()
        
        // Store the user-selected base difficulty (1–3)
        highScore.difficulty = baseDifficulty

        do {
            try context.save()
            print("High score saved: \(score) at difficulty \(baseDifficulty)")
        } catch {
            print("Failed to save high score: \(error)")
        }
    }
}
