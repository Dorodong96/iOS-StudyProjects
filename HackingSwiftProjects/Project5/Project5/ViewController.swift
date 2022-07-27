//
//  ViewController.swift
//  Project5
//
//  Created by DongKyu Kim on 2022/07/19.
//

import UIKit

class ViewController: UITableViewController {
    var allWords: [String] = []
    var usedWords: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        // count보다 빠르당
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        // 내용을 제거해도 capacity 유지
        usedWords.removeAll(keepingCapacity: true)
        // capacity가 유지된 채로 tavleView가 load
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            // closure input
            // viewController, AlertController
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(lowerAnswer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    // with -> 애니메이션
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return // 메소드 탈출
                } else {
                    showErrorMessage(title: "Word not recogized", message: "You can't just make them up, you know?")
                }
            } else {
                showErrorMessage(title: "Word already used", message: "Be more original")
            }
        } else {
            guard let title = title else { return }
            showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(title.lowercased())")
        }
    }
    
    
    func isPossible(word: String) -> Bool {
        // 가능한 단어라면 추가 (제시된 단어에서 나올 수 있는 단어)
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    
    func isOriginal(word: String) -> Bool {
        // 단어 중복 체크하기
        if usedWords.contains(word) {
            return false
        } else if word == title {
            return false
        }
        return !usedWords.contains(word)
    }
    
    
    func isReal(word: String) -> Bool {
        // 문법에 맞는 단어인지 (실제로 존제하는 단어인지 체크)
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        if range.length < 3 {
            return false
        }
        return misspelledRange.location == NSNotFound
    }
    
    func showErrorMessage(title errorTitle: String, message errorMessage: String){
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

