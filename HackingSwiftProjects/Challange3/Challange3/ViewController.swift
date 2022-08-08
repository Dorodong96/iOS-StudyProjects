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
    var alphabetButtons: [UIButton] = []
    
    let question = "HELLO"
    var usedLetters: [String] = []
    var promptWord = ""
    
    var count = 7 {
        didSet {
            countLabel.text = "Left Count: \(count)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

