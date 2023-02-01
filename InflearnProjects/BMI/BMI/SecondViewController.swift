//
//  SecondViewController.swift
//  BMI
//
//  Created by DongKyu Kim on 2023/02/02.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var bmiNumberLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var bmi: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.makeUI()
    }

    private func makeUI() {
        bmiNumberLabel.clipsToBounds = true
        bmiNumberLabel.layer.cornerRadius = 8
        bmiNumberLabel.backgroundColor = .gray
        
        backButton.clipsToBounds = true
        backButton.layer.cornerRadius = 5
        
        guard let bmi = bmi else { return }
        bmiNumberLabel.text = String(bmi)
        (bmiNumberLabel.backgroundColor, adviceLabel.text) = getBMIInfo(bmi: bmi)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private func getBMIInfo(bmi: Double) -> (UIColor, String) {
        switch bmi {
        case ..<18.6:
            return (UIColor.magenta, "저체중")
        case 18.6..<23.0:
            return (UIColor.green, "표준")
        case 23.0..<25.0:
            return (UIColor.yellow, "과체중")
        case 25.0..<30.0:
            return (UIColor.orange, "증도비만")
        case 30.0...:
            return (UIColor.red, "고도비만")
        default:
            return (UIColor.black, "")
        }
    }
}
