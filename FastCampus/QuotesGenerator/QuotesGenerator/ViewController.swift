//
//  ViewController.swift
//  QuotesGenerator
//
//  Created by DongKyu Kim on 2022/09/26.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    let quotes = [
        Quote(contents: "죽음을 두려워허는 나머지 삶을 시작조차 못하는 사람이 많다.", name: "벤다이크"),
        Quote(contents: "좋은 책을 읽지 않는 사람은 책을 읽을 수 없는 사람보다 나을 바 없다.", name: "마크 트웨인"),
        Quote(contents: "많은 공부와 지식이 곧 지혜로 연결되는 것은 아니다.", name: "헤라클레이토스"),
        Quote(contents: "교육은 암기를 얼마나 열심히 했는지, 혹은 얼마나 많이 아는지가 아니다. 교육은 아는 것과 모르는 것을 구분할 줄 아는 능력이다", name: "아나톨 프랑스"),
        Quote(contents: "어떤 분야에서든 유능해지고 성공하기 위해선 세 가지가 필요하다. 타고난 천성과 공부 그리고 부단한 노력이 그것이다.", name: "헨리 워드 비처")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapQuoteGeneratorButton(_ sender: Any) {
        let random = Int(arc4random_uniform(5)) // 0 ~ 4 사이의 난수
        let quote = quotes[random]
        self.quoteLabel.text = quote.contents
        self.nameLabel.text = quote.name
    }
    
}

