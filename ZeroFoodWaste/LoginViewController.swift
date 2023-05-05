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
    var hidePassword = true
    
    
    @IBOutlet weak var passwordButton: UIButton!
    
    
    @IBAction func hideUnhideButton(_ sender: Any) {
        if hidePassword{
            self.pwField.isSecureTextEntry = false
            passwordButton.setImage(UIImage(systemName: "eye"),for: .normal)
        }
        //hide the password
        else {
            self.pwField.isSecureTextEntry = true
            passwordButton.setImage(UIImage(systemName: "eye.slash"),for: .normal)
        }
        hidePassword = !hidePassword
    }
    
    
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
                print("Login Error: \(error!.localizedDescription)")
                self.displayMessage(title: "Login Fail", message: "email or password invalid")
                return
                
            } else {
                self.currentUser = authResult?.user
                print("Login Successful")
                
                self.performSegue(withIdentifier:"showHomeSegue", sender: self)

                
            }
            }
    }
    
    @IBAction func createAccButton(_ sender: Any){}
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.navigationController?.isNavigationBarHidden = true
        self.pwField.isSecureTextEntry = true

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    */

}
