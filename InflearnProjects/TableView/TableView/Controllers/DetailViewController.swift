//
//  DetailViewController.swift
//  TableView
//
//  Created by DongKyu Kim on 2023/02/06.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var movieData: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    private func setupUI() {
        mainImageView.image = movieData?.movieImage
        movieNameLabel.text = movieData?.movieName
        descriptionLabel.text = movieData?.movieDescription
    }

}
