
import UIKit
import BrightFutures

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PhotosImporter.importPhotos().onSuccess { photos in
            print("First photo: \(photos.first!.image)")
        }
    }
}

