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

class AuthorizationManager {
    static let shared = AuthorizationManager()
    var id = ""
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            
            AuthorizationManager.shared.id = user.userID
            //AuthorizationManager.shared.id = user.profile.email
            
            FirebaseManager.shared.ref.child("UserId").setValue(AuthorizationManager.shared.id)
            
            let appDelegate = UIApplication.shared.delegate
            let nav = appDelegate?.window?!.rootViewController as? UINavigationController
       
            let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController //as UIViewController
            nav?.pushViewController(protectedPage, animated: true)
            
            
            
            
            
            //window?.rootViewController?.performSegue(withIdentifier: "SignIn", sender: nil)
            //let appDelegate = UIApplication.shared.delegate
            //appDelegate?.window??.rootViewController = protectedPage
            //self.navigationController.pushViewController(protectedPage, animated: true)
            //self.presentViewController(protectedPage, animated:true, completion:nil)
            /* let userId = user.userID                  // For client-side use only!
             let idToken = user.authentication.idToken // Safe to send to the server
             let fullName = user.profile.name
             let givenName = user.profile.givenName
             let familyName = user.profile.familyName
             let email = user.profile.email*/
            // ...
        }
    }
  
}
