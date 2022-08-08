//
//  Person.swift
//  Project10
//
//  Created by DongKyu Kim on 2022/08/08.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
