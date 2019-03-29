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
    var sync = false
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
    
    public func signS(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
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
                
                FirebaseManager.shared.MainRef.child("Identifier").child("GoogleID").child(user.userID).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    
                    if snapshot.exists() {
                        FirebaseManager.shared.ref = FirebaseManager.shared.MainRef.child("users").child(snapshot.value as! String)
                        AuthorizationManager.shared.userUuid = snapshot.value as! String
                        self.checkSync()
                    }
                    else{
                        let uuid = UUID().uuidString
                        FirebaseManager.shared.MainRef.child("Identifier").child("GoogleID").child(user.userID).setValue(uuid)
                        FirebaseManager.shared.ref = FirebaseManager.shared.MainRef.child("users").child(uuid)
                        FirebaseManager.shared.ref.child("sync").setValue(false)
                        AuthorizationManager.shared.userUuid = uuid
                    }
                    AuthorizationManager.shared.navigationHandler?()
                })
                completionHandler?(true)
            }
            
        }
        
    }
    
    public func facebookSignInS(_ userID: String, completion : @escaping ()-> Void)
    {
        AuthorizationManager.shared.facebookId = userID
        FirebaseManager.shared.MainRef.child("Identifier").child("FacebookID").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists() {
                FirebaseManager.shared.ref = FirebaseManager.shared.MainRef.child("users").child(snapshot.value as! String)
                AuthorizationManager.shared.userUuid = snapshot.value as! String
                self.checkSync()
            }
            else{
                let uuid = UUID().uuidString
                FirebaseManager.shared.MainRef.child("Identifier").child("FacebookID").child(userID).setValue(uuid)
                FirebaseManager.shared.ref = FirebaseManager.shared.MainRef.child("users").child(uuid)
                FirebaseManager.shared.ref.child("sync").setValue(false)
                AuthorizationManager.shared.userUuid = uuid
                
            }
            completion()
            
        })
    }
    
    public func addFacebook(_ userId: String) {
        AuthorizationManager.shared.facebookId = userId
        FirebaseManager.shared.MainRef.child("Identifier").child("FacebookID").child(userId).setValue(userUuid)
        FirebaseManager.shared.ref.child("sync").setValue(true)
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
            FirebaseManager.shared.ref.child("sync").setValue(true)
            completionHandler?(true)
        }
        
    }
    
    
    func checkSync() {
        
        if !AuthorizationManager.shared.add{
            FirebaseManager.shared.MainRef.observeSingleEvent(of: .value, with: { (snapshot) in
                AuthorizationManager.shared.sync = snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: AuthorizationManager.shared.userUuid).childSnapshot(forPath: "sync").value as! Bool
            })
            
        }
        
    }
    
    //FirebaseManager.shared.MainRef.child("Identifier").child("FacebookID").child(userID).observeSingleEvent
    
    
    public func facebookSignIn(_ userID: String, completion : @escaping ()-> Void)
    {
        AuthorizationManager.shared.facebookId = userID
        FirebaseManager.shared.MainRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            FirebaseManager.shared.MainRef.child("Identifier").child("FacebookID").child(userID).observeSingleEvent(of: .value, with: { (snapshot2) in
            if snapshot2.exists() {
                FirebaseManager.shared.ref = FirebaseManager.shared.MainRef.child("users").child(snapshot2.value as! String)
                AuthorizationManager.shared.userUuid = snapshot2.value as! String
                AuthorizationManager.shared.sync = snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: AuthorizationManager.shared.userUuid).childSnapshot(forPath: "sync").value as! Bool
            }
            else{
                let uuid = UUID().uuidString
                FirebaseManager.shared.MainRef.child("Identifier").child("FacebookID").child(userID).setValue(uuid)
                FirebaseManager.shared.ref = FirebaseManager.shared.MainRef.child("users").child(uuid)
                FirebaseManager.shared.ref.child("sync").setValue(false)
                AuthorizationManager.shared.userUuid = uuid
                
            }
            completion()
            })
        })
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
                
                FirebaseManager.shared.MainRef.observeSingleEvent(of: .value, with: { (snapshotS) in
                
                FirebaseManager.shared.MainRef.child("Identifier").child("GoogleID").child(user.userID).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    
                    if snapshot.exists() {
                        FirebaseManager.shared.ref = FirebaseManager.shared.MainRef.child("users").child(snapshot.value as! String)
                        AuthorizationManager.shared.userUuid = snapshot.value as! String
                         AuthorizationManager.shared.sync = snapshotS.childSnapshot(forPath: "users").childSnapshot(forPath: AuthorizationManager.shared.userUuid).childSnapshot(forPath: "sync").value as! Bool
                    }
                    else{
                        let uuid = UUID().uuidString
                        FirebaseManager.shared.MainRef.child("Identifier").child("GoogleID").child(user.userID).setValue(uuid)
                        FirebaseManager.shared.ref = FirebaseManager.shared.MainRef.child("users").child(uuid)
                        FirebaseManager.shared.ref.child("sync").setValue(false)
                        AuthorizationManager.shared.userUuid = uuid
                    }
                    AuthorizationManager.shared.navigationHandler?()
                })
                })
                completionHandler?(true)
            }
            
        }
        
    }
}
