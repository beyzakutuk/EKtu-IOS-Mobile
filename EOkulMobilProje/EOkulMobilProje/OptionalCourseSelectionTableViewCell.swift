//
//  OptionalCourseSelectionTableViewCell.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 1.06.2024.
//

import UIKit

class OptionalCourseSelectionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lessonNameLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
