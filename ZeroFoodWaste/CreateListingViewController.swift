//
//  CreateListingViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 4/5/2023.
//

import UIKit

class CreateListingViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //hide the tab bar hehe
        self.tabBarController?.tabBar.isHidden = true
        
    }
    

    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
