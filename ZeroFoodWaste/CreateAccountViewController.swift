//
//  CreateAccountViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 27/4/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore


class CreateAccountViewController: UIViewController{
    
    var currentUser: FirebaseAuth.User?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func createAccButton(_ sender: Any) {
        //Validate fields
        guard let name = nameField.text else {return}
        guard let username = usernameField.text else {return}
        guard let email = emailField.text else {return}
        guard let password = passwordField.text else {return}
        
        if name.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty {
            displayMessage(title: "Empty Fields", message: "Please ensure no fields are empty")
            return
        }
        
        if password.count < 6 {
            displayMessage(title: "Password Too Short", message: "Please choose a longer password")
        }
        
        Auth.auth().createUser(withEmail: email, password: password){ (authResult, error) in
            //check for errors
            if error != nil {
                print("ERRRROOOORRR")
                self.displayMessage(title: "error", message: "heheuhreuihiuh")
            }
            else {
                //user was created successsfully, now store the properties :D
                self.currentUser = authResult!.user
                let database = Firestore.firestore()
                
                
                
                
                database.collection("user").document(username).setData(["name":name,
                                                                        "listings":[],
                                                                        "likes":[],
                                                                        "pfp":""]) { error in
                    if let error = error {
                        print("Error")
                    } else {
                        print("Doc succcess")
                    }
                }
                
                self.performSegue(withIdentifier: "showHomeSegue", sender: self)
                
            }
        }
        
        
        
        
        
        
        //create users
        //transition to home screen
        
        
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
