//
//  StudentExamListTableViewCell.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 22.06.2024.
//

import UIKit

class StudentExamListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var midtermGrades: UILabel!
    @IBOutlet weak var finalGrades: UILabel!
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBAction func updateButton(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
