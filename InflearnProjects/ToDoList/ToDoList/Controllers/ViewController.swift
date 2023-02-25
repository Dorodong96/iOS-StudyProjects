//
//  ViewController.swift
//  ToDoList
//
//  Created by DongKyu Kim on 2023/02/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let toDoManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupNaviBar() {
        self.title = "메모"
        
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .black
        navigationItem.rightBarButtonItem = plusButton
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
    }
    
    @objc func plusButtonTapped() {
        performSegue(withIdentifier: "ToDoCell", sender: nil)
    }
    
    // (세그웨이를 실행할때) 실제 데이터 전달 (ToDoData전달)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDoCell" {
            let detailVC = segue.destination as! DetailViewController
            
            guard let indexPath = sender as? IndexPath else { return }
            detailVC.toDoData = toDoManager.getToDoListFromCoreData()[indexPath.row]
        }
    }
}

// TableView 내용은 CoreData 항목을 활용해야 하기 때문에,
// CoreDataManager를 구현해야함. ~ 다음 시간에 계속...

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoManager.getToDoListFromCoreData().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        
        let toDoData = toDoManager.getToDoListFromCoreData()
        cell.toDoData = toDoData[indexPath.row]
        
        cell.updateButtonPressed = { [weak self] (senderCell) in
            self?.performSegue(withIdentifier: "ToDoCell", sender: indexPath)
        }
        
        cell.selectionStyle = .none
        return cell
    }


}

extension ViewController: UITableViewDelegate {
//    TableView의 segue 설정 부분
//         --> 앨런 강의에는 didSelectRowAt이 있는데, 여기서는 버튼으로 이동하는거기 때문에 구현 안해도 됨
//         prepare 메서드도 delegate말고 위에서 구현하면 됨
 // TableView의 높이 설정 delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToDoCell", sender: indexPath)
    }
    
    // 테이블뷰의 높이를 자동적으로 추청하도록 하는 메서드
    // (ToDo에서 메세지가 길때는 셀의 높이를 더 높게 ==> 셀의 오토레이아웃 설정도 필요)
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
