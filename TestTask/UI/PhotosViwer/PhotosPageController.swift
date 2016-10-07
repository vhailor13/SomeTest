
class PhotosPageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var photos: [Photo]?
    var selectedIndex = 0
    
    private var viewerControllers = [PhotoViewerController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: .None)
        photos?.forEach { photo in
            if let viewerCtrl = storyboard.instantiateViewControllerWithIdentifier("photo_viwer_controller") as? PhotoViewerController {
                
                viewerCtrl.photo = photo
                viewerControllers.append(viewerCtrl)
            }
        }
        
        viewerControllers.append(PhotoViewerController())
        
        let startPage = viewerControllers[selectedIndex]
        startPage.loadContent()
        self.setViewControllers([startPage], direction: .Forward, animated: false, completion: .None)
    }
    
    // MARK: - Page view controller
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {

        if let index = viewerControllers.indexOf(viewController as! PhotoViewerController) {
            if index == viewerControllers.count - 1 {
                return .None
            }
            
            return viewerControllers[index + 1]
        }
        
        return .None
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

        
        if let index = viewerControllers.indexOf(viewController as! PhotoViewerController) {
            if index == 0 {
                return .None
            }
            
            return viewerControllers[index - 1]
        }
        
        return .None
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // Not visible
        (previousViewControllers as? [PhotoViewerController])?.forEach { ctrl in
            ctrl.thumbContent()
        }
        
        // Current
        if let ctrl = pageViewController.viewControllers?.first as? PhotoViewerController {
            if let index = viewerControllers.indexOf(ctrl) {
                if index == viewerControllers.count - 1 {
                    self.navigationController?.popViewControllerAnimated(true)
                    return
                }
            }
            
            ctrl.loadContent()
        }
        
    }
}
