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


class TableViewController: UITableViewController, AddViewControllerDelegate {

    
    
    var checkedGroup = [TaskModel]();
    var uncheckedGroup = [TaskModel]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
        
        
        
        FirebaseManager.shared.ref.child("tasks").queryOrdered(byChild: "date").observe(.value, with : {
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
            self.uncheckedGroup.reverse()
            self.checkedGroup.reverse()
            self.tableView.reloadData()
        })
        
        
        
        
        
        
    }
    
    
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        let loginManager = LoginManager()
        loginManager.logOut()
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task",for: indexPath)
        
        if indexPath.section == 0 {
            let item = uncheckedGroup[indexPath.row]
            let label = cell.viewWithTag(1000) as! UILabel
            let checkBox = cell.viewWithTag(999) as! UIImageView
            label.text = item.text
            label.textColor = .black
            checkBox.image = #imageLiteral(resourceName: "Uncheck")
         } else {
            let item = checkedGroup[indexPath.row]
            let label = cell.viewWithTag(1000) as! UILabel
            let checkBox = cell.viewWithTag(999) as! UIImageView
            checkBox.image = #imageLiteral(resourceName: "Check")
            label.text = item.text
            label.textColor = .lightGray
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let task = uncheckedGroup[indexPath.row]
            task.Check()
            FirebaseManager.shared.editTask(task, editItem: ["checked":true])
            uncheckedGroup.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        } else {
            let task = checkedGroup[indexPath.row]
            task.Check()
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
