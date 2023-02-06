//
//  Member.swift
//  MemberList
//
//  Created by DongKyu Kim on 2023/02/06.
//

import UIKit

struct Member {
    
    lazy var memberImage: UIImage? = {
        guard let name = name else {
            return UIImage(systemName: "person")
        }
        
        return UIImage(named: "\(name).png") ?? UIImage(systemName: "person")
    }()
    
    static var memberNumbers: Int = 0
    
    let memberID: Int
    var name: String?
    let age: Int?
    let phone: String?
    var address: String?
    
    init(name: String?, age: Int?, phone: String?, address: String?) {
        self.memberID = Member.memberNumbers
        
        self.name = name
        self.age = age
        self.phone = phone
        self.address = address
        
        Member.memberNumbers += 1
    }
}
