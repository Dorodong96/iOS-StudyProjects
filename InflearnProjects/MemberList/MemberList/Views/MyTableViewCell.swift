//
//  MyTableViewCell.swift
//  MemberList
//
//  Created by DongKyu Kim on 2023/02/06.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    var member: Member? {
        didSet {
            memberImageView.image = member?.memberImage
            memberNameLabel.text = member?.name
            memberLocationLabel.text = member?.address
        }
    }
    
    let memberImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let memberNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let memberLocationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        self.addSubview(memberImageView)
        self.addSubview(stackView)
        stackView.addArrangedSubview(memberNameLabel)
        stackView.addArrangedSubview(memberLocationLabel)
    }
    
    override func updateConstraints() {
        setLayout()
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        memberImageView.clipsToBounds = true
        memberImageView.layer.cornerRadius = memberImageView.frame.width / 2
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            memberImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            memberImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            memberImageView.heightAnchor.constraint(equalToConstant: 40),
            memberImageView.widthAnchor.constraint(equalToConstant: 40),
            
            stackView.leadingAnchor.constraint(equalTo: memberImageView.trailingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: memberImageView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: memberImageView.bottomAnchor),
            
            memberNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
