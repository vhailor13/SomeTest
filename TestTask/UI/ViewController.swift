
import UIKit
import BrightFutures

class ViewController: UIViewController {
    
    @IBOutlet weak var photoView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        print("DB:")
        print("\(NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!)")
        
        db.fetchPhotos().onSuccess { photos in
            print("Number of photos: \(photos.count)")
            if let photo = photos.first {
                self.photoView?.image = photo.thumbImage
//                PhotoLoader.loadContent(photo){ image in
//                    self.photoView?.image = image
//                }
            }
        }
    }
}

