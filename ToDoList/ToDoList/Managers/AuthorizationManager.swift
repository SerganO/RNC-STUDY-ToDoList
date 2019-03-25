//
//  AuthorizationManager.swift
//  ToDoList
//
//  Created by Trainee on 3/11/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

class AuthorizationManager{
    static let shared = AuthorizationManager()
    var id = "tmp"
    var facebookId = ""
    var completionHandler: ((Bool)-> Void)?
    
    public func checkGoogleAuth(_ completion : @escaping (Bool)-> Void)
    {
        if let result = GIDSignIn.sharedInstance()?.hasAuthInKeychain(), result {
            print("Yes has")
            GIDSignIn.sharedInstance()?.signIn()
            completionHandler = completion
        } else {
            print("No")
            completion(false)
        }
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            completionHandler?(false)
        } else {
            AuthorizationManager.shared.id = user.userID
            FirebaseManager.shared.ref = Database.database().reference(withPath: "users").child(AuthorizationManager.shared.id)
            FirebaseManager.shared.ref.child("UserId").setValue(AuthorizationManager.shared.id)
            completionHandler?(true)
        }
    }
  
}
