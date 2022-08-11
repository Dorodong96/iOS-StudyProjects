//
//  ViewController.swift
//  Challange3
//
//  Created by DongKyu Kim on 2022/08/04.
//

import UIKit

class ViewController: UIViewController {
    
    var questionLabel: UILabel!
    var countLabel: UILabel!
    var stateLabel: UILabel!
    var buttonsView: UIView!
    var alphabetButtons: [UIButton] = []
    
    var question = "HELLO"
    var usedLetters: [String] = []
    var promptWord = "" {
        didSet {
            questionLabel?.text = promptWord
        }
    }
    let alphabetArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var arrayIndex = 0
    
    var count = 7 {
        didSet {
            countLabel.text = "Left Count: \(count)"
        }
    }
    
    let boxWidth = 70
    let boxHeight = 70
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        makeLabelWord()
        
        questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.textAlignment = .center
        questionLabel.font = UIFont.systemFont(ofSize: 50)
        questionLabel.text = promptWord
        view.addSubview(questionLabel)
        
        countLabel = UILabel()
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.textAlignment = .center
        countLabel.font = UIFont.systemFont(ofSize: 30)
        countLabel.text = "Left Count: 7"
        view.addSubview(countLabel)
        
        stateLabel = UILabel()
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.textAlignment = .center
        stateLabel.font = UIFont.boldSystemFont(ofSize: 40)
        stateLabel.text = "HANGMAN!"
        view.addSubview(stateLabel)
        
        let make = UIButton(type: .system)
        make.translatesAutoresizingMaskIntoConstraints = false
        make.setTitle("Make Quiz", for: .normal)
        make.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        make.addTarget(self, action: #selector(makeTapped), for: .touchUpInside)
        view.addSubview(make)
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            questionLabel.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor, constant: -200),
            questionLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            countLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            countLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            
            stateLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 80),
            stateLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            make.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            make.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: CGFloat(boxWidth)*4.0),
            buttonsView.heightAnchor.constraint(equalToConstant: CGFloat(boxHeight)*4.0),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -530),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
        ])
        
        setButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func makeLabelWord() {
        promptWord = ""
        for letter in question {
            let strLetter = String(letter)
            if usedLetters.contains(strLetter) {
                promptWord += strLetter
            } else {
                promptWord += "?"
            }
        }
    }
    
    func checkComplete() {
        if promptWord == question {
            if count > 1 {
                stateLabel.text = "Congratulations!"
            }
        } else {
            if count <= 1 {
                stateLabel.text = "Game Over!"
            }
        }
    }
    
    func setButtons() {
        for row in 0..<7 {
            for column in 0..<4 {
                if arrayIndex < 26 {
                    let alphabetButton = UIButton(type: .system)
                    alphabetButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                    alphabetButton.setTitle(alphabetArray[arrayIndex], for: .normal)
                    alphabetButton.addTarget(self, action: #selector(alphabetTapped), for: .touchUpInside)
                    alphabetButton.layer.borderWidth = 1
                    alphabetButton.layer.borderColor = UIColor.lightGray.cgColor
                    let frame = CGRect(x: column * boxWidth, y: row * boxHeight, width: boxWidth, height: boxHeight)
                    alphabetButton.frame = frame
                    alphabetButton.isEnabled = true
                    
                    arrayIndex += 1
                    buttonsView.addSubview(alphabetButton)
                    alphabetButtons.append(alphabetButton)
                }
            }
        }
    }
    
    @objc func alphabetTapped(_ sender: UIButton) {
        guard let tappedAlphabet = sender.titleLabel?.text else {
            return
        }
        usedLetters.append(tappedAlphabet)
        sender.backgroundColor = UIColor.systemGray5
        sender.isEnabled = false
        makeLabelWord()
        checkComplete()
        count -= 1
    }
    
    @objc func makeTapped(_ sender: UIButton) {
        let ac = UIAlertController(title: "Make New Question", message: "Write a word", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.question = ac.textFields?[0].text ?? ""
            self.usedLetters = []
            self.makeLabelWord()
            self.count = 7
            self.setButtons()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
}

