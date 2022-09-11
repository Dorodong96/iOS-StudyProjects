//
//  ViewController.swift
//  Project2
//
//  Created by DongKyu Kim on 2022/07/14.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var counter = 0
    
    override func viewDidAppear(_ animated: Bool) {
        scheduleLocal()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
        // related Notification methods
        registerLocal()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        // button을 normal한 상태로 표현
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased() + "   Score: \(score)"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var alertMessage = ""
        let selectedFlag = countries[sender.tag].uppercased()
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That's the flag of \(selectedFlag)"
            score -= 1
        }
        counter += 1
        
        if counter == 10 {
            title = "Game End!"
            alertMessage = "Your Final score is \(score)"
        } else {
            alertMessage = "Your score is \(score) Game: \(counter)/10"
        }
        // 팝업 형식의 UI AlertController 정의
        let ac = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
        
        // 위에서 선언한 AlertComtroller에 Action 추가 (하단 버튼)
        // handler -> 수행할 behavior (해당 버튼이 눌렸을 때)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        // viewController를 띄움 (여기서는 UIAclertController)
        present(ac, animated: true)
        
        
        if counter == 10 {
            score = 0
            counter = 0
        }
    }
    
}

// MARK: extension and related methods for Notification Center
extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom Data received \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default identifier")
            
            case "show":
                print("User pressed Show button")
            
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, Error) in
            if granted {
                print("Thanks for permission!")
                //self.scheduleLocal()
            } else {
                print("OHKAY!")
            }
        }
        
        center.removeAllPendingNotificationRequests()
    }
    
    func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "It's time to game!"
        content.body = "Your game's best score is waiting to be updated!"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 0
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Got ya!", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
}

