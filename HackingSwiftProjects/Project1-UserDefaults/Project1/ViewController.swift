//
//  ViewController.swift
//  Project1
//
//  Created by DongKyu Kim on 2022/07/13.
//

import UIKit

class ViewController: UICollectionViewController {

    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        DispatchQueue.global().async {
            for item in items {
                if item.hasPrefix("nssl") {
                    self.pictures.append(item)
                }
            }
            self.pictures.sort()
        }
        
        collectionView.reloadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // cellForRowAt -> 해당 cell이 어디에 위치하는지를 지정
        // dequeueReusableCell -> 새로운 cell이 생성되는게 아니라 위의 cell을 재활용해서 보여주는 것
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Private", for: indexPath) as? PrivateCell else {
            fatalError("Unable to dequeue private cell")
        }
        // 해당 cell의 label 지정
        cell.name.text = pictures[indexPath.item]

        cell.imageView.image = UIImage(named: pictures[indexPath.item])
        // grayscale 색상에서 유용
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        // 생성된 cell return
        return cell
    }
    
    // DetailViewController에 넘겨줄 값을 여기서 정리함
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.totalIndex = pictures.count
            vc.currentIndex = indexPath[1]
            navigationController?.pushViewController(vc, animated: true)
        } else {
            print("Error")
        }
    }
    
    @objc func shareTapped() {
        let recommendComment = "Hey guys, Try this app right now!"
        
        let vc = UIActivityViewController(activityItems: [recommendComment], applicationActivities: [])
        // iPad에서는 crash
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

