//
//  ProfileViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 10/5/2023.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        Task{
            do {
                try Auth.auth().signOut()
            } catch {
                print("Log Out Error: \(error.localizedDescription)")
            }
            self.performSegue(withIdentifier: "showLoginSegue", sender: self)
        }
    }

    @IBAction func draftsButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "draftsVC") as? DraftsViewController {
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
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
