//
//  ContentCollectionViewCell.swift
//  NetflixStyleSample
//
//  Created by DongKyu Kim on 2022/09/29.
//

import UIKit
import SnapKit

class ContentCollectionViewCell: UICollectionViewCell{
    let imageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 셀의 기본 항목 접근은 contentView를 통해 할 수 있음 (self로 안됨)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        imageView.contentMode = .scaleToFill
        
        contentView.addSubview(imageView)
        
        // 오토레이아웃 사용 (By SnapKit)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview() // superview인 cell에 이미지뷰 맞추기
            
        }
        
    }
}
