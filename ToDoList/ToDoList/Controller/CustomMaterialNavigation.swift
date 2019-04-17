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
        appBarVC.view.backgroundColor = UIColor(red: 0xE0/255, green: 0xF2/255, blue: 0xF1/255, alpha: 1)
        //let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBar.tintColor = UIColor.white//uicolorFromHex(0xffffff)
        navigationBar.barTintColor = UIColor.white //UIColorFromHex(0xffffff)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        rootViewController.addChild(appBarVC)
        rootViewController.view.addSubview(appBarVC.view)
        viewControllers.append(rootViewController)
        appBarVC.didMove(toParent: rootViewController)
        
        setNavigationBarHidden(true, animated: false)
        
    }
}
