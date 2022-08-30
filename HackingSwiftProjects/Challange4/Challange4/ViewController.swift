//
//  ViewController.swift
//  Challange4
//
//  Created by DongKyu Kim on 2022/08/28.
//

import UIKit

class ViewController: UITableViewController {

    var countries: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries"
        
        if let path = Bundle.main.path(forResource: "Countries", ofType: "json") {
            // contentsOf로 Data Object를 만들어 항목을 반환 (하지만 인터넷 문제 등의 원인으로 에러 발생 가능 -> try?)
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                // WE ARE OK TO PARSE
                parse(json: data)
                return
            } else {
                print("No data")
            }
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        
        cell.textLabel?.text = countries[indexPath.row].name
        print(countries[indexPath.row].name)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedCountry = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        // Countries 타입으로 json 파일에서 추출하기
        if let jsonCountries = try? decoder.decode(Countries.self, from: json) {
            countries = jsonCountries.results
            // tableView에 띄우기
            tableView.reloadData()
        }
    }
}

