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
        let colorScheme = MDCSemanticColorScheme.init()
    override func viewWillAppear(_ animated: Bool) {
        colorScheme.primaryColor = UIColor(red: 0x26/255, green: 0xA6/255, blue: 0x9A/255, alpha: 1)
        colorScheme.onPrimaryColor = UIColor.white
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor(red: 0xE0/255, green: 0xF2/255, blue: 0xF1/255, alpha: 1)
        if let materialNavigation = navigationController as? CustomMaterialNavigation,
            let appBarVC = materialNavigation.appBarViewController(for: self) {
            //MDCFlexibleHeaderColorThemer.apply(schema, to: appBarVC.headerView)
            MDCFlexibleHeaderColorThemer.applySemanticColorScheme(colorScheme, to: appBarVC.headerView)
            appBarVC.headerView.tintColor = UIColor.white
            appBarVC.navigationBar.tintColor = UIColor.white
            MDCNavigationBarColorThemer.applySemanticColorScheme(colorScheme, to: appBarVC.navigationBar)
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
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(check), userInfo: nil, repeats: false)
    }
    
    @objc func check(){
        //navigationController?.navigationBar.backgroundColor = UIColor.white
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
        let protectedPage2 = mainStoryBoard.instantiateViewController(withIdentifier: "ViewWithTableViewController") as! ViewWithTableViewController
        
        self.navigationController?.pushViewController(protectedPage2, animated: true)
        
        let stackCount = self.navigationController?.viewControllers.count
        let addIndex = stackCount! - 1
        self.navigationController?.viewControllers.insert(protectedPage, at: addIndex)
    }
}


