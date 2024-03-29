//
//  ViewController.swift
//  Project21
//
//  Created by DongKyu Kim on 2022/09/10.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    var delayFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    @objc func registerLocal() {
        // 사용자 permission request - 사용자 선택에 따라 다른 결과
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("Oh...K")
            }
        }
        
        center.removeAllPendingNotificationRequests()
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        var timeInterval = 5.0
        
        if delayFlag {
           timeInterval = 86400
        }
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse get the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // userInfo dictionary 내용 가져오기
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            print("Action Identifier: \(response.actionIdentifier.description)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                showAlert()
                print("Default identifier") // 사용자가 unlock 한 경우
                
            case "show":
                showAlert()
                print("Show more Information") // show more information
            
            case "delay":
                showAlert()
                delayFlag = true
                scheduleLocal()
                
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let delay = UNNotificationAction(identifier: "delay", title: "Remind me later", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [delay, show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func showAlert() {
        let ac = UIAlertController(title: "Done", message: "Your Choice was perfect", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

