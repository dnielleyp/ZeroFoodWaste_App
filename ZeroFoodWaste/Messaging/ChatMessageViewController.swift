////
////  ChatMessageViewController.swift
////  ZeroFoodWaste
////
////  Created by Danielle Yap on 26/5/2023.
////
//
//import UIKit
//import MessageKit
//import InputBarAccessoryView
//import FirebaseFirestore
////MessagesDataSource,
//class ChatMessageViewController: MessagesViewController, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
//    
//    
//    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
//        <#code#>
//    }
//    
//    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
//        <#code#>
//    }
//    
//
//    var sender: Sender?
//    var currentChat: Chat?
//    var messagesList = [ChatMessage]()
//    
//    var chatRef: CollectionReference?
//    var databaseListener: ListenerRegistration?
//    
//    let formatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.timeZone = .current
//        formatter.dateFormat = "HH:mm dd/MM/yy"
//        return formatter
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
////        messagesCollectionView.messagesDataSource = self
//        messagesCollectionView.messagesLayoutDelegate = self
//        messagesCollectionView.messagesDisplayDelegate = self
//        messageInputBar.delegate = self
//        
//        scrollsToLastItemOnKeyboardBeginsEditing = true
//        maintainPositionOnInputBarHeightChanged = true
//        
//        if currentChat != nil {
//            let database = Firestore.firestore()
//            chatRef = database.collection("chats").document(currentChat!.id).collection("messages")
//            
//            navigationItem.title = "\(currentChat!.name)"
//            
//            
//        }
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
