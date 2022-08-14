//
//  ViewController.swift
//  Project2
//
//  Created by DongKyu Kim on 2022/07/14.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var counter = 0
    
    var alertTitle = ""
    var alertMessage = ""
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "highScore") as? Data{
            let jsonDecoder = JSONDecoder()
            
            do {
                highScore = try jsonDecoder.decode(Int.self, from: savedData)
            } catch {
                print("Failed to load high score")
            }
        }
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let selectedFlag = countries[sender.tag].uppercased()
        
        if sender.tag == correctAnswer {
            alertTitle = "Correct"
            score += 1
        } else {
            alertTitle = "Wrong! That's the flag of \(selectedFlag)"
            score -= 1
        }
        counter += 1
        
        if counter == 10 {
            // check high score and update
            if highScore < score {
                highScore = score
                
                // save high score to UserDefaults
                saveHighScore()
                
                // show high score alert
                let ac = UIAlertController(title: "Congratulations!", message: "You got new highest score!", preferredStyle: .alert)
                
                ac.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    ac.dismiss(animated: true)
                    self.showContinueAlert()
                })
                present(ac, animated: true)
            }
            
            alertTitle = "Game End!"
            alertMessage = "Your Final score is \(score)"
            score = 0
            counter = 0
        } else {
            alertMessage = "Your score is \(score) Game: \(counter)/10"
        }
        
        showContinueAlert()
    }

    func showContinueAlert() {
        // 팝업 형식의 UI AlertController 정의
        let ac = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        // 위에서 선언한 AlertComtroller에 Action 추가 (하단 버튼)
        // handler -> 수행할 behavior (해당 버튼이 눌렸을 때)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        // viewController를 띄움 (여기서는 UIAclertController)
        present(ac, animated: true)
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        // button을 normal한 상태로 표현
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased() + "   Score: \(score)   High Score: \(highScore)"
    }
    
    func saveHighScore() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(highScore) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "highScore")
        } else {
            print("Failed to save high score")
        }
    }
}

