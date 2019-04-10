//
//  TestViewController2.swift
//  ToDoList
//
//  Created by Trainee on 4/10/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import MaterialComponents

class TestViewController2: UIViewController {

    let secondColor = UIColor(red: 1/255, green: 0x86/255, blue: 0x87/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let testButton = MDCFloatingButton()
        testButton.setTitle("BACK", for: .normal)
        testButton.addTarget(self, action: #selector(testFunc2), for: .touchUpInside)
        testButton.setBackgroundColor(UIColor.white)
        testButton.setTitleColor(UIColor.black, for: .normal)
        let currWidth = testButton.widthAnchor.constraint(equalToConstant: 24)
        let currHeight = testButton.heightAnchor.constraint(equalToConstant: 24)
        currWidth.isActive = true
        currHeight.isActive = true
        let testItem = UIBarButtonItem(customView: testButton)
        
        let MNavigationBar = MDCNavigationBar()
        MNavigationBar.title = "MDC NAV 2"
        MNavigationBar.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: 60)
        MNavigationBar.backgroundColor = secondColor
        MNavigationBar.leftBarButtonItem = testItem
        view.addSubview(MNavigationBar)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func testFunc2(){
         dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
