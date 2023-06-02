//
//  ListingViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 2/6/2023.
//

import UIKit

class ListingViewController: UIViewController {
    
    var listing: Listing?

    
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var descField: UITextView!
    
    @IBOutlet weak var categoryLabel: UIButton!
    @IBOutlet weak var dietPrefLabel: UILabel!
    @IBOutlet weak var allergensLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    
    let catArray = ["Produce", "Dairy", "Protein", "Grain", "Others"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = listing?.name
        
        
//        likeButton.titleLabel.text = String(listing?.likes.count)
        adjustUITextViewHeight(arg: descField)
        descField.text = listing?.desc
        categoryLabel.setTitle(catArray[(listing?.category)!], for: .normal)
        
        //iterate through allergens list and only show the ones with length>0
        
        var allerg = listing?.allergens ?? ["","","","",""]
        var allerge = ""
//        for a in 0...4 {
//            if allerg[a] != "" {
//                allerge += allerg[a]!
//            }
//        }
        
        print(allerge)
        
        
        
        
        
        
    }
    
    func adjustUITextViewHeight(arg : UITextView) {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
