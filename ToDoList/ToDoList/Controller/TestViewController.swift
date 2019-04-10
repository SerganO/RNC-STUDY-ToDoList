//
//  TestViewController.swift
//  ToDoList
//
//  Created by Trainee on 4/10/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import MaterialComponents

class TestViewController: UIViewController {

    struct Constants {
        static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        static let minHeight: CGFloat = 44 + statusBarHeight
        static let maxHeight: CGFloat = 400.0
    }
    
    
    let appBarViewController = MDCAppBarViewController()
    let secondColor = UIColor(red: 1/255, green: 0x86/255, blue: 0x87/255, alpha: 1)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.addChild(appBarViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let appBar = MDCAppBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configure()
        
        let testButton = MDCFloatingButton()
        testButton.setTitle("Date", for: .normal)
        testButton.addTarget(self, action: #selector(testFunc), for: .touchUpInside)
        let currWidth = testButton.widthAnchor.constraint(equalToConstant: 24)
        let currHeight = testButton.heightAnchor.constraint(equalToConstant: 24)
        currWidth.isActive = true
        currHeight.isActive = true
        let testItem = UIBarButtonItem(customView: testButton)
        
        let MNavigationBar = MDCNavigationBar()
        MNavigationBar.title = "MDC NAV 1"
        MNavigationBar.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: 60)
        MNavigationBar.backgroundColor = secondColor
        MNavigationBar.rightBarButtonItem = testItem
        view.addSubview(MNavigationBar)
        //MNavigationBar.observe(self.navigationItem)
 
        
        //self.navigationItem.leftBarButtonItem = testItem
        /*appBarViewController.navigationBar.leftBarButtonItem = testItem
        appBarViewController.navigationBar.leftBarButtonItems?.append(testItem)
        appBarViewController.navigationItem.leftBarButtonItem = testItem
        appBarViewController.navigationItem.leftBarButtonItems?.append(testItem)
        view.addSubview(appBarViewController.view)
        appBarViewController.didMove(toParent: self)*/
        
    }
    
    @objc func testFunc(){
        performSegue(withIdentifier: "TestSegue", sender: self)
    }
    
    func configure(){
        self.addChild(appBar.headerViewController)
        appBar.navigationBar.backgroundColor = .clear
        appBar.navigationBar.title = nil
        let headerView = appBar.headerViewController.headerView
        headerView.backgroundColor = .clear
        headerView.maximumHeight = Constants.maxHeight
        headerView.minimumHeight = Constants.minHeight
        
        // 4
        //heroHeaderView.frame = headerView.bounds
        headerView.insertSubview(UIImageView(image: UIImage(named: "GoogleIcon")), at: 0)
        
        // 5
        //headerView.trackingScrollView = self.collectionView
        
        // 6
        appBar.addSubviewsToParent()
    }
}
