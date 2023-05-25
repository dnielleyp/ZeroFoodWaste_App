//
//  EditDraftViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 11/5/2023.
//

import UIKit

class EditDraftViewController: UIViewController {
    var listing: ListingDraft?
    
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var listingName: UITextField!
    @IBOutlet weak var listingDesc: UITextView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    @IBOutlet weak var dietPrefTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        var tempCategory = Int(listing!.category)

        self.listingName.text = listing?.name
        self.listingDesc.text = listing?.desc
        self.locationField.text = listing?.location
        self.categorySegmentControl.selectedSegmentIndex = tempCategory
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateDraft(_ sender: Any) {
        var category32 = Int32(categorySegmentControl.selectedSegmentIndex)
        
        guard let lname = listingName.text else {return}
        guard let ldesc = listingDesc.text else {return}
        guard let llocation = locationField.text else {return}
        
        
        listing?.name = lname
        listing?.desc = ldesc
        listing?.location = llocation
        
        listing?.category = category32
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func selectPhoto(_ sender: Any) {
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

extension EditDraftViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prefCell", for: indexPath)
        cell.textLabel?.text = "hi"
        return cell
    }
}

extension EditDraftViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
            listingImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
