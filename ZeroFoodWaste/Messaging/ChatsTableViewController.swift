//
//  ChatsTableViewController.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 26/5/2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatsTableViewController: UITableViewController {
    
    
    @IBAction func addChatButton(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add New Chat", message: "Enter channel name below", preferredStyle: .alert)
        alertController.addTextField()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Create", style: .default) { _ in
            let chatName = alertController.textFields![0]
            var doesExist = false
            for chat in self.chats {
                
                if chat.name.lowercased() == chatName.text!.lowercased() {
                    doesExist = true
                    
                }
            }
            
            if !doesExist {
                self.chatsRef?.addDocument(data: ["name" : chatName.text!])
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        self.present(alertController, animated: false, completion: nil)
        performSegue(withIdentifier: "showMessageSegue", sender: self)
    }
    
    
    let SEGUE_CHAT = "showChatSegue"
    let CELL_CHAT = "chatCell"
    
    var currentSender: Sender?
    var chats = [Chat]()
    
    var chatsRef: CollectionReference?
    var databaseListener: ListenerRegistration?
    
    var userRef = Firestore.firestore().collection("user")
    var user: FirebaseAuth.User?
    
    override func viewWillAppear(_ animated: Bool) {
        
        getCurrentSender()
        
        databaseListener = chatsRef?.addSnapshotListener(){
            (querySnapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.chats.removeAll()
            
            querySnapshot?.documents.forEach() { snapshot in
                let id = snapshot.documentID
                let name = snapshot["name"] as? String
                let chat = Chat(id: id, name: name!)
                
                self.chats.append(chat)
            }
            
            self.tableView.reloadData()
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let database = Firestore.firestore()
        chatsRef = database.collection("chats")

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseListener?.remove()
    }
    
    func getCurrentSender(){
        guard let userID = Auth.auth().currentUser?.uid else {
            displayMessage(title: "eh", message: "errorooror")
            return
        }
        
        userRef.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error \(error!)")
                return
            }
            for document in snapshot.documents {
                let documentID = document.documentID
                if documentID == userID {
                    let username = document.get("username") as? String
                    self.currentSender = Sender(id: userID, username: username!)
                }
                
            }
        }
        
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chats.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_CHAT, for: indexPath)

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = chats[indexPath.row]
        performSegue(withIdentifier: SEGUE_CHAT, sender: chat)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
