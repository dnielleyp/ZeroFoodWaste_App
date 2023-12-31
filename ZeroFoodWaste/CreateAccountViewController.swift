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


class CreateAccountViewController: UIViewController, DatabaseListener{
    func onUserChange(change: DatabaseChange, userLikes: [Listing], userListing: [Listing]) {
        //do nothing
    }
    
    func onListingChange(change: DatabaseChange, listings: [Listing]) {
        //do nothing
    }
    
    
    var currentUser: FirebaseAuth.User?
    var authHandle: AuthStateDidChangeListenerHandle?
    var listenerType = ListenerType.user
    
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
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
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            //check for errors
            if error != nil {
                self.displayMessage(title: "error", message: "\(error)")
            }
            else {
                //user was created successsfully, now store the properties :D
                self.currentUser = authResult!.user
                
                guard let userID = Auth.auth().currentUser?.uid else {return}
                
                let user = self.databaseController?.addUser(name: name, username: username, email: email, pfp: "")
            
                let setDispName = self.currentUser!.createProfileChangeRequest()
                setDispName.displayName = username
                
                setDispName.commitChanges {(error) in
                    if let error = error {
                        print("error setting display name hehe \(error)")
                    } else {
                        print("display name is set!! hurrah!")
                    }

            }
        }
    

                
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
