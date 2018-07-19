//
//  ConversationViewController.swift
//  MessagesTask
//
//  Created by Krysta Deluca on 7/6/18.
//  Copyright © 2018 Krysta Deluca. All rights reserved.
//

import UIKit
import MessageKit
import Firebase

class ConversationViewController: MessagesViewController {

    
    var messages: [MessageType] = []
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    var selectedUsers = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        ref = Database.database().reference()
        
        //Fill users array from user defaults
        selectedUsers = []
        let userDefaults = UserDefaults.standard
        
        selectedUsers = userDefaults.stringArray(forKey: "Friends") ?? [String]()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Fill users array from user defaults
        selectedUsers = []
        let userDefaults = UserDefaults.standard
        
        selectedUsers = userDefaults.stringArray(forKey: "Friends") ?? [String]()
        
        //Set up messages
        messages.removeAll()
        databaseHandle = ref.child("messages").observe(.childAdded, with: { (snapshot) -> Void in
            if let value = snapshot.value as? [String:AnyObject] {
                let id = value["senderId"] as! String
                let text = value["text"] as! String
                let name = value["senderDisplayName"] as! String
                
                let sender = Sender(id: id, displayName: name)
                let message = UserMessage(text: text, sender: sender, messageId: id, date: Date())
                
                //Only append message if id is in selected users array or is current user
                if self.selectedUsers.contains(id) || id == self.currentSender().id {
                    self.messages.append(message)
                }
                
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                }
            }
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.ref.removeObserver(withHandle: databaseHandle)
        selectedUsers.removeAll()
        messages.removeAll()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            AuthenticationManager.sharedInstance.loggedIn = false
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
    }
}

extension ConversationViewController: MessagesDataSource {
    
    func currentSender() -> Sender {
        let senderID = Auth.auth().currentUser?.uid
        let senderDisplayName = Auth.auth().currentUser?.displayName
        
        return Sender(id: senderID!, displayName: senderDisplayName!)
    }
    
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}

extension ConversationViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let messageRef = ref.child("messages").childByAutoId()
        let message = [
            "text": text,
            "senderId": currentSender().id,
            "senderDisplayName": currentSender().displayName
        ]
        
        messageRef.setValue(message)
        inputBar.inputTextView.text = String()
    }
}

extension ConversationViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if isFromCurrentSender(message: message) {
            return .black
        } else {
            return .lightGray
        }
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if isFromCurrentSender(message: message) {
            return .white
        } else {
            return .darkText
        }
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        if isFromCurrentSender(message: message) {
            return .bubbleTail(.bottomRight, .curved)
        } else {
            return .bubbleTail(.bottomLeft, .curved)
        }
    }
}

extension ConversationViewController: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0.0
    }
    
    
    func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        if isFromCurrentSender(message: message) {
            return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)
        } else {
            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
        }
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
}
