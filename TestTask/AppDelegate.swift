
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    internal func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        loadContent()
        
        return true
    }
    
    private func loadContent() {
        let isPhotosImporterdKey = "isPhotosImporterdKey"
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.boolForKey(isPhotosImporterdKey) {
            return
        }
        
        PhotosImporter.importPhotos().onSuccess { photos in
            photos.traverse { photo in
                db.save(photo: photo)
                }.onSuccess { _ in
                    userDefaults.setBool(true, forKey: isPhotosImporterdKey)
                    userDefaults.synchronize()
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(contentUpdatedNotificationName, object: .None)
            }
        }
    }
}

