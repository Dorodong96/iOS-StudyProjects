//
//  DetailViewController.swift
//  MemberList
//
//  Created by DongKyu Kim on 2023/02/07.
//

import UIKit
import PhotosUI

final class DetailViewController: UIViewController {

    private let detailView = DetailView()
    
    weak var delegate: MemberDelegate?
    var member: Member?
    
    override func loadView() {
        detailView.member = member
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpButtonAction()
    }

    private func setUpButtonAction() {
        detailView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        detailView.mainImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setupImagePicker)))
        detailView.mainImageView.isUserInteractionEnabled = true
    }
    
    @objc private func setupImagePicker() {
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .any(of: [.images, .videos])
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    @objc func saveButtonTapped() {
        let memberID = Int(detailView.numberTextField.text!) ?? 0
        
//        // 어려운 방식...
//        let vcIndex = navigationController!.viewControllers.count - 2 // Parent view index
//
//        let vc = navigationController?.viewControllers[vcIndex] as! ViewController
        
        if var member = member {
            member.memberImage = detailView.mainImageView.image
            member.name = detailView.nameTextField.text ?? ""
            member.age = Int(detailView.ageTextField.text ?? "") ?? 0
            member.phone = detailView.phoneNumberTextField.text ?? ""
            member.address = detailView.addressTextField.text ?? ""
            
            detailView.member = member
            delegate?.updateMember(index: memberID, member)
//            vc.memberListManager.updateMemberInfo(index: memberID, member)
            
        } else {
            let name = detailView.nameTextField.text ?? ""
            let age = Int(detailView.ageTextField.text ?? "")
            let phoneNumber = detailView.phoneNumberTextField.text ?? ""
            let address = detailView.addressTextField.text ?? ""
            
            // 새로운 멤버 (구조체) 생성
            var newMember =
            Member(name: name, age: age, phone: phoneNumber, address: address)
            newMember.memberImage = detailView.mainImageView.image
            
            delegate?.addNewMember(newMember)
//            vc.memberListManager.makeNewMember(newMember)
        }
        
        navigationController?.popViewController(animated: true)
    }

}

extension DetailViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                // 디른 스레드에서 작업을 하고 (내부적으로 그렇게 구현되어있음)
                DispatchQueue.main.async { // 메인 스레드로 가서 UI 작업 하기
                    self.detailView.mainImageView.image = image as? UIImage
                }
            }
        } else {
            print("이미지 불러오기 실패")
        }
    }
}
