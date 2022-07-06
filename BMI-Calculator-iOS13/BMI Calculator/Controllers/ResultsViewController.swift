//
//  ResultsViewController.swift
//  BMI Calculator
//
//  Created by DongKyu Kim on 2022/06/30.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    var bmiValue: String?
    var advice: String?
    var color: UIColor?
    
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bmiLabel.text = bmiValue
        adviceLabel.text = advice
        // 기본적으로 view 라는 거에 프로퍼티를 가지고 있음
        view.backgroundColor = color
    }
    
    @IBAction func recalculatePress(_ sender: Any) {
        // 원래의 View로 돌아가기
        // 현재의 View Controller를 비활성화
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
