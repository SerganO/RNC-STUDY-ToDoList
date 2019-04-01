//
//  CellModel.swift
//  ToDoList
//
//  Created by Trainee on 3/11/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import Firebase

class TaskModel
{
    var text = ""
    var date = Date()
    var notificationDate = Date()
    var checked = false
    var id = -1
    var shouldRemind = false
    let uuid: UUID?
    
    
    func Check(){
        checked = !checked
    }
    
    init(text: String, date: Date){
        self.text = text
        notificationDate = Date()
        self.date = date
        checked = false
        shouldRemind = false
        uuid = UUID()
    }
    
    init(text: String, notificationDate: Date){
        self.text = text
        self.notificationDate = notificationDate
        self.date = Date()
        checked = false
        shouldRemind = false
        uuid = UUID()
    }
    
    init(){
        text = ""
        notificationDate = Date()
        date = Date()
        checked = false
        uuid = UUID()
        shouldRemind = false
    }
    
    
    init?(snapshot: DataSnapshot)
    {
        guard
        let value = snapshot.value as? [String:AnyObject],
        let text = value["text"] as? String,
        let date = value["date"] as? String,
        let notificationDate = value["notificationDate"] as? String,
        let checked = value["checked"] as? Bool,
        let shouldRemind = value["shouldRemind"] as? Bool,
        let uuid = value["uuid"] as? String,
        let id = value["id"] as? Int
        else {
            return nil
        }
        let formatter = DateFormatter()
        self.text = text
        self.checked = checked
        self.notificationDate = formatter.date(from: notificationDate) ?? Date()
        self.date = formatter.date(from: date) ?? Date()
        self.uuid = UUID(uuidString: uuid)
        self.id = id
        self.shouldRemind = shouldRemind
    }
    
    func toDic() -> [String: Any] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        return [
            "text": text,
            "date": formatter.string(from: date),
            "notificationDate": formatter.string(from: notificationDate),
            "checked": checked,
            "shouldRemind": shouldRemind,
            "uuid": uuid!.uuidString,
            "id": id
        ]
    }
}


