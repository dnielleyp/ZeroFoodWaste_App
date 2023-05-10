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
    var category: String?
    
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
    
    func createListing(name: String?, draft){
        
    }
    
    
    @IBAction func categorySelectionChanged(_ sender: Any) {
        
        category = categorySegmentedControl.titleForSegment(at: categorySegmentedControl.selectedSegmentIndex) ?? ""
        
    }
    
//    checkmark.square
    
    
    
    
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
        print("THIS RAN")
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("THIS DIDN'T RUN")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "prefCell", for: indexPath)
        cell.textLabel?.text = dietPrefList[indexPath.row]
        return cell
    }
}


