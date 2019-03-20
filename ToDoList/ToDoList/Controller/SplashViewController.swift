//
//  SplashViewController.swift
//  ToDoList
//
//  Created by Trainee on 3/19/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import GoogleSignIn

class SplashViewController: UIViewController , GIDSignInUIDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GIDSignIn.sharedInstance().uiDelegate = self
        AuthorizationManager.shared.checkGoogleAuth { (result) in
            if result {
                let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                
                let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController //as UIViewController
                protectedPage.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(protectedPage, animated: true)
                let protectedPage2 = mainStoryBoard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController //as UIViewController
                self.navigationController?.pushViewController(protectedPage2, animated: true)
            
            } else {
                let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
                protectedPage.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(protectedPage, animated: true)
            }
        }
    }
}
