import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationStack {
            HomeView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(GameState())
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
