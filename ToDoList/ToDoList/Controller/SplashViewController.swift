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
import MaterialComponents

class SplashViewController: UIViewController , GIDSignInUIDelegate {

    //let schema = MDCSemanticColorScheme(defaults: .material201804)
    //03DAC6 main
    //26A69A nav
    //E0F2F1 back
    
    let schema = MDCBasicColorScheme.init(primaryColor: UIColor(red: 0xE0/255, green: 0xF2/255, blue: 0xF1/255, alpha: 1), secondaryColor: UIColor.black)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.white
        if let materialNavigation = navigationController as? CustomMaterialNavigation,
            let appBarVC = materialNavigation.appBarViewController(for: self) {
            MDCFlexibleHeaderColorThemer.apply(schema, to: appBarVC.headerView)
            MDCNavigationBarColorThemer.apply(schema, to: appBarVC.navigationBar)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = UIColor.white
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
        navigationController?.navigationBar.backgroundColor = UIColor.white
        if let accessToken = FBSDKAccessToken.current(), FBSDKAccessToken.currentAccessTokenIsActive() {
            AuthorizationManager.shared.facebookSignIn(accessToken.userID, completion: {
                self.NavigationToTableView()
            })
        } else {
            GIDSignIn.sharedInstance().uiDelegate = self
            AuthorizationManager.shared.checkGoogleAuth { (result) in
                if result {
                    AuthorizationManager.shared.navigationHandler = {
                        self.NavigationToTableView()
                        
                    }
                } else {
                    let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                    let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
                    protectedPage.navigationItem.hidesBackButton = true
                    self.navigationController?.pushViewController(protectedPage, animated: true)
                }
            }
        }
        
        
    }
    
    
    func NavigationToTableView() {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        
        let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        protectedPage.navigationItem.hidesBackButton = true
        let protectedPage2 = mainStoryBoard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        
        self.navigationController?.pushViewController(protectedPage2, animated: true)
        
        let stackCount = self.navigationController?.viewControllers.count
        let addIndex = stackCount! - 1
        self.navigationController?.viewControllers.insert(protectedPage, at: addIndex)
    }
}


