//
//  User.swift
//  ToDoList
//
//  Created by Trainee on 3/15/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    let uid: String
    let email: String
    
    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
