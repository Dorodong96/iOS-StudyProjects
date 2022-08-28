//
//  DetailViewController.swift
//  Challange4
//
//  Created by DongKyu Kim on 2022/08/28.
//

import UIKit

class DetailViewController: UIViewController {

    var selectedCountry: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let selectedCountry = selectedCountry else { return }

        title = selectedCountry.name
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
