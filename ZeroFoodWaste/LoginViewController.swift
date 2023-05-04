//
//  LoginViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 27/4/2023.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var userRef: CollectionReference?   //reference to your user collection
    var currentUser: FirebaseAuth.User?
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!

    @IBAction func loginButton(_ sender: Any) {
    
            
        guard let email = emailField.text, let password = pwField.text else{
            return
        }
        
        if email.isEmpty || password.isEmpty {
            displayMessage(title: "Error", message: "Please ensure all fields are filled in")
            return
        }
        
        //creating the user
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                self.displayMessage(title: "Fail", message: "no cannot go in lol")
                print("Login Error: \(error!.localizedDescription)")
                
            } else {
                self.currentUser = authResult?.user
                print("Login Successful")
                
                if let result = authResult {
                    print("Auth Result: \(result)")
                }
                
            }
            }
    }
    
    @IBAction func createAccButton(_ sender: Any){}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
//

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    */

}
