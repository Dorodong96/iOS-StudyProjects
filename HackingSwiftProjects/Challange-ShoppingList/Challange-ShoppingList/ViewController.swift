//
//  ViewController.swift
//  Challange-ShoppingList
//
//  Created by DongKyu Kim on 2022/07/23.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "나의 쇼핑 리스트"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addShoppingList))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshShoppingList))
    }

    @objc func addShoppingList() {
        let ac = UIAlertController(title: "추가할 항목을 입력하세요", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "제출", style: .default) { [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else { return }
            self?.submit(item)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ item: String) {
        let indexPath = IndexPath(row: shoppingList.count, section: 0)
        
        shoppingList.append(item)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // 쇼핑 리스트 초기화
    @objc func refreshShoppingList() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    // TableView cell 관련 override methods (테이블 뷰 띄우기 위해 거의 항상 필요한 함수들)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
}

