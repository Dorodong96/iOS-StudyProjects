//
//  DetailViewController.swift
//  Project1
//
//  Created by DongKyu Kim on 2022/07/13.
//

import UIKit

class DetailViewController: UIViewController {
    // 현재 상태에서는 어떤 메모리 공간도 차지하고있지 않음 (nil)
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var totalIndex: Int = 0
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 둘 다 optional이라 binding 불필요
        title = "Picture \(currentIndex) of \(totalIndex)"
        navigationItem.largeTitleDisplayMode = .never
        
        // target 파라미터는 해당 sharedTapped 함수가 어디에 있는지 그 위치를 지정
        // #selector -> swift컴파일러에게 해당 메소드가 존재할 것이라고 알려줌(오타 디버깅에 도움됨)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        } else {
            print("There is no image")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    // Obj-C로 구현된 UIBarButtonItem은 swift 함수인 shareTapped를 인식하지 못함 -> objc attribute 선언 필요
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8), let imageName = selectedImage else {
            print("No Image Found...")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [imageName, image], applicationActivities: [])
        // iPad에서는 crash
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
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
