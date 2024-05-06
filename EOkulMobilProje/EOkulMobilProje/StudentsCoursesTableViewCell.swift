//
//  StudentsCoursesTableViewCell.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 5.05.2024.
//

import UIKit

class StudentsCoursesTableViewCell: UITableViewCell {
    
    // MARK: -VARIABLES
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var midtermResult: UILabel!
    @IBOutlet weak var finalResult: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
