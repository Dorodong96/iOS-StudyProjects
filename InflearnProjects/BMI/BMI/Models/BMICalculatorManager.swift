//
//  BMICalculatorManager.swift
//  BMI
//
//  Created by DongKyu Kim on 2023/02/02.
//

import UIKit

struct BMICalculatorManager {
    
    private var bmi: BMI?
    
    func getBMIResult() -> BMI? {
        return bmi
    }
    
    mutating func calculateBMI(height: String, weight: String) {
        
        guard let h = Double(height), let w = Double(weight) else { return }
        var bmiNumber = w / (h * h) * 10000
        bmiNumber = round(bmiNumber * 10) / 10
        
        switch bmiNumber {
        case ..<18.6:
            self.bmi = BMI(value: bmiNumber, matchColor: .magenta, advice: "저체중")
        case 18.6..<23.0:
            self.bmi = BMI(value: bmiNumber, matchColor: .green, advice: "표준")
        case 23.0..<25.0:
            self.bmi = BMI(value: bmiNumber, matchColor: .yellow, advice: "과체중")
        case 25.0..<30.0:
            self.bmi = BMI(value: bmiNumber, matchColor: .orange, advice: "중도비만")
        case 30.0...:
            self.bmi = BMI(value: bmiNumber, matchColor: .red, advice: "고도비만")
        default:
            self.bmi = BMI(value: bmiNumber, matchColor: .white, advice: "저체중")
        }
    }
}
