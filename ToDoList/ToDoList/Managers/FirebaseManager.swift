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
    let ref = Database.database().reference(withPath: "users").child(AuthorizationManager.shared.id)
    //let ref = Database.database().reference(withPath: "users").child("FakeUserId")
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
    
}
