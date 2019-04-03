//
//  NotificationManager.swift
//  ToDoList
//
//  Created by Trainee on 4/3/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func addNotification(_ task: TaskModel) {
        NotificationManager.shared.removeNotification(task)
        if let n = task.notificationDate, n > Date() {
            let content = UNMutableNotificationContent()
            content.title = "To Do List:"
            content.body = task.text
            content.sound = UNNotificationSound.default
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month,.day,.hour,.minute], from: n)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: task.uuid!.uuidString, content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
        }
    }
    
    func removeNotification(_ task: TaskModel) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [task.uuid!.uuidString])
    }
    
    func removeAllNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }
}
