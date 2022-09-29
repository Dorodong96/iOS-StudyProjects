//
//  ContentCollectionViewHeader.swift
//  NetflixStyleSample
//
//  Created by DongKyu Kim on 2022/09/29.
//

import UIKit
import SnapKit

class ContentCollectionViewHeader: UICollectionReusableView {
    let sectionNameLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sectionNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        sectionNameLabel.textColor = .white
        sectionNameLabel.sizeToFit()
        
        
        addSubview(sectionNameLabel)
        
        // AuthLayout 적용 by SnapKit
        sectionNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.bottom.leading.equalToSuperview()
        }
    }
}
