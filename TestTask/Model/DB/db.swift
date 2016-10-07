import MagicalRecord
import BrightFutures

let db = DB()
class DB {
    
    let privateContext: NSManagedObjectContext
    
    init () {
        MagicalRecord.enableShorthandMethods()
        MagicalRecord.setupCoreDataStackWithStoreNamed("photos")
        
        let mainContext = NSManagedObjectContext.MR_defaultContext()
        privateContext = NSManagedObjectContext.MR_newPrivateQueueContext()
        privateContext.parentContext = mainContext
    }

    deinit {
        MagicalRecord.cleanUp()
    }
    
    func save(photo photo: Photo) -> Future<Void, NSError> {
        let promise = Promise<Void, NSError>()
        MagicalRecord.saveWithBlock { localContext in
            let localPhoto = PhotoRecord.MR_createEntityInContext(localContext)
            localPhoto?.creationDate = photo.creationDate
            localPhoto?.photoId = photo.id
            localPhoto?.thumbImageData = UIImagePNGRepresentation(photo.thumbImage)
            
            promise.success()
        }
        
        
        return promise.future
    }
    
    func save(photos: [Photo]) -> Future<Void, NSError> {
        let promise = Promise<Void, NSError>()
        MagicalRecord.saveWithBlock ({ localContext in
            photos.forEach { photo in
                let localPhoto = PhotoRecord.MR_createEntityInContext(localContext)
                localPhoto?.creationDate = photo.creationDate
                localPhoto?.photoId = photo.id
                localPhoto?.thumbImageData = UIImagePNGRepresentation(photo.thumbImage)
            }
        }) { finished, error in
            
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            promise.success()
        }
        
        return promise.future
    }
    
    
    func fetchPhotos() -> Future<[Photo], NSError> {
        let promise = Promise<[Photo], NSError>()
        
       
        privateContext.performBlock {
            guard let photos = PhotoRecord.MR_findAllInContext(self.privateContext)?.flatMap({self.photoFrom($0)}) else {
                promise.success([])
                return
            }
            
            promise.success(photos)
        }
        
        return promise.future
    }
    
    private func photoFrom(obj: NSManagedObject) -> Photo? {
        
        guard let record = obj as? PhotoRecord else {
            return .None
        }
        
        guard let creationDate = record.creationDate else {
            return .None
        }
        
        guard let photoId = record.photoId else {
            return .None
        }
        
        guard let imageData = record.thumbImageData else {
            return .None
        }
        
        guard let thumbImage = UIImage(data: imageData) else {
            return .None
        }
        
        return Photo(id: photoId, creationDate: creationDate, thumbImage: thumbImage)
    }
    
    
}
