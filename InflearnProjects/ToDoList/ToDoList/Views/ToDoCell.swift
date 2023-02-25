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
        toDoTextLabel.text = toDoData?.memoText
        dateTextLabel.text = toDoData?.dateString
        guard let colorNum = toDoData?.color else { return }
        let color = MyColor(rawValue: colorNum) ?? .red
        updateButton.backgroundColor = color.buttonColor
        backView.backgroundColor = color.backgoundColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        updateButtonPressed(self)
    }
    
}
