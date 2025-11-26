import Foundation
import CoreData

@objc(HighScore)
public class HighScore: NSManagedObject {

}

extension HighScore: Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<HighScore> {
        NSFetchRequest<HighScore>(entityName: "HighScore")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var score: Int64
    @NSManaged public var date: Date
    @NSManaged public var difficulty: Double
}
