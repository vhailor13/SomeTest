
import UIKit
import BrightFutures

class ViewController: UIViewController {
    
    @IBOutlet weak var photoView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        db.fetchPhotos().onSuccess { photos in
            print("DB:")
            print("\(NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!)")
            print("Number of photos: \(photos.count)")
//            if let photo = photos.first {
//                self.photoView?.image = photo.image
//            }
        }
    }
}

