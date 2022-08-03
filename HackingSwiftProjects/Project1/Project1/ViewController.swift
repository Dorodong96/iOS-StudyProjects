//
//  ViewController.swift
//  Project1
//
//  Created by DongKyu Kim on 2022/07/13.
//

import UIKit

class ViewController: UITableViewController {

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
        tableView.reloadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cellForRowAt -> 해당 cell이 어디에 위치하는지를 지정
        // dequeueReusableCell -> 새로운 cell이 생성되는게 아니라 위의 cell을 재활용해서 보여주는 것
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        // 해당 cell의 label 지정
        cell.textLabel?.text = pictures[indexPath.row]
        // 생성된 cell return
        return cell
    }
    
    // DetailViewController에 넘겨줄 값을 여기서 정리함
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

