//
//  MaterialNavigationController.swift
//  ToDoList
//
//  Created by Trainee on 4/8/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import MaterialComponents

class MaterialNavigationController: MDCAppBarNavigationController {

    /*override var navigationBar: UINavigationBar{
        get {
            return MDCNavigationBar()
        }
    }*/
    let secondColor = UIColor(red: 1/255, green: 0x86/255, blue: 0x87/255, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.backgroundColor = secondColor
        // Do any additional setup after loading the view.
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
