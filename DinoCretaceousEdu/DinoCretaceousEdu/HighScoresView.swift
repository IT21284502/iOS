import SwiftUI
import CoreData

struct HighScoresView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \HighScore.score, ascending: false)],
        animation: .default
    )
    private var highScores: FetchedResults<HighScore>

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()

    var body: some View {
        List {
            if highScores.isEmpty {
                Text("No high scores yet. Play a game to create one!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                ForEach(highScores) { highScore in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Score: \(highScore.score)")
                                .font(.headline)
                            Spacer()
                            Text("Difficulty: \(String(format: "%.1f", highScore.difficulty))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        if let date = highScore.date {
                            Text(dateFormatter.string(from: date))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        } else {
                            Text("Unknown date")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("High Scores")
    }
}

#Preview {
    let controller = PersistenceController.shared
    return NavigationStack {
        HighScoresView()
            .environment(\.managedObjectContext, controller.container.viewContext)
    }
}
