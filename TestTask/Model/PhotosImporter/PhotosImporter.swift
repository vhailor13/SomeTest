
import Photos
import BrightFutures

class PhotosImporter {
    
    class func importPhotos() -> Future<[Photo], NSError> {
        return requestAuth().flatMap { _ -> Future<[Photo], NSError> in
            return importPhotosFromAssets()
        }
    }
    
    private class func importPhotosFromAssets() -> Future<[Photo], NSError> {
        
        return importPhotoAssets().flatMap { assets -> Future<[Photo], NSError> in
            return assets.traverse { asset in
                photoFrom(asset)
            }
        }
    }
    
    private class func importPhotoAssets() -> Future<[PHAsset], NSError> {
        
        let promise = Promise<[PHAsset], NSError>()
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)) {
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            
            let results = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
            var assets = [PHAsset]()
            results.enumerateObjectsUsingBlock({ (obj, _, _) in
                guard let asset = obj as? PHAsset else {
                    return
                }
                
                assets.append(asset)
            })
            
            promise.success(assets)
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
    
    private class func photoFrom(asset: PHAsset) -> Future<Photo, NSError> {
        let promise = Promise<Photo, NSError>()
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)) {
            guard let creationDate = asset.creationDate else {
                promise.failure(error(code: 0, message: "No creation date available"))
                return
            }
            
            var thumbImage: UIImage?
            let manager = PHImageManager.defaultManager()
            
            let height: CGFloat = 100.0
            let width = height * CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
            
            let options = PHImageRequestOptions()
            options.deliveryMode = .FastFormat
            options.resizeMode = .Fast
            options.synchronous = true
            
            manager.requestImageForAsset(asset,
                                         targetSize: CGSizeMake(width, height),
                                         contentMode: .AspectFill, options: options) { image, info in
                                            if let _ = thumbImage {
                                                return
                                            }
                                            
                                            guard let photoImage = image else {
                                                return
                                            }
                                            
                                            thumbImage = image
                                            let photo = Photo(
                                                id: asset.localIdentifier,
                                                creationDate: creationDate,
                                                thumbImage: photoImage)
                                            promise.success(photo)
            }
        }
        
        return promise.future
    }
}
