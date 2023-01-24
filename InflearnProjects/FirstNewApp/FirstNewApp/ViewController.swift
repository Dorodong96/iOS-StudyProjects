//
//  ViewController.swift
//  FirstNewApp
//
//  Created by DongKyu Kim on 2023/01/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    weak var timer: Timer?
    
    var number: Int = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        mainLabel.text = "초를 선택하세요"
        
        slider.minimumValue = 0.0
        slider.maximumValue = 60.0

        slider.setValue(30.0, animated: true)
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
        number = Int(sender.value)
        mainLabel.text = "\(number)초"
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] _ in
            
            if number > 1 {
                number -= 1
                mainLabel.text = "\(number)초"
            } else {
                number = 0
                mainLabel.text = "시간 종료!"
                timer?.invalidate()
                
                AudioServicesPlayAlertSound(SystemSoundID(1322))
            }
            
            slider.setValue(Float(number), animated: true)
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        slider.setValue(30.0, animated: false)
        mainLabel.text = "초를 선택하세요"
    }
    
}

