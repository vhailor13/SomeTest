import Photos

class PhotoLoader {

    class func loadContent(photo: Photo, onContentRecived: (image: UIImage)->() ) {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)) {
            guard let asset = PHAsset.fetchAssetsWithLocalIdentifiers([photo.id], options: .None).firstObject as? PHAsset else {
                return
            }
            
            let manager = PHImageManager.defaultManager()
            manager.requestImageForAsset(asset,
                                         targetSize: CGSizeMake(CGFloat(asset.pixelWidth), CGFloat(asset.pixelHeight)),
                                         contentMode: .AspectFill, options: .None) { image, info in
                                            guard let photoImage = image else {
                                                return
                                            }
                                            
                                            onContentRecived(image:photoImage)
            }
        }

    }
}

