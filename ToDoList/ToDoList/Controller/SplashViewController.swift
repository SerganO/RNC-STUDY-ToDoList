//
//  SplashViewController.swift
//  ToDoList
//
//  Created by Trainee on 3/19/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       /* AuthorizationManager.shared.checkGoogleAuth { (result) in
            if result {
                
                FirebaseManager.shared.ref.child("UserId").setValue(AuthorizationManager.shared.id)
                
                let appDelegate = UIApplication.shared.delegate
                let nav = appDelegate?.window?!.rootViewController as? UINavigationController
                
                let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController //as UIViewController
                nav?.pushViewController(protectedPage, animated: true)
            } else {
                //FirebaseManager.shared.ref.child("UserId").setValue(AuthorizationManager.shared.id)
                
                let appDelegate = UIApplication.shared.delegate
                let nav = appDelegate?.window?!.rootViewController as? UINavigationController
                
                let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController //as UIViewController
                nav?.pushViewController(protectedPage, animated: true)
            }
        }*/
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
