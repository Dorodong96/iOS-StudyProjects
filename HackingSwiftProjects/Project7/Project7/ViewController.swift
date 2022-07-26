//
//  ViewController.swift
//  Project7
//
//  Created by DongKyu Kim on 2022/07/26.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions: [Petition] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        // 해당 url이 타당한지 검토
        if let url = URL(string: urlString) {
            // contentsOf로 Data Object를 만들어 항목을 반환 (하지만 인터넷 문제 등의 원인으로 에러 발생 가능 -> try?)
            if let data = try? Data(contentsOf: url) {
                // WE ARE OK TO PARSE
                parse(json: data)
                return
            }
        }
        showError()
        
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        // Petition 타입으로 json 파일에서 추출하기
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            // tableView에 띄우기
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

