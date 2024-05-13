//
//  AbsencesTableViewCell.swift
//  EOkulMobilProje
//
//  Created by Beyza Kütük on 13.05.2024.
//

import UIKit

class AbsencesTableViewCell: UITableViewCell {
    
    // MARK: -VARIABLES
    
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
