//
//  Member.swift
//  MemberList
//
//  Created by DongKyu Kim on 2023/02/06.
//

import UIKit

protocol MemberDelegate: AnyObject {
    // 이 단계에서는 Delegate, 즉 대리자가 할 수 있는 일을 정의한다.
    func addNewMember(_ member: Member)
    func updateMember(index: Int, _ member: Member)
}

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
    var age: Int?
    var phone: String?
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
