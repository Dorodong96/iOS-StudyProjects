//
//  ViewController.swift
//  Project10
//
//  Created by DongKyu Kim on 2022/08/06.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        // tableview의 indexPath.row 대신 item을 사용
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        // grayscale 색상에서 유용
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 사용자가 cell을 탭하면 호출되는 함수
        // Person cell의 이름을 수정할 수 있도록 부여
        let person = people[indexPath.item]
        
        
        let delAc = UIAlertController(title: "Rename Person Or Delete", message: nil, preferredStyle: .alert)
        
        // Delete를 눌렀을 때 collectionView에서 cell 삭제
        delAc.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
        })
        
        
        // Rename을 눌렀을 때 새로운 Alert가 뜨면서 Rename이 가능하도록 수정
        delAc.addAction(UIAlertAction(title: "Rename", style: .default) { _ in
            
            let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else { return }
                person.name = newName
                self?.collectionView.reloadData()
            })
            self.present(ac, animated: true)
        })
        
        self.present(delAc, animated: true)
    }
    
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        
        let ac = UIAlertController(title: "이미지를 어디서 가져오시겠어요?", message: "앨범과 카메라중 선택하세요", preferredStyle: .alert)
        
        picker.allowsEditing = true
        picker.delegate = self
        
        ac.addAction(UIAlertAction(title: "앨범", style: .default) { _ in
            self.present(picker, animated: true)
        })
        
        ac.addAction(UIAlertAction(title: "카메라", style: .default) { _ in
            picker.sourceType = .camera
            self.present(picker, animated: true)
        })
        
        self.present(ac, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        // unique identifier를 String 타입으로 추출
        let imageName = UUID().uuidString
        // path에 이미지 경로 문자열 추가
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        // UIImage를 Data타입으로 변환시킴 (jpegData 메소드 활용)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            // 해당 데이터를 파일로 disk(imagePath)에 저장
            try? jpegData.write(to: imagePath)
        }
        
        // 새로운 사람을 추가할 때 마다 Person객체 지정 후 배열에 추가
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    // 디렉토리애서 파일 가져오기
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

