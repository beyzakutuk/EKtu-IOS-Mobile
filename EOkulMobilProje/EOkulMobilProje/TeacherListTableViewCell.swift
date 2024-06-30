//
//  TeacherListTableViewCell.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 29.06.2024.
//

import UIKit

class TeacherListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var teacherName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
