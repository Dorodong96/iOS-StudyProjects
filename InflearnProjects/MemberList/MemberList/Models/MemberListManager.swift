//
//  MemberListManager.swift
//  MemberList
//
//  Created by DongKyu Kim on 2023/02/06.
//

import Foundation

class MemberListManager {
    
    private var membersList: [Member] = []
    
    func makeMembersListDatas() {
        membersList = [
            Member(name: "홍길동", age: 20, phone: "010-1111-2222", address: "서울"),
            Member(name: "임꺽정", age: 23, phone: "010-2222-3333", address: "서울"),
            Member(name: "스티브", age: 50, phone: "010-1234-1234", address: "미국"),
            Member(name: "쿡", age: 30, phone: "010-7777-7777", address: "캘리포니아"),
            Member(name: "베조스", age: 50, phone: "010-2222-7777", address: "하와이"),
            Member(name: "배트맨", age: 40, phone: "010-3333-1234", address: "고담씨티"),
            Member(name: "조커", age: 40, phone: "010-4321-1234", address: "고담씨티")
        ]
    }
    
    func getMemberList() -> [Member] {
        return membersList
    }
    
    func makeNewMember(_ member: Member) {
        membersList.append(member)
    }
    
    func updateMemberInfo(index: Int, _ member: Member) {
        membersList[index] = member
    }
    
    // 굳이 필요는 없지만 subscript 구현!
    subscript(index: Int) -> Member {
        get {
            return membersList[index]
        }
        set {
            membersList[index] = newValue
        }
    }
}
