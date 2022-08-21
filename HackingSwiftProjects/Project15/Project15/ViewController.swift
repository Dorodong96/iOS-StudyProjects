//
//  ViewController.swift
//  Project15
//
//  Created by DongKyu Kim on 2022/08/21.
//

import UIKit

class ViewController: UIViewController {

    var imageView: UIImageView!
    var currentAnimation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }

    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true

        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            switch self.currentAnimation {
            case 0: // 크기 2배 증가
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            
            case 1: // 원래대로 돌아옴
                self.imageView.transform = .identity
            
            case 2: // position 이동
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
                
            case 3: // 원래대로 돌아옴
                self.imageView.transform = .identity
                
            case 4: // 회전 transform -> 움직일 수 있는 최소 방향으로 움직임!
                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 3)
                
            case 5: // 원래대로 돌아옴
                self.imageView.transform = .identity
                
            case 6: // 투명도, 배경 색상 변경
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = UIColor.green
                
            case 7: // 원래대로 돌아옴
                self.imageView.alpha = 1
                self.imageView.backgroundColor = UIColor.clear
                
            default:
                break
            }
        }) { finished in
            sender.isHidden = false
        }
        
        currentAnimation += 1
        
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
    

}

