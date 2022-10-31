//
//  RepositoryListViewController.swift
//  GitHubRepository
//
//  Created by DongKyu Kim on 2022/10/31.
//

import RxSwift
import RxCocoa
import UIKit

class RepositoryListViewController: UITableViewController {
    private let organization = "ReactiveX"
    private let repositories = BehaviorSubject<[Repository]>(value: []) // Repository의 Array를 받지만 초깃값은 empty
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = organization + " Repositories"
        
        self.refreshControl = UIRefreshControl() // 당겨서 새로고침 - 당겼을 때 API call을 하도록
        let refreshControl = self.refreshControl!
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.register(RepositoryListCell.self, forCellReuseIdentifier: "RepositoryListCell")
        tableView.rowHeight = 140
    }
    
    @objc func refresh() {
        // GitHub API 연결하기
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.fetchRepositories(of: self.organization)
        }
    }
    
    func fetchRepositories(of organization: String) {
        Observable.from([organization])
            .map { organization -> URL in // String을 URL로 변경
                return URL(string: "https://api.github.com/orgs/\(organization.lowercased())/repos")!
            }
            .map { url -> URLRequest in
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            } // Observable로 변환 완료!
            .filter { responds, _ in // 응답만 체크 (데이터는 X)
                return 200..<300 ~= responds.statusCode
            }
            .map { _, data -> [[String: Any]] in
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                      let result = json as? [[String: Any]] else {
                    return []
                }
                return result
            }
            .filter { result in
                return result.count > 0
            }
            .map { objects in
                return objects.compactMap { dic -> Repository? in // compactMap을 통해 nil 값을 자동적으로 제거
                    guard let id = dic["id"] as? Int,
                          let name = dic["name"] as? String,
                          let description = dic["description"] as? String,
                          let stargazersCount = dic["stargazers_count"] as? Int,
                          let language = dic["language"] as? String else {
                        return nil
                    }
                    
                    return Repository(id: id, name: name, description: description, stargazersCount: stargazersCount, language: language)
                }
            } // 여기까지는 그냥 Observable을 정의한 것. 아무런 역할을 하지 않음
            .subscribe(onNext: { [weak self] newRepositories in
                self?.repositories.onNext(newRepositories)
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControl?.endRefreshing() // 새로운 아이템을 받으면 refresh 그만하도록
                }
            })
            .disposed(by: disposeBag)
    }
}

// UITableView DataSource Delegate
extension RepositoryListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            return try repositories.value().count // Behavior Subject는 Value 값을 뽑아낼 수 있음
        } catch {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath) as? RepositoryListCell else { return UITableViewCell() }
        
        var currentRepo: Repository? {
            do {
                return try repositories.value()[indexPath.row]
            } catch {
                return nil
            }
        }
        
        cell.repository = currentRepo
        
        return cell
    }
}
