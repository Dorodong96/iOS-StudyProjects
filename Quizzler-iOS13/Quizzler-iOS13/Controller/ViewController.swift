//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Angela Yu on 12/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var questionOneButton: UIButton!
    @IBOutlet weak var questionTwoButton: UIButton!
    @IBOutlet weak var questionThreeButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var quizBrain = QuizBrain()
    var answerText: [String?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        
        let userAnswer = sender.currentTitle!
        let userGotItRight = quizBrain.checkAnswer(userAnswer)
        
        if userGotItRight {
            sender.backgroundColor = UIColor.green
        } else {
            sender.backgroundColor = UIColor.red
        }
        
        quizBrain.nextQuestion()
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
        
    }
    
    @objc func updateUI() {
        answerText = quizBrain.getAnswerText()
        questionLabel.text = quizBrain.getQustionText()
        progressBar.progress = quizBrain.getProgress()
        scoreLabel.text = "Score: \(quizBrain.getScore())"
        
        questionOneButton.setTitle(answerText[0], for: .normal)
        questionTwoButton.setTitle(answerText[1], for: .normal)
        questionThreeButton.setTitle(answerText[2], for: .normal)
        
        questionOneButton.backgroundColor = UIColor.clear
        questionTwoButton.backgroundColor = UIColor.clear
        questionThreeButton.backgroundColor = UIColor.clear
    }

}

