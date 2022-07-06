//
//  CalculatorBrain.swift
//  BMI Calculator
//
//  Created by DongKyu Kim on 2022/06/30.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit

struct CalculatorBrain {
    var bmi: BMI?
    
    mutating func calculateBMI(height: Float, weight: Float) {
        let bmiValue = weight / pow(height, 2)
        
        if bmiValue < 18.5 {
            bmi = BMI(value: bmiValue, advice: "Eat more chicken breast", color: .cyan)
        } else if bmiValue <= 24.9 {
            bmi = BMI(value: bmiValue, advice: "Fit as a fiddle!", color: .green)
        } else {
            bmi = BMI(value: bmiValue, advice: "Eat less pizza", color: .red)
        }
        
    }
    
    func getBMIValue() -> String {
        return String(format: "%.1f", self.bmi?.value ?? 0.0)
    }
    
    func getAdvice() -> String {
        return self.bmi?.advice ?? "No message"
    }
    
    func getColor() -> UIColor {
        return self.bmi?.color ?? .white
    }
}
