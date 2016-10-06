
import Photos
import BrightFutures

class PhotosImporter {
    
    class func importPhotos() -> Future<[Photo], NSError> {
        return PhotosImporter.requestAuth().flatMap { _ -> Future<[Photo], NSError> in
            return PhotosImporter.importPhotosFromAssets()
        }
    }
    
    private class func importPhotosFromAssets() -> Future<[Photo], NSError> {
        
        let promise = Promise<[Photo], NSError>()
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)) {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            
            let results = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
            var photos = [Photo]()
            results.enumerateObjectsUsingBlock({ (obj, _, _) in
                guard let asset = obj as? PHAsset else {
                    return
                }
                
                guard let photo = PhotosImporter.photoFrom(asset) else {
                    return
                }
                
                photos.append(photo)
            })
            // let manager = PHImageManager.defaultManager()
            
            promise.success(photos)
        }
        
        
        return promise.future
    }
    
    private class func requestAuth() -> Future<Void, NSError> {
        let promise = Promise<Void, NSError>()
        
        if PHPhotoLibrary.authorizationStatus() == .Authorized {
            promise.success()
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                if status != .Authorized {
                    promise.failure(error(code: 0, message: "No authorized for Photo Library use"))
                    return
                }
                
                promise.success()
            }
        }
        
        return promise.future
    }
    
    private class func photoFrom(asset: PHAsset) -> Photo? {
        guard let creationDate = asset.creationDate else {
            return .None
        }
        
        return Photo(creationDate: creationDate)
    }
}
