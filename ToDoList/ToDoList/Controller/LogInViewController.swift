//
//  LogInViewController.swift
//  ToDoList
//
//  Created by Trainee on 3/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FacebookLogin

class LogInViewController: UIViewController , GIDSignInUIDelegate,LoginButtonDelegate{
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        
        
        if let accessToken = FBSDKAccessToken.current(), FBSDKAccessToken.currentAccessTokenIsActive() {
            AuthorizationManager.shared.facebookSignIn(accessToken.userID, completion: {
                self.NavigationToTableView()
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        AuthorizationManager.shared.facebookId = ""
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGoogleSignInButton()
        configureFacebookButton()
        NotificationManager.shared.removeAllNotification()
    }
    
    func configureFacebookButton() {
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.loginBehavior = .web
        loginButton.center = view.center
        loginButton.center.y += 50
        view.addSubview(loginButton)
        loginButton.delegate = self
    }
    
    fileprivate func configureGoogleSignInButton() {
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.frame = CGRect(x: view.frame.width/2-100, y: view.frame.height/2-25, width: 200, height: 50)
        view.addSubview(googleSignInButton)
        GIDSignIn.sharedInstance().uiDelegate = self
        AuthorizationManager.shared.completionHandler = processAutorization
    }
    
    
    func processAutorization(_ autorize: Bool) {
        AuthorizationManager.shared.navigationHandler = NavigationToTableView
    }
    
    func NavigationToTableView()
    {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        protectedPage.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(protectedPage, animated: true)
    }
    
    
}


