//
//  AuthenticationManager.swift
//  MessagesTask
//
//  Created by Krysta Deluca on 7/5/18.
//  Copyright © 2018 Krysta Deluca. All rights reserved.
//

import Foundation
import Firebase

class AuthenticationManager: NSObject {
    
    static let sharedInstance = AuthenticationManager()
    
    var loggedIn = false
    var userName: String?
    var userId: String?
    
    func didLogIn(user: User) {
        AuthenticationManager.sharedInstance.userName = user.displayName
        AuthenticationManager.sharedInstance.loggedIn = true
        AuthenticationManager.sharedInstance.userId = user.uid
    }
}
