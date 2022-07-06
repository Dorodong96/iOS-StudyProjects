//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    let eggTimes = ["Soft" : 300, "Medium" : 420, "Hard" : 720]
    var counter = 0
    var fullCounter = 0
    var timer = Timer()
    var player: AVAudioPlayer?
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var timeProgress: UIProgressView!
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timeProgress.progress = 0
        counter = 0
        
        // 반복적인 타이머 호출을 막기 위해 기존의 타이머 비활성화
        timer.invalidate()
        
        let hardness = sender.currentTitle!
        fullCounter = eggTimes[hardness]!
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    // Objective-C 함수
    @objc func updateCounter() {
        //example functionality
        if counter < fullCounter {
            let percentageProgress = Float(counter) / Float(fullCounter)
            counter += 1
            
            timeProgress.progress = percentageProgress
            topLabel.text = "계란이 익어가는중이에요!"
            player?.stop()
            
        } else if counter == fullCounter {
            timeProgress.progress = 1.0
            topLabel.text = "완료!"
            playSound()
        }
    }
    
    
    // Play Sound Function
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
