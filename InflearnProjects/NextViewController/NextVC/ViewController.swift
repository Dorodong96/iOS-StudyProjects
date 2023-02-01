//
//  ViewController.swift
//  NextVC
//
//  Created by Allen H on 2021/12/05.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // 1) 코드로 화면 이동 (다음화면이 코드로 작성되어있을때만 가능한 방법)
    @IBAction func codeNextButtonTapped(_ sender: UIButton) {
        let firstVC = FirstViewController()
        firstVC.someString = "전달하려는 데이터"
        firstVC.modalPresentationStyle = .fullScreen
        present(firstVC, animated: true)
    }
    
    // 2) 코드로 스토리보드 객체를 생성해서, 화면 이동
    @IBAction func storyboardWithCodeButtonTapped(_ sender: UIButton) {

        
        
    }
    
    // secondVC.mainLabel.text = "전달하려는 데이터"
    // 이런식으로 전달하면 Runtime Error 발생
    // 코드베이스는 각 인스턴스가 컴파일타임에 메모리에 올라감
    // 스토리보드 인스턴스가 이후에 연결되기 때문에, 연결되기 전에 호출되어서 에러
    // viewDidLoad가 스토리보드가 코드와 연결됨
    
    
    // 3) 스토리보드에서의 화면 이동(간접 세그웨이)
    @IBAction func storyboardWithSegueButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toThirdVC", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toThirdVC" {
            let thirdVC = segue.destination as! ThirdViewController
            thirdVC.someString = "전달하려는 데이터3"
        }
        
        if segue.identifier == "toFourthVC" {
            let fourthVC = segue.destination as! FourthViewController
            fourthVC.someString = "전달하려는 데이터4"
        }
    }
    

    
}

