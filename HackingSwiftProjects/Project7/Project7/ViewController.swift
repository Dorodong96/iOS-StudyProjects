//
//  ViewController.swift
//  Project7
//
//  Created by DongKyu Kim on 2022/07/26.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions: [Petition] = []
    var filteredPetitions: [Petition] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredit))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filter))
        
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
            filteredPetitions = petitions
            // tableView에 띄우기
            tableView.reloadData()
        }
    }
    
    
    @objc func showCredit() {
        let ac = UIAlertController(title: "Credits", message: "The data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // filter alert controller
    @objc func filter() {
        let ac = UIAlertController(title: "Filter", message: "Write the word what you want to filter", preferredStyle: .alert)
        let filterAction = UIAlertAction(title: "Done", style: .default) { (filter) in
            self.filteredPetitions = []
            self.filterWord(ac.textFields?[0].text)
        }
        ac.addTextField()
        ac.addAction(filterAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    // petition의 단어 필터링
    func filterWord(_ word: String?) {
        DispatchQueue.global().async {
            if let word = word {
                for petition in self.petitions {
                    if petition.title.contains(word) {
                        self.filteredPetitions.append(petition)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                print("No Results")
            }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

