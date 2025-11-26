import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var gameState: GameState
    @State private var soundOn: Bool = true

    var body: some View {
        Form {
            Section("Game Settings") {
                Toggle("Sound Effects", isOn: $soundOn)

                Stepper(value: $gameState.baseDifficulty, in: 1...3, step: 1) {
                    Text("Base Difficulty: \(Int(gameState.baseDifficulty))")
                }
            }

            Section("About This App") {
                Text("This app is designed to teach children about the Cretaceous era using a 2D SpriteKit game enhanced with adaptive difficulty logic and Core Data.")
                    .font(.footnote)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
        .environmentObject(GameState())
}
