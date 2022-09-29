//
//  Content.swift
//  NetflixStyleSample
//
//  Created by DongKyu Kim on 2022/09/29.
//

import UIKit

struct Content: Decodable {
    let sectionType: SectionType
    let sectionName: String
    let contentItem: [Item]
    
    enum SectionType: String, Decodable {
        case basic, main, rank, large
    }
}

struct Item: Decodable {
    let decription: String
    let imageName: String
    
    var image: UIImage {
        return UIImage(named: imageName) ?? UIImage()
    }
}


