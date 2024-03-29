//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by DongKyu Kim on 2022/10/05.
//

import FirebaseDatabase
import FirebaseFirestore
// import FirebaseFirestoreSwift
import Kingfisher
import UIKit

class CardListViewController: UITableViewController {
//    var ref: DatabaseReference!  // Firebase Realtime Database
    var db = Firestore.firestore()
    
    var creditCardList: [CreditCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UITableView Cell Register
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
        
        
        // 실시간 데이터베이스 읽기
//        ref = Database.database().reference()
//
//        ref.observe(.value) { snapshot in
//            // realtime database - snapshot을 통해 값을 가져옴
//            // 레퍼런스에서 값을 지켜보고 있다가 값을 snapshot 객체로 전달
//            // value 타입을 제대로 명시해서 전달해 주어야 함
//            guard let value = snapshot.value as? [String: [String: Any]] else { return } // 이런 value가 아니라면 리턴
//
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: value)
//                let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
//                let cardList = Array(cardData.values)
//                self.creditCardList = cardList.sorted { $0.rank < $1.rank }
//
//                // Main Thread에 해당 작업 넣어주기 (UI 관련 - GCD)
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//
//            } catch let error {
//                print("Error JSON parsing \(error.localizedDescription)")
//            }
//        }
        
        // Firestore 읽기
        db.collection("creditCardList").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("ERROR Firestore fetching document \(String(describing: error))")
                return
            }
            
            self.creditCardList = documents.compactMap { doc -> CreditCard? in
                // compactMap -> nil 을 배열에 안넣기 위해
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                    let creditCard = try JSONDecoder().decode(CreditCard.self, from: jsonData)
                    return creditCard
                    
                } catch let error {
                    print("ERROR JSON Parsing \(error)")
                    return nil
                }
            }.sorted { $0.rank < $1.rank }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else { return UITableViewCell() }
        
        cell.rankLabel.text = "\(creditCardList[indexPath.row].rank)위"
        cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
        cell.cardNameLabel.text = "\(creditCardList[indexPath.row].name)"
        
        let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
        cell.cardImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 상세 화면 전달
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "CardDetailViewController") as? CardDetailViewController else { return }
        
        detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
        self.show(detailViewController, sender: nil)
        
        
        // 실시간 데이터 쓰기
        // Option1. 데이터의 객체 이름을 접근
//        let cardID = creditCardList[indexPath.row].id
//        ref.child("Item\(cardID)/isSelected").setValue(true)
        
        // Option2
        // 하지만 이렇게 항상 데이터의 이름을 파악할 수 있는 것은 아님
        // 쿼리처럼 객체가 가진 특정 값을 검색해서 객체 snapshot을 가져오는 방법이 있음
        // 마지막에는 해당 값을 다시 참조를 통해 쓰기
//        let cardID = creditCardList[indexPath.row].id
//        ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [weak self] snapshot in
//            guard let self = self,
//                  let value = snapshot.value as? [String: [String: Any]],
//                  let key = value.keys.first else { return }
//
//            self.ref.child("\(key)/isSelected").setValue(true)
//        }
        
        // Firestore 쓰기
        // Option1 경로를 알고 있는 경우 (Firebase 자료 구조를 알고 있는 경우)
        let cardID = creditCardList[indexPath.row].id
        db.collection("creditCardList").document("card\(cardID)").updateData(["isSelected": true])
        
        
        // Option2 경로를 알지 못하는 경우
        // id와 같은 고유한 값을 찾아서 연결
        db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments { snapshot, _ in
            guard let document = snapshot?.documents.first else {
                print("ERROR Firestore fetching document")
                return
            }
            document.reference.updateData(["isSelected": true])
        }
        
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 실시간 데이터 베이스 삭제
            // Option1
//            let cardID = creditCardList[indexPath.row].id
//            ref.child("item\(cardID)").removeValue()
            
            // Option2
//            ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [weak self] snapshot in
//                guard let self = self,
//                      let value = snapshot.value as? [String: [String: Any]],
//                      let key = value.keys.first else { return }
//
//                // 데이터베이스의 삭제
//                // nil을 입력해주는것도 삭제의 한 방법이 될 수 있음
//                // removeValue 활용
//                self.ref.child(key).removeValue()
//            }
            
            
            // Firestore 삭제
            // Option1 - 경로를 아는 경우
            let cardID = creditCardList[indexPath.row].id
            // db.collection("creditCardList").document("card\(cardID)").delete()
            
            // Option2 - ID를 모르거나 특정 값을 갖는 문서 전체를 알고싶을때
            // 문서를 검색 한 후 snapshot 제공
            db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments { snapshot, _ in
                guard let document = snapshot?.documents.first else {
                    print("ERROR")
                    return
                }
                
                document.reference.delete()
            }
        }
    }
}
