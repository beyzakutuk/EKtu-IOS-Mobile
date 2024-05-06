//
//  StudentCourseSelectionTableViewCell.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 6.05.2024.
//

import UIKit

class StudentCourseSelectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lessonNameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    
    var addCourseAction: (() -> Void)?

    override func awakeFromNib() {
    super.awakeFromNib()
    addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        addCourseAction?()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
