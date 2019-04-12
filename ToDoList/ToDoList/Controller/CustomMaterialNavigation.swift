//
//  CustomMaterialNavigation.swift
//  TestMaterialNavigatio
//
//  Created by Trainee on 4/12/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import MaterialComponents

class CustomMaterialNavigation: MDCAppBarNavigationController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        constructor()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        constructor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        constructor()
    }
    
    func constructor() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "SplashVC")
        viewControllers.removeAll()
        
        rootViewController.loadViewIfNeeded()
        
        let appBarVC = MDCAppBarViewController()
        rootViewController.addChild(appBarVC)
        rootViewController.view.addSubview(appBarVC.view)
        viewControllers.append(rootViewController)
        appBarVC.didMove(toParent: rootViewController)
        
        setNavigationBarHidden(true, animated: false)
        
    }
}
