
import Foundation
import CoreData


extension PhotoRecord {

    @nonobjc public override class func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName: "PhotoRecord");
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var photoId: String?

}
