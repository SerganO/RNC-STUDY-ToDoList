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
import FBSDKCoreKit

class AuthorizationManager{
    static let shared = AuthorizationManager()
    var id = ""
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
            FirebaseManager.shared.ref = Database.database().reference(withPath: "users").child("Google:" + AuthorizationManager.shared.id)
            FirebaseManager.shared.ref.child("UserId").setValue(AuthorizationManager.shared.id)
            completionHandler?(true)
        }
    }
    
    public func facebookSignIn() -> Bool
    {
        if let accessToken = FBSDKAccessToken.current() {
            AuthorizationManager.shared.facebookId = accessToken.userID
            AuthorizationManager.search()
            return true
        } else {
            return false
        }
    }
  
   
    
    
    static public func search()
    {
        FirebaseManager.shared.MainRef.child("users").observe(.value, with : {
            snapshot in
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    print("------------------------------------------")
                    print(snapshot.childSnapshot(forPath: "Auth").childSnapshot(forPath: "FacebookAuth").childSnapshot(forPath: "ID"))
                    print("------------------------------------------")
                    if snapshot.childSnapshot(forPath: "Auth").childSnapshot(forPath: "FacebookAuth").childSnapshot(forPath: "ID").value as? String? == AuthorizationManager.shared.facebookId {
                        print("""
************************
***********************
**********************
*********************
""")
                        print(snapshot.key)
                        FirebaseManager.shared.ref = FirebaseManager.shared.MainRef.child("users").child(snapshot.key)
                        break
                    }
                }
            }
        })
    }
}
