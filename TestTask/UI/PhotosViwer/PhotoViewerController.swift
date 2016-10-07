
class PhotoViewerController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var imageView: UIImageView?
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thumbContent()
    }
    
    func loadContent() {
        guard let photo = photo else {
            return
        }
        
        PhotoLoader.loadContent(photo) { image in
            self.imageView?.image = image
        }
    }
    
    func thumbContent() {
        guard let photo = photo else {
            return
        }
        
        self.imageView?.image = photo.thumbImage
    }
    
    // MARK: - ScrollView
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return  imageView
    }
}
