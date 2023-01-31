//
//  FirstViewController.swift
//  NextVC
//
//  Created by DongKyu Kim on 2023/01/31.
//

import UIKit

final class FirstViewController: UIViewController {
    
    var someString: String?

    let mainLabel = UILabel()
    let backButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .gray
        
        mainLabel.text = someString
        mainLabel.font = .systemFont(ofSize: 22)
        
        backButton.setTitle("back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = .blue
        backButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.addSubview(mainLabel)
        view.addSubview(backButton)
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }
}
