//
//  HomeViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 3/5/2023.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    var user: FirebaseAuth.User?

    @IBOutlet weak var helloLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let name = "Danielle"
        helloLabel.text = "Hello, \(name)"
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
