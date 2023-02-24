//
//  ToDoCell.swift
//  ToDoList
//
//  Created by DongKyu Kim on 2023/02/24.
//

import UIKit

final class ToDoCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var toDoTextLabel: UILabel!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    var toDoData: MemoData? {
        didSet {
            configureUIwithData()
        }
    }
    
    var updateButtonPressed: (ToDoCell) -> Void = { (sender) in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI() {
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 8
        
        updateButton.clipsToBounds = true
        updateButton.layer.cornerRadius = 10
    }
    
    private func configureUIwithData() {
        // 데이터로 적절한 UI 표현하는 부분
        // toDoTextLabel.text = MemoData?.memo.Text
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        updateButtonPressed(self)
    }
    
}
