//
//  ViewWithTableViewController.swift
//  ToDoList
//
//  Created by Trainee on 4/17/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import FacebookLogin
import MaterialComponents

class ViewWithTableViewController: UIViewController, AddViewControllerDelegate, GIDSignInUIDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let buttonColorSheme = MDCBasicColorScheme.init(primaryColor: UIColor.white, primaryLightColor: UIColor.white, primaryDarkColor: UIColor.white, secondaryColor: UIColor.white, secondaryLightColor: UIColor.white, secondaryDarkColor: UIColor.white)
   
    let buttonScheme = MDCButtonScheme()
    
    var firstStart = true
    
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
    //03DAC6 main
    //26A69A nav
    //E0F2F1 back
    //let schema = MDCBasicColorScheme.init(primaryColor: UIColor(red: 0x26/255, green: 0xA6/255, blue: 0x9A/255, alpha: 1), secondaryColor: UIColor.white)
    
    /*let schema = MDCBasicColorScheme.init(primaryColor: UIColor(red: 0x26/255, green: 0xA6/255, blue: 0x9A/255, alpha: 1), primaryLightColor: UIColor.white, primaryDarkColor: UIColor.white, secondaryColor: UIColor.white, secondaryLightColor: UIColor.white, secondaryDarkColor: UIColor.white)*/
    
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
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationItem.titleView?.tintColor = UIColor.white
        navigationItem.titleView?.tintColor = UIColor.white
        
    }
    
    
    
    
     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
    
     func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.setEditing(false, animated: true)
        
        if(AuthorizationManager.shared.id == "" && AuthorizationManager.shared.facebookId == "") {
            let alert = UIAlertController(title: "Error Auth", message: "Please Sign In", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:{
                action in
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true)
            return
        }
        
        
        let reorderButton = MaterialButton(frame: .zero)
        reorderButton.setImage(UIImage(named:"Reorder"), for: .normal)
        reorderButton.addTarget(self, action: #selector(reorder), for: .touchUpInside)
        reorderButton.backgroundColor = UIColor(red: 0x26/255, green: 0xA6/255, blue: 0x9A/255, alpha: 1)
        reorderButton.maximumSize = CGSize(width: 50, height: 50)
        
        let reorderItem = UIBarButtonItem(customView: reorderButton)
        navigationItem.rightBarButtonItem = reorderItem
        
        
        let syncButton = MaterialButton(frame: .zero)
        if AuthorizationManager.shared.sync {
            syncButton.setImage(UIImage(named:"AllDone"), for: .normal)
        } else if AuthorizationManager.shared.facebookId == "" {
            syncButton.setImage(UIImage(named:"Facebook"), for: .normal)
            syncButton.addTarget(self, action: #selector(addAccount), for: .touchUpInside)
        } else {
            syncButton.setImage(UIImage(named:"GoogleIcon"), for: .normal)
            syncButton.addTarget(self, action: #selector(addAccount), for: .touchUpInside)
        }
        syncButton.imageEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        syncButton.imageView?.contentMode = .scaleAspectFit
        //syncButton.translatesAutoresizingMaskIntoConstraints = false
        syncButton.backgroundColor = UIColor(red: 0x26/255, green: 0xA6/255, blue: 0x9A/255, alpha: 1)
        syncButton.maximumSize = CGSize(width: 50, height: 50)
      
        let syncItem = UIBarButtonItem(customView: syncButton)
        navigationItem.rightBarButtonItems?.append(syncItem)
        
        
        
        
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
            
            if self.firstStart {
                NotificationManager.shared.sync(self.uncheckedGroup)
                self.firstStart = false
            }
        })
        updateId()
        
        let AddButton = MDCFloatingButton(frame: .zero)
        
        AddButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        AddButton.backgroundColor = UIColor(red: 0x26/255, green: 0xA6/255, blue: 0x9A, alpha: 1)
        AddButton.imageView?.tintColor = UIColor.white
        AddButton.tintColor = UIColor.white
        let origImage = UIImage(named: "Add");
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        AddButton.setImage(tintedImage, for: .normal)
        AddButton.imageView?.tintColor = UIColor.white
        AddButton.tintColor = UIColor.white
        MDCFloatingActionButtonThemer.applyScheme(buttonScheme, to: AddButton)
        view.addSubview(AddButton)
        AddButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            AddButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
            AddButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        } else {
            AddButton.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
            AddButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20).isActive = true
        }
        
    }
    
    @objc func reorder() {
        if tableView.isEditing {
            updateId()
        }
        tableView.isEditing = !tableView.isEditing
    }
    
    @objc func addTask() {
        performSegue(withIdentifier: "AddTask", sender: self)
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
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.showsReorderControl = false
        return true
    }
    
     func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
     func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
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
        
        
        
        
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationItem.titleView?.tintColor = UIColor.white
        navigationItem.titleView?.tintColor = UIColor.white
        
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
        NotificationManager.shared.removeAllNotification()
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
        NotificationManager.shared.addNotification(task)
        navigationController?.popViewController(animated: true)
        
    }
    
    func addViewController(_ controller: AddViewController, didFinishEditing task: TaskModel) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let date = formatter.string(from: Date())
        var notDate = ""
        if let nD = task.notificationDate {
            notDate = formatter.string(from: nD)
        }
        FirebaseManager.shared.editTask(task, editItem: ["text":task.text])
        FirebaseManager.shared.editTask(task, editItem: ["notificationDate":notDate])
        FirebaseManager.shared.editTask(task, editItem: ["date":date])
        NotificationManager.shared.addNotification(task)
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
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return uncheckedGroup.count
        } else if section == 1 {
            return checkedGroup.count
        }
        return 0
    }
    
     func tableView(_ tableView: UITableView,titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Unfinished"
        } else {
            return "Complete"
        }
    }
    
     func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task",for: indexPath) as! TaskCell
        
        if indexPath.section == 0 {
            let item = uncheckedGroup[indexPath.row]
            cell.taskLabel.text = item.text
            cell.taskLabel.textColor = .black
            cell.checkImage.image = #imageLiteral(resourceName: "Uncheck")
            cell.checkImage.tintColor = UIColor.black
        } else {
            let item = checkedGroup[indexPath.row]
            cell.checkImage.image = #imageLiteral(resourceName: "Check")
            cell.taskLabel.text = item.text
            cell.taskLabel.textColor = .lightGray
            cell.checkImage.tintColor = UIColor.black
        }
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let task = uncheckedGroup[indexPath.row]
            incChId()
            task.Check()
            FirebaseManager.shared.editTask(task, editItem: ["id":0])
            FirebaseManager.shared.editTask(task, editItem: ["checked":true])
            NotificationManager.shared.removeNotification(task)
            uncheckedGroup.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        } else {
            let task = checkedGroup[indexPath.row]
            incId()
            task.Check()
            FirebaseManager.shared.editTask(task, editItem: ["id":0])
            FirebaseManager.shared.editTask(task,editItem: ["checked":false] )
            NotificationManager.shared.addNotification(task)
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
    
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?  {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
            
            self.performSegue(withIdentifier: "EditTask", sender: tableView.cellForRow(at: indexPath))
            
        })
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            if indexPath.section == 0 {
                let task = self.uncheckedGroup[indexPath.row]
                FirebaseManager.shared.deleteTask(task)
                FirebaseManager.shared.ref.child(task.uuid!.uuidString).removeValue()
                self.uncheckedGroup.remove(at: indexPath.row)
                NotificationManager.shared.removeNotification(task)
            } else {
                let task = self.checkedGroup[indexPath.row]
                FirebaseManager.shared.deleteTask(task)
                FirebaseManager.shared.ref.child(task.uuid!.uuidString).removeValue()
                self.checkedGroup.remove(at: indexPath.row)
                NotificationManager.shared.removeNotification(task)
            }
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        })
        
        return [deleteAction,editAction]
    }
    
    

}
