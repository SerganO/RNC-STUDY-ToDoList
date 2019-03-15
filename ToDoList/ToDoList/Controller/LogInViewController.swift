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

class LogInViewController: UIViewController , GIDSignInUIDelegate{

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGoogleSignInButton()
    }
    
    fileprivate func configureGoogleSignInButton() {
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.frame = CGRect(x: view.frame.width/2-125, y: view.frame.height/2-25, width: 250, height: 50)
        view.addSubview(googleSignInButton)
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    
    
    
}


