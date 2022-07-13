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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
