//
//  TableViewController.swift
//  ToDoList
//
//  Created by Trainee on 3/11/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import Firebase


class TableViewController: UITableViewController, AddViewControllerDelegate {
    
    var lastEditIndexSection = -1
    var lastEditIndexRow = -1
     let ref = Database.database().reference(withPath:"task")
    
    @IBAction func logOut(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    func addViewControllerDidCancel(_ controller: AddViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addViewController(_ controller: AddViewController, didFinishAdding task: TaskModel) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        let taskRef = self.ref.child(formatter.string(from: task.date))
        taskRef.setValue(task.toDic())

        
        //        let newRowIndex = uncheckedGroup.count
        //        uncheckedGroup.append(task)
        //        let indexPath = IndexPath(row: newRowIndex, section: 0)
        //        let indexPaths = [indexPath]
        //        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func addViewController(_ controller: AddViewController, didFinishEditing task: TaskModel) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        task.ref?.updateChildValues(["text":task.text])
        let date = formatter.string(from: Date())
        task.ref?.updateChildValues(["date":date])
        navigationController?.popViewController(animated:true)
    }
    
    /*func addViewControllerDidCancel(_ controller: AddViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func addItemViewController(_ controller: AddViewController, didFinishEditing task: TaskModel) {
        
    }*/
    
   
    
    
  
    
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
        
        
        
        ref.queryOrdered(byChild: "date").observe(.value, with : {
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
    
    override func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
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
    
    /*@IBAction func Add()
    {
        let newRowIndex = uncheckedGroup.count
        
        let item = TaskModel()
        item.text = "I am a new row"
        uncheckedGroup.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func AddTaskToCheck(_ task: TaskModel)
    {
        let newRowIndex = checkedGroup.count
        checkedGroup.append(task)
        let indexPath = IndexPath(row: newRowIndex, section: 1)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    func AddTaskToUncheck(_ task: TaskModel)
    {
        let newRowIndex = uncheckedGroup.count
        uncheckedGroup.append(task)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }*/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let task = uncheckedGroup[indexPath.row]
            task.Check()
            let que = DispatchQueue.global()
            que.async {
                task.ref?.updateChildValues(["checked":true])
            }
            
            uncheckedGroup.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        } else {
            let task = checkedGroup[indexPath.row]
            task.Check()
            let que = DispatchQueue.global()
            que.async {
                task.ref?.updateChildValues(["checked":false])
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .medium
                let date = formatter.string(from: Date())
                task.ref?.updateChildValues(["date":date])
            }
            checkedGroup.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }
    
    override func tableView( _ tableView: UITableView,commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let task = uncheckedGroup[indexPath.row]
            let que = DispatchQueue.global()
            que.async {
            task.ref?.removeValue()
            }
            uncheckedGroup.remove(at: indexPath.row)
        } else {
            let task = checkedGroup[indexPath.row]
            let que = DispatchQueue.global()
            que.async {
            task.ref?.removeValue()
            }
            checkedGroup.remove(at: indexPath.row)
        }
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

}
