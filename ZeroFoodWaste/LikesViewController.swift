//
//  LikesViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 9/6/2023.
//

import UIKit
import Firebase
import FirebaseStorage

class LikesViewController: UIViewController, DatabaseListener {
    

    var listenerType = ListenerType.user
    weak var databaseController: DatabaseProtocol?
    
    var storageReference = Storage.storage()
    
    var allLikes: [Listing] = []
    var index: Int?
    
    var imagePathList = [String]()
    var imageList = [UIImage]()
    

    @IBOutlet weak var likesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        
        
        likesCollectionView.backgroundColor = UIColor(red: 254/255, green: 247/255, blue: 236/255, alpha: 1)
        likesCollectionView.setCollectionViewLayout(generateLayout(), animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        databaseController?.removeListener(listener: self)
    }
    
    func onUserChange(change: DatabaseChange, userLikes: [Listing], userListing: [Listing]) {
        allLikes = userLikes
    }
    
    func onListingChange(change: DatabaseChange, listings: [Listing]) {
        //do nothing
    }

    
    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         if segue.identifier == "showListingSegue" {
             let destination = segue.destination as! ListingViewController

             destination.listing = allLikes[index!]
             
         }
     }
    
}

extension LikesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func loadImage(filename: String) -> UIImage? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let imageURL = documentsDirectory.appendingPathComponent(filename)
        
        let image = UIImage(contentsOfFile: imageURL.path)
        
        imagePathList.append(filename)
        
        return image
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allLikes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedCell", for: indexPath) as! likeCollectionViewCell
        
        cell.backgroundColor = .secondarySystemFill
        
        let like = allLikes[indexPath.row]
        
        //uuid of the image
        var imageName = like.image!
        
        //get jpg file
        let filename = "\(imageName).jpg"
        
        
        
        //image is not yet loaded?
        if !self.imagePathList.contains(filename) {

            //MARK: you want to load this image
            if let image = self.loadImage(filename: imageName) {
                
                self.imageList.append(image)
                self.imagePathList.append(imageName)
                
                cell.likedListingImageView.image = image
                
                self.likesCollectionView.reloadSections([0])
                
            }
            
            //we need to download from storage if the image not loaded
            else {
                
                let paths = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)
                let documentsDirectory = paths[0]
                let fileURL = documentsDirectory.appendingPathComponent(imageName)

                let imageRef = storageReference.reference().child("\(like.id)/\(imageName)")

                let downloadTask = imageRef.write(toFile: fileURL)

                downloadTask.observe( .success) { snapshot in
                    let image = self.loadImage(filename: imageName)!
                    self.imageList.append(image)
                    self.imagePathList.append(imageName)
                    
                    
                    cell.likedListingImageView.image = image

                    self.likesCollectionView.reloadSections([0])
                }

                downloadTask.observe(.failure) { snapshot in
                    print("\(String(describing: snapshot.error))")
                }
            }
        }

        cell.likedListingLabel.text = like.name

        return cell
    }
     
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        index = indexPath.row
        self.performSegue(withIdentifier: "showListingSegue", sender: self)
        
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let imageItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        
        let imageItem = NSCollectionLayoutItem(layoutSize: imageItemSize)
        imageItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let imageGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.55))
        
        let imageGroup = NSCollectionLayoutGroup.horizontal(layoutSize: imageGroupSize, subitems: [imageItem])
        let imageSection = NSCollectionLayoutSection(group: imageGroup)
        
        return UICollectionViewCompositionalLayout(section: imageSection)
    }
    
    
}

class likeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var likedListingLabel: UILabel!
    @IBOutlet weak var likedListingImageView: UIImageView!
    
    
}
