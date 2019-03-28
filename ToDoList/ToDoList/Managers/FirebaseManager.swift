//
//  FirebaseManager.swift
//  ToDoList
//
//  Created by Trainee on 3/11/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    let MainRef = Database.database().reference()
    var ref = Database.database().reference(withPath: "users").child(getCurrentID())
    static let shared = FirebaseManager()
    public func editTask(_ task: TaskModel, editItem:[String: Any]) {
        let que = DispatchQueue.global()
        que.async {
            self.ref.child("tasks").child(task.uuid!.uuidString).updateChildValues(editItem)
        }
    }
    public func deleteTask(_ task: TaskModel) {
        let que = DispatchQueue.global()
        que.async {
            self.ref.child("tasks").child(task.uuid!.uuidString).removeValue()
        }
    }
    
    public func addTask(_ task: TaskModel)
    {
        let que = DispatchQueue.global()
        que.async {
            let taskRef = self.ref.child("tasks").child(task.uuid!.uuidString)
            taskRef.setValue(task.toDic())
        }
    }
    
    static func getCurrentID() ->String
    {
        if AuthorizationManager.shared.id == "" {
            return "Facebook:" + AuthorizationManager.shared.facebookId
        } else {
            return "Google:" + AuthorizationManager.shared.id
        }
    }
  
    
}
