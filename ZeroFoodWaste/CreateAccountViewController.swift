//
//  CreateAccountViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 27/4/2023.
//

import UIKit
import FirebaseAuth

class CreateAccountViewController: UIViewController{
    
    var authController: Auth?
    var currentUser: FirebaseAuth.User?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func signupButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        authController = Auth.auth()
        
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
