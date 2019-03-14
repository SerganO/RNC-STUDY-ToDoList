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
    var checked = false
   // let ref: DatabaseReference?
    let uuid: UUID?
    
    
    func Check(){
        checked = !checked
    }
    
    init(text: String, date: Date){
        self.text = text
        self.date = date
        checked = false
        //self.ref = nil
        uuid = UUID()
    }
    
    init(){
        self.text = ""
        self.date = Date()
        checked = false
        //self.ref = nil
        uuid = UUID()
    }
    
    
    init?(snapshot: DataSnapshot)
    {
        guard
        let value = snapshot.value as? [String:AnyObject],
        let text = value["text"] as? String,
        let date = value["date"] as? String,
        let checked = value["checked"] as? Bool,
        let uuid = value["uuid"] as? String
        else {
            return nil
        }
        let formatter = DateFormatter()
        //self.ref = snapshot.ref
        self.text = text
        self.checked = checked
        self.date = formatter.date(from: date) ?? Date()
        self.uuid = UUID(uuidString: uuid)
    }
    /*func toAnyObject() -> Any {
        return [
            "text": text,
            //"date": date,
            "checked": checked
        ]
    }*/
    
    func toDic() -> [String: Any] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        return [
            "text": text,
            "date": formatter.string(from: date),
            "checked": checked,
            "uuid": uuid!.uuidString
        ]
    }
}


