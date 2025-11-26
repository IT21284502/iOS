//
//  GameContainerView.swift
//  DinoCretaceousEdu
//

import SwiftUI
import SpriteKit
import CoreData

struct GameContainerView: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss   // NEW: allows going back to Home

    @State private var showGameOver = false
    
    // Keep a scene reference
    @State private var scene = GameScene(size: CGSize(width: 750, height: 1334))

    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()

            // HUD
            VStack {
                HStack {
                    Text("Score: \(gameState.score)")
                    Spacer()
                    Text("Lives: \(gameState.lives)")
                    Spacer()
                    Text("Diff: \(Int(gameState.baseDifficulty))")
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .padding()
                
                Spacer()
            }

            // GAME OVER overlay
            if showGameOver {
                Color.black.opacity(0.45)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("Game Over")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Final Score: \(gameState.score)")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Difficulty: \(Int(gameState.baseDifficulty))")
                        Text("Orbs Collected: \(gameState.totalOrbsCollected)")
                        Text("Hazard Hits: \(gameState.totalHazardHits)")
                        Text("Time Survived: \(Int(gameState.currentSessionDuration())) s")
                    }
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Back to Home button
                    Button {
                        dismiss()  // Pops back to HomeView
                    } label: {
                        Text("Back to Home")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding(.horizontal, 24)
            }
        }
        .navigationTitle("Dino Game")
        .navigationBarTitleDisplayMode(.inline)

        .onAppear {
            initializeScene()
        }

        .onDisappear {
            gameState.saveHighScore(context: viewContext)
        }

        .onReceive(NotificationCenter.default.publisher(for: .gameOver)) { _ in
            self.showGameOver = true
            gameState.saveHighScore(context: viewContext)
        }
    }

    // MARK: - Scene Setup

    private func initializeScene() {
        gameState.resetGame()
        
        let newScene = GameScene(size: CGSize(width: 750, height: 1334))
        newScene.scaleMode = .aspectFill
        newScene.gameState = gameState
        
        scene = newScene
        showGameOver = false
    }
}

#Preview {
    let controller = PersistenceController.shared
    return NavigationStack {
        GameContainerView()
            .environmentObject(GameState())
            .environment(\.managedObjectContext, controller.container.viewContext)
    }
}
