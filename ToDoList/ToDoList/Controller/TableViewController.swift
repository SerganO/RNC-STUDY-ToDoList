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

class TableViewController: UITableViewController, AddViewControllerDelegate {
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        AuthorizationManager.shared.id = ""
        navigationController?.popViewController(animated: true)
    }
    
    var lastEditIndexSection = -1
    var lastEditIndexRow = -1
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
                    lastEditIndexSection = 0
                    lastEditIndexRow = indexPath.row
                } else {
                    controller?.taskToEdit = checkedGroup[indexPath.row]
                    lastEditIndexSection = 1
                    lastEditIndexRow = indexPath.row
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
  
        if(AuthorizationManager.shared.id == "")
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
    
    var checkedGroup = [TaskModel]();
    var uncheckedGroup = [TaskModel]();
    
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
//            let que = DispatchQueue.global()
//            que.async {
//                self.ref.child(task.uuid!.uuidString).updateChildValues(["checked":true])
//                //task.ref?.updateChildValues(["checked":true])
//            }
//
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
//                self.ref.child(task.uuid!.uuidString).updateChildValues(["checked":false])
//               // task.ref?.updateChildValues(["checked":false])
//                let formatter = DateFormatter()
//                formatter.dateStyle = .medium
//                formatter.timeStyle = .medium
//                let date = formatter.string(from: Date())
//                self.ref.child(task.uuid!.uuidString).updateChildValues(["date":date])
//                //task.ref?.updateChildValues(["date":date])
            
            checkedGroup.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }
    
    override func tableView( _ tableView: UITableView,commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {//DELETE
        if indexPath.section == 0 {
            let task = uncheckedGroup[indexPath.row]
            FirebaseManager.shared.deleteTask(task)
            FirebaseManager.shared.ref.child(task.uuid!.uuidString).removeValue()
//            let que = DispatchQueue.global()
//            que.async {
//                self.ref.child(task.uuid!.uuidString).removeValue()
//                //task.ref?.removeValue()
//            }
            uncheckedGroup.remove(at: indexPath.row)
        } else {
            let task = checkedGroup[indexPath.row]
            FirebaseManager.shared.deleteTask(task)
            FirebaseManager.shared.ref.child(task.uuid!.uuidString).removeValue()
//            let que = DispatchQueue.global()
//            que.async {
//                self.ref.child(task.uuid!.uuidString).removeValue()
//                //task.ref?.removeValue()
//            }
            checkedGroup.remove(at: indexPath.row)
        }
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

}
