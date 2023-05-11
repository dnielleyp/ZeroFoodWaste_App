//
//  CreateListingViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 4/5/2023.
//

import UIKit

class CreateListingViewController: UIViewController {
    
    
    weak var databaseController: DatabaseProtocol?
    
    var draft = false
    var category: Int?
    var saveDraft = false
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var locationField: UITextField!

    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var dietPrefCheckList: UITableView!
    
    let dietPrefList = ["Gluten Free", "Vegan", "Vegetarian", "Halal"]
    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //hide the tab bar hehe
        self.tabBarController?.tabBar.isHidden = true
        
        //get databaseController
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }

    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
//    checkmark.square
    
// MARK: - saving as draft
    
    @IBAction func saveAsDraft(_ sender: Any) {
        saveDraft = true
        //check that at least name field is filled :D
        guard let name = nameField.text else {return}
        guard let desc = descField.text else {return}
        guard let location = locationField.text else {return}
        category = categorySegmentedControl.selectedSegmentIndex
        
        var category32 = Int32(category!)
        
        if name.isEmpty {
            displayMessage(title: "Can't Save Draft", message: "Please input a name for your listing")
            return
        }
        //at least name is field
        else {
            databaseController?.addListingDraft(draft: true, name: name, description: desc, location: location, category: category32)
            print("ADDDED")
        }
        
        
        
        
        //calls create listing
        

        
        
        //then it leaves create listing view :)
        self.dismiss(animated: true, completion: nil)

    }
    
// MARK: Creating a listing that will be posted
    
    @IBAction func createListing(_ sender: Any) {

        //check if all fields are there yk
        
        
        
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

extension CreateListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //f5 categories
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prefCell", for: indexPath)
        cell.textLabel?.text = dietPrefList[indexPath.row]
        return cell
    }
}


