//
//  UserListViewController.swift
//  MessagesTask
////  Created by Krysta Deluca on 7/5/18.
//  Copyright © 2018 Krysta Deluca. All rights reserved.
//

import UIKit
import Firebase

class UserListViewController: UITableViewController {
    var ref: DocumentReference!
    let db = Firestore.firestore()
    var users = [Users]()
    
    var selectedUsers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedUsers = []
        
        //Fill users array from user defaults
        let userDefaults = UserDefaults.standard

        selectedUsers = userDefaults.stringArray(forKey: "Friends") ?? [String]()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Save selected user array
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(selectedUsers, forKey: "Friends")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let item = users[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.email
        
        if selectedUsers.contains(item.uid) {
            cell.accessoryType = .checkmark
        }

        return cell
    }
    
    @IBAction func createTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func fetchUser() {
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let snapshot = querySnapshot {
                    
                    //Add users from database to array
                    for document in snapshot.documents {
                        let data = document.data()
                        let name = data["username"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        let uid = data["uid"] as? String ?? ""
                        let newUser = Users(name: name, email: email, uid: uid)
                        self.users.append(newUser)
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                
                //Remove UID from array
                let selectedUid = users[indexPath.row].uid
                if let index = selectedUsers.index(of: selectedUid) {
                    selectedUsers.remove(at: index)
                }
            } else {
                cell.accessoryType = .checkmark
                
                //Add selected uid to array
                let selectedUid = users[indexPath.row].uid
                self.selectedUsers.append(selectedUid)
            }
        }
    }
}
