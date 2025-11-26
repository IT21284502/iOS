import SwiftUI
import CoreData

@main
struct DinoCretaceousEduApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var gameState = GameState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameState)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
