//
//  PriceTextFieldCell.swift
//  UsedGoodsUpload
//
//  Created by DongKyu Kim on 2022/11/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PriceTextFieldCell: UITableViewCell {
    let disposeBag = DisposeBag()
    let priceInputField = UITextField()
    // let freeShareButton = UIButton()
    
    private lazy var freeShareButton: UIButton = {
        let button = UIButton()
        button.setTitle("무료 나눔 ", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.tintColor = .orange
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.orange.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10.0
        button.clipsToBounds = true
        button.isHidden = true
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: PriceTextFieldCellViewModel) {
        // viewModel에서 view로 받는 것
        viewModel.showFreeShareButton
            .map { !$0 }    // 버튼을 보여줘! 라는걸 받으면 true -> false 변환
            .emit(to: freeShareButton.rx.isHidden) // isHidden이 false가 되어서 버튼을 보여줌
            .disposed(by: disposeBag)
        
        viewModel.resetPrice
            .map { _ in ""} // 빈 String으로 바꾸기
            .emit(to: priceInputField.rx.text)
            .disposed(by: disposeBag)
        
        priceInputField.rx.text
            .bind(to: viewModel.priceValue)
            .disposed(by: disposeBag)
        
        freeShareButton.rx.tap
            .bind(to: viewModel.freeShareButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        priceInputField.keyboardType = .numberPad
        priceInputField.font = .systemFont(ofSize: 17)
    }
    
    private func layout() {
        [priceInputField, freeShareButton].forEach {
            contentView.addSubview($0)
        }
        
        priceInputField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        freeShareButton.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(15)
            $0.width.equalTo(100)
        }
    }
}
