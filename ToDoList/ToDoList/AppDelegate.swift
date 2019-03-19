//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Trainee on 3/7/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
   /*/* func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        
    }*/*/
    
    
    
    /*/*func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error) != nil {
            print("An error occured during Google Authentication")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
            if (error) != nil {
                print("Google Authentification Fail")
            } else {
                print("Google Authentification Success")
                
                let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController //as UIViewController
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = protectedPage

            }
        })
        
        /*Auth.auth().signIn(with: credential) { (user, error) in
            if (error) != nil {
                print("Google Authentification Fail")
            } else {
                print("Google Authentification Success")
                
                let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController //as UIViewController
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = protectedPage
            }
        }*/
    }*/*/
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
       AuthorizationManager.shared.sign(signIn, didSignInFor: user, withError: error)
    }
    /*func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }*/
   
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let googleAuthentication = GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        
        
        return googleAuthentication
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

