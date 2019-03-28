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
    var id = ""
    var facebookId = ""
    var userUuid = ""
    var completionHandler: ((Bool)-> Void)?
    var navigationHandler: (()-> Void)?
    var add = false
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
        if add {
            AuthorizationManager.shared.addGoogle(signIn, didSignInFor: user, withError: error)
            AuthorizationManager.shared.add = false
        } else {
            
            if let error = error {
                print("\(error.localizedDescription)")
                completionHandler?(false)
            } else {
                AuthorizationManager.shared.id = user.userID
                /*if FirebaseManager.shared.MainRef.child("Identifier").child("GoogleID").child(user.userID).exists()
                 {
                 
                 }*/
                
                //self.ref = FIRDatabase.database().reference()
                
                FirebaseManager.shared.MainRef.child("Identifier").child("GoogleID").child(user.userID).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if snapshot.exists() {
                        FirebaseManager.shared.ref = FirebaseManager.shared.MainRef.child("users").child(snapshot.value as! String)
                        AuthorizationManager.shared.userUuid = snapshot.value as! String
                    }
                    else{
                        let uuid = UUID().uuidString
                        FirebaseManager.shared.MainRef.child("Identifier").child("GoogleID").child(user.userID).setValue(uuid)
                        FirebaseManager.shared.ref = FirebaseManager.shared.MainRef.child("users").child(uuid)
                        AuthorizationManager.shared.userUuid = uuid
                    }
                    AuthorizationManager.shared.navigationHandler?()
                })
                completionHandler?(true)
            }
            
        }
       
    }
    
    public func facebookSignIn(_ userID: String, completion : @escaping ()-> Void)
    {
        AuthorizationManager.shared.facebookId = userID
        FirebaseManager.shared.MainRef.child("Identifier").child("FacebookID").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists() {
                FirebaseManager.shared.ref = FirebaseManager.shared.MainRef.child("users").child(snapshot.value as! String)
                AuthorizationManager.shared.userUuid = snapshot.value as! String
            }
            else{
                let uuid = UUID().uuidString
                FirebaseManager.shared.MainRef.child("Identifier").child("FacebookID").child(userID).setValue(uuid)
                FirebaseManager.shared.ref = FirebaseManager.shared.MainRef.child("users").child(uuid)
                AuthorizationManager.shared.userUuid = uuid
            }
            
            completion()
        })
    }
    
    public func addFacebook(_ userId: String) {
        AuthorizationManager.shared.facebookId = userId
        FirebaseManager.shared.MainRef.child("Identifier").child("FacebookID").child(userId).setValue(userUuid)
    }
    
    public func addGoogle(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
        withError error: Error!) {
        if let error = error {
        print("\(error.localizedDescription)")
        completionHandler?(false)
        } else {
        AuthorizationManager.shared.id = user.userID
        FirebaseManager.shared.MainRef.child("Identifier").child("GoogleID").child(user.userID).setValue(userUuid)
            AuthorizationManager.shared.add = false
            completionHandler?(true)
        }
        
    }
}
