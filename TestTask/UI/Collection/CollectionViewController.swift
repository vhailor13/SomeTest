
import UIKit
import BrightFutures

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView?
    
    var photos = [Photo]()
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloaCollection()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloaCollection),
                                                         name: contentUpdatedNotificationName, object: .None)
        
    }
    
    func reloaCollection() {
        db.fetchPhotos().onSuccess { photos in
            self.photos.removeAll()
            self.photos.appendContentsOf(photos.sort({
                $0.creationDate.compare($1.creationDate) == NSComparisonResult.OrderedAscending
            }))
            
            self.collectionView?.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let ctrl = segue.destinationViewController as? PhotosPageController {
            ctrl.selectedIndex = selectedIndex
            ctrl.photos = photos
        }
    }
    
    // MARK: - Collection
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collection_cell", forIndexPath: indexPath) as! CollectionCell
        cell.imageView?.image = photos[indexPath.row].thumbImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        
        self.performSegueWithIdentifier("photos_page_segue", sender: .None)
    }
}

