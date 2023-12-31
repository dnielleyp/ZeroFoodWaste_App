//
//  LoginViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 27/4/2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var authHandle: AuthStateDidChangeListenerHandle?
    
    var currentUser: FirebaseAuth.User?
    
    var user: User?

    
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
        
        //signing in with user
        Task{
            do{
                let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
                currentUser = authDataResult.user
            
        } catch {
            displayMessage(title: "Login Failed! :(", message: "Please try again")
        } }
    }
    
    
    @IBAction func createAccButton(_ sender: Any){}
    
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
        self.pwField.isSecureTextEntry = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
    
    
        authHandle = Auth.auth().addStateDidChangeListener(){
            (auth, user) in
            guard user != nil else {return}
            self.performSegue(withIdentifier: "showHomeSegue", sender: nil)

        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        guard let authHandle = authHandle else {return}
        Auth.auth().removeStateDidChangeListener(authHandle)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showHomeSegue" {
//            let destination = segue.destination as! HomeViewController
//
//            destination.currentUser = user
//        }
//    }
    

}
