import SwiftUI

struct HomeView: View {
    @EnvironmentObject var gameState: GameState

    var body: some View {
        VStack(spacing: 24) {
            Text("Dino Run")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 40)

            Text("Embark on a fun dinosaur adventure game!")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            NavigationLink {
                GameContainerView()
            } label: {
                Text("Start Game")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.green.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            NavigationLink {
                HighScoresView()
            } label: {
                Text("View High Scores")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.orange.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            NavigationLink {
                SettingsView()
            } label: {
                Text("Settings")
                    .font(.subheadline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.2))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.bottom, 20)
    }
}
