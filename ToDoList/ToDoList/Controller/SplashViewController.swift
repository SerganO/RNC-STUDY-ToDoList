//
//  SplashViewController.swift
//  ToDoList
//
//  Created by Trainee on 3/19/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit

class SplashViewController: UIViewController , GIDSignInUIDelegate{

    var spinner = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ai = UIActivityIndicatorView.init(style: .gray)
        ai.startAnimating()
        ai.center = self.view.center
        ai.center.y = ai.center.y + 45
        
        DispatchQueue.main.async {
            self.view.addSubview(ai)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let accessToken = FBSDKAccessToken.current() {
            // User is logged in, use 'accessToken' here.
            AuthorizationManager.shared.facebookId = accessToken.userID
            let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            
            let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
            protectedPage.navigationItem.hidesBackButton = true
            let protectedPage2 = mainStoryBoard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
            
            self.navigationController?.pushViewController(protectedPage2, animated: true)
            
            let stackCount = self.navigationController?.viewControllers.count
            let addIndex = stackCount! - 1
            self.navigationController?.viewControllers.insert(protectedPage, at: addIndex)
        }
        else
        {
            GIDSignIn.sharedInstance().uiDelegate = self
            AuthorizationManager.shared.checkGoogleAuth { (result) in
                if result {
                    let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                    
                    let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
                    protectedPage.navigationItem.hidesBackButton = true
                    let protectedPage2 = mainStoryBoard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
                    
                    self.navigationController?.pushViewController(protectedPage2, animated: true)
                    
                    let stackCount = self.navigationController?.viewControllers.count
                    let addIndex = stackCount! - 1
                    self.navigationController?.viewControllers.insert(protectedPage, at: addIndex)
                    
                } else {
                    let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                    let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
                    protectedPage.navigationItem.hidesBackButton = true
                    self.navigationController?.pushViewController(protectedPage, animated: true)
                }
            }
        }
        
        
    }
}


