//
//  ViewController.swift
//  TableView
//
//  Created by DongKyu Kim on 2023/02/05.
//

import UIKit

class ViewController: UIViewController {
    var moviesArray: [Movie] = []
    var movieDataManager = DataManager()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        
        title = "영화 목록"
        
        
        movieDataManager.makeMovieData()
        moviesArray = movieDataManager.getMovieData()
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        movieDataManager.updataMovieData()
        moviesArray = movieDataManager.getMovieData()
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = moviesArray[indexPath.row]
        
        cell.mainImageView.image = movie.movieImage
        cell.movieNameLabel.text = movie.movieName
        cell.descriptionLabel.text = movie.movieDescription
        // cell.selectionStyle = .none
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: indexPath)
        // 아래의 sender로 indexPath를 전달해줌!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailVC = segue.destination as! DetailViewController
            let array = movieDataManager.getMovieData()
            // sender를 통해 전달받은 indexPath를 타입캐스팅
            let indexPath = sender as! IndexPath
            
            detailVC.movieData = array[indexPath.row]
        }
    }
}

