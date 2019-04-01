//
//  TableViewController.swift
//  ToDoList
//
//  Created by Trainee on 3/11/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKShareKit
import FacebookLogin


class TableViewController: UITableViewController, AddViewControllerDelegate, GIDSignInUIDelegate{

    
    var checkedGroup = [TaskModel]();
    var uncheckedGroup = [TaskModel]();
    var date = Date()
    
    func showAlert(_ result : Bool ) {
        if result {
            let alert = UIAlertController(title: "Done", message: "Successful login", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:nil))
            
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "Google sign in error", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:nil))
            
            self.present(alert, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        return UITableViewCell.EditingStyle.none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setEditing(false, animated: true)//////////////
        
        
        if(AuthorizationManager.shared.id == "" && AuthorizationManager.shared.facebookId == "")
        {
            let alert = UIAlertController(title: "Error Auth", message: "Please Sign In", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:{
                action in
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true)
            return
        }
        
        let b = UIButton(frame: .zero)
        if AuthorizationManager.shared.sync {
            b.setImage(UIImage(named:"Done"), for: .normal)
        } else if AuthorizationManager.shared.facebookId == "" {
            b.setImage(UIImage(named:"Facebook"), for: .normal)
            b.addTarget(self, action: #selector(addAccount), for: .touchDown)
        } else {
            b.setImage(UIImage(named:"GoogleIcon"), for: .normal)
            b.addTarget(self, action: #selector(addAccount), for: .touchDown)
        }
        let item = UIBarButtonItem(customView: b)
        let currWidth = item.customView?.widthAnchor.constraint(equalToConstant: 24)
        let currHeight = item.customView?.heightAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        currHeight?.isActive = true
        navigationItem.leftBarButtonItems?.append(item)
        
        let r = UIButton(frame: .zero)
        r.setImage(UIImage(named:"Reorder"), for: .normal)
        r.addTarget(self, action: #selector(reorder), for: .touchDown)
        let itemR = UIBarButtonItem(customView: r)
        let currWidthR = itemR.customView?.widthAnchor.constraint(equalToConstant: 24)
        let currHeightR = itemR.customView?.heightAnchor.constraint(equalToConstant: 24)
        currWidthR?.isActive = true
        currHeightR?.isActive = true
        navigationItem.rightBarButtonItems?.append(itemR)
        
        
        
        FirebaseManager.shared.ref.child("tasks").queryOrdered(byChild: "id").observe(.value, with : {
            snapshot in
            
            var tmpUncheck: [TaskModel] = []
            var tmpCheck: [TaskModel] = []
            
            for child in snapshot.children {
                
                if let snapshot = child as? DataSnapshot,
                    let task = TaskModel(snapshot: snapshot) {
                    if task.checked == false {
                        tmpUncheck.append(task)
                    } else {
                        tmpCheck.append(task)
                    }
                }
                
            }
            self.uncheckedGroup = tmpUncheck
            self.checkedGroup = tmpCheck
            self.tableView.reloadData()
        })
        updateId()
    }
    
    
    
    @objc func reorder() {
        if isEditing {
            updateId()
        }
        isEditing = !isEditing
    }
    
    
    
    func updateId() {
        var i = 0
        for task in uncheckedGroup {
            FirebaseManager.shared.editTask(task, editItem: ["id":i])
            task.id = i
            i = i+1
        }
        i = 0
        for task in checkedGroup {
            FirebaseManager.shared.editTask(task, editItem: ["id":i])
            task.id = i
            i = i+1
        }
        
    }
    
    func incId() {
        var i = 1
        for task in uncheckedGroup {
            FirebaseManager.shared.editTask(task, editItem: ["id":i])
            task.id = i
            i = i+1
        }
    }
    
    func incChId() {
        var i = 1
        for task in checkedGroup {
            FirebaseManager.shared.editTask(task, editItem: ["id":i])
            task.id = i
            i = i+1
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.showsReorderControl = false
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if(sourceIndexPath.section == destinationIndexPath.section) {
            if sourceIndexPath.section == 0 {
                let itemToMove = uncheckedGroup[sourceIndexPath.row]
                uncheckedGroup.remove(at: sourceIndexPath.row)
                uncheckedGroup.insert(itemToMove, at: destinationIndexPath.row)
            } else {
            
                let itemToMove = checkedGroup[sourceIndexPath.row]
                checkedGroup.remove(at: sourceIndexPath.row)
                checkedGroup.insert(itemToMove, at: destinationIndexPath.row)
            }
        } else {
            tableView.reloadData()
        }
        
    }
    
    
    @objc func addAccount() {
        if !AuthorizationManager.shared.sync {
            if AuthorizationManager.shared.facebookId == "" {
                let loginManager = LoginManager()
                loginManager.loginBehavior = .web
                loginManager.logIn(readPermissions: [ .publicProfile, .email ], viewController: nil, completion: { (LoginResult) in
                    if let accessToken = FBSDKAccessToken.current(), FBSDKAccessToken.currentAccessTokenIsActive() {
                        AuthorizationManager.shared.addFacebook(accessToken.userID)
                    }
                    
                })
            }
            if AuthorizationManager.shared.id == ""
            {
                AuthorizationManager.shared.add = true
                GIDSignIn.sharedInstance()?.uiDelegate = self
                GIDSignIn.sharedInstance().signIn()
            }
            
        }
        
        
    }
    
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        AuthorizationManager.shared.userUuid = ""
        let loginManager = LoginManager()
        loginManager.logOut()
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        AuthorizationManager.shared.facebookId = ""
        AuthorizationManager.shared.sync = false
        let cookies = HTTPCookieStorage.shared
        var facebookCookies = cookies.cookies(for: URL(string: "http://login.facebook.com")!)
        for cookie in facebookCookies! {
            cookies.deleteCookie(cookie )
        }
        facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
        for cookie in facebookCookies! {
            cookies.deleteCookie(cookie )
        }        
        
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        GIDSignIn.sharedInstance().signOut()
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        AuthorizationManager.shared.id = ""
        navigationController?.popViewController(animated: true)
    }
    
    func addViewControllerDidCancel(_ controller: AddViewController) {
        navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addViewController(_ controller: AddViewController, didFinishAdding task: TaskModel) {
        task.id = 0
        incId()
        FirebaseManager.shared.addTask(task)
        navigationController?.popViewController(animated: true)
        
    }
    
    func addViewController(_ controller: AddViewController, didFinishEditing task: TaskModel) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let date = formatter.string(from: Date())
        FirebaseManager.shared.editTask(task, editItem: ["text":task.text])
        FirebaseManager.shared.editTask(task, editItem: ["date":date])
        navigationController?.popViewController(animated:true)
    }
    

    override func prepare(for segue: UIStoryboardSegue,sender: Any?) {

        if segue.identifier == "AddTask" {
            let controller = segue.destination as! AddViewController
            controller.delegate = self
        } else if segue.identifier == "EditTask" {
            let controller = segue.destination as? AddViewController
            controller?.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                if indexPath.section == 0 {
                    controller?.taskToEdit = uncheckedGroup[indexPath.row]
                } else {
                    controller?.taskToEdit = checkedGroup[indexPath.row]
                }
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return uncheckedGroup.count
        } else if section == 1 {
            return checkedGroup.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView,titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Unfinished"
        } else {
            return "Complete"
        }
    }
  
    override func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task",for: indexPath) as! TaskCell
        
        if indexPath.section == 0 {
            let item = uncheckedGroup[indexPath.row]
            cell.taskLabel.text = item.text
            cell.taskLabel.textColor = .black
            cell.checkImage.image = #imageLiteral(resourceName: "Uncheck")
        } else {
            let item = checkedGroup[indexPath.row]
            cell.checkImage.image = #imageLiteral(resourceName: "Check")
            cell.taskLabel.text = item.text
            cell.taskLabel.textColor = .lightGray
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let task = uncheckedGroup[indexPath.row]
            incChId()
            task.Check()
            FirebaseManager.shared.editTask(task, editItem: ["id":0])
            FirebaseManager.shared.editTask(task, editItem: ["checked":true])
            uncheckedGroup.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        } else {
            let task = checkedGroup[indexPath.row]
            incId()
            task.Check()
            FirebaseManager.shared.editTask(task, editItem: ["id":0])
            FirebaseManager.shared.editTask(task,editItem: ["checked":false] )
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            let date = formatter.string(from: Date())
            FirebaseManager.shared.editTask(task,editItem: ["date":date] )
            checkedGroup.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            
            self.performSegue(withIdentifier: "EditTask", sender: tableView.cellForRow(at: indexPath))
            
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            if indexPath.section == 0 {
                let task = self.uncheckedGroup[indexPath.row]
                FirebaseManager.shared.deleteTask(task)
                FirebaseManager.shared.ref.child(task.uuid!.uuidString).removeValue()
                self.uncheckedGroup.remove(at: indexPath.row)
            } else {
                let task = self.checkedGroup[indexPath.row]
                FirebaseManager.shared.deleteTask(task)
                FirebaseManager.shared.ref.child(task.uuid!.uuidString).removeValue()
                self.checkedGroup.remove(at: indexPath.row)
            }
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        })
        
        return [deleteAction,editAction]
    }
    
    
    
}
